










package std.math

extend Float64 <: MathExtension<Float64> {
    @Deprecated[message: "Use `public func getPI()` instead."]
    /*
     * @noThrow
     */
    public static func GetPI(): Float64 {
        return 3.141592653589793
    }

    @Deprecated[message: "Use `public func getE()` instead."]
    /*
     * @noThrow
     */
    public static func GetE(): Float64 {
        return 2.718281828459045
    }
}

extend Float32 <: MathExtension<Float32> {
    @Deprecated[message: "Use `public func getPI()` instead."]
    /*
     * @noThrow
     */
    public static func GetPI(): Float32 {
        return 3.1415927
    }

    @Deprecated[message: "Use `public func getE()` instead."]
    /*
     * @noThrow
     */
    public static func GetE(): Float32 {
        return 2.7182817
    }
}

extend Float16 <: MathExtension<Float16> {
    @Deprecated[message: "Use `public func getPI()` instead."]
    /*
     * @noThrow
     */
    public static func GetPI(): Float16 {
        return 3.140625
    }

    @Deprecated[message: "Use `public func getE()` instead."]
    /*
     * @noThrow
     */
    public static func GetE(): Float16 {
        return 2.718750
    }
}



extend Int8 <: MaxMinValue<Int8> {
    /*
     * @noThrow
     */
    public static func getMax(): Int8 {
        Int8.Max
    }
    /*
     * @noThrow
     */
    public static func getMin(): Int8 {
        Int8.Min
    }
}

extend Int16 <: MaxMinValue<Int16> {
    /*
     * @noThrow
     */
    public static func getMax(): Int16 {
        Int16.Max
    }
    /*
     * @noThrow
     */
    public static func getMin(): Int16 {
        Int16.Min
    }
}

extend Int32 <: MaxMinValue<Int32> {
    /*
     * @noThrow
     */
    public static func getMax(): Int32 {
        Int32.Max
    }
    /*
     * @noThrow
     */
    public static func getMin(): Int32 {
        Int32.Min
    }
}

extend Int64 <: MaxMinValue<Int64> {
    /*
     * @noThrow
     */
    public static func getMax(): Int64 {
        Int64.Max
    }
    /*
     * @noThrow
     */
    public static func getMin(): Int64 {
        Int64.Min
    }
}

extend IntNative <: MaxMinValue<IntNative> {
    /*
     * @noThrow
     */
    public static func getMax(): IntNative {
        IntNative.Max
    }
    /*
     * @noThrow
     */
    public static func getMin(): IntNative {
        IntNative.Min
    }
}

extend UInt8 <: MaxMinValue<UInt8> {
    /*
     * @noThrow
     */
    public static func getMax(): UInt8 {
        UInt8.Max
    }
    /*
     * @noThrow
     */
    public static func getMin(): UInt8 {
        UInt8.Min
    }
}

extend UInt16 <: MaxMinValue<UInt16> {
    /*
     * @noThrow
     */
    public static func getMax(): UInt16 {
        UInt16.Max
    }
    /*
     * @noThrow
     */
    public static func getMin(): UInt16 {
        UInt16.Min
    }
}

extend UInt32 <: MaxMinValue<UInt32> {
    /*
     * @noThrow
     */
    public static func getMax(): UInt32 {
        UInt32.Max
    }
    /*
     * @noThrow
     */
    public static func getMin(): UInt32 {
        UInt32.Min
    }
}

extend UInt64 <: MaxMinValue<UInt64> {
    /*
     * @noThrow
     */
    public static func getMax(): UInt64 {
        UInt64.Max
    }
    /*
     * @noThrow
     */
    public static func getMin(): UInt64 {
        UInt64.Min
    }
}

extend UIntNative <: MaxMinValue<UIntNative> {
    /*
     * @noThrow
     */
    public static func getMax(): UIntNative {
        UIntNative.Max
    }
    /*
     * @noThrow
     */
    public static func getMin(): UIntNative {
        UIntNative.Min
    }
}

extend Float16 <: MaxMinValue<Float16> {
    /*
     * @noThrow
     */
    public static func getMax(): Float16 {
        Float16.Max
    }
    /*
     * @noThrow
     */
    public static func getMin(): Float16 {
        Float16.Min
    }
}

extend Float32 <: MaxMinValue<Float32> {
    /*
     * @noThrow
     */
    public static func getMax(): Float32 {
        Float32.Max
    }
    /*
     * @noThrow
     */
    public static func getMin(): Float32 {
        Float32.Min
    }
}

