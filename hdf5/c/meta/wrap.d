module hdf5.c.meta.wrap;

import std.traits;
import std.string;
import std.typetuple;
import std.exception;
import std.format;

import hdf5.meta;

bool _propertyNameMatches(alias parent, string suffix, string name)() {
    static if (!__traits(compiles, __traits(getMember, parent, name)))
        return false;
    else {
        alias symbol = ID!(__traits(getMember, parent, name));
        enum name = __traits(identifier, symbol);
        enum n = suffix.length;
        static if (!is(symbol) && is(typeof(symbol)))
            return (name.length > n) && (name[$ - n .. $] == suffix);
        else
            return false;
    }
}

unittest {
    struct Foo {
        static int foo_g, foo_x, _g;
    }
    static assert(_propertyNameMatches!(Foo, "_g", "foo_g"));
    static assert(!_propertyNameMatches!(Foo, "_g", "foo_x"));
    static assert(!_propertyNameMatches!(Foo, "_g", "_g"));
    static assert(!_propertyNameMatches!(Foo.foo_g, "_g", "foo_g"));
}

mixin template _makeProperty(alias parent, string suffix, alias func, string name) {
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
        static if (_propertyNameMatches!(parent, suffix, names[0]))
            mixin _makeProperty!(parent, suffix, func, names[0]);
        mixin _makeProperties!(parent, suffix, func, names[1 .. $]);
    }
}

template hasSuffix(string suffix) {
    bool _hasSuffix(string s)() {
        return (s.length > suffix.length) && (s[$ - suffix.length .. $] == suffix);
    }
    alias hasSuffix = _hasSuffix;
}

mixin template makeProperties(alias parent, string suffix, alias func = {}) {
    import std.string;
    import std.typetuple;
    import hdf5.meta;
    static if (__traits(compiles, __traits(allMembers, parent)))
        mixin _makeProperties!(parent, suffix, func, Filter!(hasSuffix!suffix,
                                                             __traits(allMembers, parent)));
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
        mixin("alias %s = ID!(__traits(getMember, symbol, names[0]));".format(names[0]));
        mixin _aliasMembers!(symbol, names[1 .. $]);
    }
}

mixin template aliasMembers(alias symbol) {
    mixin _aliasMembers!(symbol, __traits(allMembers, symbol));
}

mixin template _wrapSymbol(T, alias wrapper, string name) {
    mixin("alias %s = T;".format(name));
}

mixin template _wrapSymbol(alias symbol, alias wrapper, string name) {
    static if (__traits(isStaticFunction, symbol)) {
        static if (functionLinkage!symbol == "C")
            mixin("alias %s = wrapper!(symbol);".format(name));
    }
    else {
        static if (is(symbol) || is(typeof(symbol))) {
            mixin("alias %s = symbol;".format(name));
            static if (is(symbol == enum))
                mixin aliasMembers!symbol;
        }
    }
}

mixin template _wrapSymbols(alias parent, alias wrapper, names...) {
    static if (names.length > 0) {
        static if (isPublic!(__traits(getMember, parent, names[0])))
            mixin _wrapSymbol!(__traits(getMember, parent, names[0]), wrapper, names[0]);
        mixin _wrapSymbols!(parent, wrapper, names[1 .. $]);
    }
}

mixin template wrapSymbols(alias parent, alias wrapper) {
    static if (__traits(compiles, __traits(allMembers, parent)))
        mixin _wrapSymbols!(parent, wrapper, __traits(allMembers, parent));
}

unittest {
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
    static assert(is(test_enum == enum));
    assert(X == 1);
    assert(Y == 2);
    static assert(is(test_struct == struct));
    test_struct s = { 1 };
    static assert(is(test_type == int));
    static assert(!__traits(compiles, test_f));
    static assert(__traits(compiles, test_g));
    assertNotThrown!Exception(test_g(0));
    assertThrown!Exception(test_g(-1));
    static assert(TEST_FOO == 1);
    assert(isFunctionPointer!test_function);
    static assert(!__traits(compiles, TEST_BAR));
}
