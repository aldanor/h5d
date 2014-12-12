/* HDF5 Datasets API */

module hdf5.c.h5d;

import hdf5.c.h5;
import hdf5.c.h5i;

extern (C) nothrow:

enum size_t H5D_CHUNK_CACHE_NSLOTS_DEFAULT = -1;
enum size_t H5D_CHUNK_CACHE_NBYTES_DEFAULT = -1;
enum H5D_CHUNK_CACHE_W0_DEFAULT            = 1.0f;

enum H5D_XFER_DIRECT_CHUNK_WRITE_FLAG_NAME     = "direct_chunk_flag";
enum H5D_XFER_DIRECT_CHUNK_WRITE_FILTERS_NAME  = "direct_chunk_filters";
enum H5D_XFER_DIRECT_CHUNK_WRITE_OFFSET_NAME   = "direct_chunk_offset";
enum H5D_XFER_DIRECT_CHUNK_WRITE_DATASIZE_NAME = "direct_chunk_datasize";

enum H5D_layout_t {
    H5D_LAYOUT_ERROR = -1,
    H5D_COMPACT,
    H5D_CONTIGUOUS,
    H5D_CHUNKED,
    H5D_NLAYOUTS
}

enum H5D_chunk_index_t {
    H5D_CHUNK_BTREE = 0
}

enum H5D_alloc_time_t {
    H5D_ALLOC_TIME_ERROR = -1,
    H5D_ALLOC_TIME_DEFAULT,
    H5D_ALLOC_TIME_EARLY,
    H5D_ALLOC_TIME_LATE,
    H5D_ALLOC_TIME_INCR
}

enum H5D_space_status_t {
    H5D_SPACE_STATUS_ERROR = -1,
    H5D_SPACE_STATUS_NOT_ALLOCATED,
    H5D_SPACE_STATUS_PART_ALLOCATED,
    H5D_SPACE_STATUS_ALLOCATED
}

enum H5D_fill_time_t {
    H5D_FILL_TIME_ERROR = -1,
    H5D_FILL_TIME_ALLOC,
    H5D_FILL_TIME_NEVER,
    H5D_FILL_TIME_IFSET
}

enum H5D_fill_value_t {
    H5D_FILL_VALUE_ERROR = -1,
    H5D_FILL_VALUE_UNDEFINED,
    H5D_FILL_VALUE_DEFAULT,
    H5D_FILL_VALUE_USER_DEFINED
}

alias   H5D_operator_t = herr_t function(void *elem, hid_t type_id, uint ndim,
                                         const hsize_t *point, void *operator_data);
alias   H5D_scatter_func_t = herr_t function(const void **src_buf, size_t *src_buf_bytes_used,
                                             void *op_data);
alias   H5D_gather_func_t = herr_t function(const void *dst_buf, size_t dst_buf_bytes_used,
                                            void *op_data);

hid_t   H5Dcreate2(hid_t loc_id, const char *name, hid_t type_id,
                 hid_t space_id, hid_t lcpl_id, hid_t dcpl_id, hid_t dapl_id);
hid_t   H5Dcreate_anon(hid_t file_id, hid_t type_id, hid_t space_id,
        hid_t plist_id, hid_t dapl_id);
hid_t   H5Dopen2(hid_t file_id, const char *name, hid_t dapl_id);
herr_t  H5Dclose(hid_t dset_id);
hid_t   H5Dget_space(hid_t dset_id);
herr_t  H5Dget_space_status(hid_t dset_id, H5D_space_status_t *allocation);
hid_t   H5Dget_type(hid_t dset_id);
hid_t   H5Dget_create_plist(hid_t dset_id);
hid_t   H5Dget_access_plist(hid_t dset_id);
hsize_t H5Dget_storage_size(hid_t dset_id);
haddr_t H5Dget_offset(hid_t dset_id);
herr_t  H5Dread(hid_t dset_id, hid_t mem_type_id, hid_t mem_space_id,
               hid_t file_space_id, hid_t plist_id, void *buf);
herr_t  H5Dwrite(hid_t dset_id, hid_t mem_type_id, hid_t mem_space_id,
             hid_t file_space_id, hid_t plist_id, const void *buf);
herr_t  H5Diterate(void *buf, hid_t type_id, hid_t space_id,
                  H5D_operator_t op, void *operator_data);
herr_t  H5Dvlen_reclaim(hid_t type_id, hid_t space_id, hid_t plist_id, void *buf);
herr_t  H5Dvlen_get_buf_size(hid_t dataset_id, hid_t type_id, hid_t space_id, hsize_t *size);
herr_t  H5Dfill(const void *fill, hid_t fill_type, void *buf, hid_t buf_type, hid_t space);
herr_t  H5Dset_extent(hid_t dset_id, const hsize_t size[]);
herr_t  H5Dscatter(H5D_scatter_func_t op, void *op_data, hid_t type_id,
                  hid_t dst_space_id, void *dst_buf);
herr_t  H5Dgather(hid_t src_space_id, const void *src_buf, hid_t type_id,
                 size_t dst_buf_size, void *dst_buf, H5D_gather_func_t op, void *op_data);
herr_t  H5Ddebug(hid_t dset_id);
