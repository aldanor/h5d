/* HDF5 "core" File Driver */

module hdf5.c.drivers.core;

import hdf5.c.h5;
import hdf5.c.h5i;

hid_t H5FD_CORE() @property {
    return H5FD_core_init();
}

extern (C) nothrow:

hid_t   H5FD_core_init();
void    H5FD_core_term();
herr_t  H5Pset_fapl_core(hid_t fapl_id, size_t increment, hbool_t backing_store);
herr_t  H5Pget_fapl_core(hid_t fapl_id, size_t *increment, hbool_t *backing_store);
