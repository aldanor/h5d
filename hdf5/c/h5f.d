/* HDF5 Files API */

module hdf5.c.h5f;

import hdf5.c.h5;
import hdf5.c.h5ac;
import hdf5.c.h5i;

/* Constants, enums and aliases */

package {
    enum uint H5F_ACC_RDONLY_g  = 0x0000u;
    enum uint H5F_ACC_RDWR_g    = 0x0001u;
    enum uint H5F_ACC_TRUNC_g   = 0x0002u;
    enum uint H5F_ACC_EXCL_g    = 0x0004u;
    enum uint H5F_ACC_DEBUG_g   = 0x0008u;
    enum uint H5F_ACC_CREAT_g   = 0x0010u;

    enum uint H5F_ACC_DEFAULT_g = 0xffffu;
}

enum uint H5F_OBJ_FILE     = 0x0001u;
enum uint H5F_OBJ_DATASET  = 0x0002u;
enum uint H5F_OBJ_GROUP    = 0x0004u;
enum uint H5F_OBJ_DATATYPE = 0x0008u;
enum uint H5F_OBJ_ATTR     = 0x0010u;
enum uint H5F_OBJ_ALL      = H5F_OBJ_FILE | H5F_OBJ_DATASET | H5F_OBJ_GROUP |
                             H5F_OBJ_DATATYPE | H5F_OBJ_ATTR;
enum uint H5F_OBJ_LOCAL    = 0x0020u;

enum hsize_t H5F_FAMILY_DEFAULT = 0;

version (H5_HAVE_PARALLEL) {
    enum H5F_MPIO_DEBUG_KEY = "H5F_mpio_debug_key";
}

enum H5F_scope_t {
    H5F_SCOPE_LOCAL = 0,
    H5F_SCOPE_GLOBAL
}

enum hsize_t H5F_UNLIMITED = -1L;

enum H5F_close_degree_t {
    H5F_CLOSE_DEFAULT = 0,
    H5F_CLOSE_WEAK,
    H5F_CLOSE_SEMI,
    H5F_CLOSE_STRONG
}

enum H5F_mem_t {
    H5FD_MEM_NOLIST = -1,
    H5FD_MEM_DEFAULT,
    H5FD_MEM_SUPER,
    H5FD_MEM_BTREE,
    H5FD_MEM_DRAW,
    H5FD_MEM_GHEAP,
    H5FD_MEM_LHEAP,
    H5FD_MEM_OHDR,
    H5FD_MEM_NTYPES
}

enum H5F_libver_t {
    H5F_LIBVER_EARLIEST = 0,
    H5F_LIBVER_LATEST
}

enum H5F_file_space_type_t {
    H5F_FILE_SPACE_DEFAULT = 0,
    H5F_FILE_SPACE_ALL_PERSIST,
    H5F_FILE_SPACE_ALL,
    H5F_FILE_SPACE_AGGR_VFD,
    H5F_FILE_SPACE_VFD,
    H5F_FILE_SPACE_NTYPES
}

/* Extern declarations, structs and globals */

extern (C) nothrow:

struct H5F_info2_t {
    static struct super_ {              // originally: struct {} super
        uint        version_;           // originally: "version"
        hsize_t     super_size;
        hsize_t     super_ext_size;
    }
    static struct free {                // originally: struct {} free
        uint        version_;           // originally: "version"
        hsize_t     meta_size;
        hsize_t     tot_space;
    }
    static struct sohm {                // originally: struct {} sohm
        uint         version_;          //originally: "version"
        hsize_t      hdr_size;
        H5_ih_info_t msgs_info;
    }
}

struct H5F_sect_info_t {
    haddr_t addr;
    hsize_t size;
}

htri_t  H5Fis_hdf5(const char *filename);
hid_t   H5Fcreate(const char *filename, uint flags, hid_t create_plist, hid_t access_plist);
hid_t   H5Fopen(const char *filename, uint flags, hid_t access_plist);
hid_t   H5Freopen(hid_t file_id);
herr_t  H5Fflush(hid_t object_id, H5F_scope_t scope_); // was "scope"
herr_t  H5Fclose(hid_t file_id);
hid_t   H5Fget_create_plist(hid_t file_id);
hid_t   H5Fget_access_plist(hid_t file_id);
herr_t  H5Fget_intent(hid_t file_id, uint *intent);
ssize_t H5Fget_obj_count(hid_t file_id, uint types);
ssize_t H5Fget_obj_ids(hid_t file_id, uint types, size_t max_objs, hid_t *obj_id_list);
herr_t  H5Fget_vfd_handle(hid_t file_id, hid_t fapl, void **file_handle);
herr_t  H5Fmount(hid_t loc, const char *name, hid_t child, hid_t plist);
herr_t  H5Funmount(hid_t loc, const char *name);
hssize_t    H5Fget_freespace(hid_t file_id);
herr_t  H5Fget_filesize(hid_t file_id, hsize_t *size);
ssize_t H5Fget_file_image(hid_t file_id, void *buf_ptr, size_t buf_len);
herr_t  H5Fget_mdc_config(hid_t file_id, H5AC_cache_config_t *config_ptr);
herr_t  H5Fset_mdc_config(hid_t file_id, H5AC_cache_config_t *config_ptr);
herr_t  H5Fget_mdc_hit_rate(hid_t file_id, double *hit_rate_ptr);
herr_t  H5Fget_mdc_size(hid_t file_id, size_t *max_size_ptr, size_t *min_clean_size_ptr,
                       size_t *cur_size_ptr, int *cur_num_entries_ptr);
herr_t  H5Freset_mdc_hit_rate_stats(hid_t file_id);
ssize_t H5Fget_name(hid_t obj_id, char *name, size_t size);
herr_t  H5Fget_info2(hid_t obj_id, H5F_info2_t *finfo);
ssize_t H5Fget_free_sections(hid_t file_id, H5F_mem_t type, size_t nsects,
                             H5F_sect_info_t *sect_info);
herr_t  H5Fclear_elink_file_cache(hid_t file_id);

version (H5_HAVE_PARALLEL) {
    herr_t  H5Fset_mpi_atomicity(hid_t file_id, hbool_t flag);
    herr_t  H5Fget_mpi_atomicity(hid_t file_id, hbool_t *flag);
}

/* Register properties */

import hdf5.c.meta;
mixin makeProperties!(mixin(__MODULE__), "_g", H5check);
