/* HDF5 "mpi" (MPIO) File Driver */

module hdf5.c.drivers.mpi;

import hdf5.c.h5;
import hdf5.c.h5i;

enum hid_t H5FD_MPIPOSIX = -1;

const hid_t H5FD_MPIO;

shared static this() {
    version (H5_HAVE_PARALLEL) {
        H5FD_MPIO = H5FD_mpio_init();
    }
    else {
        H5FD_MPIO = -1;
    }
}

extern (C) nothrow:

enum uint H5D_ONE_LINK_CHUNK_IO_THRESHOLD = 0;

enum uint H5D_MULTI_CHUNK_IO_COL_THRESHOLD = 60;

enum H5FD_mpio_xfer_t {
    H5FD_MPIO_INDEPENDENT = 0,
    H5FD_MPIO_COLLECTIVE
}

enum H5FD_mpio_chunk_opt_t {
    H5FD_MPIO_CHUNK_DEFAULT = 0,
    H5FD_MPIO_CHUNK_ONE_IO,
    H5FD_MPIO_CHUNK_MULTI_IO
}

enum H5FD_mpio_collective_opt_t {
    H5FD_MPIO_COLLECTIVE_IO = 0,
    H5FD_MPIO_INDIVIDUAL_IO
}

version (H5_HAVE_PARALLEL) {
    extern __gshared hbool_t H5FD_mpi_opt_types_g;

    hid_t   H5FD_mpio_init();
    void    H5FD_mpio_term();
    herr_t  H5Pset_fapl_mpio(hid_t fapl_id, MPI_Comm comm, MPI_Info info);
    herr_t  H5Pget_fapl_mpio(hid_t fapl_id, MPI_Comm *comm, MPI_Info *info);
    herr_t  H5Pset_dxpl_mpio(hid_t dxpl_id, H5FD_mpio_xfer_t xfer_mode);
    herr_t  H5Pget_dxpl_mpio(hid_t dxpl_id, H5FD_mpio_xfer_t *xfer_mode);
    herr_t  H5Pset_dxpl_mpio_collective_opt(hid_t dxpl_id, H5FD_mpio_collective_opt_t opt_mode);
    herr_t  H5Pset_dxpl_mpio_chunk_opt(hid_t dxpl_id, H5FD_mpio_chunk_opt_t opt_mode);
    herr_t  H5Pset_dxpl_mpio_chunk_opt_num(hid_t dxpl_id, unsigned num_chunk_per_proc);
    herr_t  H5Pset_dxpl_mpio_chunk_opt_ratio(hid_t dxpl_id, unsigned percent_num_proc_per_chunk);
}
