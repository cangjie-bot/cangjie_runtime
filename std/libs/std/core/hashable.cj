







package std.core

public interface Hashable {
    /*
     * @noThrow
     */
    func hashCode(): Int64
}


extend Ordering <: Hashable {
    /*
     * @noThrow
     */
    public func hashCode(): Int64 {
        match (this) {
            case Ordering.GT => return 3
            case Ordering.LT => return 1
            case _ => return 2
        }
    }
}

extend Unit <: Hashable {
    /*
     * @noThrow
     */
    public func hashCode(): Int64 {
        return 0
    }
}

extend Bool <: Hashable {
    /*
     * @noThrow
     */
    public func hashCode(): Int64 {
        if (this) {
            return 1
        }
        return 0
    }
}

extend Rune <: Hashable {
    /*
     * @noThrow
     */
    public func hashCode(): Int64 {
        return Int64(UInt32(this))
    }
}

/*
 * @noThrow
 */
func i32tof32(num: Int32): Float32 {
    var _src: Int32 = num
    return unsafe { CPointer<Float32>(inout _src).read() }
}

/*
 * @noThrow
 */
func f32toi32(num: Float32): Int32 {
    var _src: Float32 = num
    return unsafe { CPointer<Int32>(inout _src).read() }
}

/*
 * @noThrow
 */
func i64tof64(num: Int64): Float64 {
    var _src: Int64 = num
    return unsafe { CPointer<Float64>(inout _src).read() }
}

/*
 * @noThrow
 */
func f642i64(num: Float64): Int64 {
    var _src: Float64 = num
    return unsafe { CPointer<Int64>(inout _src).read() }
}

extend IntNative <: Hashable {
    @OverflowWrapping
    /*
     * @noThrow
     */
    public func hashCode(): Int64 {
        return Int64(this)
    }

    public static prop Max: IntNative {
        /*
         * @noThrow
         */
        get() {
            IntNative(UIntNative.Max >> 1)
        }
    }
    public static prop Min: IntNative {
        /*
         * @noThrow
         */
        get() {
            !IntNative.Max
        }
    }
}

extend Int64 <: Hashable {
    /*
     * @noThrow
     */
    public func hashCode(): Int64 {
        return this
    }

    public static prop Max: Int64 {
        /*
         * @noThrow
         */
        get() {
            0x7FFF_FFFF_FFFF_FFFF
        }
    }

    public static prop Min: Int64 {
        /*
         * @noThrow
         */
        get() {
            -0x8000_0000_0000_0000
        }
    }
}

extend Int32 <: Hashable {
    /*
     * @noThrow
     */
    public func hashCode(): Int64 {
        return Int64(this)
    }

    public static prop Max: Int32 {
        /*
         * @noThrow
         */
        get() {
            0x7FFF_FFFF
        }
    }

    public static prop Min: Int32 {
        /*
         * @noThrow
         */
        get() {
            -0x8000_0000
        }
    }
}

extend Int16 <: Hashable {
    /*
     * @noThrow
     */
    public func hashCode(): Int64 {
        return Int64(this)
    }

    public static prop Max: Int16 {
        /*
         * @noThrow
         */
        get() {
            0x7FFF
        }
    }

    public static prop Min: Int16 {
        /*
         * @noThrow
         */
        get() {
            -0x8000
        }
    }
}

extend Int8 <: Hashable {
    /*
     * @noThrow
     */
    public func hashCode(): Int64 {
        return Int64(this)
    }

    public static prop Max: Int8 {
        /*
         * @noThrow
         */
        get() {
            0x7F
        }
    }

    public static prop Min: Int8 {
        /*
         * @noThrow
         */
        get() {
            -0x80
        }
    }
}

extend UIntNative <: Hashable {
    @OverflowWrapping
    /*
     * @noThrow
     */
    public func hashCode(): Int64 {
        return Int64(this)
    }

    public static prop Max: UIntNative {
        /*
         * @noThrow
         */
        get() {
            !UIntNative(0)
        }
    }

    public static prop Min: UIntNative {
        /*
         * @noThrow
         */
        get() {
            !UIntNative.Max
        }
    }
}

extend UInt64 <: Hashable {
    @OverflowWrapping
    /*
     * @noThrow
     */
    public func hashCode(): Int64 {
        return Int64(this)
    }

    public static prop Max: UInt64 {
        /*
         * @noThrow
         */
        get() {
            0xFFFF_FFFF_FFFF_FFFF
        }
    }

    public static prop Min: UInt64 {
        /*
         * @noThrow
         */
        get() {
            0x0
        }
    }
}

