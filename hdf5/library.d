module hdf5.library;

import hdf5.id;
import hdf5.api;

package ssize_t objectCount(hid_t where = H5F_OBJ_ALL, uint types = H5F_OBJ_ALL) {
    return D_H5Fget_obj_count(where, types);
}

/// Note: this returns borrowed references
package H5ID[] findObjects(hid_t where = H5F_OBJ_ALL, uint types = H5F_OBJ_ALL) {
    auto count = objectCount(where, types);
    H5ID[] objects;
    if (count > 0) {
        auto ids = new hid_t[count];
        D_H5Fget_obj_ids(where, types, count, ids.ptr);
        foreach (id; ids)
            objects ~= new H5ID(id);
    }
    return objects;
}
