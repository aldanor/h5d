/* HDF5 References API */

module hdf5.c.h5r;

import hdf5.c.h5;
import hdf5.c.h5g;
import hdf5.c.h5i;
import hdf5.c.h5o;

/* Constants, enums and aliases */

enum H5R_type_t {
    H5R_BADTYPE = -1,
    H5R_OBJECT,
    H5R_DATASET_REGION,
    H5R_MAXTYPE
}

enum H5R_OBJ_REF_BUF_SIZE = haddr_t.sizeof;
alias hobj_ref_t = haddr_t;

enum H5R_DSET_REG_REF_BUF_SIZE = haddr_t.sizeof + 4;

alias hdfset_reg_ref_t = ubyte[H5R_DSET_REG_REF_BUF_SIZE];

/* Extern declarations, structs and globals */

extern (C) nothrow:

herr_t  H5Rcreate(void *ref_, hid_t loc_id, const char *name, // was "ref"
                  H5R_type_t ref_type, hid_t space_id);
hid_t   H5Rdereference(hid_t dataset, H5R_type_t ref_type,
                       const void *ref_); // was "ref"
hid_t   H5Rget_region(hid_t dataset, H5R_type_t ref_type,
                      const void *ref_); // was "ref"
herr_t  H5Rget_obj_type2(hid_t id, H5R_type_t ref_type, const void *_ref, H5O_type_t *obj_type);
ssize_t H5Rget_name(hid_t loc_id, H5R_type_t ref_type,
                    const void *ref_, char *name, size_t size); // was "ref"