extend Float64 <: MaxMinValue<Float64> {
    /*
     * @noThrow
     */
    public static func getMax(): Float64 {
        Float64.Max
    }
    /*
     * @noThrow
     */
    public static func getMin(): Float64 {
        Float64.Min
    }
}



/*
 * @noThrow
 */
/*
 * @noThrow
 */
/*
 * @noThrow
 */
/*
 * @noThrow
 */
/*
 * @noThrow
 */
extend Int8 <: Number<Int8> {}

/*
 * @noThrow
 */
/*
 * @noThrow
 */
/*
 * @noThrow
 */
/*
 * @noThrow
 */
/*
 * @noThrow
 */
extend Int16 <: Number<Int16> {}

/*
 * @noThrow
 */
/*
 * @noThrow
 */
/*
 * @noThrow
 */
/*
 * @noThrow
 */
/*
 * @noThrow
 */
extend Int32 <: Number<Int32> {}

/*
 * @noThrow
 */
/*
 * @noThrow
 */
/*
 * @noThrow
 */
/*
 * @noThrow
 */
/*
 * @noThrow
 */
extend Int64 <: Number<Int64> {}

/*
 * @noThrow
 */
/*
 * @noThrow
 */
/*
 * @noThrow
 */
/*
 * @noThrow
 */
/*
 * @noThrow
 */
extend IntNative <: Number<IntNative> {}

/*
 * @noThrow
 */
/*
 * @noThrow
 */
/*
 * @noThrow
 */
/*
 * @noThrow
 */
/*
 * @noThrow
 */
extend UInt8 <: Number<UInt8> {}

/*
 * @noThrow
 */
/*
 * @noThrow
 */
/*
 * @noThrow
 */
/*
 * @noThrow
 */
/*
 * @noThrow
 */
extend UInt16 <: Number<UInt16> {}

/*
 * @noThrow
 */
/*
 * @noThrow
 */
/*
 * @noThrow
 */
/*
 * @noThrow
 */
/*
 * @noThrow
 */
extend UInt32 <: Number<UInt32> {}

/*
 * @noThrow
 */
/*
 * @noThrow
 */
/*
 * @noThrow
 */
/*
 * @noThrow
 */
/*
 * @noThrow
 */
extend UInt64 <: Number<UInt64> {}

/*
 * @noThrow
 */
/*
 * @noThrow
 */
/*
 * @noThrow
 */
/*
 * @noThrow
 */
/*
 * @noThrow
 */
extend UIntNative <: Number<UIntNative> {}

/*
 * @noThrow
 */
/*
 * @noThrow
 */
/*
 * @noThrow
 */
/*
 * @noThrow
 */
/*
 * @noThrow
 */
extend Float16 <: Number<Float16> {}

/*
 * @noThrow
 */
/*
 * @noThrow
 */
/*
 * @noThrow
 */
/*
 * @noThrow
 */
/*
 * @noThrow
 */
extend Float32 <: Number<Float32> {}

/*
 * @noThrow
 */
/*
 * @noThrow
 */
/*
 * @noThrow
 */
/*
 * @noThrow
 */
/*
 * @noThrow
 */
extend Float64 <: Number<Float64> {}



/*
 * @noThrow
 */
/*
 * @noThrow
 */
/*
 * @noThrow
 */
/*
 * @noThrow
 */
/*
 * @noThrow
 */
/*
 * @noThrow
 */
/*
 * @noThrow
 */
extend Int8 <: Integer<Int8> {
    /*
     * @noThrow
     */
    public static func isSigned(): Bool {
        true
    }
}

/*
 * @noThrow
 */
/*
 * @noThrow
 */
/*
 * @noThrow
 */
/*
 * @noThrow
 */
/*
 * @noThrow
 */
/*
 * @noThrow
 */
/*
 * @noThrow
 */
extend Int16 <: Integer<Int16> {
    /*
     * @noThrow
     */
    public static func isSigned(): Bool {
        true
    }
}

/*
 * @noThrow
 */
/*
 * @noThrow
 */
/*
 * @noThrow
 */
/*
 * @noThrow
 */
/*
 * @noThrow
 */
/*
 * @noThrow
 */
/*
 * @noThrow
 */
extend Int32 <: Integer<Int32> {
    /*
     * @noThrow
     */
    public static func isSigned(): Bool {
        true
    }
}

/*
 * @noThrow
 */
/*
 * @noThrow
 */
/*
 * @noThrow
 */
/*
 * @noThrow
 */
/*
 * @noThrow
 */
/*
 * @noThrow
 */
/*
 * @noThrow
 */
