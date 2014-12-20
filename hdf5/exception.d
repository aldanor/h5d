module hdf5.exception;

import std.traits       : ParameterTypeTuple, ReturnType, isIntegral, isSigned;
import std.exception    : assertThrown, assertNotThrown;

bool maybeError(T)(T v) {
    static if (is(T == function) || is (T : void *))
        return v is null;
    else static if (isIntegral!T)
        static if (isSigned!T)
            return v < 0;
        else
            return v == 0;
    else
        return false;
}

unittest {
    assert(maybeError(-1));
    assert(!maybeError(0));
    assert(!maybeError(1));

    assert(maybeError(0u));
    assert(!maybeError(1u));
    assert(!maybeError(cast(uint) -1));

    assert(maybeError(null));

    char c = 'c';
    assert(!maybeError(&c));
    assert(maybeError(cast(char *) null));
}


auto errorCheck(alias func, alias callback = null)(ParameterTypeTuple!(func) args)
// TODO: add static if check for alias / callback
{
    static if (is(ReturnType!(func) == void))
        func(args);
    else {
        auto result = func(args);
        if (maybeError(result)) {
            static if (is(typeof(callback) == typeof(null)))
                auto exc = new Exception("not valid");
            else {
                auto exc = callback();
                if (exc is null)
                    return result;
            }
            throw exc;
        }
        return result;
    }
}


unittest {
    void void_func() {}
    assertNotThrown!Exception(errorCheck!void_func());

    auto int_func = (int x) => x;
    assertNotThrown!Exception(errorCheck!int_func(1));
    assertNotThrown!Exception(errorCheck!int_func(0));
    assertThrown!Exception(errorCheck!int_func(-1));
    assert(errorCheck!int_func(1) == 1);

    auto uint_func = (uint x) => x;
    assertNotThrown!Exception(errorCheck!uint_func(1));
    assertThrown!Exception(errorCheck!uint_func(0));
    assertNotThrown!Exception(errorCheck!uint_func(-1));
    assert(errorCheck!uint_func(1) == 1);

    static int y = 1;
    auto ptr_func = (bool x) => x ? &y : null;
    assertNotThrown!Exception(errorCheck!ptr_func(true));
    assertThrown!Exception(errorCheck!ptr_func(false));
    assert(*errorCheck!ptr_func(true) == 1);

    alias func_type = int function (int);
    auto func_func = (func_type x) => x;
    assertNotThrown!Exception(errorCheck!func_func((x) => x));
    assertThrown!Exception(errorCheck!func_func(null));
    assert(errorCheck!func_func((x) => x)(42) == 42);

    auto other_func = () => "foo";
    assertNotThrown!Exception(errorCheck!other_func());
    assert(errorCheck!other_func() == "foo");

    auto callback_always = () => new Exception("foo");
    assertThrown!Exception(errorCheck!(int_func, callback_always)(-1));
    assertNotThrown!Exception(errorCheck!(int_func, callback_always)(0));
    assert(errorCheck!(int_func, callback_always)(0) == 0);

    auto callback_never = () => cast(Exception) null;
    assertNotThrown!Exception(errorCheck!(int_func, callback_never)(-1));
    assertNotThrown!Exception(errorCheck!(int_func, callback_never)(0));
    assert(errorCheck!(int_func, callback_never)(0) == 0);
}

