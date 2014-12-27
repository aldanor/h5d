/* HDF5 "sec2" File Driver */

module hdf5.c.drivers.sec2;

import hdf5.c.h5;
import hdf5.c.h5i;

hid_t H5FD_SEC2() @property @nogc {
    return H5FD_sec2_init();
}

extern (C) nothrow @nogc:

hid_t   H5FD_sec2_init();
void    H5FD_sec2_term();
herr_t  H5Pset_fapl_sec2(hid_t fapl_id);
