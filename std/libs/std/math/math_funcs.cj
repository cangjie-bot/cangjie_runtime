










package std.math














public func cbrt(x: Float64): Float64 {
    unsafe { return CJ_MATH_Cbrt(x) }
}














public func cbrt(x: Float32): Float32 {
    unsafe { return CJ_MATH_Cbrtf(x) }
}














public func cbrt(x: Float16): Float16 {
    unsafe { return Float16(CJ_MATH_Cbrt(Float64(x))) }
}



















/**
 * @throws IllegalArgumentException
 */
public func logBase(x: Float32, base: Float32): Float32 {
    if (x <= 0.0 || base <= 0.0 || isEqual(base, 1.0)) {
        throw IllegalArgumentException("The input parameter is invalid. Please enter a correct parameter.")
    }
    unsafe { return log(x) / log(base) }
}



















/**
 * @throws IllegalArgumentException
 */
public func logBase(x: Float64, base: Float64): Float64 {
    if (x <= 0.0 || base <= 0.0 || isEqual(base, 1.0)) {
        throw IllegalArgumentException("The input parameter is invalid. Please enter a correct parameter.")
    }
    return unsafe { log(x) / log(base) }
}



















/**
 * @throws IllegalArgumentException
 */
public func logBase(x: Float16, base: Float16): Float16 {
    if (x <= 0.0 || base <= 0.0 || isEqual(base, 1.0)) {
        throw IllegalArgumentException("The input parameter is invalid. Please enter a correct parameter.")
    }
    unsafe { return log(x) / log(base) }
}







public func gamma(x: Float64): Float64 {
    unsafe { return CJ_MATH_Tgamma(x) }
}







public func gamma(x: Float32): Float32 {
    unsafe { return CJ_MATH_Tgammaf(x) }
}







public func gamma(x: Float16): Float16 {
    unsafe { return Float16(CJ_MATH_Tgamma(Float64(x))) }
}








public func erf(x: Float64): Float64 {
    unsafe { return CJ_MATH_Erf(x) }
}








public func erf(x: Float32): Float32 {
    unsafe { return CJ_MATH_Erff(x) }
}








public func erf(x: Float16): Float16 {
    unsafe { return Float16(CJ_MATH_Erf(Float64(x))) }
}







public func tan(x: Float64): Float64 {
    unsafe { return CJ_MATH_Tan(x) }
}







public func tan(x: Float32): Float32 {
    unsafe { return CJ_MATH_Tanf(x) }
}







public func tan(x: Float16): Float16 {
    unsafe { return Float16(CJ_MATH_Tan(Float64(x))) }
}









/**
 * @throws IllegalArgumentException
 */
public func asin(x: Float64): Float64 {
    if (x > 1.0 || x < -1.0) {
        throw IllegalArgumentException("The input parameter is invalid. Please enter a correct parameter.")
    }
    unsafe { return CJ_MATH_Asin(x) }
}









/**
 * @throws IllegalArgumentException
 */
public func asin(x: Float32): Float32 {
    if (x > 1.0 || x < -1.0) {
        throw IllegalArgumentException("The input parameter is invalid. Please enter a correct parameter.")
    }
    unsafe { return CJ_MATH_Asinf(x) }
}









/**
 * @throws IllegalArgumentException
 */
public func asin(x: Float16): Float16 {
    if (x > 1.0 || x < -1.0) {
        throw IllegalArgumentException("The input parameter is invalid. Please enter a correct parameter.")
    }
    unsafe { return Float16(CJ_MATH_Asin(Float64(x))) }
}









/**
 * @throws IllegalArgumentException
 */
public func acos(x: Float64): Float64 {
    if (x > 1.0 || x < -1.0) {
        throw IllegalArgumentException("The input parameter is invalid. Please enter a correct parameter.")
    }
    unsafe { return CJ_MATH_Acos(x) }
}









/**
 * @throws IllegalArgumentException
 */
public func acos(x: Float32): Float32 {
    if (x > 1.0 || x < -1.0) {
        throw IllegalArgumentException("The input parameter is invalid. Please enter a correct parameter.")
    }
    unsafe { return CJ_MATH_Acosf(x) }
}









/**
 * @throws IllegalArgumentException
 */
public func acos(x: Float16): Float16 {
    if (x > 1.0 || x < -1.0) {
        throw IllegalArgumentException("The input parameter is invalid. Please enter a correct parameter.")
    }
    unsafe { return Float16(CJ_MATH_Acos(Float64(x))) }
}







public func atan(x: Float64): Float64 {
    unsafe { return CJ_MATH_Atan(x) }
}







public func atan(x: Float32): Float32 {
    unsafe { return CJ_MATH_Atanf(x) }
}







public func atan(x: Float16): Float16 {
    unsafe { return Float16(CJ_MATH_Atan(Float64(x))) }
}







public func sinh(x: Float64): Float64 {
    unsafe { return CJ_MATH_Sinh(x) }
}







public func sinh(x: Float32): Float32 {
    unsafe { return CJ_MATH_Sinhf(x) }
}







public func sinh(x: Float16): Float16 {
    unsafe { return Float16(CJ_MATH_Sinh(Float64(x))) }
}







public func cosh(x: Float64): Float64 {
    unsafe { return CJ_MATH_Cosh(x) }
}







public func cosh(x: Float32): Float32 {
    unsafe { return Float32(CJ_MATH_Cosh(Float64(x))) }
}







public func cosh(x: Float16): Float16 {
    unsafe { return Float16(CJ_MATH_Cosh(Float64(x))) }
}







public func tanh(x: Float64): Float64 {
    unsafe { return CJ_MATH_Tanh(x) }
}







public func tanh(x: Float32): Float32 {
    unsafe { return CJ_MATH_Tanhf(x) }
}







