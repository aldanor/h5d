/* HDF5 Errors API */

module hdf5.c.h5e;

import core.stdc.stdio;

import hdf5.c.h5;
import hdf5.c.h5i;

shared static this() {
    H5open();
}

extern (C) nothrow:

enum hid_t H5E_DEFAULT = 0;

enum H5E_type_t {
    H5E_MAJOR = 0,
    H5E_MINOR
}

struct H5E_error2_t {
    hid_t       cls_id;
    hid_t       maj_num;
    hid_t       min_num;
    uint        line;
    const char  *func_name;
    const char  *file_name;
    const char  *desc;
}

extern __gshared hid_t H5E_ERR_CLS_g;
alias H5_ERR_CLS = H5E_ERR_CLS_g;

enum H5E_direction_t {
    H5E_WALK_UPWARD = 0,
    H5E_WALK_DOWNWARD
}

alias   H5E_walk2_t = herr_t function(uint n, const H5E_error2_t *err_desc, void *client_data);
alias   H5E_auto2_t = herr_t function(hid_t estack, void *client_data);

hid_t   H5Eregister_class(const char *cls_name, const char *lib_name,
                          const char *version_); // was "version"
herr_t  H5Eunregister_class(hid_t class_id);
herr_t  H5Eclose_msg(hid_t err_id);
hid_t   H5Ecreate_msg(hid_t cls, H5E_type_t msg_type, const char *msg);
hid_t   H5Ecreate_stack();
hid_t   H5Eget_current_stack();
herr_t  H5Eclose_stack(hid_t stack_id);
ssize_t H5Eget_class_name(hid_t class_id, char *name, size_t size);
herr_t  H5Eset_current_stack(hid_t err_stack_id);
herr_t  H5Epush2(hid_t err_stack, const char *file, const char *func, uint line,
                 hid_t cls_id, hid_t maj_id, hid_t min_id, const char *msg, ...);
herr_t  H5Epop(hid_t err_stack, size_t count);
herr_t  H5Eprint2(hid_t err_stack, FILE *stream);
herr_t  H5Ewalk2(hid_t err_stack, H5E_direction_t direction, H5E_walk2_t func, void *client_data);
herr_t  H5Eget_auto2(hid_t estack_id, H5E_auto2_t *func, void **client_data);
herr_t  H5Eset_auto2(hid_t estack_id, H5E_auto2_t func, void *client_data);
herr_t  H5Eclear2(hid_t err_stack);
herr_t  H5Eauto_is_v2(hid_t err_stack, uint *is_stack);
ssize_t H5Eget_msg(hid_t msg_id, H5E_type_t *type, char *msg, size_t size);
ssize_t H5Eget_num(hid_t error_stack_id);

