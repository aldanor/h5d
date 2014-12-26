module hdf5.id;

import hdf5.api;
import hdf5.utils;

package class H5ID {
    protected hid_t m_id = H5I_INVALID_HID;

    package this(hid_t id) {
        m_id = id;
    }

    ~this() {
        this.decref();
    }

    void close() {
        this.decref();
        m_id = H5I_INVALID_HID;
    }

    final public auto dup(this R)() const {
        this.incref();
        return cast(R) new H5ID(this.id);
    }

    final public @property hid_t id() const nothrow {
        return m_id;
    }
}

public const nothrow {
    bool isFile(in H5ID obj)              { return obj.type == H5I_FILE; }
    bool isGroup(in H5ID obj)             { return obj.type == H5I_GROUP; }
    bool isDatatype(in H5ID obj)          { return obj.type == H5I_DATATYPE; }
    bool isDataspace(in H5ID obj)         { return obj.type == H5I_DATASPACE; }
    bool isDataset(in H5ID obj)           { return obj.type == H5I_DATASET; }
    bool isAttribute(in H5ID obj)         { return obj.type == H5I_ATTR; }
    bool isReference(in H5ID obj)         { return obj.type == H5I_REFERENCE; }
    bool isVFL(in H5ID obj)               { return obj.type == H5I_VFL; }
    bool isPropertyListClass(in H5ID obj) { return obj.type == H5I_GENPROP_CLS; }
    bool isPropertyList(in H5ID obj)      { return obj.type == H5I_GENPROP_LST; }
    bool isErrorClass(in H5ID obj)        { return obj.type == H5I_ERROR_CLASS; }
    bool isErrorMessage(in H5ID obj)      { return obj.type == H5I_ERROR_MSG; }
    bool isErrorStack(in H5ID obj)        { return obj.type == H5I_ERROR_STACK; }

    H5I_type_t type(in H5ID obj) {
        if (obj.id <= 0)
            return H5I_BADID;
        auto id_type = H5Iget_type(obj.id);
        if (id_type <= H5I_BADID || id_type >= H5I_NTYPES)
            return H5I_BADID;
        return id_type;
    }

    bool valid(in H5ID obj)  {
        if (!obj.id)
            return false;
        auto id_type = obj.type;
        return id_type > H5I_BADID && id_type < H5I_NTYPES;
    }

    bool valid(in H5ID obj, bool user = false) {
        return user ? H5Iis_valid(obj.id) == 1 : obj.valid;
    }

    string name(in H5ID obj) {
        scope(failure) return null;
        return getH5String!D_H5Iget_name(obj.id);
    }
}

package const {
    uint refcount(in H5ID obj) {
        return D_H5Iget_ref(obj.id);
    }

    void incref(in H5ID obj) {
        if (obj.valid(true))
            D_H5Iinc_ref(obj.id);
    }

    void decref(in H5ID obj){
        if (obj.valid(true))
            D_H5Idec_ref(obj.id);
    }
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
    assert(obj.name is null);

    // existing generic id
    obj = new H5ID(H5P_ROOT);
    assert(obj.id == H5P_ROOT);
    assert(obj.valid);
    assert(!obj.valid(true));
    assert(obj.valid(false));
    assert(obj.isPropertyListClass);
    assert(obj.name is null);
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
    assert(obj.name is null);
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
