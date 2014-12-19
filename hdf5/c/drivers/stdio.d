/* HDF5 "stdio" File Driver */

module hdf5.c.drivers.stdio;

import hdf5.c.h5;
import hdf5.c.h5i;

hid_t H5FD_STDIO() @property {
    return H5FD_stdio_init();
}

extern (C) nothrow:

hid_t   H5FD_stdio_init();
void    H5FD_stdio_term();
herr_t  H5Pset_fapl_stdio(hid_t fapl_id);
