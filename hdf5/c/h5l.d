/* HDF5 Groups API */

module hdf5.c.h5l;

import core.stdc.stdint;

import hdf5.c.h5;
import hdf5.c.h5i;
import hdf5.c.h5t;

extern (C) nothrow:

enum uint32_t H5L_MAX_LINK_NAME_LEN = -1;

enum hid_t H5L_SAME_LOC = 0;

enum int H5L_LINK_CLASS_T_VERS  = 0;

enum H5L_type_t {
    H5L_TYPE_ERROR = -1,
    H5L_TYPE_HARD = 0,
    H5L_TYPE_SOFT = 1,
    H5L_TYPE_EXTERNAL = 64,
    H5L_TYPE_MAX = 255
}

alias H5L_TYPE_BUILTIN_MAX = H5L_type_t.H5L_TYPE_SOFT;
alias H5L_TYPE_UD_MIN      = H5L_type_t.H5L_TYPE_EXTERNAL;

struct H5L_info_t {
    H5L_type_t  type;
    hbool_t     corder_valid;
    int64_t     corder;
    H5T_cset_t  cset;
    static union u { // was union
        haddr_t     address;
        size_t      val_size;
    }
}

alias H5L_create_func_t = herr_t function (const char *link_name, hid_t loc_group,
                                           const void *lnkdata, size_t lnkdata_size,
                                           hid_t lcpl_id);

alias H5L_move_func_t = herr_t function (const char *new_name, hid_t new_loc,
                                         const void *lnkdata, size_t lnkdata_size);

alias H5L_copy_func_t = herr_t function (const char *new_name, hid_t new_loc,
                                         const void *lnkdata, size_t lnkdata_size);

alias H5L_traverse_func_t = hid_t function (const char *link_name, hid_t cur_group,
                                            const void *lnkdata, size_t lnkdata_size,
                                            hid_t lapl_id);

alias H5L_delete_func_t = herr_t function (const char *link_name, hid_t file,
                                           const void *lnkdata, size_t lnkdata_size);

alias H5L_query_func_t = ssize_t function (const char *link_name, const void *lnkdata,
                                           size_t lnkdata_size, void *buf , size_t buf_size);

struct H5L_class_t {
    int                 version_; // was "version"
    H5L_type_t          id;
    const char         *comment;
    H5L_create_func_t   create_func;
    H5L_move_func_t     move_func;
    H5L_copy_func_t     copy_func;
    H5L_traverse_func_t trav_func;
    H5L_delete_func_t   del_func;
    H5L_query_func_t    query_func;
}

alias H5L_iterate_t = herr_t function (hid_t group, const char *name, const H5L_info_t *info,
                                       void *op_data);

alias H5L_elink_traverse_t = herr_t function (const char *parent_file_name,
                                              const char *parent_group_name,
                                              const char *child_file_name,
                                              const char *child_object_name,
                                              uint *acc_flags, hid_t fapl_id, void *op_data);

herr_t  H5Lmove(hid_t src_loc, const char *src_name, hid_t dst_loc, const char *dst_name,
                hid_t lcpl_id, hid_t lapl_id);
herr_t  H5Lcopy(hid_t src_loc, const char *src_name, hid_t dst_loc, const char *dst_name,
                hid_t lcpl_id, hid_t lapl_id);
herr_t  H5Lcreate_hard(hid_t cur_loc, const char *cur_name, hid_t dst_loc, const char *dst_name,
                       hid_t lcpl_id, hid_t lapl_id);
herr_t  H5Lcreate_soft(const char *link_target, hid_t link_loc_id, const char *link_name,
                       hid_t lcpl_id, hid_t lapl_id);
herr_t  H5Ldelete(hid_t loc_id, const char *name, hid_t lapl_id);
herr_t  H5Ldelete_by_idx(hid_t loc_id, const char *group_name, H5_index_t idx_type,
                         H5_iter_order_t order, hsize_t n, hid_t lapl_id);
herr_t  H5Lget_val(hid_t loc_id, const char *name, void *buf, size_t size, hid_t lapl_id);
herr_t  H5Lget_val_by_idx(hid_t loc_id, const char *group_name, H5_index_t idx_type,
                          H5_iter_order_t order, hsize_t n, void *buf, size_t size, hid_t lapl_id);
htri_t  H5Lexists(hid_t loc_id, const char *name, hid_t lapl_id);
herr_t  H5Lget_info(hid_t loc_id, const char *name, H5L_info_t *linfo , hid_t lapl_id);
herr_t  H5Lget_info_by_idx(hid_t loc_id, const char *group_name, H5_index_t idx_type,
                           H5_iter_order_t order, hsize_t n, H5L_info_t *linfo , hid_t lapl_id);
ssize_t H5Lget_name_by_idx(hid_t loc_id, const char *group_name, H5_index_t idx_type,
                           H5_iter_order_t order, hsize_t n, char *name , size_t size,
                           hid_t lapl_id);
herr_t  H5Literate(hid_t grp_id, H5_index_t idx_type, H5_iter_order_t order, hsize_t *idx,
                   H5L_iterate_t op, void *op_data);
herr_t  H5Literate_by_name(hid_t loc_id, const char *group_name, H5_index_t idx_type,
                           H5_iter_order_t order, hsize_t *idx, H5L_iterate_t op, void *op_data,
                           hid_t lapl_id);
herr_t  H5Lvisit(hid_t grp_id, H5_index_t idx_type, H5_iter_order_t order, H5L_iterate_t op,
                 void *op_data);
herr_t  H5Lvisit_by_name(hid_t loc_id, const char *group_name, H5_index_t idx_type,
                         H5_iter_order_t order, H5L_iterate_t op, void *op_data, hid_t lapl_id);

herr_t  H5Lcreate_ud(hid_t link_loc_id, const char *link_name, H5L_type_t link_type,
                     const void *udata, size_t udata_size, hid_t lcpl_id,hid_t lapl_id);
herr_t  H5Lregister(const H5L_class_t *cls);
herr_t  H5Lunregister(H5L_type_t id);
htri_t  H5Lis_registered(H5L_type_t id);

herr_t  H5Lunpack_elink_val(const void *ext_linkval, size_t link_size, uint *flags,
                            const char **filename);
herr_t  H5Lcreate_external(const char *file_name, const char *obj_name, hid_t link_loc_id,
                           const char *link_name, hid_t lcpl_id, hid_t lapl_id);
