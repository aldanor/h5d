/* HDF5 Memory Management API */

module hdf5.c.h5mm;

import hdf5.c.h5;

extern (C) nothrow:

alias H5MM_allocate_t = void *function (size_t size, void *alloc_info);
alias H5MM_free_t = void function (void *mem, void *free_info);
