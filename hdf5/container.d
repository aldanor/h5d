module hdf5.container;

import hdf5.api;
import hdf5.file;
import hdf5.group;
import hdf5.location;

import std.string   : toStringz;

package abstract class H5Container : H5Location {
    protected this(hid_t id) { super(id); }

    H5Group opIndex(in string name) const {
        return this.group(name);
    }

    protected H5G_info_t groupInfo() @property const {
        H5G_info_t info;
        D_H5Gget_info(m_id, &info);
        return info;
    }

    public @property const {
        /// Returns the number of objects in the container.
        size_t length() {
            return groupInfo.nlinks;
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

        /// Creates hard/soft link. Note: name/destination are relative to the current object.
        void link(in string source, in string destination, bool soft = false) {
            if (soft)
                D_H5Lcreate_soft(source.toStringz, m_id, destination.toStringz,
                                 H5P_DEFAULT, H5P_DEFAULT);
            else
                D_H5Lcreate_hard(m_id, source.toStringz, H5L_SAME_LOC, destination.toStringz,
                                 H5P_DEFAULT, H5P_DEFAULT);
        }

        /// Removes a link to an object from this file or group.
        void unlink(in string name) {
            H5Ldelete(m_id, name.toStringz, H5P_DEFAULT);
        }

        /// Relinks an object. Note: source/destination are relative to the current object.
        void move(in string source, in string destination) {
            D_H5Lmove(m_id, source.toStringz, H5L_SAME_LOC, destination.toStringz,
                      H5P_DEFAULT, H5P_DEFAULT);
        }
    }
}

// length, group, createGroup, opIndex, link, unlink, move
unittest {
    import std.exception;
    import hdf5.exception;

    auto file = openH5File!("core", false)("foo.h5");
    scope(exit) file.close();

    // length, group, createGroup, opIndex
    file.createGroup("foo").createGroup("bar");
    file.createGroup("baz");
    assert(file.length == 2);
    assert(file.root.group(".").length == 2);
    assert(file["foo"].length == 1);
    assert(file["foo"].group("bar").length == 0);
    assert(file.root["baz"].length == 0);

    // move
    file.createGroup("test");
    file.group("test");
    file.move("test", "foo/test");
    file.group("foo/test");
    assertThrown!H5Exception(file.group("test"));

    // hard link
    file.group("foo/test").createGroup("inner");
    file.link("foo/test", "foo/hard");
    file.group("foo/test/inner");
    file.group("foo/hard/inner");
    assertThrown!H5Exception(file.link("foo/test", "foo/test/inner"));
    assertThrown!H5Exception(file.link("foo/qwe", "foo/qweqwe"));
    file.move("/foo/hard", "/foo/hard2");
    file.group("/foo/hard2/inner");
    file.move("/foo/test", "/foo/test2");
    file.group("/foo/test2/inner");
    file.group("/foo/hard2/inner");

    // soft link
    file.link("/foo/test2", "/foo/soft", true);
    file.group("/foo/soft/inner");
    file.move("/foo/soft", "/foo/soft2");
    file.group("/foo/soft2/inner");
    file.move("/foo/test2", "/foo/test3");
    assertThrown!H5Exception(file.group("/foo/soft2/inner"));
    file.link("/foo/qwe", "/foo/qweqwe", true);
    assertThrown!H5Exception(file.group("/foo/qweqwe"));
    file.createGroup("/foo/qwe");
    file.group("/foo/qweqwe");

    // unlink
    file.unlink("/foo/qwe");
    assertThrown!H5Exception(file.group("/foo/qwe"));
    assertThrown!H5Exception(file.group("/foo/qweqwe"));
    file.unlink("/foo/test2");
    assertThrown!H5Exception(file.group("/foo/test2"));
    file.group("/foo/hard2/inner");
    file.unlink("/foo/hard2");
    assertThrown!H5Exception(file.group("/foo/hard2/inner"));
}
