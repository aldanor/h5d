/* HDF5 Metadata Cache API */

module hdf5.c.h5ac;

import hdf5.c.h5;
import hdf5.c.h5c;

/* Constants and enums */

enum int H5AC__CURR_CACHE_CONFIG_VERSION = 1;
enum int H5AC__MAX_TRACE_FILE_NAME_LEN   = 1024;

enum int H5AC_METADATA_WRITE_STRATEGY__PROCESS_0_ONLY = 0;
enum int H5AC_METADATA_WRITE_STRATEGY__DISTRIBUTED    = 1;

/* Extern declarations, structs and globals */

extern (C) nothrow:

struct H5AC_cache_config_t {
    int     version_;               // was "version"
    hbool_t rpt_fcn_enabled;
    hbool_t open_trace_file;
    hbool_t close_trace_file;
    char    trace_file_name[H5AC__MAX_TRACE_FILE_NAME_LEN + 1];
    hbool_t evictions_enabled;
    hbool_t set_initial_size;
    size_t  initial_size;
    double  min_clean_fraction;
    size_t  max_size;
    size_t  min_size;
    int     epoch_length;
    H5C_cache_incr_mode         incr_mode;
    double  lower_hr_threshold;
    double  increment;
    hbool_t apply_max_increment;
    size_t  max_increment;
    H5C_cache_flash_incr_mode   flash_incr_mode;
    double  flash_multiple;
    double  flash_threshold;
    H5C_cache_decr_mode         decr_mode;
    double  upper_hr_threshold;
    double  decrement;
    hbool_t apply_max_decrement;
    size_t  max_decrement;
    int     epochs_before_eviction;
    hbool_t apply_empty_reserve;
    double  empty_reserve;
    int     dirty_bytes_threshold;
    int     metadata_write_strategy;
}
