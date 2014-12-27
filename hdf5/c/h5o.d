/* HDF5 Object Headers API */

module hdf5.c.h5o;

import core.stdc.stdint;
import core.stdc.time;

import hdf5.c.h5;
import hdf5.c.h5i;
import hdf5.c.h5l;

/* Constants, enums and aliases */

enum uint H5O_COPY_SHALLOW_HIERARCHY_FLAG     = 0x0001u;
enum uint H5O_COPY_EXPAND_SOFT_LINK_FLAG      = 0x0002u;
enum uint H5O_COPY_EXPAND_EXT_LINK_FLAG       = 0x0004u;
enum uint H5O_COPY_EXPAND_REFERENCE_FLAG      = 0x0008u;
enum uint H5O_COPY_WITHOUT_ATTR_FLAG          = 0x0010u;
enum uint H5O_COPY_PRESERVE_NULL_FLAG         = 0x0020u;
enum uint H5O_COPY_MERGE_COMMITTED_DTYPE_FLAG = 0x0040u;
enum uint H5O_COPY_ALL                        = 0x007Fu;

enum uint H5O_SHMESG_NONE_FLAG    = 0x0000;
enum uint H5O_SHMESG_SDSPACE_FLAG = 1 << 0x0001;
enum uint H5O_SHMESG_DTYPE_FLAG   = 1 << 0x0003;
enum uint H5O_SHMESG_FILL_FLAG    = 1 << 0x0005;
enum uint H5O_SHMESG_PLINE_FLAG   = 1 << 0x000b;
enum uint H5O_SHMESG_ATTR_FLAG    = 1 << 0x000c;
enum uint H5O_SHMESG_ALL_FLAG     = H5O_SHMESG_SDSPACE_FLAG | H5O_SHMESG_DTYPE_FLAG |
                                    H5O_SHMESG_FILL_FLAG | H5O_SHMESG_PLINE_FLAG |
                                    H5O_SHMESG_ATTR_FLAG;

enum uint H5O_HDR_CHUNK0_SIZE             = 0x03;
enum uint H5O_HDR_ATTR_CRT_ORDER_TRACKED  = 0x04;
enum uint H5O_HDR_ATTR_CRT_ORDER_INDEXED  = 0x08;
enum uint H5O_HDR_ATTR_STORE_PHASE_CHANGE = 0x10;
enum uint H5O_HDR_STORE_TIMES             = 0x20;
enum uint H5O_HDR_ALL_FLAGS               = H5O_HDR_CHUNK0_SIZE | H5O_HDR_ATTR_CRT_ORDER_TRACKED |
                                            H5O_HDR_ATTR_CRT_ORDER_INDEXED |
                                            H5O_HDR_ATTR_STORE_PHASE_CHANGE | H5O_HDR_STORE_TIMES;

enum uint H5O_SHMESG_MAX_NINDEXES  = 8;
enum uint H5O_SHMESG_MAX_LIST_SIZE = 5000;

enum H5O_type_t {
    H5O_TYPE_UNKNOWN = -1,
    H5O_TYPE_GROUP,
    H5O_TYPE_DATASET,
    H5O_TYPE_NAMED_DATATYPE,
    H5O_TYPE_NTYPES
}

enum H5O_mcdt_search_ret_t {
    H5O_MCDT_SEARCH_ERROR = -1,
    H5O_MCDT_SEARCH_CONT,
    H5O_MCDT_SEARCH_STOP
}

alias H5O_msg_crt_idx_t = uint32_t;

/* Extern declarations, structs and globals */

extern (C) nothrow @nogc:

struct H5O_hdr_info_t {
    uint version_; // was "version"
    uint nmesgs;
    uint nchunks;
    uint flags;
    static struct space { // was struct {} space
        hsize_t total;
        hsize_t meta;
        hsize_t mesg;
        hsize_t free;
    }
    static struct mesg { // was struct {} mesg
        uint64_t present;
        uint64_t shared_; // was "shared"
    }
}

struct H5O_info_t {
    ulong           fileno;
    haddr_t         addr;
    H5O_type_t      type;
    uint            rc;
    time_t          atime;
    time_t          mtime;
    time_t          ctime;
    time_t          btime;
    hsize_t         num_attrs;
    H5O_hdr_info_t  hdr;
    static struct meta_size { // was struct {} meta_size
        H5_ih_info_t   obj;
        H5_ih_info_t   attr;
    }
}

alias H5O_iterate_t        = herr_t function (hid_t obj, const char *name, const H5O_info_t *info,
                                              void *op_data);
alias H5O_mcdt_search_cb_t = H5O_mcdt_search_ret_t function (void *op_data);

hid_t   H5Oopen(hid_t loc_id, const char *name, hid_t lapl_id);
hid_t   H5Oopen_by_addr(hid_t loc_id, haddr_t addr);
hid_t   H5Oopen_by_idx(hid_t loc_id, const char *group_name, H5_index_t idx_type,
                       H5_iter_order_t order, hsize_t n, hid_t lapl_id);
htri_t  H5Oexists_by_name(hid_t loc_id, const char *name, hid_t lapl_id);
herr_t  H5Oget_info(hid_t loc_id, H5O_info_t *oinfo);
herr_t  H5Oget_info_by_name(hid_t loc_id, const char *name, H5O_info_t *oinfo, hid_t lapl_id);
herr_t  H5Oget_info_by_idx(hid_t loc_id, const char *group_name, H5_index_t idx_type,
                           H5_iter_order_t order, hsize_t n, H5O_info_t *oinfo, hid_t lapl_id);
herr_t  H5Olink(hid_t obj_id, hid_t new_loc_id, const char *new_name, hid_t lcpl_id,
                hid_t lapl_id);
herr_t  H5Oincr_refcount(hid_t object_id);
herr_t  H5Odecr_refcount(hid_t object_id);
herr_t  H5Ocopy(hid_t src_loc_id, const char *src_name, hid_t dst_loc_id, const char *dst_name,
                hid_t ocpypl_id, hid_t lcpl_id);
herr_t  H5Oset_comment(hid_t obj_id, const char *comment);
herr_t  H5Oset_comment_by_name(hid_t loc_id, const char *name, const char *comment, hid_t lapl_id);
ssize_t H5Oget_comment(hid_t obj_id, char *comment, size_t bufsize);
ssize_t H5Oget_comment_by_name(hid_t loc_id, const char *name, char *comment, size_t bufsize,
                               hid_t lapl_id);
herr_t  H5Ovisit(hid_t obj_id, H5_index_t idx_type, H5_iter_order_t order, H5O_iterate_t op,
                 void *op_data);
herr_t  H5Ovisit_by_name(hid_t loc_id, const char *obj_name, H5_index_t idx_type,
                         H5_iter_order_t order, H5O_iterate_t op, void *op_data, hid_t lapl_id);
herr_t H5Oclose(hid_t object_id);