public func tanh(x: Float16): Float16 {
    unsafe { return Float16(CJ_MATH_Tanh(Float64(x))) }
}







public func asinh(x: Float64): Float64 {
    unsafe { return CJ_MATH_Asinh(x) }
}







public func asinh(x: Float32): Float32 {
    unsafe { return CJ_MATH_Asinhf(x) }
}







public func asinh(x: Float16): Float16 {
    unsafe { return Float16(CJ_MATH_Asinh(Float64(x))) }
}









/**
 * @throws IllegalArgumentException
 */
public func acosh(x: Float64): Float64 {
    if (x < 1.0) {
        throw IllegalArgumentException("The input parameter is invalid. Please enter a correct parameter.")
    }
    unsafe { return CJ_MATH_Acosh(x) }
}









/**
 * @throws IllegalArgumentException
 */
public func acosh(x: Float32): Float32 {
    if (x < 1.0) {
        throw IllegalArgumentException("The input parameter is invalid. Please enter a correct parameter.")
    }
    unsafe { return CJ_MATH_Acoshf(x) }
}









/**
 * @throws IllegalArgumentException
 */
public func acosh(x: Float16): Float16 {
    if (x < 1.0) {
        throw IllegalArgumentException("The input parameter is invalid. Please enter a correct parameter.")
    }
    unsafe { return Float16(CJ_MATH_Acosh(Float64(x))) }
}









/**
 * @throws IllegalArgumentException
 */
public func atanh(x: Float64): Float64 {
    if (x >= 1.0 || x <= -1.0) {
        throw IllegalArgumentException("The input parameter is invalid. Please enter a correct parameter.")
    }
    unsafe { return CJ_MATH_Atanh(x) }
}









/**
 * @throws IllegalArgumentException
 */
public func atanh(x: Float32): Float32 {
    if (x >= 1.0 || x <= -1.0) {
        throw IllegalArgumentException("The input parameter is invalid. Please enter a correct parameter.")
    }
    unsafe { return CJ_MATH_Atanhf(x) }
}









/**
 * @throws IllegalArgumentException
 */
public func atanh(x: Float16): Float16 {
    if (x >= 1.0 || x <= -1.0) {
        throw IllegalArgumentException("The input parameter is invalid. Please enter a correct parameter.")
    }
    unsafe { return Float16(CJ_MATH_Atanh(Float64(x))) }
}



var uint8len: Array<Int64> = [0x00, 0x01, 0x02, 0x02, 0x03, 0x03, 0x03, 0x03, 0x04, 0x04, 0x04, 0x04, 0x04, 0x04, 0x04,
    0x04, 0x05, 0x05, 0x05, 0x05, 0x05, 0x05, 0x05, 0x05, 0x05, 0x05, 0x05, 0x05, 0x05, 0x05, 0x05, 0x05, 0x06, 0x06,
    0x06, 0x06, 0x06, 0x06, 0x06, 0x06, 0x06, 0x06, 0x06, 0x06, 0x06, 0x06, 0x06, 0x06, 0x06, 0x06, 0x06, 0x06, 0x06,
    0x06, 0x06, 0x06, 0x06, 0x06, 0x06, 0x06, 0x06, 0x06, 0x06, 0x06, 0x07, 0x07, 0x07, 0x07, 0x07, 0x07, 0x07, 0x07,
    0x07, 0x07, 0x07, 0x07, 0x07, 0x07, 0x07, 0x07, 0x07, 0x07, 0x07, 0x07, 0x07, 0x07, 0x07, 0x07, 0x07, 0x07, 0x07,
    0x07, 0x07, 0x07, 0x07, 0x07, 0x07, 0x07, 0x07, 0x07, 0x07, 0x07, 0x07, 0x07, 0x07, 0x07, 0x07, 0x07, 0x07, 0x07,
    0x07, 0x07, 0x07, 0x07, 0x07, 0x07, 0x07, 0x07, 0x07, 0x07, 0x07, 0x07, 0x07, 0x07, 0x07, 0x07, 0x07, 0x07, 0x08,
    0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08,
    0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08,
    0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08,
    0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08,
    0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08,
    0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08,
    0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08]


