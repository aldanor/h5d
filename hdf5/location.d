module hdf5.location;

import hdf5.api;
import hdf5.exception;
import hdf5.utils;

public import hdf5.id;

import std.string : toStringz;

abstract class H5Location : H5ID {
    protected this(hid_t id) { super(id); }

    public @property {
        string comment() const nothrow {
            scope(failure) return null;
            return getH5String!D_H5Oget_comment(m_id);
        }

        void comment(string s) {
            D_H5Oset_comment(m_id, s.toStringz);
        }
    }
}

public const {
    string filename(in H5Location loc) {
        return getH5String!D_H5Fget_name(loc.id);
    }
}
