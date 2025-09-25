










package std.math












@Frozen
public func abs(x: Float64): Float64 {
    intrinsicFabs<Float64>(x)
}












@Frozen
public func abs(x: Float32): Float32 {
    intrinsicFabs<Float32>(x)
}












@Frozen
public func abs(x: Float16): Float16 {
    intrinsicFabs<Float16>(x)
}













@Frozen
public func abs(x: Int64): Int64 {
    if (x == Int64.Min) {
        throw OverflowException("The absolute value of the minimum Int64 value is out of range.")
    }
    intrinsicAbs<Int64>(x)
}













@Frozen
public func abs(x: Int32): Int32 {
    if (x == Int32.Min) {
        throw OverflowException("The absolute value of the minimum Int32 value is out of range.")
    }
    intrinsicAbs<Int32>(x)
}













@Frozen
public func abs(x: Int16): Int16 {
    if (x == Int16.Min) {
        throw OverflowException("The absolute value of the minimum Int16 value is out of range.")
    }
    intrinsicAbs<Int16>(x)
}













@Frozen
public func abs(x: Int8): Int8 {
    if (x == Int8.Min) {
        throw OverflowException("The absolute value of the minimum Int8 value is out of range.")
    }
    intrinsicAbs<Int8>(x)
}















@Frozen
public func sqrt(x: Float16): Float16 {
    if (x < 0.0) {
        throw IllegalArgumentException(
            "The input parameter must be greater than or equal to 0.0. Please enter a correct parameter.")
    }
    return intrinsicSqrt<Float16>(x)
}















@Frozen
public func sqrt(x: Float32): Float32 {
    if (x < 0.0) {
        throw IllegalArgumentException(
            "The input parameter must be greater than or equal to 0.0. Please enter a correct parameter.")
    }
    return intrinsicSqrt<Float32>(x)
}















@Frozen
public func sqrt(x: Float64): Float64 {
    if (x < 0.0) {
        throw IllegalArgumentException(
            "The input parameter must be greater than or equal to 0.0. Please enter a correct parameter.")
    }
    return intrinsicSqrt<Float64>(x)
}












@Frozen
public func exp(x: Float64): Float64 {
    return intrinsicExp<Float64>(x)
}












@Frozen
public func exp(x: Float32): Float32 {
    return intrinsicExp<Float32>(x)
}












@Frozen
public func exp(x: Float16): Float16 {
    return intrinsicExp<Float16>(x)
}












@Frozen
public func exp2(x: Float64): Float64 {
    return intrinsicExp2<Float64>(x)
}












@Frozen
public func exp2(x: Float32): Float32 {
    return intrinsicExp2<Float32>(x)
}












@Frozen
public func exp2(x: Float16): Float16 {
    return intrinsicExp2<Float16>(x)
}














@Frozen
public func log10(x: Float64): Float64 {
    return intrinsicLog10<Float64>(x)
}














@Frozen
public func log10(x: Float32): Float32 {
    return intrinsicLog10<Float32>(x)
}














@Frozen
public func log10(x: Float16): Float16 {
    return intrinsicLog10<Float16>(x)
}














@Frozen
public func log2(x: Float64): Float64 {
    return intrinsicLog2<Float64>(x)
}














@Frozen
public func log2(x: Float32): Float32 {
    return intrinsicLog2<Float32>(x)
}














@Frozen
public func log2(x: Float16): Float16 {
    return intrinsicLog2<Float16>(x)
}













@Frozen
public func log(x: Float64): Float64 {
    return intrinsicLog<Float64>(x)
}













@Frozen
public func log(x: Float32): Float32 {
    return intrinsicLog<Float32>(x)
}













@Frozen
public func log(x: Float16): Float16 {
    return intrinsicLog<Float16>(x)
}









@Frozen
public func floor(x: Float64): Float64 {
    return intrinsicFloor<Float64>(x)
}









@Frozen
public func floor(x: Float32): Float32 {
    return intrinsicFloor<Float32>(x)
}









@Frozen
public func floor(x: Float16): Float16 {
    intrinsicFloor(x)
}









@Frozen
public func ceil(x: Float64): Float64 {
    return intrinsicCeil(x)
}









@Frozen
public func ceil(x: Float32): Float32 {
    return intrinsicCeil(x)
}









@Frozen
public func ceil(x: Float16): Float16 {
    return intrinsicCeil(x)
}







@Frozen
public func trunc(x: Float64): Float64 {
    return intrinsicTrunc(x)
}







@Frozen
public func trunc(x: Float32): Float32 {
    return intrinsicTrunc(x)
}







@Frozen
public func trunc(x: Float16): Float16 {
    return intrinsicTrunc(x)
}







@Frozen
public func sin(x: Float64): Float64 {
    return intrinsicSin<Float64>(x)
}







@Frozen
public func sin(x: Float32): Float32 {
    return intrinsicSin<Float32>(x)
}







@Frozen
public func sin(x: Float16): Float16 {
    return intrinsicSin<Float16>(x)
}







@Frozen
public func cos(x: Float64): Float64 {
    return intrinsicCos<Float64>(x)
}







@Frozen
public func cos(x: Float32): Float32 {
    return intrinsicCos<Float32>(x)
}







@Frozen
public func cos(x: Float16): Float16 {
    return intrinsicCos<Float16>(x)
}







@Frozen
public func pow(base: Float64, exponent: Float64): Float64 {
    return intrinsicPow<Float64>(base, exponent)
}







@Frozen
public func pow(base: Float32, exponent: Float32): Float32 {
    return intrinsicPow<Float32>(base, exponent)
}








@Frozen
public func pow(base: Float64, exponent: Int64): Float64 {
    unsafe { return CJ_CORE_FastPowerDoubleInt64(base, exponent) }
}







@Frozen
public func pow(base: Float32, exponent: Int32): Float32 {
    return intrinsicPowi(base, exponent)
}