var poptab: Array<Int64> = [0x00, 0x01, 0x01, 0x02, 0x01, 0x02, 0x02, 0x03, 0x01, 0x02, 0x02, 0x03, 0x02, 0x03, 0x03,
    0x04, 0x01, 0x02, 0x02, 0x03, 0x02, 0x03, 0x03, 0x04, 0x02, 0x03, 0x03, 0x04, 0x03, 0x04, 0x04, 0x05, 0x01, 0x02,
    0x02, 0x03, 0x02, 0x03, 0x03, 0x04, 0x02, 0x03, 0x03, 0x04, 0x03, 0x04, 0x04, 0x05, 0x02, 0x03, 0x03, 0x04, 0x03,
    0x04, 0x04, 0x05, 0x03, 0x04, 0x04, 0x05, 0x04, 0x05, 0x05, 0x06, 0x01, 0x02, 0x02, 0x03, 0x02, 0x03, 0x03, 0x04,
    0x02, 0x03, 0x03, 0x04, 0x03, 0x04, 0x04, 0x05, 0x02, 0x03, 0x03, 0x04, 0x03, 0x04, 0x04, 0x05, 0x03, 0x04, 0x04,
    0x05, 0x04, 0x05, 0x05, 0x06, 0x02, 0x03, 0x03, 0x04, 0x03, 0x04, 0x04, 0x05, 0x03, 0x04, 0x04, 0x05, 0x04, 0x05,
    0x05, 0x06, 0x03, 0x04, 0x04, 0x05, 0x04, 0x05, 0x05, 0x06, 0x04, 0x05, 0x05, 0x06, 0x05, 0x06, 0x06, 0x07, 0x01,
    0x02, 0x02, 0x03, 0x02, 0x03, 0x03, 0x04, 0x02, 0x03, 0x03, 0x04, 0x03, 0x04, 0x04, 0x05, 0x02, 0x03, 0x03, 0x04,
    0x03, 0x04, 0x04, 0x05, 0x03, 0x04, 0x04, 0x05, 0x04, 0x05, 0x05, 0x06, 0x02, 0x03, 0x03, 0x04, 0x03, 0x04, 0x04,
    0x05, 0x03, 0x04, 0x04, 0x05, 0x04, 0x05, 0x05, 0x06, 0x03, 0x04, 0x04, 0x05, 0x04, 0x05, 0x05, 0x06, 0x04, 0x05,
    0x05, 0x06, 0x05, 0x06, 0x06, 0x07, 0x02, 0x03, 0x03, 0x04, 0x03, 0x04, 0x04, 0x05, 0x03, 0x04, 0x04, 0x05, 0x04,
    0x05, 0x05, 0x06, 0x03, 0x04, 0x04, 0x05, 0x04, 0x05, 0x05, 0x06, 0x04, 0x05, 0x05, 0x06, 0x05, 0x06, 0x06, 0x07,
    0x03, 0x04, 0x04, 0x05, 0x04, 0x05, 0x05, 0x06, 0x04, 0x05, 0x05, 0x06, 0x05, 0x06, 0x06, 0x07, 0x04, 0x05, 0x05,
    0x06, 0x05, 0x06, 0x06, 0x07, 0x05, 0x06, 0x06, 0x07, 0x06, 0x07, 0x07, 0x08]


var revtab: Array<UInt8> = [0x00, 0x80, 0x40, 0xc0, 0x20, 0xa0, 0x60, 0xe0, 0x10, 0x90, 0x50, 0xd0, 0x30, 0xb0, 0x70,
    0xf0, 0x08, 0x88, 0x48, 0xc8, 0x28, 0xa8, 0x68, 0xe8, 0x18, 0x98, 0x58, 0xd8, 0x38, 0xb8, 0x78, 0xf8, 0x04, 0x84,
    0x44, 0xc4, 0x24, 0xa4, 0x64, 0xe4, 0x14, 0x94, 0x54, 0xd4, 0x34, 0xb4, 0x74, 0xf4, 0x0c, 0x8c, 0x4c, 0xcc, 0x2c,
    0xac, 0x6c, 0xec, 0x1c, 0x9c, 0x5c, 0xdc, 0x3c, 0xbc, 0x7c, 0xfc, 0x02, 0x82, 0x42, 0xc2, 0x22, 0xa2, 0x62, 0xe2,
    0x12, 0x92, 0x52, 0xd2, 0x32, 0xb2, 0x72, 0xf2, 0x0a, 0x8a, 0x4a, 0xca, 0x2a, 0xaa, 0x6a, 0xea, 0x1a, 0x9a, 0x5a,
    0xda, 0x3a, 0xba, 0x7a, 0xfa, 0x06, 0x86, 0x46, 0xc6, 0x26, 0xa6, 0x66, 0xe6, 0x16, 0x96, 0x56, 0xd6, 0x36, 0xb6,
    0x76, 0xf6, 0x0e, 0x8e, 0x4e, 0xce, 0x2e, 0xae, 0x6e, 0xee, 0x1e, 0x9e, 0x5e, 0xde, 0x3e, 0xbe, 0x7e, 0xfe, 0x01,
    0x81, 0x41, 0xc1, 0x21, 0xa1, 0x61, 0xe1, 0x11, 0x91, 0x51, 0xd1, 0x31, 0xb1, 0x71, 0xf1, 0x09, 0x89, 0x49, 0xc9,
    0x29, 0xa9, 0x69, 0xe9, 0x19, 0x99, 0x59, 0xd9, 0x39, 0xb9, 0x79, 0xf9, 0x05, 0x85, 0x45, 0xc5, 0x25, 0xa5, 0x65,
    0xe5, 0x15, 0x95, 0x55, 0xd5, 0x35, 0xb5, 0x75, 0xf5, 0x0d, 0x8d, 0x4d, 0xcd, 0x2d, 0xad, 0x6d, 0xed, 0x1d, 0x9d,
    0x5d, 0xdd, 0x3d, 0xbd, 0x7d, 0xfd, 0x03, 0x83, 0x43, 0xc3, 0x23, 0xa3, 0x63, 0xe3, 0x13, 0x93, 0x53, 0xd3, 0x33,
    0xb3, 0x73, 0xf3, 0x0b, 0x8b, 0x4b, 0xcb, 0x2b, 0xab, 0x6b, 0xeb, 0x1b, 0x9b, 0x5b, 0xdb, 0x3b, 0xbb, 0x7b, 0xfb,
    0x07, 0x87, 0x47, 0xc7, 0x27, 0xa7, 0x67, 0xe7, 0x17, 0x97, 0x57, 0xd7, 0x37, 0xb7, 0x77, 0xf7, 0x0f, 0x8f, 0x4f,
    0xcf, 0x2f, 0xaf, 0x6f, 0xef, 0x1f, 0x9f, 0x5f, 0xdf, 0x3f, 0xbf, 0x7f, 0xff]







/**
 * @throws IndexOutOfBoundsException
 */
public func leadingZeros(x: UInt64): Int64 {
    var n: Int64 = 0
    var xx = x
    if (xx > UInt64(UInt32.Max)) {
        n = n + 32
        xx = xx >> UInt64(32)
    }
    if (xx > UInt64(UInt16.Max)) {
        n = n + 16
        xx = xx >> UInt64(16)
    }
    if (xx > UInt64(UInt8.Max)) {
        n = n + 8
        xx = xx >> UInt64(8)
    }
    return 64 - n - uint8len[Int64(xx)]
}







