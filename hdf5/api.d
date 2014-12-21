module hdf5.api;

import hdf5.c.meta.wrap : wrapSymbolsH5;

public import hdf5.c.h5;    mixin wrapSymbolsH5!(hdf5.c.h5);
public import hdf5.c.h5a;   mixin wrapSymbolsH5!(hdf5.c.h5a);
public import hdf5.c.h5ac;  mixin wrapSymbolsH5!(hdf5.c.h5ac);
public import hdf5.c.h5c;   mixin wrapSymbolsH5!(hdf5.c.h5c);
public import hdf5.c.h5d;   mixin wrapSymbolsH5!(hdf5.c.h5d);
public import hdf5.c.h5e;   mixin wrapSymbolsH5!(hdf5.c.h5e);
public import hdf5.c.h5f;   mixin wrapSymbolsH5!(hdf5.c.h5f);
public import hdf5.c.h5fd;  mixin wrapSymbolsH5!(hdf5.c.h5fd);
public import hdf5.c.h5g;   mixin wrapSymbolsH5!(hdf5.c.h5g);
public import hdf5.c.h5i;   mixin wrapSymbolsH5!(hdf5.c.h5i);
public import hdf5.c.h5l;   mixin wrapSymbolsH5!(hdf5.c.h5l);
public import hdf5.c.h5mm;  mixin wrapSymbolsH5!(hdf5.c.h5mm);
public import hdf5.c.h5o;   mixin wrapSymbolsH5!(hdf5.c.h5o);
public import hdf5.c.h5p;   mixin wrapSymbolsH5!(hdf5.c.h5p);
public import hdf5.c.h5r;   mixin wrapSymbolsH5!(hdf5.c.h5r);
public import hdf5.c.h5s;   mixin wrapSymbolsH5!(hdf5.c.h5s);
public import hdf5.c.h5t;   mixin wrapSymbolsH5!(hdf5.c.h5t);
public import hdf5.c.h5z;   mixin wrapSymbolsH5!(hdf5.c.h5z);

public import hdf5.c.drivers.core;      mixin wrapSymbolsH5!(hdf5.c.drivers.core);
public import hdf5.c.drivers.family;    mixin wrapSymbolsH5!(hdf5.c.drivers.family);
public import hdf5.c.drivers.log;       mixin wrapSymbolsH5!(hdf5.c.drivers.log);
public import hdf5.c.drivers.mpi;       mixin wrapSymbolsH5!(hdf5.c.drivers.mpi);
public import hdf5.c.drivers.multi;     mixin wrapSymbolsH5!(hdf5.c.drivers.multi);
public import hdf5.c.drivers.sec2;      mixin wrapSymbolsH5!(hdf5.c.drivers.sec2);
public import hdf5.c.drivers.stdio;     mixin wrapSymbolsH5!(hdf5.c.drivers.stdio);
public import hdf5.c.drivers.windows;   mixin wrapSymbolsH5!(hdf5.c.drivers.windows);
public import hdf5.c.drivers.direct;    mixin wrapSymbolsH5!(hdf5.c.drivers.direct);
