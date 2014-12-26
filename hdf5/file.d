module hdf5.file;

import hdf5.id;
import hdf5.api;
import hdf5.exception;

public import hdf5.id;
public import hdf5.plist;
public import hdf5.container;

import std.string    : toStringz;

version (unittest) {
    import std.stdio;
}

public final class H5File : H5Container {
    package this(hid_t id) { super(id); }

    public {
        static alias open = openH5File;

        this(in string filename, in string mode = null, size_t userblock = 0) {
            auto fapl = new H5FileAccessPL;
            this(filename, mode, userblock, fapl);
        }
    }

    public const @property {
        size_t userblock() {
            return this.fcpl.userblock;
        }

        string driver() {
            return this.fapl.driver;
        }

        size_t freeSpace() {
            return D_H5Fget_freespace(m_id);
        }

        size_t fileSize() {
            hsize_t size;
            D_H5Fget_filesize(m_id, &size);
            return size;
        }
    }

    private this(in string filename, in string mode, size_t userblock, in H5FileAccessPL fapl) {
        auto fcpl = new H5FileCreatePL;
        enforceH5((userblock == 0) || (mode != "r" && mode != "r+"),
                  "cannot specify userblock when reading a file");
        fcpl.userblock = userblock;

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
        else if (mode == "a")
            try
                file_id = open(H5F_ACC_RDWR);
            catch (H5Exception)
                file_id = create(H5F_ACC_EXCL);
        else if (mode is null)
            try
                file_id = open(H5F_ACC_RDWR);
            catch (H5Exception)
                try
                    file_id = open(H5F_ACC_RDONLY);
                catch (H5Exception)
                    file_id = create(H5F_ACC_EXCL);
        else
            throwH5(q{invalid mode: "%s" (expected r|r+|w|w-|x|a)}, mode);

        this(file_id);
        scope(failure) this.close();
        enforceH5(this.valid, "the opened file has a broken handle");
        enforceH5(userblock == this.userblock, "expected userblock %d, got %d",
                  userblock, this.userblock);
    }
}

public {
    /* TODO: add support for log, family, multi, split (mpio?) (windows?) */

    H5File openH5File
    (in string filename, in string mode = null, size_t userblock = 0)
    out (file) {
        assert(file.valid && file.driver == "sec2");
    }
    body {
        return new H5File(filename, mode, userblock);
    }

    H5File openH5File(string driver : "stdio")
    (in string filename, in string mode = null, size_t userblock = 0)
    out (file) {
        assert(file.valid && file.driver == "stdio");
    }
    body {
        auto fapl = new H5FileAccessPL;
        fapl.setDriver!"stdio";
        return new H5File(filename, mode, userblock, fapl);
    }

    H5File openH5File(string driver : "sec2")
    (in string filename, in string mode = null, size_t userblock = 0)
    out (file) {
        assert(file.valid && file.driver == "sec2");
    }
    body {
        auto fapl = new H5FileAccessPL;
        fapl.setDriver!"sec2";
        return new H5File(filename, mode, userblock, fapl);
    }

    H5File openH5File(string driver : "core", bool filebacked = CORE_DRIVER_FILEBACKED,
                      size_t increment = CORE_DRIVER_INCREMENT)
    (in string filename, in string mode = null, size_t userblock = 0)
    out (file) {
        assert(file.valid && file.driver == "core");
    }
    body {
        /* TODO: add support for core images */
        auto fapl = new H5FileAccessPL;
        fapl.setDriver!"core"(filebacked, increment);
        return new H5File(filename, mode, userblock, fapl);
    }
}

unittest {
    import std.file : tempDir, remove, exists;
    import std.path : buildPath;

    auto dir = tempDir();
    auto filename = "foo.h5";
    auto path = dir.buildPath(filename);
    scope(exit) remove(path);

    auto file = new H5File(path);
    scope(exit) file.close();
    assert(path.exists);
    assert(file.driver == "sec2");
    assert(file.filename == path);
    assert(file.name == "/");
    assert(file.userblock == 0);
}
