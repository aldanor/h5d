/* HDF5 File Drivers API */

module hdf5.c.h5fd;

import hdf5.c.h5;
import hdf5.c.h5f;
import hdf5.c.h5i;

extern (C) nothrow:

enum int H5_HAVE_VFL      = 1;
enum int H5FD_VFD_DEFAULT = 0;

alias H5FD_mem_t = H5F_mem_t;

alias H5FD_MEM_FHEAP_HDR        = H5FD_mem_t.H5FD_MEM_OHDR;
alias H5FD_MEM_FHEAP_IBLOCK     = H5FD_mem_t.H5FD_MEM_OHDR;
alias H5FD_MEM_FHEAP_DBLOCK     = H5FD_mem_t.H5FD_MEM_LHEAP;
alias H5FD_MEM_FHEAP_HUGE_OBJ   = H5FD_mem_t.H5FD_MEM_DRAW;

alias H5FD_MEM_FSPACE_HDR       = H5FD_mem_t.H5FD_MEM_OHDR;
alias H5FD_MEM_FSPACE_SINFO     = H5FD_mem_t.H5FD_MEM_LHEAP;

alias H5FD_MEM_SOHM_TABLE       = H5FD_mem_t.H5FD_MEM_OHDR;
alias H5FD_MEM_SOHM_INDEX       = H5FD_mem_t.H5FD_MEM_BTREE;

alias H5FD_MEM_EARRAY_HDR       = H5FD_mem_t.H5FD_MEM_OHDR;
alias H5FD_MEM_EARRAY_IBLOCK    = H5FD_mem_t.H5FD_MEM_OHDR;
alias H5FD_MEM_EARRAY_SBLOCK    = H5FD_mem_t.H5FD_MEM_BTREE;
alias H5FD_MEM_EARRAY_DBLOCK    = H5FD_mem_t.H5FD_MEM_LHEAP;
alias H5FD_MEM_EARRAY_DBLK_PAGE = H5FD_mem_t.H5FD_MEM_LHEAP;

alias H5FD_MEM_FARRAY_HDR       = H5FD_mem_t.H5FD_MEM_OHDR;
alias H5FD_MEM_FARRAY_DBLOCK    = H5FD_mem_t.H5FD_MEM_LHEAP;
alias H5FD_MEM_FARRAY_DBLK_PAGE = H5FD_mem_t.H5FD_MEM_LHEAP;

enum uint[] H5FD_FLMAP_SINGLE = [
    H5FD_mem_t.H5FD_MEM_SUPER,
    H5FD_mem_t.H5FD_MEM_SUPER,
    H5FD_mem_t.H5FD_MEM_SUPER,
    H5FD_mem_t.H5FD_MEM_SUPER,
    H5FD_mem_t.H5FD_MEM_SUPER,
    H5FD_mem_t.H5FD_MEM_SUPER,
    H5FD_mem_t.H5FD_MEM_SUPER
];

enum uint[] H5FD_FLMAP_DICHOTOMY = [
    H5FD_mem_t.H5FD_MEM_SUPER,
    H5FD_mem_t.H5FD_MEM_SUPER,
    H5FD_mem_t.H5FD_MEM_SUPER,
    H5FD_mem_t.H5FD_MEM_DRAW,
    H5FD_mem_t.H5FD_MEM_DRAW,
    H5FD_mem_t.H5FD_MEM_SUPER,
    H5FD_mem_t.H5FD_MEM_SUPER
];

enum uint[] H5FD_FLMAP_DEFAULT = [
    H5FD_mem_t.H5FD_MEM_DEFAULT,
    H5FD_mem_t.H5FD_MEM_DEFAULT,
    H5FD_mem_t.H5FD_MEM_DEFAULT,
    H5FD_mem_t.H5FD_MEM_DEFAULT,
    H5FD_mem_t.H5FD_MEM_DEFAULT,
    H5FD_mem_t.H5FD_MEM_DEFAULT,
    H5FD_mem_t.H5FD_MEM_DEFAULT
];

enum uint H5FD_FEAT_AGGREGATE_METADATA           = 0x00000001;
enum uint H5FD_FEAT_ACCUMULATE_METADATA_WRITE    = 0x00000002;
enum uint H5FD_FEAT_ACCUMULATE_METADATA_READ     = 0x00000004;
enum uint H5FD_FEAT_ACCUMULATE_METADATA          = H5FD_FEAT_ACCUMULATE_METADATA_WRITE |
                                                   H5FD_FEAT_ACCUMULATE_METADATA_READ;
enum uint H5FD_FEAT_DATA_SIEVE                   = 0x00000008;
enum uint H5FD_FEAT_AGGREGATE_SMALLDATA          = 0x00000010;
enum uint H5FD_FEAT_IGNORE_DRVRINFO              = 0x00000020;
enum uint H5FD_FEAT_DIRTY_SBLK_LOAD              = 0x00000040;
enum uint H5FD_FEAT_POSIX_COMPAT_HANDLE          = 0x00000080;
enum uint H5FD_FEAT_HAS_MPI                      = 0x00000100;
enum uint H5FD_FEAT_ALLOCATE_EARLY               = 0x00000200;
enum uint H5FD_FEAT_ALLOW_FILE_IMAGE             = 0x00000400;
enum uint H5FD_FEAT_CAN_USE_FILE_IMAGE_CALLBACKS = 0x00000800;

