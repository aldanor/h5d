/* HDF5 "log" File Driver */

module hdf5.c.drivers.log;

import hdf5.c.h5;
import hdf5.c.h5i;

hid_t H5FD_LOG() @property @nogc {
    return H5FD_log_init();
}

extern (C) nothrow @nogc:

enum ulong H5FD_LOG_LOC_READ     = 0x00000001;
enum ulong H5FD_LOG_LOC_WRITE    = 0x00000002;
enum ulong H5FD_LOG_LOC_SEEK     = 0x00000004;
enum ulong H5FD_LOG_LOC_IO       = H5FD_LOG_LOC_READ | H5FD_LOG_LOC_WRITE | H5FD_LOG_LOC_SEEK;

enum ulong H5FD_LOG_FILE_READ    = 0x00000008;
enum ulong H5FD_LOG_FILE_WRITE   = 0x00000010;
enum ulong H5FD_LOG_FILE_IO      = H5FD_LOG_FILE_READ | H5FD_LOG_FILE_WRITE;

enum ulong H5FD_LOG_FLAVOR       = 0x00000020;

enum ulong H5FD_LOG_NUM_READ     = 0x00000040;
enum ulong H5FD_LOG_NUM_WRITE    = 0x00000080;
enum ulong H5FD_LOG_NUM_SEEK     = 0x00000100;
enum ulong H5FD_LOG_NUM_TRUNCATE = 0x00000200;
enum ulong H5FD_LOG_NUM_IO       = H5FD_LOG_NUM_READ | H5FD_LOG_NUM_WRITE | H5FD_LOG_NUM_SEEK |
                                   H5FD_LOG_NUM_TRUNCATE;

enum ulong H5FD_LOG_TIME_OPEN  = 0x00000400;
enum ulong H5FD_LOG_TIME_STAT  = 0x00000800;
enum ulong H5FD_LOG_TIME_READ  = 0x00001000;
enum ulong H5FD_LOG_TIME_WRITE = 0x00002000;
enum ulong H5FD_LOG_TIME_SEEK  = 0x00004000;
enum ulong H5FD_LOG_TIME_CLOSE = 0x00008000;
enum ulong H5FD_LOG_TIME_IO    = H5FD_LOG_TIME_OPEN | H5FD_LOG_TIME_STAT | H5FD_LOG_TIME_READ |
                                 H5FD_LOG_TIME_WRITE | H5FD_LOG_TIME_SEEK | H5FD_LOG_TIME_CLOSE;

enum ulong H5FD_LOG_ALLOC      = 0x00010000;
enum ulong H5FD_LOG_ALL        = H5FD_LOG_ALLOC | H5FD_LOG_TIME_IO | H5FD_LOG_NUM_IO |
                                 H5FD_LOG_FLAVOR | H5FD_LOG_FILE_IO | H5FD_LOG_LOC_IO;

hid_t   H5FD_log_init();
void    H5FD_log_term();
herr_t  H5Pset_fapl_log(hid_t fapl_id, const char *logfile, ulong flags, size_t buf_size);
