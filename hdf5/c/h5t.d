/* HDF5 Datatypes API */

module hdf5.c.h5t;

import core.stdc.config;
import core.stdc.limits;

import hdf5.c.h5;
import hdf5.c.h5i;

/* Constants, enums and aliases */

enum H5T_class_t {
    H5T_NO_CLASS = -1,
    H5T_INTEGER,
    H5T_FLOAT,
    H5T_TIME,
    H5T_STRING,
    H5T_BITFIELD,
    H5T_OPAQUE,
    H5T_COMPOUND,
    H5T_REFERENCE,
    H5T_ENUM,
    H5T_VLEN,
    H5T_ARRAY,
    H5T_NCLASSES
}

enum H5T_order_t {
    H5T_ORDER_ERROR = -1,
    H5T_ORDER_LE,
    H5T_ORDER_BE,
    H5T_ORDER_VAX,
    H5T_ORDER_MIXED,
    H5T_ORDER_NONE
}

enum H5T_sign_t {
    H5T_SGN_ERROR = -1,
    H5T_SGN_NONE,
    H5T_SGN_2,
    H5T_NSGN
}

enum H5T_norm_t {
    H5T_NORM_ERROR = -1,
    H5T_NORM_IMPLIED,
    H5T_NORM_MSBSET,
    H5T_NORM_NONE
}

enum H5T_cset_t {
    H5T_CSET_ERROR = -1,
    H5T_CSET_ASCII,
    H5T_CSET_UTF8,
    H5T_CSET_RESERVED_2,
    H5T_CSET_RESERVED_3,
    H5T_CSET_RESERVED_4,
    H5T_CSET_RESERVED_5,
    H5T_CSET_RESERVED_6,
    H5T_CSET_RESERVED_7,
    H5T_CSET_RESERVED_8,
    H5T_CSET_RESERVED_9,
    H5T_CSET_RESERVED_10,
    H5T_CSET_RESERVED_11,
    H5T_CSET_RESERVED_12,
    H5T_CSET_RESERVED_13,
    H5T_CSET_RESERVED_14,
    H5T_CSET_RESERVED_15
}

alias H5T_NCSET = H5T_cset_t.H5T_CSET_RESERVED_2;

enum H5T_str_t {
    H5T_STR_ERROR = -1,
    H5T_STR_NULLTERM,
    H5T_STR_NULLPAD,
    H5T_STR_SPACEPAD,
    H5T_STR_RESERVED_3,
    H5T_STR_RESERVED_4,
    H5T_STR_RESERVED_5,
    H5T_STR_RESERVED_6,
    H5T_STR_RESERVED_7,
    H5T_STR_RESERVED_8,
    H5T_STR_RESERVED_9,
    H5T_STR_RESERVED_10,
    H5T_STR_RESERVED_11,
    H5T_STR_RESERVED_12,
    H5T_STR_RESERVED_13,
    H5T_STR_RESERVED_14,
    H5T_STR_RESERVED_15
}

alias H5T_NSTR = H5T_str_t.H5T_STR_RESERVED_3;

enum H5T_pad_t {
    H5T_PAD_ERROR = -1,
    H5T_PAD_ZERO,
    H5T_PAD_ONE,
    H5T_PAD_BACKGROUND,
    H5T_NPAD
}

enum H5T_cmd_t {
    H5T_CONV_INIT = 0,
    H5T_CONV_CONV,
    H5T_CONV_FREE
}

enum H5T_bkg_t {
    H5T_BKG_NO      = 0,
    H5T_BKG_TEMP    = 1,
    H5T_BKG_YES     = 2
}

enum H5T_pers_t {
    H5T_PERS_DONTCARE = -1,
    H5T_PERS_HARD,
    H5T_PERS_SOFT
}

enum H5T_direction_t {
    H5T_DIR_DEFAULT = 0,
    H5T_DIR_ASCEND,
    H5T_DIR_DESCEND
}

