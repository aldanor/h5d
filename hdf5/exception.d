module hdf5.exception;

import std.traits       : ParameterTypeTuple, ReturnType, isIntegral, isSigned;
import std.exception    : assertThrown, assertNotThrown;
import std.string       : fromStringz;
import std.conv         : to;

import hdf5.api;

shared static this() {
    version (unittest) {
        // Disable error message printing when running unit tests
        H5Eset_auto2(H5E_DEFAULT, null, null);
    }
}

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
{
    static if (is(ReturnType!(func) == void))
        func(args);
    else {
        auto result = func(args);
        if (maybeError(result)) {
            static if (is(typeof(callback) == typeof(null)))
                auto exc = "not valid";
            else {
                auto exc = callback();
                if (exc is null)
                    return result;
            }
            throw new Exception(exc);
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

    auto callback_always = () => "foo";
    assertThrown!Exception(errorCheck!(int_func, callback_always)(-1));
    assertNotThrown!Exception(errorCheck!(int_func, callback_always)(0));
    assert(errorCheck!(int_func, callback_always)(0) == 0);

    auto callback_never = () => cast(string) null;
    assertNotThrown!Exception(errorCheck!(int_func, callback_never)(-1));
    assertNotThrown!Exception(errorCheck!(int_func, callback_never)(0));
    assert(errorCheck!(int_func, callback_never)(0) == 0);
}

private struct error_data_t {
    H5E_error2_t *err;
    uint err_stack;
    const nothrow @property {
        string desc() { return err.desc.to!string; }
        string func_name() { return err.func_name.to!string; }
    }
}

extern (C) herr_t walk_cb(uint err_stack, const H5E_error2_t *eptr, void *data) nothrow {
    auto error_data = cast(error_data_t*) data;
    error_data.err_stack = err_stack;
    H5E_error2_t err = *eptr;
    error_data.err = &err;
    return 0;
}

class H5Exception(Exception) {
}

string checkH5Exception() nothrow {
    error_data_t err_top, err_bottom;

    if (H5Ewalk2(H5E_DEFAULT, H5E_WALK_UPWARD, &walk_cb, cast(void *) &err_top) < 0)
        return "Failed to walk the error stack upwards.";
    if (err_top.err_stack < 0)
        return null;
    if (err_top.err.desc is null)
        return "Failed to extract top-level error description.";

    if (H5Ewalk2(H5E_DEFAULT, H5E_WALK_DOWNWARD, &walk_cb, cast(void *) &err_bottom) < 0)
        return "Failed to walk the error stack downwards.";
    if (err_bottom.err_stack < 0)
        return null;
    if (err_bottom.err.desc is null)
        return "Failed to extract bottom-level error description.";

    string msg = err_top.desc ~ " in " ~ err_top.func_name ~ "()";
    if (*err_top.err != *err_bottom.err)
        msg ~= "[" ~ err_bottom.desc ~ " in " ~ err_bottom.func_name ~ "()]";
    return msg;
}

unittest {
    assert(H5Iget_ref(-1) < 0);
    try {
        D_H5Iget_ref(-1);
    }
    catch (Exception e) {
        assert(e.msg == "invalid ID in H5Iget_ref()");
    }
}

alias errorCheckH5(alias func) = errorCheck!(func, checkH5Exception);
