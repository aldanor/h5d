/* HDF5 "direct" File Driver */

module hdf5.c.drivers.direct;

import hdf5.c.h5;
import hdf5.c.h5i;

hid_t H5FD_DIRECT() @property @nogc {
    version (H5_HAVE_DIRECT) {
        return H5FD_direct_init();
    }
    else {
        return -1;
    }
}

extern (C) nothrow @nogc:

version (H5_HAVE_DIRECT) {
    enum uint MBOUNDARY_DEF = 4096;
    enum uint FBSIZE_DEF    = 4096;
    enum uint CBSIZE_DEF    = 16 * 1024 * 1024;

    hid_t   H5FD_direct_init();
    void    H5FD_direct_term();
    herr_t  H5Pset_fapl_direct(hid_t fapl_id, size_t alignment, size_t block_size,
                               size_t cbuf_size);
    herr_t  H5Pget_fapl_direct(hid_t fapl_id, size_t *boundary, size_t *block_size,
                               size_t *cbuf_size);
}