extend UInt32 <: Hashable {
    /*
     * @noThrow
     */
    public func hashCode(): Int64 {
        return Int64(this)
    }

    public static prop Max: UInt32 {
        /*
         * @noThrow
         */
        get() {
            0xFFFF_FFFF
        }
    }

    public static prop Min: UInt32 {
        /*
         * @noThrow
         */
        get() {
            0x0
        }
    }
}

extend UInt16 <: Hashable {
    /*
     * @noThrow
     */
    public func hashCode(): Int64 {
        return Int64(this)
    }

    public static prop Max: UInt16 {
        /*
         * @noThrow
         */
        get() {
            0xFFFF
        }
    }

    public static prop Min: UInt16 {
        /*
         * @noThrow
         */
        get() {
            0x0
        }
    }
}

extend UInt8 <: Hashable {
    /*
     * @noThrow
     */
    public func hashCode(): Int64 {
        return Int64(this)
    }

    public static prop Max: UInt8 {
        /*
         * @noThrow
         */
        get() {
            0xFF
        }
    }

    public static prop Min: UInt8 {
        /*
         * @noThrow
         */
        get() {
            0x0
        }
    }
}

extend Float64 <: Hashable {
    /*
     * @noThrow
     */
    public func hashCode(): Int64 {
        let i = if (this == 0.0f64) {
            0
        } else {
            unsafe { CJ_CORE_Float64ToHash(this) }
        }
        return wyrand(i)
    }

    public static prop NaN: Float64 {
        /*
         * @noThrow
         */
        get() {
            Float64(0.0) / Float64(0.0)
        }
    }

    public static prop Inf: Float64 {
        /*
         * @noThrow
         */
        get() {
            Float64(1.0) / Float64(0.0)
        }
    }

    public static prop Max: Float64 {
        /*
         * @noThrow
         */
        get() {
            i64tof64((Int64(0x7FE) << 52) | 0x000FFFFFFFFFFFFF)
        }
    }

    public static prop Min: Float64 {
        /*
         * @noThrow
         */
        get() {
            (i64tof64((Int64(0x7FE) << 52) | 0x000FFFFFFFFFFFFF)) * Float64(-1.0)
        }
    }

    public static prop MinDenormal: Float64 {
        /*
         * @noThrow
         */
        get() {
            Float64(Float64(1.0 / Float64(2.0 ** 0x3FE)) * Float64(1.0 / Float64(1 << 52)))
        }
    }
    public static prop MinNormal: Float64 {
        /*
         * @noThrow
         */
        get() {
            i64tof64(Int64(0x1) << 52)
        }
    }







    /*
     * @noThrow
     */
    public func isInf(): Bool {
        return this == Float64.Inf || this == -Float64.Inf
    }






    /*
     * @noThrow
     */
    public func isNaN(): Bool {
        return this != this
    }







    /*
     * @noThrow
     */
    public func isNormal(): Bool {
        var exp: Int64 = (f642i64(this) >> Int64(52)) & 0x7FF
        return exp != 0 && exp != 0x7FF
    }

    /*
     * @noThrow
     */
    public static func max(a: Float64, b: Float64, others: Array<Float64>): Float64 {
        if (a.isNaN() || b.isNaN()) {
            return Float64.NaN
        }
        var max: Float64 = if (a > b) {
            a
        } else {
            b
        }
        if (others.size == 0) {
            return max
        }
        for (f in others) {
            if (f.isNaN()) {
                return Float64.NaN
            }
            if (max < f) {
                max = f
            }
        }
        return max
    }

    /*
     * @noThrow
     */
    public static func min(a: Float64, b: Float64, others: Array<Float64>): Float64 {
        if (a.isNaN() || b.isNaN()) {
            return Float64.NaN
        }
        var min: Float64 = if (a < b) {
            a
        } else {
            b
        }
        if (others.size == 0) {
            return min
        }
        for (f in others) {
            if (f.isNaN()) {
                return Float64.NaN
            }
            if (min > f) {
                min = f
            }
        }
        return min
    }
}

