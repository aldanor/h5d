module hdf5.plist;

import hdf5.api;
import hdf5.id;
import hdf5.exception;

import hdf5.file : H5File;

version (unittest) {
    import std.exception;
    import std.stdio;
    import hdf5.exception;
}

private mixin template initPropertyListClass(alias plistClass) {
    invariant {
        auto id_type = H5Iget_type(m_id);
        if (id_type > H5I_BADID && id_type < H5I_NTYPES)
            assert(id_type == H5I_GENPROP_LST);
    }

    protected this(hid_t id) {
        super(id);
    }

    public this() {
        this(D_H5Pcreate(plistClass));
    }
}

/* Generic Property List */

abstract package class H5PropertyList : H5ID {
    mixin initPropertyListClass!H5P_ROOT;

    protected final override void doClose() {
        D_H5Pclose(m_id);
    }

    final override bool opEquals(Object rhs) nothrow {
        auto plist = cast(typeof(this)) rhs;
        if (plist is null)
            return false;
        if (plist is this)
            return true;
        if (!plist.valid || !this.valid)
            return false;
        if (plist.id == this.id)
            return true;
        return H5Pequal(plist.id, this.id) > 0;
    }
}

/* File Access Property List */

enum CORE_DRIVER_INCREMENT  = 64 * 1024 * 1024; // default increment for core driver: 64 MB
enum CORE_DRIVER_FILEBACKED = true;             // core driver is filebacked by default

public final class H5FileAccessPL : H5PropertyList {
    mixin initPropertyListClass!H5P_FILE_ACCESS;

    public const {
        void setDriver(string driver : "sec2")() {
            D_H5Pset_fapl_sec2(m_id);
        }

        void setDriver(string driver : "stdio")() {
            D_H5Pset_fapl_stdio(m_id);
        }

        void setDriver(string driver : "core")(bool filebacked = CORE_DRIVER_FILEBACKED,
                                               size_t increment = CORE_DRIVER_INCREMENT) {
            D_H5Pset_fapl_core(m_id, increment, filebacked);
        }
    }

    public const @property {
        string driver() {
            auto driver = new H5ID(D_H5Pget_driver(m_id)); // H5I_VFL
            if (driver.id == H5FD_STDIO)
                return "stdio";
            else if (driver.id == H5FD_SEC2)
                return "sec2";
            else if (driver.id == H5FD_CORE)
                return "core";
            throwH5("unknown file driver (ID %d)", driver.id);
            return null;
        }

        bool filebacked() {
            enforceH5(this.driver == "core", q{no "filebacked" for driver "%s"}, driver);
            hbool_t filebacked;
            D_H5Pget_fapl_core(m_id, null, &filebacked);
            return filebacked > 0;
        }

        size_t increment() {
            enforceH5(this.driver == "core", q{no "increment" for driver "%s"}, driver);
            hsize_t increment;
            D_H5Pget_fapl_core(m_id, &increment, null);
            return increment;
        }
    }
}

package H5FileAccessPL fapl(in H5File file) {
    return new H5FileAccessPL(D_H5Fget_access_plist(file.id));
}

unittest {
    import std.exception : assertThrown;

    auto plist = new H5FileAccessPL;
    assert(plist == new H5FileAccessPL(H5P_FILE_ACCESS_DEFAULT));

    assert(plist.driver == "sec2");

    plist.setDriver!"stdio";
    assert(plist.driver == "stdio");

    plist.setDriver!"sec2";
    assert(plist.driver == "sec2");

    plist.setDriver!"core";
    assert(plist.driver == "core");

    plist.setDriver!"core"(true);
    assert(plist.filebacked);

    plist.setDriver!"core"(false);
    assert(!plist.filebacked);

    plist.setDriver!"core"(true, 1024);
    assert(plist.increment == 1024);

    plist.setDriver!"sec2";
    assertThrown!H5Exception(plist.filebacked);
    assertThrown!H5Exception(plist.increment);

    auto file = H5File.open!("core", false, 1024)("foo");
    scope(exit) file.close();
    assert(file.fapl.driver == "core");
    assert(file.fapl.filebacked == false);
    assert(file.fapl.increment == 1024);
}

/* File Create Property List */

public final class H5FileCreatePL : H5PropertyList {
    mixin initPropertyListClass!H5P_FILE_CREATE;

    public const @property {
        hsize_t userblock() {
            hsize_t userblock;
            D_H5Pget_userblock(m_id, &userblock);
            return userblock;
        }

        void userblock(hsize_t userblock) {
            D_H5Pset_userblock(m_id, userblock);
        }
    }
}

package H5FileCreatePL fcpl(in H5File file) {
    return new H5FileCreatePL(D_H5Fget_create_plist(file.id));
}

unittest {
    auto plist = new H5FileCreatePL;
    plist.userblock = 1024;
    assert(plist == plist);
    assert(plist != new H5FileAccessPL);
    assert(plist != new H5FileCreatePL);
    auto plist2 = new H5FileCreatePL;
    assert(plist2 != plist);
    plist2.userblock = 1024;
    assert(plist == plist2);
    assert(new H5FileCreatePL == new H5FileCreatePL);
    assert(new H5FileCreatePL != new H5FileAccessPL);
}

unittest {
    auto plist = new H5FileCreatePL;
    assert(plist == new H5FileCreatePL(H5P_FILE_CREATE_DEFAULT));
    plist.userblock = 0;
    assert(plist.userblock == 0);
    assertThrown!H5Exception(plist.userblock(511));
    plist.userblock = 512;
    assert(plist.userblock == 512);

    auto file = H5File.open!("core", false)("foo", null, 1024);
    scope(exit) file.close();
    assert(file.fcpl.userblock == 1024);
}

