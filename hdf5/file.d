module hdf5.file;

import hdf5.id;
import hdf5.api;
import hdf5.exception;

public import hdf5.container;

import std.string : toStringz, format;

version (unittest) {
    import std.stdio;
}

class H5File : H5Container {
    package this(hid_t id) { super(id); }

    public {
        static alias open = openH5File;

        this(string filename, string mode = null, hsize_t userblock = 0) {
            this(filename, mode, userblock, makeFAPL());
        }

        hsize_t userblock() const @property {
            hsize_t userblock;
            D_H5Pget_userblock(fcpl.id, &userblock);
            return userblock;
        }

        string driver() const @property {
            auto driver = new H5ID(D_H5Pget_driver(fapl.id));
            if (driver.id == H5FD_STDIO)
                return "stdio";
            else if (driver.id == H5FD_SEC2)
                return "sec2";
            else if (driver.id == H5FD_CORE)
                return "core";
            else
                throw new H5Exception("unknown file driver (ID %d)".format(driver.id));
        }
    }

    private this(string filename, string mode, hsize_t userblock, in H5ID fapl) {
        auto fcpl = makeFCPL();

        if (userblock > 0) {
            if (mode == "r" || mode == "r+")
                throw new H5Exception("cannot specify userblock size when reading a file");
            D_H5Pset_userblock(fcpl.id, userblock);
        }

        auto open = (uint flags) => D_H5Fopen(filename.toStringz, flags, fapl.id);
        auto create = (uint flags) => D_H5Fcreate(filename.toStringz, flags, fcpl.id, fapl.id);

        hid_t file_id = H5I_INVALID_HID;
        if (mode == "r")
            file_id = open(H5F_ACC_RDONLY);
        else if (mode == "r+")
            file_id = open(H5F_ACC_RDWR);
        else if (mode == "w-" || mode == "x")
            file_id = create(H5F_ACC_EXCL);
        else if (mode == "w")
            file_id = create(H5F_ACC_TRUNC);
        else if (mode == "a") {
            try
                file_id = open(H5F_ACC_RDWR);
            catch (H5Exception)
                file_id = create(H5F_ACC_EXCL);
        }
        else if (mode is null) {
            try
                file_id = open(H5F_ACC_RDWR);
            catch (H5Exception)
                try
                    file_id = open(H5F_ACC_RDONLY);
                catch (H5Exception)
                    file_id = create(H5F_ACC_EXCL);
        }
        else
            throw new H5Exception(q{invalid mode: "%s" (expected r|r+|w|w-|x|a)}.format(mode));

        this(file_id);
        scope(failure) this.close();
        if (!this.valid)
            throw new H5Exception("the opened file has a broken handle");
        if (userblock != this.userblock)
            throw new H5Exception("expected userblock %d, got %d"
                                  .format(userblock, this.userblock));
    }

    protected H5ID fcpl() const {
        return new H5ID(D_H5Fget_create_plist(m_id));
    }

    protected H5ID fapl() const {
        return new H5ID(D_H5Fget_access_plist(m_id));
    }
}

private {
    H5ID makeFCPL() {
        return new H5ID(D_H5Pcreate(H5P_FILE_CREATE));
    }

    H5ID makeFAPL() {
        return new H5ID(D_H5Pcreate(H5P_FILE_ACCESS));
    }
}

public {
    /* TODO: add support for log, family, multi, split (mpio?) (windows?) */

    H5File openH5File
    (string filename, string mode = null, hsize_t userblock = 0)
    out (file) {
        assert(file.driver == "sec2");
    }
    body {
        return new H5File(filename, mode, userblock, makeFAPL());
    }

    H5File openH5File(string driver : "stdio")
    (string filename, string mode = null, hsize_t userblock = 0)
    out (file) {
        assert(file.driver == "stdio");
    }
    body {
        auto fapl = makeFAPL();
        D_H5Pset_fapl_stdio(fapl.id);
        return new H5File(filename, mode, userblock, fapl);
    }

    H5File openH5File(string driver : "sec2")
    (string filename, string mode = null, hsize_t userblock = 0)
    out (file) {
        assert(file.driver == "sec2");
    }
    body {
        auto fapl = makeFAPL();
        D_H5Pset_fapl_sec2(fapl.id);
        return new H5File(filename, mode, userblock, fapl);
    }

    H5File openH5File(string driver : "core", bool filebacked = true,
                             size_t increment = 64 * 1024 * 1024)
    (string filename, string mode = null, hsize_t userblock = 0)
    out (file) {
        assert(file.driver == "core");
    }
    body {
        /* TODO: add support for core images */
        auto fapl = makeFAPL();
        D_H5Pset_fapl_core(fapl.id, increment, filebacked);
        return new H5File(filename, mode, userblock, fapl);
    }
}

unittest {
    import std.file;
    import std.path;

    auto dir = tempDir();
    auto filename = "foo.h5";
    auto path = dir.buildPath(filename);
    scope(exit) remove(path);

    auto file = new H5File(path);
    assert(path.exists);
    assert(file.driver == "sec2");
    assert(file.filename == path);
    assert(file.name == "/");
    assert(file.userblock == 0);
}
