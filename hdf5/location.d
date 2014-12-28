module hdf5.location;

import hdf5.api;
import hdf5.exception;
import hdf5.utils;
import hdf5.id;

import std.string : toStringz;

version (unittest) {
    import std.file : tempDir, getSize, exists, remove;
    import hdf5.file;
}

package abstract class H5Location : H5ID {
    protected this(hid_t id) { super(id); }

    public const @property {
        /// Returns the comment attached to a named object (null if none).
        string comment() {
            scope(failure) return null;
            return getH5String!D_H5Oget_comment(m_id);
        }

        // Sets the comment on a named object (null to remove).
        void comment(string s) {
            D_H5Oset_comment(m_id, s.toStringz);
        }

        // Returns name of a named object within the file.
        string name() {
            return getH5String!D_H5Iget_name(m_id);
        }

        // Returns the name of the file containing the named object.
        string filename() {
            return getH5String!D_H5Fget_name(m_id);
        }
    }

    public const {
        // Flushes a named object.
        void flush(bool global = false) {
            D_H5Fflush(m_id, false ? H5F_SCOPE_GLOBAL : H5F_SCOPE_LOCAL);
        }
    }
}

// name/filename/flush/comment
unittest {
    auto filename = tempDir.buildPath("foo.h5");
    scope(exit) if (filename.exists) filename.remove();
    auto file = new H5File(filename);
    scope(exit) file.close();
    file.createGroup("bar").createGroup("baz");
    assert(filename.getSize == 0);
    assert(file.size > 0);
    file["bar/baz"].flush();
    assert(filename.getSize > 0);
    assert(file.size == filename.getSize);
    assert(file.filename == filename);
    assert(file["bar/baz"].filename == filename);
    assert(file.name == "/");
    assert(file.root.name == "/");
    assert(file["bar/baz"].name == "/bar/baz");
    assert(file["bar/baz"].comment is null);
    file["bar/baz"].comment = "foo";
    assert(file["bar/baz"].comment == "foo");
    file["bar/baz"].comment = null;
    assert(file["bar/baz"].comment is null);
}