/**
 * @throws IndexOutOfBoundsException
 */
public func leadingZeros(x: UInt32): Int64 {
    var n: Int64 = 0
    var xx = x
    if (xx > UInt32(UInt16.Max)) {
        n = n + 16
        xx = xx >> UInt32(16)
    }
    if (xx > UInt32(UInt8.Max)) {
        n = n + 8
        xx = xx >> UInt32(8)
    }
    return 32 - n - uint8len[Int64(xx)]
}







/**
 * @throws IndexOutOfBoundsException
 */
public func leadingZeros(x: UInt16): Int64 {
    var n: Int64 = 0
    var xx = x
    if (xx > UInt16(UInt8.Max)) {
        xx = xx >> UInt16(8)
        n = n + 8
    }
    return 16 - n - uint8len[Int64(xx)]
}







/**
 * @throws IndexOutOfBoundsException
 */
public func leadingZeros(x: UInt8): Int64 {
    return 8 - uint8len[Int64(x)]
}







/**
 * @throws IndexOutOfBoundsException
 */
@OverflowWrapping
public func leadingZeros(x: Int8): Int64 {
    return if (x >= 0) {
        leadingZeros(UInt8(x))
    } else if (x == Int8.Min) {
        0x0
    } else {
        leadingZeros(UInt8(-x) + UInt8(Int8.Min))
    }
}







/**
 * @throws IndexOutOfBoundsException
 */
@OverflowWrapping
public func leadingZeros(x: Int16): Int64 {
    return if (x >= 0) {
        leadingZeros(UInt16(x))
    } else if (x == Int16.Min) {
        0x0
    } else {
        leadingZeros(UInt16(-x) + UInt16(Int16.Min))
    }
}







/**
 * @throws IndexOutOfBoundsException
 */
@OverflowWrapping
public func leadingZeros(x: Int32): Int64 {
    return if (x >= 0) {
        leadingZeros(UInt32(x))
    } else if (x == Int32.Min) {
        0x0
    } else {
        leadingZeros(UInt32(-x) + UInt32(Int32.Min))
    }
}







/**
 * @throws IndexOutOfBoundsException
 */
@OverflowWrapping
public func leadingZeros(x: Int64): Int64 {
    return if (x >= 0) {
        leadingZeros(UInt64(x))
    } else if (x == Int64.Min) {
        0x0
    } else {
        leadingZeros(UInt64(-x) + UInt64(Int64.Min))
    }
}







public func trailingZeros(x: UInt64): Int64 {
    if (x == 0) {
        return 64
    }

    var t = x & (!x + 1)
    var count: Int64 = 0
    while (t > 1) {
        t = t / 2
        count = count + 1
    }

    return count
}







public func trailingZeros(x: UInt32): Int64 {
    if (x == 0) {
        return 32
    }

    return trailingZeros(UInt64(x))
}







public func trailingZeros(x: UInt16): Int64 {
    if (x == 0) {
        return 16
    }

    return trailingZeros(UInt64(x))
}







public func trailingZeros(x: UInt8): Int64 {
    if (x == 0) {
        return 8
    }

    return trailingZeros(UInt64(x))
}







@OverflowWrapping
public func trailingZeros(x: Int8): Int64 {
    return if (x >= 0) {
        trailingZeros(UInt8(x))
    } else if (x == Int8.Min) {
        0x7
    } else {
        trailingZeros(UInt8(-x) + UInt8(Int8.Min))
    }
}







@OverflowWrapping
public func trailingZeros(x: Int16): Int64 {
    return if (x >= 0) {
        trailingZeros(UInt16(x))
    } else if (x == Int16.Min) {
        0xF
    } else {
        trailingZeros(UInt16(-x) + UInt16(Int16.Min))
    }
}







@OverflowWrapping
public func trailingZeros(x: Int32): Int64 {
    return if (x >= 0) {
        trailingZeros(UInt32(x))
    } else if (x == Int32.Min) {
        0x1F
    } else {
        trailingZeros(UInt32(-x) + UInt32(Int32.Min))
    }
}







@OverflowWrapping
public func trailingZeros(x: Int64): Int64 {
    return if (x >= 0) {
        trailingZeros(UInt64(x))
    } else if (x == Int64.Min) {
        0x3F
    } else {
        trailingZeros(UInt64(-x) + UInt64(Int64.Min))
    }
}







/**
 * @throws IndexOutOfBoundsException
 */
public func countOnes(x: UInt64): Int64 {
    return countOnes(UInt32(x >> 32)) + countOnes(UInt32(x & 0xFFFFFFFF))
}







/**
 * @throws IndexOutOfBoundsException
 */
public func countOnes(x: UInt32): Int64 {
    return countOnes(UInt16(x >> 16)) + countOnes(UInt16(x & 0xFFFF))
}







/**
 * @throws IndexOutOfBoundsException
 */
public func countOnes(x: UInt16): Int64 {
    return poptab[Int64(x >> 8)] + poptab[Int64(x & 0xFF)]
}







/**
 * @throws IndexOutOfBoundsException
 */
public func countOnes(x: UInt8): Int64 {
    return poptab[Int64(x)]
}







/**
 * @throws IndexOutOfBoundsException
 */
@OverflowWrapping
public func countOnes(x: Int8): Int64 {
    return if (x >= 0) {
        countOnes(UInt8(x))
    } else if (x == Int8.Min) {
        0x1
    } else {
        countOnes(UInt8(-x) + UInt8(Int8.Min))
    }
}







/**
 * @throws IndexOutOfBoundsException
 */
