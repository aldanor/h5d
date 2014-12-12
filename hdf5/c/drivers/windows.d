/* HDF5 "windows" File Driver */

module hdf5.c.drivers.windows;

import hdf5.c.h5;
import hdf5.c.h5i;
import hdf5.c.drivers.sec2;

const hid_t H5FD_WINDOWS;

shared static this() {
    version (Windows) {
        H5FD_WINDOWS = H5FD_windows_init();
    }
    else {
        H5FD_WINDOWS = -1;
    }
}

extern (C) nothrow:

version (Windows) {
    alias H5FD_windows_init = H5FD_sec2_init;
    alias H5FD_windows_term = H5FD_sec2_term;

    herr_t  H5Pset_fapl_windows(hid_t fapl_id);
}