enum H5T_conv_except_t {
    H5T_CONV_EXCEPT_RANGE_HI = 0,
    H5T_CONV_EXCEPT_RANGE_LOW,
    H5T_CONV_EXCEPT_PRECISION,
    H5T_CONV_EXCEPT_TRUNCATE,
    H5T_CONV_EXCEPT_PINF,
    H5T_CONV_EXCEPT_NINF,
    H5T_CONV_EXCEPT_NAN
}

enum H5T_conv_ret_t {
    H5T_CONV_ABORT = -1,
    H5T_CONV_UNHANDLED,
    H5T_CONV_HANDLED
}

enum size_t H5T_VARIABLE = -1;

enum uint H5T_OPAQUE_TAG_MAX = 256;

/* Extern declarations, structs and globals */

extern (C) nothrow:

struct H5T_cdata_t {
    H5T_cmd_t   command;
    H5T_bkg_t   need_bkg;
    hbool_t     recalc;
    void       *priv;
}

struct hvl_t {
    size_t  len;
    void   *p;
}

alias H5T_conv_t             = herr_t function (hid_t src_id, hid_t dst_id, H5T_cdata_t *cdata,
                                                size_t nelmts, size_t buf_stride, size_t bkg_stride,
                                                void *buf, void *bkg, hid_t dset_xfer_plist);
alias H5T_conv_except_func_t = H5T_conv_ret_t function (H5T_conv_except_t except_type,
                                                        hid_t src_id, hid_t dst_id,
                                                        void *src_buf, void *dst_buf,
                                                        void *user_data);

