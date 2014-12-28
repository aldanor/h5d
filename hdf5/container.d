module hdf5.container;

import hdf5.api;
import hdf5.file;
import hdf5.group;
import hdf5.location;

import std.string : toStringz;

package abstract class H5Container : H5Location {
    protected this(hid_t id) { super(id); }

    H5Group opIndex(in string name) const {
        return this.group(name);
    }

    protected H5G_info_t info() @property const {
        H5G_info_t info;
        D_H5Gget_info(m_id, &info);
        return info;
    }

    public @property const {
        /// Returns the number of objects in the container.
        size_t length() {
            return info.nlinks;
        }
    }

    public const {
        /// Creates a new group in a container which can be a file or another group.
        H5Group createGroup(in string name) {
            return new H5Group(D_H5Gcreate2(m_id, name.toStringz, H5P_DEFAULT, 0, H5P_DEFAULT));
        }

        /// Opens an existing group in a container which can be a file or another group.
        H5Group group(in string name) {
            return new H5Group(D_H5Gopen2(m_id, name.toStringz, H5P_DEFAULT));
        }
    }
}

// length, group, createGroup, opIndex
unittest {
    auto file = openH5File!("core", false)("foo.h5");
    scope(exit) file.close();
    file.createGroup("foo").createGroup("bar");
    file.createGroup("baz");
    assert(file.length == 2);
    assert(file.root.group(".").length == 2);
    assert(file["foo"].length == 1);
    assert(file["foo"].group("bar").length == 0);
    assert(file.root["baz"].length == 0);
}