@OverflowWrapping
public func countOnes(x: Int16): Int64 {
    return if (x >= 0) {
        countOnes(UInt16(x))
    } else if (x == Int16.Min) {
        0x1
    } else {
        countOnes(UInt16(-x) + UInt16(Int16.Min))
    }
}







/**
 * @throws IndexOutOfBoundsException
 */
@OverflowWrapping
public func countOnes(x: Int32): Int64 {
    return if (x >= 0) {
        countOnes(UInt32(x))
    } else if (x == Int32.Min) {
        0x1
    } else {
        countOnes(UInt32(-x) + UInt32(Int32.Min))
    }
}







/**
 * @throws IndexOutOfBoundsException
 */
@OverflowWrapping
public func countOnes(x: Int64): Int64 {
    return if (x >= 0) {
        countOnes(UInt64(x))
    } else if (x == Int64.Min) {
        0x1
    } else {
        countOnes(UInt64(-x) + UInt64(Int64.Min))
    }
}

/**
 * @throws IndexOutOfBoundsException
 */
@Deprecated[message: "Use global funtion `public func countOnes(x: Int8): Int64` instead."]
public func countOne(x: Int8): Int8 {
    Int8(countOnes(x))
}

/**
 * @throws IndexOutOfBoundsException
 */
@Deprecated[message: "Use global funtion `public func countOnes(x: Int16): Int64` instead."]
public func countOne(x: Int16): Int8 {
    Int8(countOnes(x))
}

/**
 * @throws IndexOutOfBoundsException
 */
@Deprecated[message: "Use global funtion `public func countOnes(x: Int32): Int64` instead."]
public func countOne(x: Int32): Int8 {
    Int8(countOnes(x))
}

/**
 * @throws IndexOutOfBoundsException
 */
@Deprecated[message: "Use global funtion `public func countOnes(x: Int64): Int64` instead."]
public func countOne(x: Int64): Int8 {
    Int8(countOnes(x))
}

/**
 * @throws IndexOutOfBoundsException
 */
@Deprecated[message: "Use global funtion `public func countOnes(x: UInt8): Int64` instead."]
public func countOne(x: UInt8): Int8 {
    Int8(countOnes(x))
}

/**
 * @throws IndexOutOfBoundsException
 */
@Deprecated[message: "Use global funtion `public func countOnes(x: UInt16): Int64` instead."]
public func countOne(x: UInt16): Int8 {
    Int8(countOnes(x))
}

/**
 * @throws IndexOutOfBoundsException
 */
@Deprecated[message: "Use global funtion `public func countOnes(x: UInt32): Int64` instead."]
public func countOne(x: UInt32): Int8 {
    Int8(countOnes(x))
}

/**
 * @throws IndexOutOfBoundsException
 */
@Deprecated[message: "Use global funtion `public func countOnes(x: UInt64): Int64` instead."]
public func countOne(x: UInt64): Int8 {
    Int8(countOnes(x))
}







/**
 * @throws IndexOutOfBoundsException
 */
public func reverse(x: UInt64): UInt64 {
    return UInt64(reverse(UInt32(x & 0xFFFFFFFF))) << UInt64(32) | UInt64(reverse(UInt32(x >> UInt64(32))))
}







/**
 * @throws IndexOutOfBoundsException
 */
public func reverse(x: UInt32): UInt32 {
    return UInt32(reverse(UInt16(x & 0xFFFF))) << UInt32(16) | UInt32(reverse(UInt16(x >> UInt32(16))))
}







/**
 * @throws IndexOutOfBoundsException
 */
public func reverse(x: UInt16): UInt16 {
    return (UInt16(revtab[Int64(x & 0xFF)]) << UInt16(8)) | UInt16(revtab[Int64(x >> UInt16(8))])
}







/**
 * @throws IndexOutOfBoundsException
 */
public func reverse(x: UInt8): UInt8 {
    return revtab[Int64(x)]
}









/**
 * @throws OverflowException
 */
public func checkedAbs(x: Int8): Option<Int8> {
    return if (x == Int8.Min) {
        None
    } else {
        abs(x)
    }
}









/**
 * @throws OverflowException
 */
public func checkedAbs(x: Int16): Option<Int16> {
    return if (x == Int16.Min) {
        None
    } else {
        abs(x)
    }
}









/**
 * @throws OverflowException
 */
public func checkedAbs(x: Int32): Option<Int32> {
    return if (x == Int32.Min) {
        None
    } else {
        abs(x)
    }
}









/**
 * @throws OverflowException
 */
public func checkedAbs(x: Int64): Option<Int64> {
    return if (x == Int64.Min) {
        None
    } else {
        abs(x)
    }
}
















@OverflowWrapping
public func rotate(num: UInt8, d: Int8): UInt8 {
    let numberWidth: Int8 = 8
    let rotateMid: Int8 = d & (numberWidth - 1)
    if (rotateMid == 0) {
        return num
    }
    return num << rotateMid | num >> (numberWidth - rotateMid)
}
















@OverflowWrapping
public func rotate(num: UInt16, d: Int8): UInt16 {
    let numberWidth: Int16 = 16
    let rotateMid: Int16 = Int16(d) & (numberWidth - 1)
    if (rotateMid == 0) {
        return num
    }
    return num << rotateMid | num >> (numberWidth - rotateMid)
}
















@OverflowWrapping
public func rotate(num: UInt32, d: Int8): UInt32 {
    let numberWidth: Int32 = 32
    let rotateMid: Int32 = Int32(d) & (numberWidth - 1)
    if (rotateMid == 0) {
        return num
    }
    return num << rotateMid | num >> (numberWidth - rotateMid)
}
















