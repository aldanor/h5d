module hdf5.exception;

import std.traits       : ParameterTypeTuple, ReturnType, isIntegral, isSigned;
import std.exception    : assertThrown, assertNotThrown, enforceEx;
import std.string       : fromStringz, format;
import std.conv         : to;

import hdf5.api;

shared static this() {
    version (unittest) {
        // Disable error message printing when running unit tests
        H5Eset_auto2(H5E_DEFAULT, null, null);
    }
}

private bool maybeError(T)(T v) {
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

package auto errorCheck(alias func, alias callback = null)(ParameterTypeTuple!(func) args,
                                                           string __file__ = __FILE__,
                                                           size_t __line__ = __LINE__) {
    static if (is(ReturnType!(func) == void))
        func(args);
    else {
        auto result = func(args);
        if (maybeError(result)) {
            static if (is(typeof(callback) == typeof(null)))
                auto exc = new Exception("error", __file__, __line__);
            else {
                auto exc = callback();
                if (exc is null)
                    return result;
            }
            exc.file = __file__;
            exc.line = __line__;
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

    try errorCheck!(int_func, callback_always)(-1);
    catch (Exception exc) {
        assert(exc.file == __FILE__);
        assert(exc.line == __LINE__ - 3);
    }
}

public enum H5E_NOT_SET = -1;

public struct H5ErrorData {
    herr_t major;
    herr_t minor;
    string desc;
    string func_name;
}

struct H5ErrorStack {
    H5ErrorData[] stack;
    alias stack this;

nothrow:
    void push(H5ErrorData err){
        stack ~= err;
    }

    string toString() const{
        if (length == 0)
            return "<unknown>";
        auto msg = "\"" ~ stack[0].desc ~ "\" in " ~ stack[0].func_name ~ "()";
        if (length > 1)
            msg ~= " [\"" ~ stack[$ - 1].desc ~ "\" in " ~ stack[$ - 1].func_name ~ "()]";
        return msg;
    }

    static extern (C) herr_t walk_cb(uint err_stack, const H5E_error2_t *eptr, void *data) {
        if (err_stack >= 0) {
            auto stack = cast(H5ErrorStack*) data;
            stack.push(H5ErrorData(eptr.maj_num, eptr.min_num,
                                   eptr.desc.to!string, eptr.func_name.to!string));
        }
        return 0;
    }
}

public class H5Exception : Exception {
    H5ErrorStack stack;

    public nothrow {
        this(string msg = null, Throwable next = null) {
            super(msg, next);
        }
        this(string msg, string file, size_t line, Throwable next = null) {
            super(msg, file, line, next);
        }
        this(H5ErrorStack stack, Throwable next = null) {
            super(stack.to!string, next);
            this.stack = stack;
        }
        this(H5ErrorStack stack, string file, size_t line, Throwable next = null) {
            super(stack.to!string, file, line, next);
            this.stack = stack;
        }
    }

    public const @property nothrow {
        herr_t major() {
            return stack.length > 0 ? stack[0].major : H5E_NOT_SET;
        }

        herr_t minor() {
            return stack.length > 0 ? stack[0].minor : H5E_NOT_SET;
        }

        string desc() {
            return stack.length > 0 ? stack[0].desc : "<unknown>";
        }

        string func_name() {
            return stack.length > 0 ? stack[0].func_name : "<unknown>";
        }
    }

    public static H5Exception check() nothrow {
        H5ErrorStack stack;

        if (H5Ewalk2(H5E_DEFAULT, H5E_WALK_UPWARD, &H5ErrorStack.walk_cb, cast(void*) &stack) < 0)
            return new H5Exception("ERROR: Failed to walk the error stack.");

        return stack.length > 0 ? new H5Exception(stack) : null;
    }
}

unittest {
    assert(H5Iget_ref(-1) < 0);
    try {
        D_H5Iget_ref(-1);
    }
    catch (H5Exception exc) {
        auto err = exc.stack[0];
        assert(err.major == H5E_ATOM);
        assert(err.minor == H5E_BADATOM);
        assert(err.desc == "invalid ID");
        assert(err.func_name == "H5Iget_ref");

        assert(exc.major == H5E_ATOM);
        assert(exc.minor == H5E_BADATOM);
        assert(exc.desc == "invalid ID");
        assert(exc.func_name == "H5Iget_ref");

        assert(exc.msg == "\"invalid ID\" in H5Iget_ref()");
    }

    auto exc = new H5Exception(cast(H5ErrorStack) []);
    assert(exc.major == H5E_NOT_SET);
    assert(exc.minor == H5E_NOT_SET);
    assert(exc.desc == "<unknown>");
    assert(exc.func_name == "<unknown>");
    assert(exc.msg == "<unknown>");

    exc = new H5Exception("foo");
    assert(exc.major == H5E_NOT_SET);
    assert(exc.minor == H5E_NOT_SET);
    assert(exc.desc == "<unknown>");
    assert(exc.func_name == "<unknown>");
    assert(exc.msg == "foo");
}

public alias errorCheckH5(alias func) = errorCheck!(func, H5Exception.check);

public void enforceH5(T, Args...)(T value, lazy string msg, Args args) {
    enforceEx!H5Exception(value, msg.format(args));
}

unittest {
    enforceH5(1 == 1, "foo");
    try
        enforceH5(0 == 1, "bar %s", "baz");
    catch (H5Exception exc)
        assert(exc.msg == "bar baz");
}

public void throwH5(Args...)(lazy string msg, Args args) {
    throw new H5Exception(msg.format(args));
}

unittest {
    try
        throwH5("1 %d", 2);
    catch (H5Exception exc)
        assert(exc.msg == "1 2");
}
