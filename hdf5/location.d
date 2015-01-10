module hdf5.location;

import hdf5.api;
import hdf5.exception;
import hdf5.utils;
import hdf5.id;
import hdf5.file;

import std.string   : toStringz;

version (unittest) {
    import std.file : tempDir, getSize, exists, remove;
}

package abstract class H5Location : H5ID {
    protected this(hid_t id) { super(id); }

    public const @property {
        /// Returns the comment attached to a named object (null if none).
        string comment() nothrow {
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

        // Returns a handle to the file containing the named object.
        H5File file() {
            return new H5File(D_H5Iget_file_id(m_id));
        }

        // Returns unique file number.
        ulong fileno() {
            return objectInfo.fileno;
        }
    }

    protected H5O_info_t objectInfo() const @property {
        H5O_info_t info;
        D_H5Oget_info(m_id, &info);
        return info;
    }

    public const {
        // Flushes the file containing a named object to storage.
        void flush(bool global = false) {
            D_H5Fflush(m_id, false ? H5F_SCOPE_GLOBAL : H5F_SCOPE_LOCAL);
        }
    }
}

// name, filename, flush, comment, fileno
unittest {
    auto filename = tempDir.buildPath("foo.h5");
    scope(exit) if (filename.exists) filename.remove();
    auto file = new H5File(filename);
    scope(exit) file.close();
    file.createGroup("bar").createGroup("baz");
    assert(filename.getSize == 0);
    assert(file.size > 0);
    auto baz = file.group("bar/baz");
    baz.flush();
    assert(filename.getSize > 0);
    assert(file.size == filename.getSize);
    assert(file.filename == filename);
    assert(baz.filename == filename);
    assert(file.name == "/");
    assert(file.root.name == "/");
    assert(baz.name == "/bar/baz");
    assert(baz.comment is null);
    baz.comment = "foo";
    assert(baz.comment == "foo");
    baz.comment = null;
    assert(baz.comment is null);
    assert(file.fileno > 0 && file.fileno == baz.fileno);
}

// file (test that file references are all closed at once)
unittest {
    auto file = openH5File!("core", false)("foo.h5");
    scope(exit) file.close();
    auto baz = file.createGroup("bar").createGroup("baz");
    auto file1 = file["/"].file;
    auto file2 = baz.file;
    assert(file1.id == file.id);
    assert(file2.id == file.id);
    assert(file1.fileno == file.fileno);
    assert(file2.fileno == file.fileno);
    assert(file1.mode == file.mode);
    assert(file2.mode == file.mode);
    file2.close();
    assert(!file.valid);
    assert(!file1.valid);
    assert(!file2.valid);
    assert(!baz.valid);
}