package {
    extern __gshared hid_t H5T_IEEE_F32BE_g;
    extern __gshared hid_t H5T_IEEE_F32LE_g;
    extern __gshared hid_t H5T_IEEE_F64BE_g;
    extern __gshared hid_t H5T_IEEE_F64LE_g;

    extern __gshared hid_t H5T_STD_I8BE_g;
    extern __gshared hid_t H5T_STD_I8LE_g;
    extern __gshared hid_t H5T_STD_I16BE_g;
    extern __gshared hid_t H5T_STD_I16LE_g;
    extern __gshared hid_t H5T_STD_I32BE_g;
    extern __gshared hid_t H5T_STD_I32LE_g;
    extern __gshared hid_t H5T_STD_I64BE_g;
    extern __gshared hid_t H5T_STD_I64LE_g;
    extern __gshared hid_t H5T_STD_U8BE_g;
    extern __gshared hid_t H5T_STD_U8LE_g;
    extern __gshared hid_t H5T_STD_U16BE_g;
    extern __gshared hid_t H5T_STD_U16LE_g;
    extern __gshared hid_t H5T_STD_U32BE_g;
    extern __gshared hid_t H5T_STD_U32LE_g;
    extern __gshared hid_t H5T_STD_U64BE_g;
    extern __gshared hid_t H5T_STD_U64LE_g;
    extern __gshared hid_t H5T_STD_B8BE_g;
    extern __gshared hid_t H5T_STD_B8LE_g;
    extern __gshared hid_t H5T_STD_B16BE_g;
    extern __gshared hid_t H5T_STD_B16LE_g;
    extern __gshared hid_t H5T_STD_B32BE_g;
    extern __gshared hid_t H5T_STD_B32LE_g;
    extern __gshared hid_t H5T_STD_B64BE_g;
    extern __gshared hid_t H5T_STD_B64LE_g;
    extern __gshared hid_t H5T_STD_REF_OBJ_g;
    extern __gshared hid_t H5T_STD_REF_DSETREG_g;

    extern __gshared hid_t H5T_UNIX_D32BE_g;
    extern __gshared hid_t H5T_UNIX_D32LE_g;
    extern __gshared hid_t H5T_UNIX_D64BE_g;
    extern __gshared hid_t H5T_UNIX_D64LE_g;

    extern __gshared hid_t H5T_C_S1_g;

    extern __gshared hid_t H5T_FORTRAN_S1_g;

    // if sizeof(c_long_double) != 0
    extern __gshared hid_t H5T_NATIVE_LDOUBLE_g;

    extern __gshared hid_t H5T_VAX_F32_g;
    extern __gshared hid_t H5T_VAX_F64_g;

    extern __gshared hid_t H5T_NATIVE_SCHAR_g;
    extern __gshared hid_t H5T_NATIVE_UCHAR_g;
    extern __gshared hid_t H5T_NATIVE_SHORT_g;
    extern __gshared hid_t H5T_NATIVE_USHORT_g;
    extern __gshared hid_t H5T_NATIVE_INT_g;
    extern __gshared hid_t H5T_NATIVE_UINT_g;
    extern __gshared hid_t H5T_NATIVE_LONG_g;
    extern __gshared hid_t H5T_NATIVE_ULONG_g;
    extern __gshared hid_t H5T_NATIVE_LLONG_g;
    extern __gshared hid_t H5T_NATIVE_ULLONG_g;
    extern __gshared hid_t H5T_NATIVE_FLOAT_g;
    extern __gshared hid_t H5T_NATIVE_DOUBLE_g;
    extern __gshared hid_t H5T_NATIVE_B8_g;
    extern __gshared hid_t H5T_NATIVE_B16_g;
    extern __gshared hid_t H5T_NATIVE_B32_g;
    extern __gshared hid_t H5T_NATIVE_B64_g;
    extern __gshared hid_t H5T_NATIVE_OPAQUE_g;
    extern __gshared hid_t H5T_NATIVE_HADDR_g;
    extern __gshared hid_t H5T_NATIVE_HSIZE_g;
    extern __gshared hid_t H5T_NATIVE_HSSIZE_g;
    extern __gshared hid_t H5T_NATIVE_HERR_g;
    extern __gshared hid_t H5T_NATIVE_HBOOL_g;

    extern __gshared hid_t H5T_NATIVE_INT8_g;
    extern __gshared hid_t H5T_NATIVE_UINT8_g;
    extern __gshared hid_t H5T_NATIVE_INT_LEAST8_g;
    extern __gshared hid_t H5T_NATIVE_UINT_LEAST8_g;
    extern __gshared hid_t H5T_NATIVE_INT_FAST8_g;
    extern __gshared hid_t H5T_NATIVE_UINT_FAST8_g;

    extern __gshared hid_t H5T_NATIVE_INT16_g;
    extern __gshared hid_t H5T_NATIVE_UINT16_g;
    extern __gshared hid_t H5T_NATIVE_INT_LEAST16_g;
    extern __gshared hid_t H5T_NATIVE_UINT_LEAST16_g;
    extern __gshared hid_t H5T_NATIVE_INT_FAST16_g;
    extern __gshared hid_t H5T_NATIVE_UINT_FAST16_g;

    extern __gshared hid_t H5T_NATIVE_INT32_g;
    extern __gshared hid_t H5T_NATIVE_UINT32_g;
    extern __gshared hid_t H5T_NATIVE_INT_LEAST32_g;
    extern __gshared hid_t H5T_NATIVE_UINT_LEAST32_g;
    extern __gshared hid_t H5T_NATIVE_INT_FAST32_g;
    extern __gshared hid_t H5T_NATIVE_UINT_FAST32_g;

    extern __gshared hid_t H5T_NATIVE_INT64_g;
    extern __gshared hid_t H5T_NATIVE_UINT64_g;
    extern __gshared hid_t H5T_NATIVE_INT_LEAST64_g;
    extern __gshared hid_t H5T_NATIVE_UINT_LEAST64_g;
    extern __gshared hid_t H5T_NATIVE_INT_FAST64_g;
    extern __gshared hid_t H5T_NATIVE_UINT_FAST64_g;
}

hid_t   H5Tcreate(H5T_class_t type, size_t size);
hid_t   H5Tcopy(hid_t type_id);
herr_t  H5Tclose(hid_t type_id);
htri_t  H5Tequal(hid_t type1_id, hid_t type2_id);
herr_t  H5Tlock(hid_t type_id);
herr_t  H5Tcommit2(hid_t loc_id, const char *name, hid_t type_id, hid_t lcpl_id, hid_t tcpl_id,
                   hid_t tapl_id);
