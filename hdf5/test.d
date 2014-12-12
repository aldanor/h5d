module hdf5.test;

import hdf5.c;

unittest {
    import std.stdio;
    writeln(H5P_CLS_ROOT);
    writeln(H5E_SYSERRSTR);
    writeln(H5T_NATIVE_LDOUBLE);
    writeln(H5FD_CORE);
    writeln(H5FD_FAMILY);
    writeln(H5FD_LOG);
    writeln(H5FD_MPIO);
    writeln(H5FD_MULTI);
    writeln(H5FD_SEC2);
    writeln(H5FD_STDIO);
    writeln(H5FD_WINDOWS);
    writeln(H5FD_DIRECT);
}
