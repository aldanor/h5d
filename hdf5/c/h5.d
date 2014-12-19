/* HDF5 API Public Declarations */

module hdf5.c.h5;

/* Constants, enums and aliases */

enum H5_VERS_MAJOR      = 1;
enum H5_VERS_MINOR      = 8;
enum H5_VERS_RELEASE    = 14;
enum H5_VERS_SUBRELEASE = "";
enum H5_VERS_INFO       = "HDF5 library version: 1.8.14";

alias herr_t   = int;
alias hbool_t  = uint;
alias htri_t   = int;
alias hsize_t  = ulong;
alias hssize_t = long;
alias haddr_t  = ulong;

alias ssize_t  = ptrdiff_t;

enum haddr_t HADDR_UNDEF = -1;
enum haddr_t HADDR_MAX   = HADDR_UNDEF - 1;

enum H5_iter_order_t {
    H5_ITER_UNKNOWN = -1,
    H5_ITER_INC,
    H5_ITER_DEC,
    H5_ITER_NATIVE,
    H5_ITER_N
}

enum {
    H5_ITER_ERROR = -1,
    H5_ITER_CONT,
    H5_ITER_STOP
}

enum H5_index_t {
    H5_INDEX_UNKNOWN = -1,
    H5_INDEX_NAME,
    H5_INDEX_CRT_ORDER,
    H5_INDEX_N
}

/* Extern declarations, structs and globals */

extern (C) nothrow:

herr_t H5check() {
    return H5check_version(H5_VERS_MAJOR, H5_VERS_MINOR, H5_VERS_RELEASE);
}

bool H5_VERSION_GE(uint major, uint minor, uint release) {
    return
        (((H5_VERS_MAJOR == major) && (H5_VERS_MINOR == minor) && (H5_VERS_RELEASE >= release)) ||
        ((H5_VERS_MAJOR == major) && (H5_VERS_MINOR > minor)) ||
        (H5_VERS_MAJOR > major));
}

bool H5_VERSION_LE(uint major, uint minor, uint release) {
    return
        (((H5_VERS_MAJOR == major) && (H5_VERS_MINOR == minor) && (H5_VERS_RELEASE <= release)) ||
        ((H5_VERS_MAJOR == major) && (H5_VERS_MINOR < minor)) ||
        (H5_VERS_MAJOR < major));
}

struct H5_ih_info_t {
    hsize_t     index_size;
    hsize_t     heap_size;
}

herr_t H5open();
herr_t H5close();
herr_t H5dont_atexit();
herr_t H5garbage_collect();
herr_t H5set_free_list_limits(int reg_global_lim, int reg_list_lim, int arr_global_lim,
                              int arr_list_lim, int blk_global_lim, int blk_list_lim);
herr_t H5get_libversion(uint *majnum, uint *minnum, uint *relnum);
herr_t H5check_version(uint majnum, uint minnum, uint relnum);
herr_t H5free_memory(void *mem);
