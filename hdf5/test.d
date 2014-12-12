module hdf5.test;

import hdf5.c;

unittest {
    import std.stdio;
    writeln(H5P_CLS_ROOT);
    writeln(H5E_SYSERRSTR);
}
