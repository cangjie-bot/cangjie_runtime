






package std.unittest.prop_test

public interface RandomSource {
    /*
     * @noThrow
     */
    func nextBool(): Bool {
        (nextUInt8() & 1) == 1
    }

    @OverflowWrapping
    /*
     * @noThrow
     */
    func nextInt8(): Int8 {
        Int8(nextUInt8())
    }

    @OverflowWrapping
    /*
     * @noThrow
     */
    func nextInt16(): Int16 {
        Int16(nextUInt16())
    }

    @OverflowWrapping
    /*
     * @noThrow
     */
    func nextInt32(): Int32 {
        Int32(nextUInt32())
    }

    @OverflowWrapping
    /*
     * @noThrow
     */
    func nextInt64(): Int64 {
        Int64(nextUInt64())
    }

    /*
     * @throws IllegalArgumentException
     */
    func nextInt8(max: Int8): Int8 {
        if (max < 0) {
            throw IllegalArgumentException("max must be positive")
        }
        let i = nextInt8()
        match {
            case i == Int8.Min => max - 1
            case i < 0 => -i % max
            case _ => i % max
        }
    }
    /*
     * @throws IllegalArgumentException
     */
    func nextInt16(max: Int16): Int16 {
        if (max < 0) {
            throw IllegalArgumentException("max must be positive")
        }
        let i = nextInt16()
        match {
            case i == Int16.Min => max - 1
            case i < 0 => -i % max
            case _ => i % max
        }
    }
    /*
     * @throws IllegalArgumentException
     */
    func nextInt32(max: Int32): Int32 {
        if (max < 0) {
            throw IllegalArgumentException("max must be positive")
        }
        let i = nextInt32()
        match {
            case i == Int32.Min => max - 1
            case i < 0 => -i % max
            case _ => i % max
        }
    }
    /*
     * @throws IllegalArgumentException
     */
    func nextInt64(max: Int64): Int64 {
        if (max < 0) {
            throw IllegalArgumentException("max must be positive")
        }
        let i = nextInt64()
        match {
            case i == Int64.Min => max - 1
            case i < 0 => -i % max
            case _ => i % max
        }
    }

    /*
     * @noThrow
     */
    func nextUInt8(): UInt8
    /*
     * @noThrow
     */
    func nextUInt16(): UInt16
    /*
     * @noThrow
     */
    func nextUInt32(): UInt32
    /*
     * @noThrow
     */
    func nextUInt64(): UInt64

    /*
     * @noThrow
     */
    func nextUInt8(max: UInt8): UInt8 {
        nextUInt8() % max
    }
    /*
     * @noThrow
     */
    func nextUInt16(max: UInt16): UInt16 {
        nextUInt16() % max
    }
    /*
     * @noThrow
     */
    func nextUInt32(max: UInt32): UInt32 {
        nextUInt32() % max
    }
    /*
     * @noThrow
     */
    func nextUInt64(max: UInt64): UInt64 {
        nextUInt64() % max
    }

    /*
     * @noThrow
     */
    func nextFloat16(): Float16
    /*
     * @noThrow
     */
    func nextFloat32(): Float32
    /*
     * @noThrow
     */
    func nextFloat64(): Float64

    /*
     * @noThrow
     */
    func nextGaussianFloat64(mean!: Float64, sigma!: Float64): Float64

    @OverflowWrapping
    /*
     * @noThrow
     */
    func nextIntNative(): IntNative {
        IntNative(this.nextInt64())
    }

    @OverflowWrapping
    /*
     * @noThrow
     */
    func nextUIntNative(): UIntNative {
        UIntNative(this.nextUInt64())
    }

    /*
     * @noThrow
     */
    func suggestUInt8(): UInt8
    /*
     * @noThrow
     */
    func suggestUInt16(): UInt16
    /*
     * @noThrow
     */
    func suggestUInt32(): UInt32
    /*
     * @noThrow
     */
    func suggestUInt64(): UInt64

    @OverflowWrapping
    /*
     * @noThrow
     */
    func suggestUIntNative(): UIntNative { UIntNative(suggestUInt64()) }
    /*
     * @noThrow
     */
    func suggestInt8(): Int8
    /*
     * @noThrow
     */
    func suggestInt16(): Int16
    /*
     * @noThrow
     */
    func suggestInt32(): Int32
    /*
     * @noThrow
     */
    func suggestInt64(): Int64
    @OverflowWrapping
    /*
     * @noThrow
     */
    func suggestIntNative(): IntNative { IntNative(suggestInt64()) }
    /*
     * @noThrow
     */
    func suggestFloat16(): Float16
    /*
     * @noThrow
     */
    func suggestFloat32(): Float32
    /*
     * @noThrow
     */
    func suggestFloat64(): Float64
    /*
     * @noThrow
     */
    func suggestBool(): Bool { suggestUInt8() == 0 }

    /*
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    func suggestRune(): Rune { randomSuggestedRune(this) }

    /*
     * @noThrow
     */
    func suggestInt64(l: Int64, r: Int64): Int64 { remap(l, r, suggestInt64()) }
    /*
     * @noThrow
     */
    func suggestUInt64(l: UInt64, r: UInt64): UInt64 { remap(l, r, suggestUInt64()) }
    /*
     * @noThrow
     */
    func suggestInt32(l: Int32, r: Int32): Int32 { remap(l, r, suggestInt32()) }
    /*
     * @noThrow
     */
    func suggestUInt32(l: UInt32, r: UInt32): UInt32 { remap(l, r, suggestUInt32()) }
    /*
     * @noThrow
     */
    func suggestInt16(l: Int16, r: Int16): Int16 { remap(l, r, suggestInt16()) }
    /*
     * @noThrow
     */
    func suggestUInt16(l: UInt16, r: UInt16): UInt16 { remap(l, r, suggestUInt16()) }
    /*
     * @noThrow
     */
    func suggestInt8(l: Int8, r: Int8): Int8 { remap(l, r, suggestInt8()) }
    /*
     * @noThrow
     */
    func suggestUInt8(l: UInt8, r: UInt8): UInt8 { remap(l, r, suggestUInt8()) }
    /*
     * @noThrow
     */
    func suggestIntNative(l: IntNative, r: IntNative): IntNative { remap(l, r, suggestIntNative()) }
    /*
     * @noThrow
     */
    func suggestUIntNative(l: UIntNative, r: UIntNative): UIntNative { remap(l, r, suggestUIntNative()) }
    /*
     * @throws IllegalArgumentException
     */
    func suggestFloat64(l: Float64, r: Float64): Float64 { remap(l, r, suggestFloat64()) }
    /*
     * @throws IllegalArgumentException
     */
    func suggestFloat32(l: Float32, r: Float32): Float32 { remap(l, r, suggestFloat32()) }
    /*
     * @throws IllegalArgumentException
     */
    func suggestFloat16(l: Float16, r: Float16): Float16 { remap(l, r, suggestFloat16()) }
}
