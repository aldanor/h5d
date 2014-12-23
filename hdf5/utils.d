module hdf5.utils;

import std.conv : to;

import hdf5.api : hid_t;

/* Get the string from an HDF5 C funtion with args (hid_t, char *, size_t, ...) */
package string getH5String(alias func, Args...)(hid_t id, Args args) {
    auto size = func(id, null, 0, args);
    if (!size)
        return null;
    auto result = new char[size + 1];
    func(id, result.ptr, size + 1, args);
    return result.to!string;
}
