







package std.core

@Intrinsic
/*
 * @noThrow
 */
func bitCast<From, To>(val: From): To where From <: BitCastRange, To <: BitCastRange

extend Float64 {





    /*
     * @noThrow
     */
    public static func fromBits(bits: UInt64): Float64 {
        bitCast(bits)
    }





    /*
     * @noThrow
     */
    public func toBits(): UInt64 {
        bitCast(this)
    }
}

extend Float32 {





    /*
     * @noThrow
     */
    public static func fromBits(bits: UInt32): Float32 {
        bitCast(bits)
    }





    /*
     * @noThrow
     */
    public func toBits(): UInt32 {
        bitCast(this)
    }
}

extend Float16 {





    /*
     * @noThrow
     */
    public static func fromBits(bits: UInt16): Float16 {
        bitCast(bits)
    }





    /*
     * @noThrow
     */
    public func toBits(): UInt16 {
        bitCast(this)
    }
}
interface BitCastRange {}

extend UInt64 <: BitCastRange {}

extend Float64 <: BitCastRange {}

extend UInt32 <: BitCastRange {}

extend Float32 <: BitCastRange {}

extend UInt16 <: BitCastRange {}

extend Float16 <: BitCastRange {}