extend Float32 <: Hashable {
    /*
     * @noThrow
     */
    public func hashCode(): Int64 {
        let i = if (this == 0.0f32) {
            0
        } else {
            unsafe { CJ_CORE_Float32ToHash(this) }
        }
        return wyrand(i)
    }

    public static prop NaN: Float32 {
        /*
         * @noThrow
         */
        get() {
            Float32(0.0) / Float32(0.0)
        }
    }

    public static prop Inf: Float32 {
        /*
         * @noThrow
         */
        get() {
            Float32(1.0) / Float32(0.0)
        }
    }

    public static prop Max: Float32 {
        /*
         * @noThrow
         */
        get() {
            i32tof32((Int32(0xFE) << 23) | 0x007FFFFF)
        }
    }

    public static prop Min: Float32 {
        /*
         * @noThrow
         */
        get() {
            (i32tof32((Int32(0xFE) << 23) | 0x007FFFFF)) * Float32(-1.0)
        }
    }

    public static prop MinDenormal: Float32 {
        /*
         * @noThrow
         */
        get() {
            Float32(Float64(1.0 / Float64(2.0 ** 0x7E)) * Float64(1.0 / Float64(1 << 23)))
        }
    }

    public static prop MinNormal: Float32 {
        /*
         * @noThrow
         */
        get() {
            i32tof32(Int32(0x1) << 23)
        }
    }







    /*
     * @noThrow
     */
    public func isInf(): Bool {
        return this == Float32.Inf || this == -Float32.Inf
    }






    /*
     * @noThrow
     */
    public func isNaN(): Bool {
        return this != this
    }







    /*
     * @noThrow
     */
    public func isNormal(): Bool {
        var exp: Int32 = (f32toi32(this) >> Int32(23)) & 0xFF
        return exp != 0 && exp != 0xFF
    }

    /*
     * @noThrow
     */
    public static func max(a: Float32, b: Float32, others: Array<Float32>): Float32 {
        if (a.isNaN() || b.isNaN()) {
            return Float32.NaN
        }
        var max: Float32 = if (a > b) {
            a
        } else {
            b
        }
        if (others.size == 0) {
            return max
        }
        for (f in others) {
            if (f.isNaN()) {
                return Float32.NaN
            }
            if (max < f) {
                max = f
            }
        }
        return max
    }

    /*
     * @noThrow
     */
    public static func min(a: Float32, b: Float32, others: Array<Float32>): Float32 {
        if (a.isNaN() || b.isNaN()) {
            return Float32.NaN
        }
        var min: Float32 = if (a < b) {
            a
        } else {
            b
        }
        if (others.size == 0) {
            return min
        }
        for (f in others) {
            if (f.isNaN()) {
                return Float32.NaN
            }
            if (min > f) {
                min = f
            }
        }
        return min
    }
}

extend Float16 <: Hashable {
    /*
     * @noThrow
     */
    public func hashCode(): Int64 {
        let i = if (this == 0.0f16) {
            0
        } else {
            unsafe { CJ_CORE_Float32ToHash(Float32(this)) }
        }
        return wyrand(i)
    }

    public static prop NaN: Float16 {
        /*
         * @noThrow
         */
        get() {
            Float16(0.0) / Float16(0.0)
        }
    }

    public static prop Inf: Float16 {
        /*
         * @noThrow
         */
        get() {
            Float16(1.0) / Float16(0.0)
        }
    }

    public static prop Max: Float16 {
        /*
         * @noThrow
         */
        get() {
            Float16((1.0 + Float64((Float64(1 << 10) - 1.0) / Float64(1 << 10))) * Float64(2.0 ** 0xF))
        }
    }

    public static prop Min: Float16 {
        /*
         * @noThrow
         */
        get() {
            (Float16((1.0 + Float64((Float64(1 << 10) - 1.0) / Float64(1 << 10))) * Float64(2.0 ** 0xF))) * Float16(-1.0)
        }
    }

    public static prop MinDenormal: Float16 {
        /*
         * @noThrow
         */
        get() {
            Float16(Float64(1.0 / Float64(2.0 ** 0xE)) * Float64(1.0 / Float64(1 << 10)))
        }
    }

    public static prop MinNormal: Float16 {
        /*
         * @noThrow
         */
        get() {
            Float16(Float64(1.0 / Float64(2.0 ** 0xE)) * Float64(1.0))
        }
    }







    /*
     * @noThrow
     */
    public func isInf(): Bool {
        return this == Float16.Inf || this == -Float16.Inf
    }






    /*
     * @noThrow
     */
    public func isNaN(): Bool {
        return this != this
    }







    /*
     * @noThrow
     */
    public func isNormal(): Bool {
        if (this == Float16(0)) {
            return false
        }
        if (this != this) {
            return false
        }
        if (this.isInf()) {
            return false
        }
        return true
    }

    /*
     * @noThrow
     */
    public static func max(a: Float16, b: Float16, others: Array<Float16>): Float16 {
        if (a.isNaN() || b.isNaN()) {
            return Float16.NaN
        }
        var max: Float16 = if (a > b) {
            a
        } else {
            b
        }
        if (others.size == 0) {
            return max
        }
        for (f in others) {
            if (f.isNaN()) {
                return Float16.NaN
            }
            if (max < f) {
                max = f
            }
        }
        return max
    }

    /*
     * @noThrow
     */
    public static func min(a: Float16, b: Float16, others: Array<Float16>): Float16 {
        if (a.isNaN() || b.isNaN()) {
            return Float16.NaN
        }
        var min: Float16 = if (a < b) {
            a
        } else {
            b
        }
        if (others.size == 0) {
            return min
        }
        for (f in others) {
            if (f.isNaN()) {
                return Float16.NaN
            }
            if (min > f) {
                min = f
            }
        }
        return min
    }
}

