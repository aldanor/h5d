/* HDF5 Groups API */

module hdf5.c.h5g;

import core.stdc.stdint;

import hdf5.c.h5;
import hdf5.c.h5l;
import hdf5.c.h5o;
import hdf5.c.h5t;
import hdf5.c.h5i;

extern (C) nothrow:

enum H5G_storage_type_t {
    H5G_STORAGE_TYPE_UNKNOWN = -1,
    H5G_STORAGE_TYPE_SYMBOL_TABLE,
    H5G_STORAGE_TYPE_COMPACT,
    H5G_STORAGE_TYPE_DENSE
}

struct H5G_info_t {
    H5G_storage_type_t  storage_type;
    hsize_t             nlinks;
    int64_t             max_corder;
    hbool_t             mounted;
}

hid_t   H5Gcreate2(hid_t loc_id, const char *name, hid_t lcpl_id, hid_t gcpl_id, hid_t gapl_id);
hid_t   H5Gcreate_anon(hid_t loc_id, hid_t gcpl_id, hid_t gapl_id);
hid_t   H5Gopen2(hid_t loc_id, const char *name, hid_t gapl_id);
hid_t   H5Gget_create_plist(hid_t group_id);
herr_t  H5Gget_info(hid_t loc_id, H5G_info_t *ginfo);
herr_t  H5Gget_info_by_name(hid_t loc_id, const char *name, H5G_info_t *ginfo, hid_t lapl_id);
herr_t  H5Gget_info_by_idx(hid_t loc_id, const char *group_name, H5_index_t idx_type,
                           H5_iter_order_t order, hsize_t n, H5G_info_t *ginfo, hid_t lapl_id);
herr_t  H5Gclose(hid_t group_id);
