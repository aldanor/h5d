/* HDF5 "family" File Driver */

module hdf5.c.drivers.family;

import hdf5.c.h5;
import hdf5.c.h5i;

hid_t H5FD_FAMILY() @property @nogc {
    return H5FD_family_init;
}

extern (C) nothrow @nogc:

hid_t   H5FD_family_init();
void    H5FD_family_term();
herr_t  H5Pset_fapl_family(hid_t fapl_id, hsize_t memb_size, hid_t memb_fapl_id);
herr_t  H5Pget_fapl_family(hid_t fapl_id, hsize_t *memb_size, hid_t *memb_fapl_id);
