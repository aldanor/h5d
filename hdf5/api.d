module hdf5.api;

import std.format     : format;
import std.traits     : fullyQualifiedName;

import hdf5.exception : errorCheck;
import hdf5.c.meta    : wrapSymbols;

private mixin template wrapH5(alias mod) {
    mixin("public import %s;".format(fullyQualifiedName!mod));
    mixin wrapSymbols!(mod, errorCheck);
}

mixin wrapH5!(hdf5.c.h5);
mixin wrapH5!(hdf5.c.h5a);
mixin wrapH5!(hdf5.c.h5ac);
mixin wrapH5!(hdf5.c.h5c);
mixin wrapH5!(hdf5.c.h5d);
mixin wrapH5!(hdf5.c.h5e);
mixin wrapH5!(hdf5.c.h5f);
mixin wrapH5!(hdf5.c.h5fd);
mixin wrapH5!(hdf5.c.h5g);
mixin wrapH5!(hdf5.c.h5i);
mixin wrapH5!(hdf5.c.h5l);
mixin wrapH5!(hdf5.c.h5mm);
mixin wrapH5!(hdf5.c.h5o);
mixin wrapH5!(hdf5.c.h5p);
mixin wrapH5!(hdf5.c.h5r);
mixin wrapH5!(hdf5.c.h5s);
mixin wrapH5!(hdf5.c.h5t);
mixin wrapH5!(hdf5.c.h5z);

mixin wrapH5!(hdf5.c.drivers.core);
mixin wrapH5!(hdf5.c.drivers.family);
mixin wrapH5!(hdf5.c.drivers.log);
mixin wrapH5!(hdf5.c.drivers.mpi);
mixin wrapH5!(hdf5.c.drivers.multi);
mixin wrapH5!(hdf5.c.drivers.sec2);
mixin wrapH5!(hdf5.c.drivers.stdio);
mixin wrapH5!(hdf5.c.drivers.windows);
mixin wrapH5!(hdf5.c.drivers.direct);
