module hdf5.id;

import hdf5.api;
import hdf5.utils;


private struct H5IDRegistry {
    private hid_t[size_t] registry;

    static size_t toAddr(in H5ID obj) @nogc nothrow {
        return cast(size_t) *cast(void**) &obj;
    }

    static H5ID fromAddr(size_t addr) @nogc nothrow {
        auto ptr = cast(void*) addr;
        return ptr is null ? null : *cast(H5ID*) &ptr;
    }

    void store(in H5ID obj) nothrow {
        if (obj !is null)
            registry[toAddr(obj)] = obj.id;
    }

    void remove(in H5ID obj) @nogc nothrow {
        if (obj !is null) {
            auto ptr = toAddr(obj) in registry;
            if (ptr !is null)
                *ptr = 0;
        }
    }

    bool opIn_r(in H5ID obj) const {
        return toAddr(obj) in this;
    }

    bool opIn_r(size_t addr) const {
        return (addr in registry) !is null;
    }

    void prune() {
        auto r = registry.dup;
        registry = registry.init;
        foreach (addr, id; r) {
            if (!addr || id <= 0)
                continue;
            auto obj = fromAddr(addr);
            if (obj is null)
                continue;
            auto id_type = H5Iget_type(obj.id);
            if (id_type <= H5I_BADID || id_type >= H5I_NTYPES || H5Iget_ref(obj.id) <= 0)
                obj.invalidate();
            else
                store(obj);
        }
    }
}

package class H5ID {
    protected hid_t m_id = H5I_INVALID_HID;
    private static H5IDRegistry registry; // TODO: make registry shared

    package this(hid_t id) {
        m_id = id;
        registry.store(this);
    }

    ~this() @nogc {
        auto id_type = H5Iget_type(m_id);
        if (id_type > H5I_BADID && id_type < H5I_NTYPES)
            if (H5Iget_ref(m_id) > 0)
                H5Idec_ref(m_id);
        registry.remove(this);
    }

    public final void close() {
        if (this.valid)
            doClose();
        invalidate();
        afterClose();
    }

    protected void doClose() {
        this.decref();
    }

    protected void afterClose() {
    }

    public final auto dup(this R)() const {
        this.incref();
        return cast(R) new H5ID(this.id);
    }

    public final hid_t id() const @property nothrow @nogc {
        return m_id;
    }

    package final void invalidate() nothrow @nogc {
        m_id = H5I_INVALID_HID;
    }

    package static void invalidateRegistry() {
        registry.prune();
    }

    public const nothrow {
        bool isFile()              { return this.type == H5I_FILE; }
        bool isGroup()             { return this.type == H5I_GROUP; }
        bool isDatatype()          { return this.type == H5I_DATATYPE; }
        bool isDataspace()         { return this.type == H5I_DATASPACE; }
        bool isDataset()           { return this.type == H5I_DATASET; }
        bool isAttribute()         { return this.type == H5I_ATTR; }
        bool isReference()         { return this.type == H5I_REFERENCE; }
        bool isVFL()               { return this.type == H5I_VFL; }
        bool isPropertyListClass() { return this.type == H5I_GENPROP_CLS; }
        bool isPropertyList()      { return this.type == H5I_GENPROP_LST; }
        bool isErrorClass()        { return this.type == H5I_ERROR_CLASS; }
        bool isErrorMessage()      { return this.type == H5I_ERROR_MSG; }
        bool isErrorStack()        { return this.type == H5I_ERROR_STACK; }

        H5I_type_t type() {
            if (m_id <= 0)
                return H5I_BADID;
            auto id_type = H5Iget_type(m_id);
            if (id_type <= H5I_BADID || id_type >= H5I_NTYPES)
                return H5I_BADID;
            return id_type;
        }

        bool valid()  {
            if (m_id <= 0 || m_id == H5I_INVALID_HID)
                return false;
            auto id_type = this.type;
            return id_type > H5I_BADID && id_type < H5I_NTYPES;
        }

        bool valid(bool user = false) {
            return user ? H5Iis_valid(m_id) == 1 : this.valid;
        }
    }

    package const {
        uint refcount() {
            return D_H5Iget_ref(m_id);
        }

        void incref() {
            if (this.valid(true))
                D_H5Iinc_ref(m_id);
        }

        void decref() {
            if (this.valid(true))
                D_H5Idec_ref(m_id);
        }
    }
}

unittest {
    H5IDRegistry registry;
    auto id = new H5ID(-1);
    auto dt = new H5ID(D_H5Tcreate(H5T_INTEGER, 1));
    auto addr = registry.toAddr(id);
    registry.store(id);
    registry.store(dt);
    assert(addr in registry);
    assert(id in registry);
    assert(dt in registry);
    destroy(id);
    registry.prune();
    assert(addr !in registry);
    assert(dt in registry);
    dt.invalidate();
    registry.prune();
    assert(dt !in registry);
}

unittest {
    import hdf5.exception : H5Exception;
    import std.exception  : assertThrown;

    // invalid id
    auto obj = new H5ID(-1);
    assert(obj.id == -1);
    assert(!obj.valid);
    assert(obj.type == H5I_BADID);
    assert(!obj.valid(false));
    assert(!obj.valid(true));
    assertThrown!H5Exception(obj.refcount);
    obj.incref();
    assertThrown!H5Exception(obj.refcount);
    obj.decref();
    assertThrown!H5Exception(obj.refcount);

    // existing generic id
    obj = new H5ID(H5P_ROOT);
    assert(obj.id == H5P_ROOT);
    assert(obj.valid);
    assert(!obj.valid(true));
    assert(obj.valid(false));
    assert(obj.isPropertyListClass);
    assert(obj.refcount == 0);
    auto obj2 = obj.dup;
    assert(obj2.id == obj.id);
    assert(obj.refcount == 0);

    // new user id (datatype)
    obj = new H5ID(D_H5Tcreate(H5T_INTEGER, 1));
    assert(obj.id > 0 && obj.id != H5I_INVALID_HID);
    assert(obj.valid);
    assert(obj.valid(true));
    assert(obj.valid(false));
    assert(obj.isDatatype);
    assert(obj.refcount == 1);
    obj.incref();
    assert(obj.refcount == 2);
    obj2 = obj;
    assert(obj.refcount == 2);
    obj2 = obj.dup;
    assert(obj.refcount == 3);
    assert(obj2.id == obj.id);
    destroy(obj2);
    assert(obj.refcount == 2);
    obj.decref();
    assert(obj.refcount == 1);
    auto id = obj.id;
    obj.close();
    assert(!obj.valid);
    assert(obj.id == H5I_INVALID_HID);
    obj2 = new H5ID(id);
    assert(!obj2.valid);
    assert(!obj2.valid(true));
}
