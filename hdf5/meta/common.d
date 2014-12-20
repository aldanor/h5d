module hdf5.meta.common;

alias ID(T) = T;
alias ID(alias T) = T;

unittest {
    struct Foo {
        int x;
    }
    alias member = ID!(__traits(getMember, Foo, "x"));
}