hid_t   H5Topen2(hid_t loc_id, const char *name, hid_t tapl_id);
herr_t  H5Tcommit_anon(hid_t loc_id, hid_t type_id, hid_t tcpl_id, hid_t tapl_id);
hid_t   H5Tget_create_plist(hid_t type_id);
htri_t  H5Tcommitted(hid_t type_id);
herr_t  H5Tencode(hid_t obj_id, void *buf, size_t *nalloc);
hid_t   H5Tdecode(const void *buf);

herr_t  H5Tinsert(hid_t parent_id, const char *name, size_t offset, hid_t member_id);
herr_t  H5Tpack(hid_t type_id);

hid_t   H5Tenum_create(hid_t base_id);
herr_t  H5Tenum_insert(hid_t type, const char *name, const void *value);
herr_t  H5Tenum_nameof(hid_t type, const void *value, char *name, size_t size);
herr_t  H5Tenum_valueof(hid_t type, const char *name, void *value);

hid_t   H5Tvlen_create(hid_t base_id);

hid_t   H5Tarray_create2(hid_t base_id, uint ndims, const hsize_t dim[]);
int     H5Tget_array_ndims(hid_t type_id);
int     H5Tget_array_dims2(hid_t type_id, hsize_t dims[]);

herr_t  H5Tset_tag(hid_t type, const char *tag);
char   *H5Tget_tag(hid_t type);

hid_t   H5Tget_super(hid_t type);
H5T_class_t     H5Tget_class(hid_t type_id);
htri_t  H5Tdetect_class(hid_t type_id, H5T_class_t cls);
size_t  H5Tget_size(hid_t type_id);
H5T_order_t     H5Tget_order(hid_t type_id);
size_t  H5Tget_precision(hid_t type_id);
int     H5Tget_offset(hid_t type_id);
herr_t  H5Tget_pad(hid_t type_id, H5T_pad_t *lsb, H5T_pad_t *msb);
H5T_sign_t  H5Tget_sign(hid_t type_id);
herr_t  H5Tget_fields(hid_t type_id, size_t *spos, size_t *epos, size_t *mpos);
size_t  H5Tget_ebias(hid_t type_id);
H5T_norm_t  H5Tget_norm(hid_t type_id);
H5T_pad_t   H5Tget_inpad(hid_t type_id);
H5T_str_t   H5Tget_strpad(hid_t type_id);
int     H5Tget_nmembers(hid_t type_id);
char    *H5Tget_member_name(hid_t type_id, uint membno);
int     H5Tget_member_index(hid_t type_id, const char *name);
size_t  H5Tget_member_offset(hid_t type_id, uint membno);
H5T_class_t     H5Tget_member_class(hid_t type_id, uint membno);
hid_t   H5Tget_member_type(hid_t type_id, uint membno);
herr_t  H5Tget_member_value(hid_t type_id, uint membno, void *value);
H5T_cset_t  H5Tget_cset(hid_t type_id);
htri_t  H5Tis_variable_str(hid_t type_id);
hid_t   H5Tget_native_type(hid_t type_id, H5T_direction_t direction);

herr_t  H5Tset_size(hid_t type_id, size_t size);
herr_t  H5Tset_order(hid_t type_id, H5T_order_t order);
herr_t  H5Tset_precision(hid_t type_id, size_t prec);
herr_t  H5Tset_offset(hid_t type_id, size_t offset);
herr_t  H5Tset_pad(hid_t type_id, H5T_pad_t lsb, H5T_pad_t msb);
herr_t  H5Tset_sign(hid_t type_id, H5T_sign_t sign);
herr_t  H5Tset_fields(hid_t type_id, size_t spos, size_t epos, size_t esize, size_t mpos,
                      size_t msize);
herr_t  H5Tset_ebias(hid_t type_id, size_t ebias);
herr_t  H5Tset_norm(hid_t type_id, H5T_norm_t norm);
herr_t  H5Tset_inpad(hid_t type_id, H5T_pad_t pad);
herr_t  H5Tset_cset(hid_t type_id, H5T_cset_t cset);
herr_t  H5Tset_strpad(hid_t type_id, H5T_str_t strpad);