@OverflowWrapping
public func rotate(num: UInt64, d: Int8): UInt64 {
    let numberWidth: Int64 = 64
    let rotateMid: Int64 = Int64(d) & (numberWidth - 1)
    if (rotateMid == 0) {
        return num
    }
    return num << rotateMid | num >> (numberWidth - rotateMid)
}















@OverflowWrapping
public func rotate(num: Int8, d: Int8): Int8 {
    return Int8(rotate(UInt8(num), d))
}















@OverflowWrapping
public func rotate(num: Int16, d: Int8): Int16 {
    return Int16(rotate(UInt16(num), d))
}















@OverflowWrapping
public func rotate(num: Int32, d: Int8): Int32 {
    return Int32(rotate(UInt32(num), d))
}















@OverflowWrapping
public func rotate(num: Int64, d: Int8): Int64 {
    return Int64(rotate(UInt64(num), d))
}














/**
 * @throws OverflowException
 * @throws IllegalArgumentException
 */
@OverflowWrapping
public func gcd(x: Int8, y: Int8): Int8 {
    return match {
        case y == x && y == Int8.Min => throw IllegalArgumentException(
            "Both parameters x and y are minimum boundary values.")
        case (y == Int8.Min && x == 0) || (y == 0 && x == Int8.Min) => throw IllegalArgumentException(
            "One of the parameters is minimum boundary value, and another is 0.")
        case (y == Int8.Min && x != 0) || (y != 0 && x == Int8.Min) => return Int8(gcd(UInt8(x), UInt8(y)))
        case x == 0 && y != 0 => abs(y)
        case y == 0 && x != 0 => abs(x)
        case _ =>
            var x = if (x < 0) {
                UInt8(-x)
            } else {
                UInt8(x)
            }
            var y = if (y < 0) {
                UInt8(-y)
            } else {
                UInt8(y)
            }
            return Int8(gcd(x, y))
    }
}














/**
 * @throws OverflowException
 * @throws IllegalArgumentException
 */
@OverflowWrapping
public func gcd(x: Int16, y: Int16): Int16 {
    return match {
        case y == x && y == Int16.Min => throw IllegalArgumentException(
            "Both parameters x and y are minimum boundary values.")
        case (y == Int16.Min && x == 0) || (y == 0 && x == Int16.Min) => throw IllegalArgumentException(
            "One of the parameters is minimum boundary value, and another is 0.")
        case (y == Int16.Min && x != 0) || (y != 0 && x == Int16.Min) => return Int16(gcd(UInt16(x), UInt16(y)))
        case x == 0 && y != 0 => abs(y)
        case y == 0 && x != 0 => abs(x)
        case _ =>
            var x = if (x < 0) {
                UInt16(-x)
            } else {
                UInt16(x)
            }
            var y = if (y < 0) {
                UInt16(-y)
            } else {
                UInt16(y)
            }
            return Int16(gcd(x, y))
    }
}














/**
 * @throws OverflowException
 * @throws IllegalArgumentException
 */
@OverflowWrapping
public func gcd(x: Int32, y: Int32): Int32 {
    return match {
        case y == x && y == Int32.Min => throw IllegalArgumentException(
            "Both parameters x and y are minimum boundary values.")
        case (y == Int32.Min && x == 0) || (y == 0 && x == Int32.Min) => throw IllegalArgumentException(
            "One of the parameters is minimum boundary value, and another is 0.")
        case (y == Int32.Min && x != 0) || (y != 0 && x == Int32.Min) => return Int32(gcd(UInt32(x), UInt32(y)))
        case x == 0 && y != 0 => abs(y)
        case y == 0 && x != 0 => abs(x)
        case _ =>
            var x = if (x < 0) {
                UInt32(-x)
            } else {
                UInt32(x)
            }
            var y = if (y < 0) {
                UInt32(-y)
            } else {
                UInt32(y)
            }
            return Int32(gcd(x, y))
    }
}














/**
 * @throws OverflowException
 * @throws IllegalArgumentException
 */
@OverflowWrapping
public func gcd(x: Int64, y: Int64): Int64 {
    return match {
        case y == x && y == Int64.Min => throw IllegalArgumentException(
            "Both parameters x and y are minimum boundary values.")
        case (y == Int64.Min && x == 0) || (y == 0 && x == Int64.Min) => throw IllegalArgumentException(
            "One of the parameters is minimum boundary value, and another is 0.")
        case (y == Int64.Min && x != 0) || (y != 0 && x == Int64.Min) => return Int64(gcd(UInt64(x), UInt64(y)))
        case x == 0 && y != 0 => abs(y)
        case y == 0 && x != 0 => abs(x)
        case _ =>
            var x = if (x < 0) {
                UInt64(-x)
            } else {
                UInt64(x)
            }
            var y = if (y < 0) {
                UInt64(-y)
            } else {
                UInt64(y)
            }
            return Int64(gcd(x, y))
    }
}









public func gcd(x: UInt8, y: UInt8): UInt8 {
    if (y == 0) {
        return x
    }

    if (x == 0) {
        return y
    }

    var x_ = x;
    var y_ = y;
    var counter = 0;
    while (x_ != y_) {
        if (x_ < y_) {
            x_ = x_ ^ y_
            y_ = x_ ^ y_
            x_ = x_ ^ y_
        }

        if (UInt8(x_ & 1) == 1) {
            if (UInt8(y_ & 1) == 1) {
                y_ = (x_ - y_) >> 1
                x_ -= y_
            } else {
                y_ >>= 1
            }
        } else {
            x_ >>= 1
            if (UInt8(y_ & 1) != 1) {
                y_ >>= 1
                counter++;
            }
        }
    }

    x_ << counter;
}