extend<T> Range<T> <: Hashable where T <: Hashable & Countable<T> & Comparable<T> & Equatable<T> {
    /*
     * @noThrow
     */
    public func hashCode(): Int64 {
        var dfh: DefaultHasher = DefaultHasher()
        dfh.write(start.hashCode())
        dfh.write(end.hashCode())
        dfh.write(step.hashCode())
        dfh.write(isClosed.hashCode())
        return dfh.finish()
    }
}

public interface Hasher {
    /*
     * @noThrow
     */
    func finish(): Int64
    /*
     * @noThrow
     */
    mut func reset(): Unit
    /*
     * @noThrow
     */
    mut func write(value: Bool): Unit
    /*
     * @noThrow
     */
    mut func write(value: Rune): Unit
    /*
     * @noThrow
     */
    mut func write(value: Int8): Unit
    /*
     * @noThrow
     */
    mut func write(value: Int16): Unit
    /*
     * @noThrow
     */
    mut func write(value: Int32): Unit
    /*
     * @noThrow
     */
    mut func write(value: Int64): Unit
    /*
     * @noThrow
     */
    mut func write(value: UInt8): Unit
    /*
     * @noThrow
     */
    mut func write(value: UInt16): Unit
    /*
     * @noThrow
     */
    mut func write(value: UInt32): Unit
    /*
     * @noThrow
     */
    mut func write(value: UInt64): Unit
    /*
     * @noThrow
     */
    mut func write(value: Float16): Unit
    /*
     * @noThrow
     */
    mut func write(value: Float32): Unit
    /*
     * @noThrow
     */
    mut func write(value: Float64): Unit
    /*
     * @noThrow
     */
    mut func write(value: String): Unit
}

public struct DefaultHasher <: Hasher {
    private var res: Int64 = 0

    /*
     * @noThrow
     */
    public func finish(): Int64 {
        return res
    }

    /*
     * @noThrow
     */
    public mut func reset(): Unit {
        res = 0
    }

    /*
     * @noThrow
     */
    public mut func write(value: Bool): Unit {
        res = hashCombine(res, value.hashCode())
    }

    /*
     * @noThrow
     */
    public mut func write(value: Rune): Unit {
        res = hashCombine(res, value.hashCode())
    }

    /*
     * @noThrow
     */
    public mut func write(value: Int8): Unit {
        res = hashCombine(res, value.hashCode())
    }

    /*
     * @noThrow
     */
    public mut func write(value: Int16): Unit {
        res = hashCombine(res, value.hashCode())
    }

    /*
     * @noThrow
     */
    public mut func write(value: Int32): Unit {
        res = hashCombine(res, value.hashCode())
    }

    /*
     * @noThrow
     */
    public mut func write(value: Int64): Unit {
        res = hashCombine(res, value.hashCode())
    }

    /*
     * @noThrow
     */
    public mut func write(value: UInt8): Unit {
        res = hashCombine(res, value.hashCode())
    }

    /*
     * @noThrow
     */
    public mut func write(value: UInt16): Unit {
        res = hashCombine(res, value.hashCode())
    }

    /*
     * @noThrow
     */
    public mut func write(value: UInt32): Unit {
        res = hashCombine(res, value.hashCode())
    }

    /*
     * @noThrow
     */
    public mut func write(value: UInt64): Unit {
        res = hashCombine(res, value.hashCode())
    }

    /*
     * @noThrow
     */
    public mut func write(value: Float16): Unit {
        res = hashCombine(res, value.hashCode())
    }

    /*
     * @noThrow
     */
    public mut func write(value: Float32): Unit {
        res = hashCombine(res, value.hashCode())
    }

    /*
     * @noThrow
     */
    public mut func write(value: Float64): Unit {
        res = hashCombine(res, value.hashCode())
    }

    /*
     * @noThrow
     */
    public mut func write(value: String): Unit {
        res = hashCombine(res, value.hashCode())
    }



