module hdf5.container;

import hdf5.api;
import hdf5.file;
import hdf5.group;

public import hdf5.location;

import std.string : toStringz;

package abstract class H5Container : H5Location {
    protected this(hid_t id) { super(id); }

    H5Group opIndex(in string name) const {
        return this.group(name);
    }
}

public const {
    /* Create a new group in a container which can be a file or another group */
    H5Group createGroup(in H5Container obj, in string name) {
        return new H5Group(D_H5Gcreate2(obj.id, name.toStringz, H5P_DEFAULT, 0, H5P_DEFAULT));
    }

    /* Open an existing group in a container which can be a file or another group */
    H5Group group(in H5Container obj, in string name) {
        return new H5Group(D_H5Gopen2(obj.id, name.toStringz, H5P_DEFAULT));
    }
}
