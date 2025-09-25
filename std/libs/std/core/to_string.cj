







package std.core





public interface ToString {
    /*
     * @noThrow
     */
    func toString(): String
}

extend Int64 <: ToString {
    @OverflowWrapping
    /*
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    public func toString(): String {
        let (numLen, unum, buffer) = if (this < 0) {
            let unum = UInt64(-this)
            let numLen = 1 + calcNumLen(unum)
            let buffer = Array<Byte>(numLen, repeat: 0)
            buffer[0] = b'-'
            (numLen, unum, buffer)
        } else {
            let numLen = calcNumLen(UInt64(this))
            (numLen, UInt64(this), Array<Byte>(numLen, repeat: 0))
        }
        numberToString(unum, numLen, buffer)
        return String(buffer)
    }
}

extend IntNative <: ToString {
    @OverflowWrapping
    /*
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    public func toString(): String {
        return Int64(this).toString()
    }
}

extend Int32 <: ToString {
    /*
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    public func toString(): String {
        return Int64(this).toString()
    }
}

extend Int16 <: ToString {
    /*
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    public func toString(): String {
        return Int64(this).toString()
    }
}

extend Int8 <: ToString {
    /*
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    public func toString(): String {
        return Int64(this).toString()
    }
}

extend UInt64 <: ToString {
    /*
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    public func toString(): String {
        let numLen = calcNumLen(this)
        let buffer = Array<Byte>(numLen, repeat: 0)
        numberToString(this, numLen, buffer)
        return String(buffer)
    }
}

extend UIntNative <: ToString {
    @OverflowWrapping
    /*
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    public func toString(): String {
        return UInt64(this).toString()
    }
}

extend UInt32 <: ToString {
    /*
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    public func toString(): String {
        return UInt64(this).toString()
    }
}

extend UInt16 <: ToString {
    /*
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    public func toString(): String {
        return UInt64(this).toString()
    }
}

extend UInt8 <: ToString {
    /*
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    public func toString(): String {
        return UInt64(this).toString()
    }
}

extend Float64 <: ToString {
    /*
     * @throws IllegalArgumentException
     */
    public func toString(): String {
        let p: CPointer<UInt8> = unsafe { CJ_CORE_Float64ToCPointer(this) }
        if (p.isNull()) {
            return String()
        }
        let s: String = unsafe { createStrFromCPointer(p) }
        unsafe { LibC.free(p) }
        return s
    }
}

extend Float32 <: ToString {
    /*
     * @throws IllegalArgumentException
     */
    public func toString(): String {
        return Float64(this).toString()
    }
}

extend Float16 <: ToString {
    /*
     * @throws IllegalArgumentException
     */
    public func toString(): String {
        return Float64(this).toString()
    }
}

extend Bool <: ToString {
    /*
     * @noThrow
     */
    public func toString(): String {
        return if (this) {
            "true"
        } else {
            "false"
        }
    }
}

extend Rune <: ToString {
    /*
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    public func toString(): String {
        return String([this])
    }
}

extend Unit <: ToString {
    /*
     * @noThrow
     */
    public func toString(): String {
        return "()"
    }
}
