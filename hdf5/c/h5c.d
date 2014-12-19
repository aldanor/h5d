/* HDF5 Cache Functions API */

module hdf5.c.h5c;

import hdf5.c.h5;

/* Constants, enums and aliases */

enum H5C_cache_incr_mode {
    H5C_incr__off = 0,
    H5C_incr__threshold
}

enum H5C_cache_flash_incr_mode {
     H5C_flash_incr__off = 0,
     H5C_flash_incr__add_space
}

enum H5C_cache_decr_mode {
    H5C_decr__off = 0,
    H5C_decr__threshold,
    H5C_decr__age_out,
    H5C_decr__age_out_with_threshold
}
