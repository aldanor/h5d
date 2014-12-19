module hdf5.meta.common;

alias ID(T) = T;
alias ID(alias T) = T;

unittest {
    struct Foo {
        int x;
    }
    alias member = ID!(__traits(getMember, Foo, "x"));
}

enum bool isPublic(T) = true;

bool isPublic(alias symbol)() {
    static if (__traits(compiles, __traits(getProtection, symbol))) {
        static if (__traits(getProtection, symbol) == "public")
            return true;
        else
            return false;
    }
    else
        return true;
}

unittest {
    struct Foo {
        public static int foo;
        private static int bar;
    }
    static assert(isPublic!(Foo.foo));
    static assert(!isPublic!(Foo.bar));
    static assert(isPublic!int);
    static assert(isPublic!1);
}
