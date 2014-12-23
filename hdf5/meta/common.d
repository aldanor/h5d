module hdf5.meta.common;

alias Alias(T) = T;
alias Alias(alias T) = T;

unittest {
    struct Foo {
        int x;
    }
    alias member = Alias!(__traits(getMember, Foo, "x"));
}

