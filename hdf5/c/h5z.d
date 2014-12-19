/* HDF5 Data Filters API */

module hdf5.c.h5z;

import hdf5.c.h5;
import hdf5.c.h5i;

/* Constants, enums and aliases */

alias H5Z_filter_t = int;

enum int H5Z_FILTER_ERROR       = -1;
enum int H5Z_FILTER_NONE        = 0;
enum int H5Z_FILTER_DEFLATE     = 1;
enum int H5Z_FILTER_SHUFFLE     = 2;
enum int H5Z_FILTER_FLETCHER32  = 3;
enum int H5Z_FILTER_SZIP        = 4;
enum int H5Z_FILTER_NBIT        = 5;
enum int H5Z_FILTER_SCALEOFFSET = 6;
enum int H5Z_FILTER_RESERVED    = 256;

enum int H5Z_FILTER_MAX         = 65535;

enum int H5Z_FILTER_ALL         = 0;
enum int H5Z_MAX_NFILTERS       = 32;

enum uint H5Z_FLAG_DEFMASK      = 0x00ff;
enum uint H5Z_FLAG_MANDATORY    = 0x0000;
enum uint H5Z_FLAG_OPTIONAL     = 0x0001;

enum uint H5Z_FLAG_INVMASK      = 0xff00;
enum uint H5Z_FLAG_REVERSE      = 0x0100;
enum uint H5Z_FLAG_SKIP_EDC     = 0x0200;

enum uint H5_SZIP_ALLOW_K13_OPTION_MASK = 1;
enum uint H5_SZIP_CHIP_OPTION_MASK      = 2;
enum uint H5_SZIP_EC_OPTION_MASK        = 4;
enum uint H5_SZIP_NN_OPTION_MASK        = 32;
enum uint H5_SZIP_MAX_PIXELS_PER_BLOCK  = 32;

enum uint H5Z_SHUFFLE_USER_NPARMS       = 0;
enum uint H5Z_SHUFFLE_TOTAL_NPARMS      = 1;

enum uint H5Z_SZIP_USER_NPARMS  = 2;
enum uint H5Z_SZIP_TOTAL_NPARMS = 4;
enum uint H5Z_SZIP_PARM_MASK    = 0;
enum uint H5Z_SZIP_PARM_PPB     = 1;
enum uint H5Z_SZIP_PARM_BPP     = 2;
enum uint H5Z_SZIP_PARM_PPS     = 3;

enum uint H5Z_NBIT_USER_NPARMS = 0;

enum uint H5Z_SCALEOFFSET_USER_NPARMS = 2;

enum uint H5Z_SO_INT_MINBITS_DEFAULT = 0;

enum H5Z_SO_scale_type_t {
    H5Z_SO_FLOAT_DSCALE = 0,
    H5Z_SO_FLOAT_ESCALE,
    H5Z_SO_INT
}

enum uint H5Z_CLASS_T_VERS = 1;

enum H5Z_EDC_t {
    H5Z_ERROR_EDC = -1,
    H5Z_DISABLE_EDC,
    H5Z_ENABLE_EDC,
    H5Z_NO_EDC
}

enum uint H5Z_FILTER_CONFIG_ENCODE_ENABLED = 0x0001;
enum uint H5Z_FILTER_CONFIG_DECODE_ENABLED = 0x0002;

enum H5Z_cb_return_t {
    H5Z_CB_ERROR = -1,
    H5Z_CB_FAIL,
    H5Z_CB_CONT,
    H5Z_CB_NO
}

/* Extern declarations, structs and globals */

extern (C) nothrow:

struct H5Z_cb_t {
    H5Z_filter_func_t func;
    void             *op_data;
}

struct H5Z_class2_t {
    int                  version_; // was "version"
    H5Z_filter_t         id;
    uint                 encoder_present;
    uint                 decoder_present;
    const char          *name;
    H5Z_can_apply_func_t can_apply;
    H5Z_set_local_func_t set_local;
    H5Z_func_t           filter;
}

alias H5Z_filter_func_t    = H5Z_cb_return_t function (H5Z_filter_t filter, void* buf,
                                                       size_t buf_size, void* op_data);
alias H5Z_can_apply_func_t = htri_t function (hid_t dcpl_id, hid_t type_id, hid_t space_id);
alias H5Z_set_local_func_t = herr_t function (hid_t dcpl_id, hid_t type_id, hid_t space_id);
alias H5Z_func_t           = size_t function (uint flags, size_t cd_nelmts, const uint cd_values[],
                                              size_t nbytes, size_t *buf_size, void **buf);

herr_t  H5Zregister(const void *cls);
herr_t  H5Zunregister(H5Z_filter_t id);
htri_t  H5Zfilter_avail(H5Z_filter_t id);
herr_t  H5Zget_filter_info(H5Z_filter_t filter, uint *filter_config_flags);
