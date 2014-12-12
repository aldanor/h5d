/* HDF5 "multi" File Driver */

module hdf5.c.drivers.multi;

import hdf5.c.h5;
import hdf5.c.h5i;
import hdf5.c.h5p;
import hdf5.c.h5fd;

const hid_t H5FD_MULTI;

shared static this() {
    H5FD_MULTI = H5FD_multi_init();
}

extern (C) nothrow:

hid_t   H5FD_multi_init();
void    H5FD_multi_term();
herr_t  H5Pset_fapl_multi(hid_t fapl_id, const H5FD_mem_t *memb_map, const hid_t *memb_fapl,
                          char **memb_name, // was "const char * const *"
                          const haddr_t *memb_addr, hbool_t relax);
herr_t  H5Pget_fapl_multi(hid_t fapl_id, H5FD_mem_t *memb_map, hid_t *memb_fapl, char **memb_name,
                          haddr_t *memb_addr, hbool_t *relax);
herr_t  H5Pset_fapl_split(hid_t fapl, const char *meta_ext, hid_t meta_plist_id,
                          const char *raw_ext, hid_t raw_plist_id);