herr_t  H5Tregister(H5T_pers_t pers, const char *name, hid_t src_id, hid_t dst_id,
                    H5T_conv_t func);
herr_t  H5Tunregister(H5T_pers_t pers, const char *name, hid_t src_id, hid_t dst_id,
                      H5T_conv_t func);
H5T_conv_t  H5Tfind(hid_t src_id, hid_t dst_id, H5T_cdata_t **pcdata);
htri_t  H5Tcompiler_conv(hid_t src_id, hid_t dst_id);
herr_t  H5Tconvert(hid_t src_id, hid_t dst_id, size_t nelmts, void *buf, void *background,
                   hid_t plist_id);

/* Register properties */

import hdf5.c.meta;
mixin makeProperties!(mixin(__MODULE__), "_g", H5open);

/* Additional aliases */

alias H5T_INTEL_I8  = H5T_STD_I8LE;
alias H5T_INTEL_I16 = H5T_STD_I16LE;
alias H5T_INTEL_I32 = H5T_STD_I32LE;
alias H5T_INTEL_I64 = H5T_STD_I64LE;
alias H5T_INTEL_U8  = H5T_STD_U8LE;
alias H5T_INTEL_U16 = H5T_STD_U16LE;
alias H5T_INTEL_U32 = H5T_STD_U32LE;
alias H5T_INTEL_U64 = H5T_STD_U64LE;
alias H5T_INTEL_B8  = H5T_STD_B8LE;
alias H5T_INTEL_B16 = H5T_STD_B16LE;
alias H5T_INTEL_B32 = H5T_STD_B32LE;
alias H5T_INTEL_B64 = H5T_STD_B64LE;
alias H5T_INTEL_F32 = H5T_IEEE_F32LE;
alias H5T_INTEL_F64 = H5T_IEEE_F64LE;

alias H5T_ALPHA_I8  = H5T_STD_I8LE;
alias H5T_ALPHA_I16 = H5T_STD_I16LE;
alias H5T_ALPHA_I32 = H5T_STD_I32LE;
alias H5T_ALPHA_I64 = H5T_STD_I64LE;
alias H5T_ALPHA_U8  = H5T_STD_U8LE;
alias H5T_ALPHA_U16 = H5T_STD_U16LE;
alias H5T_ALPHA_U32 = H5T_STD_U32LE;
alias H5T_ALPHA_U64 = H5T_STD_U64LE;
alias H5T_ALPHA_B8  = H5T_STD_B8LE;
alias H5T_ALPHA_B16 = H5T_STD_B16LE;
alias H5T_ALPHA_B32 = H5T_STD_B32LE;
alias H5T_ALPHA_B64 = H5T_STD_B64LE;
alias H5T_ALPHA_F32 = H5T_IEEE_F32LE;
alias H5T_ALPHA_F64 = H5T_IEEE_F64LE;

alias H5T_MIPS_I8   = H5T_STD_I8BE;
alias H5T_MIPS_I16  = H5T_STD_I16BE;
alias H5T_MIPS_I32  = H5T_STD_I32BE;
alias H5T_MIPS_I64  = H5T_STD_I64BE;
alias H5T_MIPS_U8   = H5T_STD_U8BE;
alias H5T_MIPS_U16  = H5T_STD_U16BE;
alias H5T_MIPS_U32  = H5T_STD_U32BE;
alias H5T_MIPS_U64  = H5T_STD_U64BE;
alias H5T_MIPS_B8   = H5T_STD_B8BE;
alias H5T_MIPS_B16  = H5T_STD_B16BE;
alias H5T_MIPS_B32  = H5T_STD_B32BE;
alias H5T_MIPS_B64  = H5T_STD_B64BE;
alias H5T_MIPS_F32  = H5T_IEEE_F32BE;
alias H5T_MIPS_F64  = H5T_IEEE_F64BE;

static if (CHAR_MIN) {
    alias H5T_NATIVE_CHAR = H5T_NATIVE_SCHAR;
}
else {
    alias H5T_NATIVE_CHAR = H5T_NATIVE_UCHAR;
}
