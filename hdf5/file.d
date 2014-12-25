module hdf5.file;

import hdf5.id;
import hdf5.api;
import hdf5.exception;
import hdf5.container;

import std.string : toStringz, format;

class H5File : H5Container {
    package this(hid_t id) { super(id); }

    protected H5ID fcpl() const {
        return new H5ID(D_H5Fget_create_plist(m_id));
    }

    public hsize_t userblock() const {
        hsize_t userblock;
        D_H5Pget_userblock(this.fcpl.id, &userblock);
        return userblock;
    }

    public static alias open = openH5File;

    public this(string filename, string mode = null, hsize_t userblock = 0) {
        this(makeFAPL(), filename, mode, userblock);
    }

    private this(in H5ID fapl, string filename, string mode, hsize_t userblock) {
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
    (string filename, string mode = null, hsize_t userblock = 0) {
        return new H5File(makeFAPL(), filename, mode, userblock);
    }

    H5File openH5File(string driver : "stdio")
    (string filename, string mode = null, hsize_t userblock = 0) {
        auto fapl = makeFAPL();
        D_H5Pset_fapl_stdio(fapl.id);
        return new H5File(fapl, filename, mode, userblock);
    }

    H5File openH5File(string driver : "sec2")
    (string filename, string mode = null, hsize_t userblock = 0) {
        auto fapl = makeFAPL();
        D_H5Pset_fapl_sec2(fapl.id);
        return new H5File(fapl, filename, mode, userblock);
    }

    H5File openH5File(string driver : "core", bool filebacked = true,
                             size_t increment = 64 * 1024 * 1024)
    (string filename, string mode = null, hsize_t userblock = 0) {
        auto fapl = makeFAPL();
        D_H5Pset_fapl_core(fapl.id, increment, filebacked);
        return new H5File(fapl, filename, mode, userblock);
    }
}
