module hdf5.group;

import hdf5.api;
import hdf5.container;

public final class H5Group : H5Container {
    package this(hid_t id) { super(id); }

    protected final override void doClose() {
        if (this.valid)
            D_H5Gclose(m_id);
    }
}
