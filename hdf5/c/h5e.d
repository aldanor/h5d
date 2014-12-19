/* HDF5 Errors API */

module hdf5.c.h5e;

import core.stdc.stdio;

import hdf5.c.h5;
import hdf5.c.h5i;

/* Constants, enums and aliases */

enum hid_t H5E_DEFAULT = 0;

enum H5E_type_t {
    H5E_MAJOR = 0,
    H5E_MINOR
}

enum H5E_direction_t {
    H5E_WALK_UPWARD = 0,
    H5E_WALK_DOWNWARD
}

/* Extern declarations, structs and globals */

extern (C) nothrow:

struct H5E_error2_t {
    hid_t       cls_id;
    hid_t       maj_num;
    hid_t       min_num;
    uint        line;
    const char  *func_name;
    const char  *file_name;
    const char  *desc;
}

package {
    extern __gshared hid_t H5E_ERR_CLS_g;
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

package {
    /*********************/
    /* Major error codes */
    /*********************/

    extern __gshared hid_t H5E_DATASET_g;       /* Dataset */
    extern __gshared hid_t H5E_FUNC_g;          /* Function entry/exit */
    extern __gshared hid_t H5E_STORAGE_g;       /* Data storage */
    extern __gshared hid_t H5E_FILE_g;          /* File accessibilty */
    extern __gshared hid_t H5E_SOHM_g;          /* Shared Object Header Messages */
    extern __gshared hid_t H5E_SYM_g;           /* Symbol table */
    extern __gshared hid_t H5E_PLUGIN_g;        /* Plugin for dynamically loaded library */
    extern __gshared hid_t H5E_VFL_g;           /* Virtual File Layer */
    extern __gshared hid_t H5E_INTERNAL_g;      /* Internal error (too specific to document in detail) */
    extern __gshared hid_t H5E_BTREE_g;         /* B-Tree node */
    extern __gshared hid_t H5E_REFERENCE_g;     /* References */
    extern __gshared hid_t H5E_DATASPACE_g;     /* Dataspace */
    extern __gshared hid_t H5E_RESOURCE_g;      /* Resource unavailable */
    extern __gshared hid_t H5E_PLIST_g;         /* Property lists */
    extern __gshared hid_t H5E_LINK_g;          /* Links */
    extern __gshared hid_t H5E_DATATYPE_g;      /* Datatype */
    extern __gshared hid_t H5E_RS_g;            /* Reference Counted Strings */
    extern __gshared hid_t H5E_HEAP_g;          /* Heap */
    extern __gshared hid_t H5E_OHDR_g;          /* Object header */
    extern __gshared hid_t H5E_ATOM_g;          /* Object atom */
    extern __gshared hid_t H5E_ATTR_g;          /* Attribute */
    extern __gshared hid_t H5E_NONE_MAJOR_g;    /* No error */
    extern __gshared hid_t H5E_IO_g;            /* Low-level I/O */
    extern __gshared hid_t H5E_SLIST_g;         /* Skip Lists */
    extern __gshared hid_t H5E_EFL_g;           /* External file list */
    extern __gshared hid_t H5E_TST_g;           /* Ternary Search Trees */
    extern __gshared hid_t H5E_ARGS_g;          /* Invalid arguments to routine */
    extern __gshared hid_t H5E_ERROR_g;         /* Error API */
    extern __gshared hid_t H5E_PLINE_g;         /* Data filters */
    extern __gshared hid_t H5E_FSPACE_g;        /* Free Space Manager */
    extern __gshared hid_t H5E_CACHE_g;         /* Object cache */

    /*********************/
    /* Minor error codes */
    /*********************/

    /* Generic low-level file I/O errors */
    extern __gshared hid_t H5E_SEEKERROR_g;     /* Seek failed */
    extern __gshared hid_t H5E_READERROR_g;     /* Read failed */
    extern __gshared hid_t H5E_WRITEERROR_g;    /* Write failed */
    extern __gshared hid_t H5E_CLOSEERROR_g;    /* Close failed */
    extern __gshared hid_t H5E_OVERFLOW_g;      /* Address overflowed */
    extern __gshared hid_t H5E_FCNTL_g;         /* File control (fcntl) failed */

    /* Resource errors */
    extern __gshared hid_t H5E_NOSPACE_g;       /* No space available for allocation */
    extern __gshared hid_t H5E_CANTALLOC_g;     /* Can't allocate space */
    extern __gshared hid_t H5E_CANTCOPY_g;      /* Unable to copy object */
    extern __gshared hid_t H5E_CANTFREE_g;      /* Unable to free object */
    extern __gshared hid_t H5E_ALREADYEXISTS_g; /* Object already exists */
    extern __gshared hid_t H5E_CANTLOCK_g;      /* Unable to lock object */
    extern __gshared hid_t H5E_CANTUNLOCK_g;    /* Unable to unlock object */
    extern __gshared hid_t H5E_CANTGC_g;        /* Unable to garbage collect */
    extern __gshared hid_t H5E_CANTGETSIZE_g;   /* Unable to compute size */
    extern __gshared hid_t H5E_OBJOPEN_g;       /* Object is already open */

    /* Heap errors */
    extern __gshared hid_t H5E_CANTRESTORE_g;   /* Can't restore condition */
    extern __gshared hid_t H5E_CANTCOMPUTE_g;   /* Can't compute value */
    extern __gshared hid_t H5E_CANTEXTEND_g;    /* Can't extend heap's space */
    extern __gshared hid_t H5E_CANTATTACH_g;    /* Can't attach object */
    extern __gshared hid_t H5E_CANTUPDATE_g;    /* Can't update object */
    extern __gshared hid_t H5E_CANTOPERATE_g;   /* Can't operate on object */

    /* Function entry/exit interface errors */
    extern __gshared hid_t H5E_CANTINIT_g;      /* Unable to initialize object */
    extern __gshared hid_t H5E_ALREADYINIT_g;   /* Object already initialized */
    extern __gshared hid_t H5E_CANTRELEASE_g;   /* Unable to release object */

    /* Property list errors */
    extern __gshared hid_t H5E_CANTGET_g;       /* Can't get value */
    extern __gshared hid_t H5E_CANTSET_g;       /* Can't set value */
    extern __gshared hid_t H5E_DUPCLASS_g;      /* Duplicate class name in parent class */
    extern __gshared hid_t H5E_SETDISALLOWED_g; /* Disallowed operation */

    /* Free space errors */
    extern __gshared hid_t H5E_CANTMERGE_g;     /* Can't merge objects */
    extern __gshared hid_t H5E_CANTREVIVE_g;    /* Can't revive object */
    extern __gshared hid_t H5E_CANTSHRINK_g;    /* Can't shrink container */

    /* Object header related errors */
    extern __gshared hid_t H5E_LINKCOUNT_g;     /* Bad object header link count */
    extern __gshared hid_t H5E_VERSION_g;       /* Wrong version number */
    extern __gshared hid_t H5E_ALIGNMENT_g;     /* Alignment error */
    extern __gshared hid_t H5E_BADMESG_g;       /* Unrecognized message */
    extern __gshared hid_t H5E_CANTDELETE_g;    /* Can't delete message */
    extern __gshared hid_t H5E_BADITER_g;       /* Iteration failed */
    extern __gshared hid_t H5E_CANTPACK_g;      /* Can't pack messages */
    extern __gshared hid_t H5E_CANTRESET_g;     /* Can't reset object */
    extern __gshared hid_t H5E_CANTRENAME_g;    /* Unable to rename object */

    /* System level errors */
    extern __gshared hid_t H5E_SYSERRSTR_g;     /* System error message */

    /* I/O pipeline errors */
    extern __gshared hid_t H5E_NOFILTER_g;      /* Requested filter is not available */
    extern __gshared hid_t H5E_CALLBACK_g;      /* Callback failed */
    extern __gshared hid_t H5E_CANAPPLY_g;      /* Error from filter 'can apply' callback */
    extern __gshared hid_t H5E_SETLOCAL_g;      /* Error from filter 'set local' callback */
    extern __gshared hid_t H5E_NOENCODER_g;     /* Filter present but encoding disabled */
    extern __gshared hid_t H5E_CANTFILTER_g;    /* Filter operation failed */

    /* Group related errors */
    extern __gshared hid_t H5E_CANTOPENOBJ_g;   /* Can't open object */
    extern __gshared hid_t H5E_CANTCLOSEOBJ_g;  /* Can't close object */
    extern __gshared hid_t H5E_COMPLEN_g;       /* Name component is too long */
    extern __gshared hid_t H5E_PATH_g;          /* Problem with path to object */

    /* No error */
    extern __gshared hid_t H5E_NONE_MINOR_g;    /* No error */

    /* Plugin errors */
    extern __gshared hid_t H5E_OPENERROR_g;     /* Can't open directory or file */

    /* File accessibilty errors */
    extern __gshared hid_t H5E_FILEEXISTS_g;    /* File already exists */
    extern __gshared hid_t H5E_FILEOPEN_g;      /* File already open */
    extern __gshared hid_t H5E_CANTCREATE_g;    /* Unable to create file */
    extern __gshared hid_t H5E_CANTOPENFILE_g;  /* Unable to open file */
    extern __gshared hid_t H5E_CANTCLOSEFILE_g; /* Unable to close file */
    extern __gshared hid_t H5E_NOTHDF5_g;       /* Not an HDF5 file */
    extern __gshared hid_t H5E_BADFILE_g;       /* Bad file ID accessed */
    extern __gshared hid_t H5E_TRUNCATED_g;     /* File has been truncated */
    extern __gshared hid_t H5E_MOUNT_g;         /* File mount error */

    /* Object atom related errors */
    extern __gshared hid_t H5E_BADATOM_g;       /* Unable to find atom information (already closed?) */
    extern __gshared hid_t H5E_BADGROUP_g;      /* Unable to find ID group information */
    extern __gshared hid_t H5E_CANTREGISTER_g;  /* Unable to register new atom */
    extern __gshared hid_t H5E_CANTINC_g;       /* Unable to increment reference count */
    extern __gshared hid_t H5E_CANTDEC_g;       /* Unable to decrement reference count */
    extern __gshared hid_t H5E_NOIDS_g;         /* Out of IDs for group */

    /* Cache related errors */
    extern __gshared hid_t H5E_CANTFLUSH_g;     /* Unable to flush data from cache */
    extern __gshared hid_t H5E_CANTSERIALIZE_g; /* Unable to serialize data from cache */
    extern __gshared hid_t H5E_CANTLOAD_g;      /* Unable to load metadata into cache */
    extern __gshared hid_t H5E_PROTECT_g;       /* Protected metadata error */
    extern __gshared hid_t H5E_NOTCACHED_g;     /* Metadata not currently cached */
    extern __gshared hid_t H5E_SYSTEM_g;        /* Internal error detected */
    extern __gshared hid_t H5E_CANTINS_g;       /* Unable to insert metadata into cache */
    extern __gshared hid_t H5E_CANTPROTECT_g;   /* Unable to protect metadata */
    extern __gshared hid_t H5E_CANTUNPROTECT_g; /* Unable to unprotect metadata */
    extern __gshared hid_t H5E_CANTPIN_g;       /* Unable to pin cache entry */
    extern __gshared hid_t H5E_CANTUNPIN_g;     /* Unable to un-pin cache entry */
    extern __gshared hid_t H5E_CANTMARKDIRTY_g; /* Unable to mark a pinned entry as dirty */
    extern __gshared hid_t H5E_CANTDIRTY_g;     /* Unable to mark metadata as dirty */
    extern __gshared hid_t H5E_CANTEXPUNGE_g;   /* Unable to expunge a metadata cache entry */
    extern __gshared hid_t H5E_CANTRESIZE_g;    /* Unable to resize a metadata cache entry */

    /* Link related errors */
    extern __gshared hid_t H5E_TRAVERSE_g;      /* Link traversal failure */
    extern __gshared hid_t H5E_NLINKS_g;        /* Too many soft links in path */
    extern __gshared hid_t H5E_NOTREGISTERED_g; /* Link class not registered */
    extern __gshared hid_t H5E_CANTMOVE_g;      /* Can't move object */
    extern __gshared hid_t H5E_CANTSORT_g;      /* Can't sort objects */

    /* Parallel MPI errors */
    extern __gshared hid_t H5E_MPI_g;           /* Some MPI function failed */
    extern __gshared hid_t H5E_MPIERRSTR_g;     /* MPI Error String */
    extern __gshared hid_t H5E_CANTRECV_g;      /* Can't receive data */

    /* Dataspace errors */
    extern __gshared hid_t H5E_CANTCLIP_g;      /* Can't clip hyperslab region */
    extern __gshared hid_t H5E_CANTCOUNT_g;     /* Can't count elements */
    extern __gshared hid_t H5E_CANTSELECT_g;    /* Can't select hyperslab */
    extern __gshared hid_t H5E_CANTNEXT_g;      /* Can't move to next iterator location */
    extern __gshared hid_t H5E_BADSELECT_g;     /* Invalid selection */
    extern __gshared hid_t H5E_CANTCOMPARE_g;   /* Can't compare objects */

    /* Argument errors */
    extern __gshared hid_t H5E_UNINITIALIZED_g; /* Information is uinitialized */
    extern __gshared hid_t H5E_UNSUPPORTED_g;   /* Feature is unsupported */
    extern __gshared hid_t H5E_BADTYPE_g;       /* Inappropriate type */
    extern __gshared hid_t H5E_BADRANGE_g;      /* Out of range */
    extern __gshared hid_t H5E_BADVALUE_g;      /* Bad value */

    /* B-tree related errors */
    extern __gshared hid_t H5E_NOTFOUND_g;      /* Object not found */
    extern __gshared hid_t H5E_EXISTS_g;        /* Object already exists */
    extern __gshared hid_t H5E_CANTENCODE_g;    /* Unable to encode value */
    extern __gshared hid_t H5E_CANTDECODE_g;    /* Unable to decode value */
    extern __gshared hid_t H5E_CANTSPLIT_g;     /* Unable to split node */
    extern __gshared hid_t H5E_CANTREDISTRIBUTE_g; /* Unable to redistribute records */
    extern __gshared hid_t H5E_CANTSWAP_g;      /* Unable to swap records */
    extern __gshared hid_t H5E_CANTINSERT_g;    /* Unable to insert object */
    extern __gshared hid_t H5E_CANTLIST_g;      /* Unable to list node */
    extern __gshared hid_t H5E_CANTMODIFY_g;    /* Unable to modify record */
    extern __gshared hid_t H5E_CANTREMOVE_g;    /* Unable to remove object */

    /* Datatype conversion errors */
    extern __gshared hid_t H5E_CANTCONVERT_g;   /* Can't convert datatypes */
    extern __gshared hid_t H5E_BADSIZE_g;       /* Bad size for object */
}

/* Register properties */

import hdf5.c.meta;
mixin makeProperties!(mixin(__MODULE__), "_g", H5open);