public func gcd(x: UInt16, y: UInt16): UInt16 {
    if (y == 0) {
        return x
    }

    if (x == 0) {
        return y
    }

    var x_ = x;
    var y_ = y;
    var counter = 0;
    while (x_ != y_) {
        if (x_ < y_) {
            x_ = x_ ^ y_
            y_ = x_ ^ y_
            x_ = x_ ^ y_
        }

        if (UInt16(x_ & 1) == 1) {
            if (UInt16(y_ & 1) == 1) {
                y_ = (x_ - y_) >> 1
                x_ -= y_
            } else {
                y_ >>= 1
            }
        } else {
            x_ >>= 1
            if (UInt16(y_ & 1) != 1) {
                y_ >>= 1
                counter++;
            }
        }
    }

    x_ << counter;
}









public func gcd(x: UInt32, y: UInt32): UInt32 {
    if (y == 0) {
        return x
    }

    if (x == 0) {
        return y
    }

    var x_ = x;
    var y_ = y;
    var counter = 0;
    while (x_ != y_) {
        if (x_ < y_) {
            x_ = x_ ^ y_
            y_ = x_ ^ y_
            x_ = x_ ^ y_
        }

        if (UInt32(x_ & 1) == 1) {
            if (UInt32(y_ & 1) == 1) {
                y_ = (x_ - y_) >> 1
                x_ -= y_
            } else {
                y_ >>= 1
            }
        } else {
            x_ >>= 1
            if (UInt32(y_ & 1) != 1) {
                y_ >>= 1
                counter++;
            }
        }
    }

    x_ << counter;
}









public func gcd(x: UInt64, y: UInt64): UInt64 {
    if (y == 0) {
        return x
    }

    if (x == 0) {
        return y
    }

    var x_ = x;
    var y_ = y;
    var counter = 0;
    while (x_ != y_) {
        if (x_ < y_) {
            x_ = x_ ^ y_
            y_ = x_ ^ y_
            x_ = x_ ^ y_
        }

        if (UInt64(x_ & 1) == 1) {
            if (UInt64(y_ & 1) == 1) {
                y_ = (x_ - y_) >> 1
                x_ -= y_
            } else {
                y_ >>= 1
            }
        } else {
            x_ >>= 1
            if (UInt64(y_ & 1) != 1) {
                y_ >>= 1
                counter++;
            }
        }
    }

    x_ << counter;
}












/**
 * @throws OverflowException
 * @throws IllegalArgumentException
 */
public func lcm(x: Int8, y: Int8): Int8 {
    if (x == 0 || y == 0) {
        return 0
    }

    let xDivGcd = x / gcd(x, y)
    if (xDivGcd == Int8.Min || y == Int8.Min) {
        throw IllegalArgumentException("The result is out of the Int8 range.")
    }

    let xDivGcdAbs = abs(xDivGcd)
    let yAbs = abs(y)
    if (yAbs > Int8.Max / xDivGcdAbs) {
        throw IllegalArgumentException("The result is out of the Int8 range.")
    } else {
        return abs(xDivGcdAbs * yAbs)
    }
}












/**
 * @throws OverflowException
 * @throws IllegalArgumentException
 */
public func lcm(x: Int16, y: Int16): Int16 {
    if (x == 0 || y == 0) {
        return 0
    }

    let xDivGcd = x / gcd(x, y)
    if (xDivGcd == Int16.Min || y == Int16.Min) {
        throw IllegalArgumentException("The result is out of the Int16 range.")
    }

    let xDivGcdAbs = abs(xDivGcd)
    let yAbs = abs(y)
    if (yAbs > Int16.Max / xDivGcdAbs) {
        throw IllegalArgumentException("The result is out of the Int16 range.")
    } else {
        return abs(xDivGcdAbs * yAbs)
    }
}












/**
 * @throws OverflowException
 * @throws IllegalArgumentException
 */
public func lcm(x: Int32, y: Int32): Int32 {
    if (x == 0 || y == 0) {
        return 0
    }

    let xDivGcd = x / gcd(x, y)
    if (xDivGcd == Int32.Min || y == Int32.Min) {
        throw IllegalArgumentException("The result is out of the Int32 range.")
    }

    let xDivGcdAbs = abs(xDivGcd)
    let yAbs = abs(y)
    if (yAbs > Int32.Max / xDivGcdAbs) {
        throw IllegalArgumentException("The result is out of the Int32 range.")
    } else {
        return abs(xDivGcdAbs * yAbs)
    }
}












/**
 * @throws OverflowException
 * @throws IllegalArgumentException
 */
public func lcm(x: Int64, y: Int64): Int64 {
    if (x == 0 || y == 0) {
        return 0
    }

    let xDivGcd = x / gcd(x, y)
    if (xDivGcd == Int64.Min || y == Int64.Min) {
        throw IllegalArgumentException("The result is out of the Int64 range.")
    }

    let xDivGcdAbs = abs(xDivGcd)
    let yAbs = abs(y)
    if (yAbs > Int64.Max / xDivGcdAbs) {
        throw IllegalArgumentException("The result is out of the Int64 range.")
    } else {
        return abs(xDivGcdAbs * yAbs)
    }
}










/**
 * @throws IllegalArgumentException
 */
public func lcm(x: UInt8, y: UInt8): UInt8 {
    if (x == 0 || y == 0) {
        return 0
    }

    let a = x / gcd(x, y)
    let c = UInt8.Max / a
    if (y > c) {
        throw IllegalArgumentException("The result is out of the UInt8 range.")
    } else {
        return x / gcd(x, y) * y
    }
}










/**
 * @throws IllegalArgumentException
 */
public func lcm(x: UInt16, y: UInt16): UInt16 {
    if (x == 0 || y == 0) {
        return 0
    }

    let a = x / gcd(x, y)
    let c = UInt16.Max / a
    if (y > c) {
        throw IllegalArgumentException("The result is out of the UInt16 range.")
    } else {
        return x / gcd(x, y) * y
    }
}










