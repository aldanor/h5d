/* HDF5 IDs API */

module hdf5.c.h5i;

import core.stdc.stdint;

import hdf5.c.h5;

/* Constants, enums and aliases */

enum H5I_type_t {
    H5I_UNINIT = -2,
    H5I_BADID  = -1,
    H5I_FILE   = 1,
    H5I_GROUP,
    H5I_DATATYPE,
    H5I_DATASPACE,
    H5I_DATASET,
    H5I_ATTR,
    H5I_REFERENCE,
    H5I_VFL,
    H5I_GENPROP_CLS,
    H5I_GENPROP_LST,
    H5I_ERROR_CLASS,
    H5I_ERROR_MSG,
    H5I_ERROR_STACK,
    H5I_NTYPES
}

alias hid_t = int64_t;

enum H5_SIZEOF_HID_T = int64_t.sizeof;

enum hid_t H5I_INVALID_HID = -1;

/* Extern declarations, structs and globals */

extern (C) nothrow:

alias H5I_free_t = herr_t function (void*);

alias H5I_search_func_t = int function(void *obj, hid_t id, void *key);

hid_t   H5Iregister(H5I_type_t type, const void *object);
void   *H5Iobject_verify(hid_t id, H5I_type_t id_type);
void   *H5Iremove_verify(hid_t id, H5I_type_t id_type);
H5I_type_t  H5Iget_type(hid_t id);
hid_t   H5Iget_file_id(hid_t id);
ssize_t H5Iget_name(hid_t id, char *name, size_t size);
int     H5Iinc_ref(hid_t id);
int     H5Idec_ref(hid_t id);
int     H5Iget_ref(hid_t id);
H5I_type_t H5Iregister_type(size_t hash_size, uint reserved, H5I_free_t free_func);
herr_t  H5Iclear_type(H5I_type_t type, hbool_t force);
herr_t  H5Idestroy_type(H5I_type_t type);
int     H5Iinc_type_ref(H5I_type_t type);
int     H5Idec_type_ref(H5I_type_t type);
int     H5Iget_type_ref(H5I_type_t type);
void   *H5Isearch(H5I_type_t type, H5I_search_func_t func, void *key);
herr_t  H5Inmembers(H5I_type_t type, hsize_t *num_members);
htri_t  H5Itype_exists(H5I_type_t type);
htri_t  H5Iis_valid(hid_t id);
