module hdf5.location;

import hdf5.api;
import hdf5.exception;
import hdf5.utils;

public import hdf5.id;

import std.string : toStringz;

abstract class H5Location : H5ID {
    protected this(hid_t id) { super(id); }

    public const @property {
        string comment() nothrow {
            scope(failure) return null;
            return getH5String!D_H5Oget_comment(m_id);
        }

        void comment(string s) {
            D_H5Oset_comment(m_id, s.toStringz);
        }
    }

    public const {
        void flush(bool global = false) {
            D_H5Fflush(m_id, false ? H5F_SCOPE_GLOBAL : H5F_SCOPE_LOCAL);
        }
    }
}

public const {
    string filename(in H5Location loc) {
        return getH5String!D_H5Fget_name(loc.id);
    }
}
