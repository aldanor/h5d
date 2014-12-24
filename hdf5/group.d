module hdf5.group;

import hdf5.api;
import hdf5.container;

class H5Group : H5Container {
    package this(hid_t id) { super(id); }
}
