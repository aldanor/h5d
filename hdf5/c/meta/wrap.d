module hdf5.c.meta.wrap;

mixin template _makeProperty(alias parent, string suffix, alias func, string name) {
    import std.string : format;
    mixin(("public typeof(__traits(getMember, parent, name)) %s() @property nothrow "
          ~ "{ cast(void) func(); return __traits(getMember, parent, name); }").format(
          name[0 .. $ - suffix.length]));
}

unittest {
    struct Foo {
        static int x_g = 1;
        static mixin _makeProperty!(Foo, "_g", { return 1; }, "x_g");
    }
    mixin _makeProperty!(Foo, "_g", { return 1; }, "x_g");
    assert(Foo.x == 1);
    assert(x == 1);
}

mixin template _makeProperties(alias parent, string suffix, alias func, names...) {
    static if (names.length > 0) {
        mixin _makeProperty!(parent, suffix, func, names[0]);
        mixin _makeProperties!(parent, suffix, func, names[1 .. $]);
    }
}

template _variableSuffixMatches(alias parent, string suffix) {
    bool _variableSuffixMatchesImpl(string name)() {
        static if (!__traits(compiles, __traits(getMember, parent, name)))
            return false;
        else {
            import hdf5.meta : Alias;
            alias symbol = Alias!(__traits(getMember, parent, name));
            static if (is(symbol) || !is(typeof(symbol)))
                return false;
            else
                return (name.length > suffix.length) && (name[$ - suffix.length .. $] == suffix);
        }
    }
    alias _variableSuffixMatches = _variableSuffixMatchesImpl;
}

unittest {
    struct Foo {
        static int foo_g, foo_x, _g;
        alias qwe_g = int;
    }
    alias check = _variableSuffixMatches!(Foo, "_g");
    static assert(check!("foo_g"));
    static assert(!check!("foo_x"));
    static assert(!check!("_g"));
    static assert(!check!("qwe_g"));
    static assert(!check!("foobar_g"));
}

mixin template makeProperties(alias parent, string suffix, alias func = {}) {
    import std.string, std.typetuple, hdf5.meta;
    static if (__traits(compiles, __traits(allMembers, parent)))
        mixin _makeProperties!(parent, suffix, func,
            Filter!(_variableSuffixMatches!(parent, suffix),__traits(allMembers, parent)));
}

unittest {
    struct Foo {
        static int x_g = 1;
        static int y_g = 2;
        static int z = 3;
        private static int a_g = 4;
        static mixin makeProperties!(Foo, "_g", { return 1; });
    }
    int counter = 0;
    mixin makeProperties!(Foo, "_g", { counter++; });
    assert(Foo.x == 1);
    assert(Foo.y == 2);
    assert(Foo.a == 4);
    assert(x == 1);
    assert(counter == 1);
    assert(y == 2);
    assert(counter == 2);
    static assert(!is(typeof(z)));
}

mixin template _aliasMembers(alias symbol, names...) {
    static if (names.length > 0) {
        mixin("alias %s = Alias!(__traits(getMember, symbol, names[0]));".format(names[0]));
        mixin _aliasMembers!(symbol, names[1 .. $]);
    }
}

mixin template aliasMembers(alias symbol) {
    import std.string : format;
    import hdf5.meta : Alias;
    mixin _aliasMembers!(symbol, __traits(allMembers, symbol));
}

mixin template _wrapSymbol(T, alias wrapper, string name) {}

mixin template _wrapSymbol(alias symbol, alias wrapper, string name) {
    static if (__traits(isStaticFunction, symbol)) {
        static if (functionLinkage!symbol == "C") {
            static if (!(functionAttributes!symbol & FunctionAttribute.property)) {
                mixin("alias D_%s = wrapper!(symbol);".format(name));
            }
        }
    }
    else static if (is(symbol == enum))
        mixin aliasMembers!symbol;
}

mixin template _wrapSymbols(alias parent, alias wrapper, names...) {
    static if (names.length > 0) {
        static if (__traits(compiles, __traits(getMember, parent, names[0]))) {
            mixin _wrapSymbol!(__traits(getMember, parent, names[0]), wrapper, names[0]);
        }
        mixin _wrapSymbols!(parent, wrapper, names[1 .. $]);
    }
}

mixin template wrapSymbols(alias parent, alias wrapper) {
    import std.traits;
    import std.string : format;
    import hdf5.c.meta : _wrapSymbols, _wrapSymbol, aliasMembers, _aliasMembers;
    static if (__traits(compiles, __traits(allMembers, parent)))
        mixin _wrapSymbols!(parent, wrapper, __traits(allMembers, parent));
}

unittest {
    import std.exception : assertThrown, assertNotThrown;
    auto wrapper(alias func)(ParameterTypeTuple!(func) args)
    {
        static if (is(ReturnType!(func) == void))
            func(args);
        else {
            auto result = func(args);
            if (result < 0)
                throw new Exception("");
            return result;
        }
    }
    static struct Test {
        enum test_enum {
            X = 1,
            Y = 2
        }
        struct test_struct {
            int x;
        }
        alias test_type = int;
        static void test_f() {}
        static extern (C) int test_g(int x) { return x; }
        alias test_function = extern (C) void function();
        enum TEST_FOO = 1;
        private enum TEST_BAR = 2;
    }
    mixin wrapSymbols!(Test, wrapper);
    assert(X == 1);
    assert(Y == 2);
    static assert(!__traits(compiles, test_struct));
    static assert(!__traits(compiles, test_f));
    static assert(__traits(compiles, D_test_g));
    assertNotThrown!Exception(D_test_g(0));
    assertThrown!Exception(D_test_g(-1));
    static assert(!__traits(compiles, test_function));
    static assert(!__traits(compiles, test_type));
    static assert(!__traits(compiles, TEST_BAR));
}

mixin template wrapSymbolsH5(alias parent) {
    import hdf5.c.meta.wrap : wrapSymbols;
    import hdf5.exception : errorCheckH5;
    mixin wrapSymbols!(parent, errorCheckH5);
}