extend Int64 <: Integer<Int64> {
    /*
     * @noThrow
     */
    public static func isSigned(): Bool {
        true
    }
}

/*
 * @noThrow
 */
/*
 * @noThrow
 */
/*
 * @noThrow
 */
/*
 * @noThrow
 */
/*
 * @noThrow
 */
/*
 * @noThrow
 */
/*
 * @noThrow
 */
extend IntNative <: Integer<IntNative> {
    /*
     * @noThrow
     */
    public static func isSigned(): Bool {
        true
    }
}

/*
 * @noThrow
 */
/*
 * @noThrow
 */
/*
 * @noThrow
 */
/*
 * @noThrow
 */
/*
 * @noThrow
 */
/*
 * @noThrow
 */
/*
 * @noThrow
 */
extend UInt8 <: Integer<UInt8> {
    /*
     * @noThrow
     */
    public static func isSigned(): Bool {
        false
    }
}

/*
 * @noThrow
 */
/*
 * @noThrow
 */
/*
 * @noThrow
 */
/*
 * @noThrow
 */
/*
 * @noThrow
 */
/*
 * @noThrow
 */
/*
 * @noThrow
 */
extend UInt16 <: Integer<UInt16> {
    /*
     * @noThrow
     */
    public static func isSigned(): Bool {
        false
    }
}

/*
 * @noThrow
 */
/*
 * @noThrow
 */
/*
 * @noThrow
 */
/*
 * @noThrow
 */
/*
 * @noThrow
 */
/*
 * @noThrow
 */
/*
 * @noThrow
 */
extend UInt32 <: Integer<UInt32> {
    /*
     * @noThrow
     */
    public static func isSigned(): Bool {
        false
    }
}

/*
 * @noThrow
 */
/*
 * @noThrow
 */
/*
 * @noThrow
 */
/*
 * @noThrow
 */
/*
 * @noThrow
 */
/*
 * @noThrow
 */
/*
 * @noThrow
 */
extend UInt64 <: Integer<UInt64> {
    /*
     * @noThrow
     */
    public static func isSigned(): Bool {
        false
    }
}

/*
 * @noThrow
 */
/*
 * @noThrow
 */
/*
 * @noThrow
 */
/*
 * @noThrow
 */
/*
 * @noThrow
 */
/*
 * @noThrow
 */
/*
 * @noThrow
 */
extend UIntNative <: Integer<UIntNative> {
    /*
     * @noThrow
     */
    public static func isSigned(): Bool {
        false
    }
}



extend Float16 <: FloatingPoint<Float16> {
    /*
     * @noThrow
     */
    public static func getPI(): Float16 {
        3.140625
    }
    /*
     * @noThrow
     */
    public static func getE(): Float16 {
        2.718750
    }
    /*
     * @noThrow
     */
    public static func getNaN(): Float16 {
        Float16.NaN
    }
    /*
     * @noThrow
     */
    public static func getInf(): Float16 {
        Float16.Inf
    }
    /*
     * @noThrow
     */
    public static func getMinDenormal(): Float16 {
        Float16.MinDenormal
    }
    /*
     * @noThrow
     */
    public static func getMinNormal(): Float16 {
        Float16.MinNormal
    }
}

extend Float32 <: FloatingPoint<Float32> {
    /*
     * @noThrow
     */
    public static func getPI(): Float32 {
        3.1415927
    }
    /*
     * @noThrow
     */
    public static func getE(): Float32 {
        2.7182817
    }
    /*
     * @noThrow
     */
    public static func getNaN(): Float32 {
        Float32.NaN
    }
    /*
     * @noThrow
     */
    public static func getInf(): Float32 {
        Float32.Inf
    }
    /*
     * @noThrow
     */
    public static func getMinDenormal(): Float32 {
        Float32.MinDenormal
    }
    /*
     * @noThrow
     */
    public static func getMinNormal(): Float32 {
        Float32.MinNormal
    }
}

extend Float64 <: FloatingPoint<Float64> {
    /*
     * @noThrow
     */
    public static func getPI(): Float64 {
        3.141592653589793
    }
    /*
     * @noThrow
     */
    public static func getE(): Float64 {
        2.718281828459045
    }
    /*
     * @noThrow
     */
    public static func getNaN(): Float64 {
        Float64.NaN
    }
    /*
     * @noThrow
     */
    public static func getInf(): Float64 {
        Float64.Inf
    }
    /*
     * @noThrow
     */
    public static func getMinDenormal(): Float64 {
        Float64.MinDenormal
    }
    /*
     * @noThrow
     */
    public static func getMinNormal(): Float64 {
        Float64.MinNormal
    }
}