/**
 * @throws IllegalArgumentException
 */
public func lcm(x: UInt32, y: UInt32): UInt32 {
    if (x == 0 || y == 0) {
        return 0
    }

    var a = x / gcd(x, y)
    var c = UInt32.Max / a
    if (y > c) {
        throw IllegalArgumentException("The result is out of the UInt32 range.")
    } else {
        return x / gcd(x, y) * y
    }
}










/**
 * @throws IllegalArgumentException
 */
public func lcm(x: UInt64, y: UInt64): UInt64 {
    if (x == 0 || y == 0) {
        return 0
    }

    let a = x / gcd(x, y)
    let c = UInt64.Max / a
    if (y > c) {
        throw IllegalArgumentException("The result is out of the UInt64 range.")
    } else {
        return x / gcd(x, y) * y
    }
}
















/**
 * @throws IllegalArgumentException
 */
public func clamp(v: Float16, min: Float16, max: Float16): Float16 {
    match {
        case !isEqual(min, min) || !isEqual(max, max) || min > max => throw IllegalArgumentException(
            "Check parameter min:'${min}' or max:'${max}'.\n")
        case v < min => min
        case v > max => max
        case _ => v
    }
}
















/**
 * @throws IllegalArgumentException
 */
public func clamp(v: Float32, min: Float32, max: Float32): Float32 {
    match {
        case !isEqual(min, min) || !isEqual(max, max) || min > max => throw IllegalArgumentException(
            "Check parameter min:'${min}' or max:'${max}'.\n")
        case v < min => min
        case v > max => max
        case _ => v
    }
}















/**
 * @throws IllegalArgumentException
 */
public func clamp(v: Float64, min: Float64, max: Float64): Float64 {
    match {
        case !isEqual(min, min) || !isEqual(max, max) || min > max => throw IllegalArgumentException(
            "Check parameter min:'${min}' or max:'${max}'.\n")
        case v < min => min
        case v > max => max
        case _ => v
    }
}













public func round(x: Float64): Float64 {
    var result: Float64 = abs(x)
    if (result >= 1e16) {
        return x
    }

    let integer: Float64 = floor(result)
    let decimal: Float64 = result - integer
    result = match {
        case decimal < 0.5 => integer
        case decimal > 0.5 => integer + 1.0
        case Int64(integer) % 2 == 0 => integer
        case _ => integer + 1.0
    }

    return match (x < 0.0) {
        case true => -result
        case false => result
    }
}













public func round(x: Float32): Float32 {
    var result: Float32 = abs(x)
    if (result >= 1e8) {
        return x
    }

    let integer: Float32 = floor(result)
    let decimal: Float32 = result - integer
    result = match {
        case decimal < 0.5 => integer
        case decimal > 0.5 => integer + 1.0
        case Int64(integer) % 2 == 0 => integer
        case _ => integer + 1.0
    }

    return match (x < 0.0) {
        case true => -result
        case false => result
    }
}













public func round(x: Float16): Float16 {
    var result: Float16 = abs(x)
    if (result >= 1e4) {
        return x
    }

    let integer: Float16 = floor(result)
    let decimal: Float16 = result - integer
    result = match {
        case decimal < 0.5 => integer
        case decimal > 0.5 => integer + 1.0
        case Int64(integer) % 2 == 0 => integer
        case _ => integer + 1.0
    }

    return match (x < 0.0) {
        case true => -result
        case false => result
    }
}




public func atan2(y: Float64, x: Float64): Float64 {
    return unsafe { CJ_MATH_Atan2(y, x) }
}




public func atan2(y: Float32, x: Float32): Float32 {
    return unsafe { CJ_MATH_Atan2f(y, x) }
}




public func atan2(y: Float16, x: Float16): Float16 {
    return unsafe { Float16(CJ_MATH_Atan2(Float64(y), Float64(x))) }
}





/**
 * @throws IllegalArgumentException
 */
public func fmod(x: Float64, y: Float64): Float64 {
    if (isEqual(x, Float64.Inf) || isEqual(y, 0.0)) {
        throw IllegalArgumentException("The input parameter is invalid. Please enter a correct parameter.")
    }
    return unsafe { CJ_MATH_Fmod(x, y) }
}





/**
 * @throws IllegalArgumentException
 */
public func fmod(x: Float32, y: Float32): Float32 {
    if (isEqual(x, Float32.Inf) || isEqual(y, 0.0)) {
        throw IllegalArgumentException("The input parameter is invalid. Please enter a correct parameter.")
    }
    return unsafe { CJ_MATH_Fmodf(x, y) }
}





/**
 * @throws IllegalArgumentException
 */
public func fmod(x: Float16, y: Float16): Float16 {
    if (isEqual(x, Float16.Inf) || isEqual(y, 0.0)) {
        throw IllegalArgumentException("The input parameter is invalid. Please enter a correct parameter.")
    }
    return unsafe { Float16(CJ_MATH_Fmod(Float64(x), Float64(y))) }
}

func isEqual(a: Float16, b: Float16): Bool {
    if (a.isInf() || b.isInf() || a.isNaN() || b.isNaN()) {
        return a == b
    }
    return abs(a - b) <= 1e-3
}

func isEqual(a: Float32, b: Float32): Bool {
    if (a.isInf() || b.isInf() || a.isNaN() || b.isNaN()) {
        return a == b
    }
    return abs(a - b) <= 1e-6
}

func isEqual(a: Float64, b: Float64): Bool {
    if (a.isInf() || b.isInf() || a.isNaN() || b.isNaN()) {
        return a == b
    }
    return abs(a - b) <= 1e-15
}