extern __gshared hid_t H5E_FUNC_g;              alias H5E_FUNC = H5E_FUNC_g;
extern __gshared hid_t H5E_FILE_g;              alias H5E_FILE = H5E_FILE_g;
extern __gshared hid_t H5E_SOHM_g;              alias H5E_SOHM = H5E_SOHM_g;
extern __gshared hid_t H5E_SYM_g;               alias H5E_SYM = H5E_SYM_g;
extern __gshared hid_t H5E_PLUGIN_g;            alias H5E_PLUGIN = H5E_PLUGIN_g;
extern __gshared hid_t H5E_VFL_g;               alias H5E_VFL = H5E_VFL_g;
extern __gshared hid_t H5E_INTERNAL_g;          alias H5E_INTERNAL = H5E_INTERNAL_g;
extern __gshared hid_t H5E_BTREE_g;             alias H5E_BTREE = H5E_BTREE_g;
extern __gshared hid_t H5E_REFERENCE_g;         alias H5E_REFERENCE = H5E_REFERENCE_g;
extern __gshared hid_t H5E_DATASPACE_g;         alias H5E_DATASPACE = H5E_DATASPACE_g;
extern __gshared hid_t H5E_RESOURCE_g;          alias H5E_RESOURCE = H5E_RESOURCE_g;
extern __gshared hid_t H5E_RS_g;                alias H5E_RS = H5E_RS_g;
extern __gshared hid_t H5E_FARRAY_g;            alias H5E_FARRAY = H5E_FARRAY_g;
extern __gshared hid_t H5E_HEAP_g;              alias H5E_HEAP = H5E_HEAP_g;
extern __gshared hid_t H5E_ATTR_g;              alias H5E_ATTR = H5E_ATTR_g;
extern __gshared hid_t H5E_IO_g;                alias H5E_IO = H5E_IO_g;
extern __gshared hid_t H5E_EFL_g;               alias H5E_EFL = H5E_EFL_g;
extern __gshared hid_t H5E_TST_g;               alias H5E_TST = H5E_TST_g;
extern __gshared hid_t H5E_FSPACE_g;            alias H5E_FSPACE = H5E_FSPACE_g;
extern __gshared hid_t H5E_DATASET_g;           alias H5E_DATASET = H5E_DATASET_g;
extern __gshared hid_t H5E_STORAGE_g;           alias H5E_STORAGE = H5E_STORAGE_g;
extern __gshared hid_t H5E_LINK_g;              alias H5E_LINK = H5E_LINK_g;
extern __gshared hid_t H5E_PLIST_g;             alias H5E_PLIST = H5E_PLIST_g;
extern __gshared hid_t H5E_DATATYPE_g;          alias H5E_DATATYPE = H5E_DATATYPE_g;
extern __gshared hid_t H5E_OHDR_g;              alias H5E_OHDR = H5E_OHDR_g;
extern __gshared hid_t H5E_ATOM_g;              alias H5E_ATOM = H5E_ATOM_g;
extern __gshared hid_t H5E_NONE_MAJOR_g;        alias H5E_NONE_MAJOR = H5E_NONE_MAJOR_g;
extern __gshared hid_t H5E_SLIST_g;             alias H5E_SLIST = H5E_SLIST_g;
extern __gshared hid_t H5E_ARGS_g;              alias H5E_ARGS = H5E_ARGS_g;
extern __gshared hid_t H5E_EARRAY_g;            alias H5E_EARRAY = H5E_EARRAY_g;
extern __gshared hid_t H5E_PLINE_g;             alias H5E_PLINE = H5E_PLINE_g;
extern __gshared hid_t H5E_ERROR_g;             alias H5E_ERROR = H5E_ERROR_g;
extern __gshared hid_t H5E_CACHE_g;             alias H5E_CACHE = H5E_CACHE_g;
extern __gshared hid_t H5E_SEEKERROR_g;         alias H5E_SEEKERROR = H5E_SEEKERROR_g;
extern __gshared hid_t H5E_READERROR_g;         alias H5E_READERROR = H5E_READERROR_g;
extern __gshared hid_t H5E_WRITEERROR_g;        alias H5E_WRITEERROR = H5E_WRITEERROR_g;
extern __gshared hid_t H5E_CLOSEERROR_g;        alias H5E_CLOSEERROR = H5E_CLOSEERROR_g;
extern __gshared hid_t H5E_OVERFLOW_g;          alias H5E_OVERFLOW = H5E_OVERFLOW_g;
extern __gshared hid_t H5E_FCNTL_g;             alias H5E_FCNTL = H5E_FCNTL_g;
extern __gshared hid_t H5E_NOSPACE_g;           alias H5E_NOSPACE = H5E_NOSPACE_g;
extern __gshared hid_t H5E_CANTALLOC_g;         alias H5E_CANTALLOC = H5E_CANTALLOC_g;
extern __gshared hid_t H5E_CANTCOPY_g;          alias H5E_CANTCOPY = H5E_CANTCOPY_g;
extern __gshared hid_t H5E_CANTFREE_g;          alias H5E_CANTFREE = H5E_CANTFREE_g;
extern __gshared hid_t H5E_ALREADYEXISTS_g;     alias H5E_ALREADYEXISTS = H5E_ALREADYEXISTS_g;
extern __gshared hid_t H5E_CANTLOCK_g;          alias H5E_CANTLOCK = H5E_CANTLOCK_g;
extern __gshared hid_t H5E_CANTUNLOCK_g;        alias H5E_CANTUNLOCK = H5E_CANTUNLOCK_g;
extern __gshared hid_t H5E_CANTGC_g;            alias H5E_CANTGC = H5E_CANTGC_g;
extern __gshared hid_t H5E_CANTGETSIZE_g;       alias H5E_CANTGETSIZE = H5E_CANTGETSIZE_g;
extern __gshared hid_t H5E_OBJOPEN_g;           alias H5E_OBJOPEN = H5E_OBJOPEN_g;
extern __gshared hid_t H5E_CANTRESTORE_g;       alias H5E_CANTRESTORE = H5E_CANTRESTORE_g;
extern __gshared hid_t H5E_CANTCOMPUTE_g;       alias H5E_CANTCOMPUTE = H5E_CANTCOMPUTE_g;
extern __gshared hid_t H5E_CANTEXTEND_g;        alias H5E_CANTEXTEND = H5E_CANTEXTEND_g;
extern __gshared hid_t H5E_CANTATTACH_g;        alias H5E_CANTATTACH = H5E_CANTATTACH_g;
extern __gshared hid_t H5E_CANTUPDATE_g;        alias H5E_CANTUPDATE = H5E_CANTUPDATE_g;
extern __gshared hid_t H5E_CANTOPERATE_g;       alias H5E_CANTOPERATE = H5E_CANTOPERATE_g;
extern __gshared hid_t H5E_CANTINIT_g;          alias H5E_CANTINIT = H5E_CANTINIT_g;
extern __gshared hid_t H5E_ALREADYINIT_g;       alias H5E_ALREADYINIT = H5E_ALREADYINIT_g;
extern __gshared hid_t H5E_CANTRELEASE_g;       alias H5E_CANTRELEASE = H5E_CANTRELEASE_g;
extern __gshared hid_t H5E_CANTGET_g;           alias H5E_CANTGET = H5E_CANTGET_g;
extern __gshared hid_t H5E_CANTSET_g;           alias H5E_CANTSET = H5E_CANTSET_g;
extern __gshared hid_t H5E_DUPCLASS_g;          alias H5E_DUPCLASS = H5E_DUPCLASS_g;
extern __gshared hid_t H5E_SETDISALLOWED_g;     alias H5E_SETDISALLOWED = H5E_SETDISALLOWED_g;
extern __gshared hid_t H5E_CANTMERGE_g;         alias H5E_CANTMERGE = H5E_CANTMERGE_g;
extern __gshared hid_t H5E_CANTREVIVE_g;        alias H5E_CANTREVIVE = H5E_CANTREVIVE_g;
extern __gshared hid_t H5E_CANTSHRINK_g;        alias H5E_CANTSHRINK = H5E_CANTSHRINK_g;
extern __gshared hid_t H5E_LINKCOUNT_g;         alias H5E_LINKCOUNT = H5E_LINKCOUNT_g;
extern __gshared hid_t H5E_VERSION_g;           alias H5E_VERSION = H5E_VERSION_g;
extern __gshared hid_t H5E_ALIGNMENT_g;         alias H5E_ALIGNMENT = H5E_ALIGNMENT_g;
extern __gshared hid_t H5E_BADMESG_g;           alias H5E_BADMESG = H5E_BADMESG_g;
extern __gshared hid_t H5E_CANTDELETE_g;        alias H5E_CANTDELETE = H5E_CANTDELETE_g;
extern __gshared hid_t H5E_BADITER_g;           alias H5E_BADITER = H5E_BADITER_g;
extern __gshared hid_t H5E_CANTPACK_g;          alias H5E_CANTPACK = H5E_CANTPACK_g;
extern __gshared hid_t H5E_CANTRESET_g;         alias H5E_CANTRESET = H5E_CANTRESET_g;
extern __gshared hid_t H5E_CANTRENAME_g;        alias H5E_CANTRENAME = H5E_CANTRENAME_g;
extern __gshared hid_t H5E_SYSERRSTR_g;         alias H5E_SYSERRSTR = H5E_SYSERRSTR_g;
extern __gshared hid_t H5E_NOFILTER_g;          alias H5E_NOFILTER = H5E_NOFILTER_g;
extern __gshared hid_t H5E_CALLBACK_g;          alias H5E_CALLBACK = H5E_CALLBACK_g;
extern __gshared hid_t H5E_CANAPPLY_g;          alias H5E_CANAPPLY = H5E_CANAPPLY_g;
extern __gshared hid_t H5E_SETLOCAL_g;          alias H5E_SETLOCAL = H5E_SETLOCAL_g;
extern __gshared hid_t H5E_NOENCODER_g;         alias H5E_NOENCODER = H5E_NOENCODER_g;
extern __gshared hid_t H5E_CANTFILTER_g;        alias H5E_CANTFILTER = H5E_CANTFILTER_g;
extern __gshared hid_t H5E_CANTOPENOBJ_g;       alias H5E_CANTOPENOBJ = H5E_CANTOPENOBJ_g;
extern __gshared hid_t H5E_CANTCLOSEOBJ_g;      alias H5E_CANTCLOSEOBJ = H5E_CANTCLOSEOBJ_g;
extern __gshared hid_t H5E_COMPLEN_g;           alias H5E_COMPLEN = H5E_COMPLEN_g;
extern __gshared hid_t H5E_PATH_g;              alias H5E_PATH = H5E_PATH_g;
extern __gshared hid_t H5E_NONE_MINOR_g;        alias H5E_NONE_MINOR = H5E_NONE_MINOR_g;
extern __gshared hid_t H5E_OPENERROR_g;         alias H5E_OPENERROR = H5E_OPENERROR_g;
extern __gshared hid_t H5E_FILEEXISTS_g;        alias H5E_FILEEXISTS = H5E_FILEEXISTS_g;
extern __gshared hid_t H5E_FILEOPEN_g;          alias H5E_FILEOPEN = H5E_FILEOPEN_g;
extern __gshared hid_t H5E_CANTCREATE_g;        alias H5E_CANTCREATE = H5E_CANTCREATE_g;
extern __gshared hid_t H5E_CANTOPENFILE_g;      alias H5E_CANTOPENFILE = H5E_CANTOPENFILE_g;
extern __gshared hid_t H5E_CANTCLOSEFILE_g;     alias H5E_CANTCLOSEFILE = H5E_CANTCLOSEFILE_g;
extern __gshared hid_t H5E_NOTHDF5_g;           alias H5E_NOTHDF5 = H5E_NOTHDF5_g;
extern __gshared hid_t H5E_BADFILE_g;           alias H5E_BADFILE = H5E_BADFILE_g;
extern __gshared hid_t H5E_TRUNCATED_g;         alias H5E_TRUNCATED = H5E_TRUNCATED_g;
extern __gshared hid_t H5E_MOUNT_g;             alias H5E_MOUNT = H5E_MOUNT_g;
extern __gshared hid_t H5E_BADATOM_g;           alias H5E_BADATOM = H5E_BADATOM_g;
extern __gshared hid_t H5E_BADGROUP_g;          alias H5E_BADGROUP = H5E_BADGROUP_g;
extern __gshared hid_t H5E_CANTREGISTER_g;      alias H5E_CANTREGISTER = H5E_CANTREGISTER_g;
extern __gshared hid_t H5E_CANTINC_g;           alias H5E_CANTINC = H5E_CANTINC_g;
extern __gshared hid_t H5E_CANTDEC_g;           alias H5E_CANTDEC = H5E_CANTDEC_g;
extern __gshared hid_t H5E_NOIDS_g;             alias H5E_NOIDS = H5E_NOIDS_g;
extern __gshared hid_t H5E_CANTFLUSH_g;         alias H5E_CANTFLUSH = H5E_CANTFLUSH_g;
extern __gshared hid_t H5E_CANTSERIALIZE_g;     alias H5E_CANTSERIALIZE = H5E_CANTSERIALIZE_g;
extern __gshared hid_t H5E_CANTTAG_g;           alias H5E_CANTTAG = H5E_CANTTAG_g;
extern __gshared hid_t H5E_CANTLOAD_g;          alias H5E_CANTLOAD = H5E_CANTLOAD_g;
extern __gshared hid_t H5E_PROTECT_g;           alias H5E_PROTECT = H5E_PROTECT_g;
extern __gshared hid_t H5E_NOTCACHED_g;         alias H5E_NOTCACHED = H5E_NOTCACHED_g;
extern __gshared hid_t H5E_SYSTEM_g;            alias H5E_SYSTEM = H5E_SYSTEM_g;
extern __gshared hid_t H5E_CANTINS_g;           alias H5E_CANTINS = H5E_CANTINS_g;
extern __gshared hid_t H5E_CANTPROTECT_g;       alias H5E_CANTPROTECT = H5E_CANTPROTECT_g;
extern __gshared hid_t H5E_CANTUNPROTECT_g;     alias H5E_CANTUNPROTECT = H5E_CANTUNPROTECT_g;
extern __gshared hid_t H5E_CANTPIN_g;           alias H5E_CANTPIN = H5E_CANTPIN_g;
extern __gshared hid_t H5E_CANTUNPIN_g;         alias H5E_CANTUNPIN = H5E_CANTUNPIN_g;
extern __gshared hid_t H5E_CANTMARKDIRTY_g;     alias H5E_CANTMARKDIRTY = H5E_CANTMARKDIRTY_g;
extern __gshared hid_t H5E_CANTDIRTY_g;         alias H5E_CANTDIRTY = H5E_CANTDIRTY_g;
extern __gshared hid_t H5E_CANTEXPUNGE_g;       alias H5E_CANTEXPUNGE = H5E_CANTEXPUNGE_g;
extern __gshared hid_t H5E_CANTRESIZE_g;        alias H5E_CANTRESIZE = H5E_CANTRESIZE_g;
extern __gshared hid_t H5E_CANTDEPEND_g;        alias H5E_CANTDEPEND = H5E_CANTDEPEND_g;
extern __gshared hid_t H5E_CANTUNDEPEND_g;      alias H5E_CANTUNDEPEND = H5E_CANTUNDEPEND_g;
extern __gshared hid_t H5E_CANTNOTIFY_g;        alias H5E_CANTNOTIFY = H5E_CANTNOTIFY_g;
extern __gshared hid_t H5E_TRAVERSE_g;          alias H5E_TRAVERSE = H5E_TRAVERSE_g;
extern __gshared hid_t H5E_NLINKS_g;            alias H5E_NLINKS = H5E_NLINKS_g;
extern __gshared hid_t H5E_NOTREGISTERED_g;     alias H5E_NOTREGISTERED = H5E_NOTREGISTERED_g;
extern __gshared hid_t H5E_CANTMOVE_g;          alias H5E_CANTMOVE = H5E_CANTMOVE_g;
extern __gshared hid_t H5E_CANTSORT_g;          alias H5E_CANTSORT = H5E_CANTSORT_g;
extern __gshared hid_t H5E_MPI_g;               alias H5E_MPI = H5E_MPI_g;
extern __gshared hid_t H5E_MPIERRSTR_g;         alias H5E_MPIERRSTR = H5E_MPIERRSTR_g;
extern __gshared hid_t H5E_CANTRECV_g;          alias H5E_CANTRECV = H5E_CANTRECV_g;
extern __gshared hid_t H5E_CANTCLIP_g;          alias H5E_CANTCLIP = H5E_CANTCLIP_g;
extern __gshared hid_t H5E_CANTCOUNT_g;         alias H5E_CANTCOUNT = H5E_CANTCOUNT_g;
extern __gshared hid_t H5E_CANTSELECT_g;        alias H5E_CANTSELECT = H5E_CANTSELECT_g;
extern __gshared hid_t H5E_CANTNEXT_g;          alias H5E_CANTNEXT = H5E_CANTNEXT_g;
extern __gshared hid_t H5E_BADSELECT_g;         alias H5E_BADSELECT = H5E_BADSELECT_g;
extern __gshared hid_t H5E_CANTCOMPARE_g;       alias H5E_CANTCOMPARE = H5E_CANTCOMPARE_g;
extern __gshared hid_t H5E_UNINITIALIZED_g;     alias H5E_UNINITIALIZED = H5E_UNINITIALIZED_g;
extern __gshared hid_t H5E_UNSUPPORTED_g;       alias H5E_UNSUPPORTED = H5E_UNSUPPORTED_g;
extern __gshared hid_t H5E_BADTYPE_g;           alias H5E_BADTYPE = H5E_BADTYPE_g;
extern __gshared hid_t H5E_BADRANGE_g;          alias H5E_BADRANGE = H5E_BADRANGE_g;
extern __gshared hid_t H5E_BADVALUE_g;          alias H5E_BADVALUE = H5E_BADVALUE_g;
extern __gshared hid_t H5E_NOTFOUND_g;          alias H5E_NOTFOUND = H5E_NOTFOUND_g;
extern __gshared hid_t H5E_EXISTS_g;            alias H5E_EXISTS = H5E_EXISTS_g;
extern __gshared hid_t H5E_CANTENCODE_g;        alias H5E_CANTENCODE = H5E_CANTENCODE_g;
extern __gshared hid_t H5E_CANTDECODE_g;        alias H5E_CANTDECODE = H5E_CANTDECODE_g;
extern __gshared hid_t H5E_CANTSPLIT_g;         alias H5E_CANTSPLIT = H5E_CANTSPLIT_g;
extern __gshared hid_t H5E_CANTREDISTRIBUTE_g;  alias H5E_CANTREDISTRIBUTE = H5E_CANTREDISTRIBUTE_g;
extern __gshared hid_t H5E_CANTSWAP_g;          alias H5E_CANTSWAP = H5E_CANTSWAP_g;
extern __gshared hid_t H5E_CANTINSERT_g;        alias H5E_CANTINSERT = H5E_CANTINSERT_g;
extern __gshared hid_t H5E_CANTLIST_g;          alias H5E_CANTLIST = H5E_CANTLIST_g;
extern __gshared hid_t H5E_CANTMODIFY_g;        alias H5E_CANTMODIFY = H5E_CANTMODIFY_g;
extern __gshared hid_t H5E_CANTREMOVE_g;        alias H5E_CANTREMOVE = H5E_CANTREMOVE_g;
extern __gshared hid_t H5E_CANTCONVERT_g;       alias H5E_CANTCONVERT = H5E_CANTCONVERT_g;
extern __gshared hid_t H5E_BADSIZE_g;           alias H5E_BADSIZE = H5E_BADSIZE_g;