struct H5FD_class_t {
    const char *name;
    haddr_t maxaddr;
    H5F_close_degree_t fc_degree;
    herr_t  function() terminate;
    hsize_t function (H5FD_t *file) sb_size;
    herr_t  function (H5FD_t *file, char *name, ubyte *p) sb_encode;
    herr_t  function (H5FD_t *f, const char *name, const ubyte *p) sb_decode;
    size_t  fapl_size;
    void *  function (H5FD_t *file) fapl_get;
    void *  function (const void *fapl) fapl_copy;
    herr_t  function (void *fapl) fapl_free;
    size_t  dxpl_size;
    void *  function (const void *dxpl) dxpl_copy;
    herr_t  function (void *dxpl) dxpl_free;
    H5FD_t  function (const char *name, uint flags, hid_t fapl, haddr_t maxaddr) *open;
    herr_t  function (H5FD_t *file) close;
    int     function (const H5FD_t *f1, const H5FD_t *f2) cmp;
    herr_t  function (const H5FD_t *f1, ulong *flags) query;
    herr_t  function (const H5FD_t *file, H5FD_mem_t *type_map) get_type_map;
    haddr_t function (H5FD_t *file, H5FD_mem_t type, hid_t dxpl_id, hsize_t size) alloc;
    herr_t  function (H5FD_t *file, H5FD_mem_t type, hid_t dxpl_id, haddr_t addr,
                      hsize_t size) free;
    haddr_t function (const H5FD_t *file, H5FD_mem_t type) get_eoa;
    herr_t  function (H5FD_t *file, H5FD_mem_t type, haddr_t addr) set_eoa;
    haddr_t function (const H5FD_t *file) get_eof;
    herr_t  function (H5FD_t *file, hid_t fapl, void **file_handle) get_handle;
    herr_t  function (H5FD_t *file, H5FD_mem_t type, hid_t dxpl, haddr_t addr,
                      size_t size, void *buffer) read;
    herr_t  function (H5FD_t *file, H5FD_mem_t type, hid_t dxpl, haddr_t addr,
                      size_t size, const void *buffer) write;
    herr_t  function (H5FD_t *file, hid_t dxpl_id, uint closing) flush;
    herr_t  function (H5FD_t *file, hid_t dxpl_id, hbool_t closing) truncate;
    herr_t  function (H5FD_t *file, ubyte *oid, uint lock_type, hbool_t last) lock;
    herr_t  function (H5FD_t *file, ubyte *oid, hbool_t last) unlock;
    H5FD_mem_t fl_map[H5FD_mem_t.H5FD_MEM_NTYPES];
}

struct H5FD_free_t {
    haddr_t      addr;
    hsize_t      size;
    H5FD_free_t *next;
}

struct H5FD_t {
    hid_t               driver_id;
    const H5FD_class_t *cls;
    ulong               fileno;
    ulong               feature_flags;
    haddr_t             maxaddr;
    haddr_t             base_addr;
    hsize_t             threshold;
    hsize_t             alignment;
}

enum H5FD_file_image_op_t {
    H5FD_FILE_IMAGE_OP_NO_OP = 0,
    H5FD_FILE_IMAGE_OP_PROPERTY_LIST_SET,
    H5FD_FILE_IMAGE_OP_PROPERTY_LIST_COPY,
    H5FD_FILE_IMAGE_OP_PROPERTY_LIST_GET,
    H5FD_FILE_IMAGE_OP_PROPERTY_LIST_CLOSE,
    H5FD_FILE_IMAGE_OP_FILE_OPEN,
    H5FD_FILE_IMAGE_OP_FILE_RESIZE,
    H5FD_FILE_IMAGE_OP_FILE_CLOSE
}

struct H5FD_file_image_callbacks_t {
    void    function (size_t size,
                      H5FD_file_image_op_t file_image_op, void *udata) *image_malloc;
    void    function (void *dest, const void *src, size_t size,
                      H5FD_file_image_op_t file_image_op, void *udata) *image_memcpy;
    void    function (void *ptr, size_t size,
                      H5FD_file_image_op_t file_image_op, void *udata) *image_realloc;
    herr_t  function (void *ptr,
                      H5FD_file_image_op_t file_image_op, void *udata) image_free;
    void    function (void *udata) *udata_copy;
    herr_t  function (void *udata) udata_free;
    void   *udata;
}

hid_t   H5FDregister(const H5FD_class_t *cls);
herr_t  H5FDunregister(hid_t driver_id);
H5FD_t *H5FDopen(const char *name, uint flags, hid_t fapl_id, haddr_t maxaddr);
herr_t  H5FDclose(H5FD_t *file);
int     H5FDcmp(const H5FD_t *f1, const H5FD_t *f2);
int     H5FDquery(const H5FD_t *f, ulong *flags);
haddr_t H5FDalloc(H5FD_t *file, H5FD_mem_t type, hid_t dxpl_id, hsize_t size);
herr_t  H5FDfree(H5FD_t *file, H5FD_mem_t type, hid_t dxpl_id, haddr_t addr, hsize_t size);
haddr_t H5FDget_eoa(H5FD_t *file, H5FD_mem_t type);
herr_t  H5FDset_eoa(H5FD_t *file, H5FD_mem_t type, haddr_t eoa);
haddr_t H5FDget_eof(H5FD_t *file);
herr_t  H5FDget_vfd_handle(H5FD_t *file, hid_t fapl, void**file_handle);
herr_t  H5FDread(H5FD_t *file, H5FD_mem_t type, hid_t dxpl_id,
                 haddr_t addr, size_t size, void *buf/*out*/);
herr_t  H5FDwrite(H5FD_t *file, H5FD_mem_t type, hid_t dxpl_id, haddr_t addr,
                  size_t size, const void *buf);
herr_t  H5FDflush(H5FD_t *file, hid_t dxpl_id, uint closing);
herr_t  H5FDtruncate(H5FD_t *file, hid_t dxpl_id, hbool_t closing);