    @OverflowWrapping
    /*
     * @noThrow
     */
    private func hashCombine(seed: Int64, hashV: Int64): Int64 {
        let a: Int64 = -7046029254386353131
        return seed ^ (hashV + a + (seed << 6) + (seed >> 2))
    }
    /*
     * @noThrow
     */
    public init(res!: Int64 = 0) {
        this.res = res
    }
}






const SECRET0 = 0xa0761d6478bd642fu64
const SECRET1 = 0xe7037ed1a0b428dbu64
const SECRET2 = 0x8ebc6af09c88c6e3u64
const SECRET3 = 0x589965cc75374cc3u64

@OverflowWrapping
/*
 * @noThrow
 */
func wyrand(seed: Int64) {
    let v: UInt64 = UInt64(seed) + SECRET0
    return Int64(mix(v, v ^ SECRET1))
}

@OverflowWrapping
/*
 * @noThrow
 */
func wyhash(arr: RawArray<UInt8>, start: Int64, size: Int64, see: UInt64) {
    var seed = see ^ mix(see ^ SECRET0, SECRET1)
    if (size == 0) {
        return seed
    }
    var a: UInt64
    var b: UInt64
    match {
        case size < 4 =>
            a = (UInt64(arrayGetUnchecked(arr, start)) << 16) |
                (UInt64(arrayGetUnchecked(arr, start + (size >> 1))) << 8) |
                (UInt64(arrayGetUnchecked(arr, start + size - 1)))
            b = 0
        case size == 4 =>
            a = r4(arr, start)
            b = a
        case size < 8 =>
            a = r4(arr, start)
            b = r4(arr, start + size - 4)
        case size <= 16 =>
            a = r8(arr, start)
            b = r8(arr, start + size - 8)
        case _ =>
            var pos = start
            var l = size
            if (l > 48) {
                var seed1 = seed
                var seed2 = seed

                do {
                    seed = mix(r8(arr, pos) ^ SECRET1, r8(arr, pos + 8) ^ seed)
                    seed1 = mix(r8(arr, pos + 16) ^ SECRET2, r8(arr, pos + 24) ^ seed1)
                    seed2 = mix(r8(arr, pos + 32) ^ SECRET3, r8(arr, pos + 40) ^ seed2)
                    pos += 48
                    l -= 48
                } while (l > 48)
                seed = seed ^ seed1 ^ seed2
            }

            while (l > 16) {
                seed = mix(r8(arr, pos) ^ SECRET1, r8(arr, pos + 8) ^ seed)
                l -= 16
                pos += 16
            }
            a = r8(arr, pos + l - 16)
            b = r8(arr, pos + l - 8)
    }
    a ^= SECRET1
    b ^= seed
    return mix(a ^ SECRET0 ^ UInt64(size), b ^ SECRET1)
}

@OverflowWrapping
/*
 * @noThrow
 */
func mix(A: UInt64, B: UInt64) {
    let ha: UInt64 = A >> 32
    let hb: UInt64 = B >> 32
    let la: UInt64 = UInt64(UInt32(A))
    let lb: UInt64 = UInt64(UInt32(B))
    let rh = ha * hb
    let rm0 = ha * lb
    let rm1 = hb * la
    let rl = la * lb
    let t = rl + (rm0 << 32)
    var c: UInt64 = if (t < rl) {
        1
    } else {
        0
    }
    let lo = t + (rm1 << 32)
    c += if (lo < t) {
        1
    } else {
        0
    }
    let hi = rh + (rm0 >> 32) + (rm1 >> 32) + c
    return lo ^ hi
}

@OverflowWrapping
/*
 * @noThrow
 */
func r4(arr: RawArray<UInt8>, pos: Int64) {
    (UInt64(arrayGetUnchecked(arr, pos)) << 24) |
    (UInt64(arrayGetUnchecked(arr, pos + 1)) << 16) |
    (UInt64(arrayGetUnchecked(arr, pos + 2)) << 8) |
    UInt64(arrayGetUnchecked(arr, pos + 3))
}

@OverflowWrapping
/*
 * @noThrow
 */
func r8(arr: RawArray<UInt8>, pos: Int64) {
    (UInt64(arrayGetUnchecked(arr, pos)) << 56) |
    (UInt64(arrayGetUnchecked(arr, pos + 1)) << 48) |
    (UInt64(arrayGetUnchecked(arr, pos + 2)) << 40) |
    (UInt64(arrayGetUnchecked(arr, pos + 3)) << 32) |
    (UInt64(arrayGetUnchecked(arr,pos + 4)) << 24) |
    (UInt64(arrayGetUnchecked(arr, pos + 5)) << 16) |
    (UInt64(arrayGetUnchecked(arr, pos + 6)) << 8) |
        UInt64(arrayGetUnchecked(arr, pos + 7))
}
