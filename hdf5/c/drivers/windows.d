/* HDF5 "windows" File Driver */

module hdf5.c.drivers.windows;

import hdf5.c.h5;
import hdf5.c.h5i;
import hdf5.c.drivers.sec2;

hid_t H5FD_WINDOWS() @property @nogc {
    version (Windows) {
        return H5FD_windows_init();
    }
    else {
        return -1;
    }
}

extern (C) nothrow @nogc:

version (Windows) {
    alias H5FD_windows_init = H5FD_sec2_init;
    alias H5FD_windows_term = H5FD_sec2_term;

    herr_t  H5Pset_fapl_windows(hid_t fapl_id);
}
