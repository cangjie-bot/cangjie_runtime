







package std.overflow

public interface CarryingOp<T> {
    /*
     * @noThrow
     */
    func carryingAdd(y: T): (Bool, T)
    /*
     * @noThrow
     */
    func carryingSub(y: T): (Bool, T)
    /*
     * @noThrow
     */
    func carryingMul(y: T): (Bool, T)
    /*
     * @noThrow
     */
    func carryingDiv(y: T): (Bool, T)
    /*
     * @noThrow
     */
    func carryingMod(y: T): (Bool, T)
    /*
     * @noThrow
     */
    func carryingInc(): (Bool, T)
    /*
     * @noThrow
     */
    func carryingDec(): (Bool, T)
    /*
     * @noThrow
     */
    func carryingNeg(): (Bool, T)
    /*
     * @noThrow
     */
    func carryingShl(y: UInt64): (Bool, T)
    /*
     * @noThrow
     */
    func carryingShr(y: UInt64): (Bool, T)
}

public interface CarryingPow {
    /*
     * @noThrow
     */
    func carryingPow(y: UInt64): (Bool, Int64)
}

extend Int8 <: CarryingOp<Int8> {
    /*
     * @noThrow
     */
    public func carryingAdd(y: Int8): (Bool, Int8) {
        (this.checkedAdd(y).isNone(), wrappingAdd(this, y))
    }

    /*
     * @noThrow
     */
    public func carryingSub(y: Int8): (Bool, Int8) {
        (this.checkedSub(y).isNone(), wrappingSub(this, y))
    }

    /*
     * @noThrow
     */
    public func carryingMul(y: Int8): (Bool, Int8) {
        (this.checkedMul(y).isNone(), wrappingMul(this, y))
    }

    /*
     * @noThrow
     */
    public func carryingDiv(y: Int8): (Bool, Int8) {
        (this.checkedDiv(y).isNone(), wrappingDiv(this, y))
    }

    /*
     * @noThrow
     */
    public func carryingMod(y: Int8): (Bool, Int8) {
        (this.checkedMod(y).isNone(), wrappingMod(this, y))
    }

    /*
     * @noThrow
     */
    public func carryingInc(): (Bool, Int8) {
        (this.checkedInc().isNone(), wrappingInc(this))
    }

    /*
     * @noThrow
     */
    public func carryingDec(): (Bool, Int8) {
        (this.checkedDec().isNone(), wrappingDec(this))
    }

    /*
     * @noThrow
     */
    public func carryingNeg(): (Bool, Int8) {
        (this.checkedNeg().isNone(), wrappingNeg(this))
    }

    /*
     * @noThrow
     */
    public func carryingShl(y: UInt64): (Bool, Int8) {
        (this.checkedShl(y).isNone(), wrappingShl(y))
    }

    /*
     * @noThrow
     */
    public func carryingShr(y: UInt64): (Bool, Int8) {
        (this.checkedShr(y).isNone(), wrappingShr(y))
    }
}

extend Int16 <: CarryingOp<Int16> {
    /*
     * @noThrow
     */
    public func carryingAdd(y: Int16): (Bool, Int16) {
        (this.checkedAdd(y).isNone(), wrappingAdd(this, y))
    }
    /*
     * @noThrow
     */
    public func carryingSub(y: Int16): (Bool, Int16) {
        (this.checkedSub(y).isNone(), wrappingSub(this, y))
    }
    /*
     * @noThrow
     */
    public func carryingMul(y: Int16): (Bool, Int16) {
        (this.checkedMul(y).isNone(), wrappingMul(this, y))
    }
    /*
     * @noThrow
     */
    public func carryingDiv(y: Int16): (Bool, Int16) {
        (this.checkedDiv(y).isNone(), wrappingDiv(this, y))
    }
    /*
     * @noThrow
     */
    public func carryingMod(y: Int16): (Bool, Int16) {
        (this.checkedMod(y).isNone(), wrappingMod(this, y))
    }
    /*
     * @noThrow
     */
    public func carryingInc(): (Bool, Int16) {
        (this.checkedInc().isNone(), wrappingInc(this))
    }
    /*
     * @noThrow
     */
    public func carryingDec(): (Bool, Int16) {
        (this.checkedDec().isNone(), wrappingDec(this))
    }
    /*
     * @noThrow
     */
    public func carryingNeg(): (Bool, Int16) {
        (this.checkedNeg().isNone(), wrappingNeg(this))
    }

    /*
     * @noThrow
     */
    public func carryingShl(y: UInt64): (Bool, Int16) {
        (this.checkedShl(y).isNone(), wrappingShl(y))
    }

    /*
     * @noThrow
     */
    public func carryingShr(y: UInt64): (Bool, Int16) {
        (this.checkedShr(y).isNone(), wrappingShr(y))
    }
}

extend Int32 <: CarryingOp<Int32> {
    /*
     * @noThrow
     */
    public func carryingAdd(y: Int32): (Bool, Int32) {
        (this.checkedAdd(y).isNone(), wrappingAdd(this, y))
    }
    /*
     * @noThrow
     */
    public func carryingSub(y: Int32): (Bool, Int32) {
        (this.checkedSub(y).isNone(), wrappingSub(this, y))
    }
    /*
     * @noThrow
     */
    public func carryingMul(y: Int32): (Bool, Int32) {
        (this.checkedMul(y).isNone(), wrappingMul(this, y))
    }
    /*
     * @noThrow
     */
    public func carryingDiv(y: Int32): (Bool, Int32) {
        (this.checkedDiv(y).isNone(), wrappingDiv(this, y))
    }
    /*
     * @noThrow
     */
    public func carryingMod(y: Int32): (Bool, Int32) {
        (this.checkedMod(y).isNone(), wrappingMod(this, y))
    }
    /*
     * @noThrow
     */
    public func carryingInc(): (Bool, Int32) {
        (this.checkedInc().isNone(), wrappingInc(this))
    }
    /*
     * @noThrow
     */
    public func carryingDec(): (Bool, Int32) {
        (this.checkedDec().isNone(), wrappingDec(this))
    }
    /*
     * @noThrow
     */
    public func carryingNeg(): (Bool, Int32) {
        (this.checkedNeg().isNone(), wrappingNeg(this))
    }

    /*
     * @noThrow
     */
    public func carryingShl(y: UInt64): (Bool, Int32) {
        (this.checkedShl(y).isNone(), wrappingShl(y))
    }

    /*
     * @noThrow
     */
    public func carryingShr(y: UInt64): (Bool, Int32) {
        (this.checkedShr(y).isNone(), wrappingShr(y))
    }
}

extend Int64 <: CarryingOp<Int64> & CarryingPow {
    /*
     * @noThrow
     */
    public func carryingAdd(y: Int64): (Bool, Int64) {
        (this.checkedAdd(y).isNone(), wrappingAdd(this, y))
    }
    /*
     * @noThrow
     */
    public func carryingSub(y: Int64): (Bool, Int64) {
        (this.checkedSub(y).isNone(), wrappingSub(this, y))
    }
    /*
     * @noThrow
     */
    public func carryingMul(y: Int64): (Bool, Int64) {
        (this.checkedMul(y).isNone(), wrappingMul(this, y))
    }
    /*
     * @noThrow
     */
    public func carryingDiv(y: Int64): (Bool, Int64) {
        (this.checkedDiv(y).isNone(), wrappingDiv(this, y))
    }
    /*
     * @noThrow
     */
    public func carryingMod(y: Int64): (Bool, Int64) {
        (this.checkedMod(y).isNone(), wrappingMod(this, y))
    }
    /*
     * @noThrow
     */
    public func carryingInc(): (Bool, Int64) {
        (this.checkedInc().isNone(), wrappingInc(this))
    }
    /*
     * @noThrow
     */
    public func carryingDec(): (Bool, Int64) {
        (this.checkedDec().isNone(), wrappingDec(this))
    }
    /*
     * @noThrow
     */
    public func carryingNeg(): (Bool, Int64) {
        (this.checkedNeg().isNone(), wrappingNeg(this))
    }

    /*
     * @noThrow
     */
    public func carryingShl(y: UInt64): (Bool, Int64) {
        (this.checkedShl(y).isNone(), wrappingShl(y))
    }

    /*
     * @noThrow
     */
    public func carryingShr(y: UInt64): (Bool, Int64) {
        (this.checkedShr(y).isNone(), wrappingShr(y))
    }

    /*
     * @noThrow
     */
    public func carryingPow(y: UInt64): (Bool, Int64) {
        (this.checkedPow(y).isNone(), wrappingPow(this, y))
    }
}

extend IntNative <: CarryingOp<IntNative> {
    /*
     * @noThrow
     */
    public func carryingAdd(y: IntNative): (Bool, IntNative) {
        (this.checkedAdd(y).isNone(), wrappingAdd(this, y))
    }
    /*
     * @noThrow
     */
    public func carryingSub(y: IntNative): (Bool, IntNative) {
        (this.checkedSub(y).isNone(), wrappingSub(this, y))
    }
    /*
     * @noThrow
     */
    public func carryingMul(y: IntNative): (Bool, IntNative) {
        (this.checkedMul(y).isNone(), wrappingMul(this, y))
    }
    /*
     * @noThrow
     */
    public func carryingDiv(y: IntNative): (Bool, IntNative) {
        (this.checkedDiv(y).isNone(), wrappingDiv(this, y))
    }
    /*
     * @noThrow
     */
    public func carryingMod(y: IntNative): (Bool, IntNative) {
        (this.checkedMod(y).isNone(), wrappingMod(this, y))
    }
    /*
     * @noThrow
     */
    public func carryingInc(): (Bool, IntNative) {
        (this.checkedInc().isNone(), wrappingInc(this))
    }
    /*
     * @noThrow
     */
    public func carryingDec(): (Bool, IntNative) {
        (this.checkedDec().isNone(), wrappingDec(this))
    }
    /*
     * @noThrow
     */
    public func carryingNeg(): (Bool, IntNative) {
        (this.checkedNeg().isNone(), wrappingNeg(this))
    }

    /*
     * @noThrow
     */
    public func carryingShl(y: UInt64): (Bool, IntNative) {
        (this.checkedShl(y).isNone(), wrappingShl(y))
    }

    /*
     * @noThrow
     */
    public func carryingShr(y: UInt64): (Bool, IntNative) {
        (this.checkedShr(y).isNone(), wrappingShr(y))
    }
}

extend UInt8 <: CarryingOp<UInt8> {
    /*
     * @noThrow
     */
    public func carryingAdd(y: UInt8): (Bool, UInt8) {
        (this.checkedAdd(y).isNone(), wrappingAdd(this, y))
    }
    /*
     * @noThrow
     */
    public func carryingSub(y: UInt8): (Bool, UInt8) {
        (this.checkedSub(y).isNone(), wrappingSub(this, y))
    }
    /*
     * @noThrow
     */
    public func carryingMul(y: UInt8): (Bool, UInt8) {
        (this.checkedMul(y).isNone(), wrappingMul(this, y))
    }
    /*
     * @noThrow
     */
    public func carryingDiv(y: UInt8): (Bool, UInt8) {
        (this.checkedDiv(y).isNone(), wrappingDiv(this, y))
    }
    /*
     * @noThrow
     */
    public func carryingMod(y: UInt8): (Bool, UInt8) {
        (this.checkedMod(y).isNone(), wrappingMod(this, y))
    }
    /*
     * @noThrow
     */
    public func carryingInc(): (Bool, UInt8) {
        (this.checkedInc().isNone(), wrappingInc(this))
    }
    /*
     * @noThrow
     */
    public func carryingDec(): (Bool, UInt8) {
        (this.checkedDec().isNone(), wrappingDec(this))
    }
    /*
     * @noThrow
     */
    public func carryingNeg(): (Bool, UInt8) {
        (this.checkedNeg().isNone(), wrappingNeg(this))
    }

    /*
     * @noThrow
     */
    public func carryingShl(y: UInt64): (Bool, UInt8) {
        (this.checkedShl(y).isNone(), wrappingShl(y))
    }

    /*
     * @noThrow
     */
    public func carryingShr(y: UInt64): (Bool, UInt8) {
        (this.checkedShr(y).isNone(), wrappingShr(y))
    }
}

extend UInt16 <: CarryingOp<UInt16> {
    /*
     * @noThrow
     */
    public func carryingAdd(y: UInt16): (Bool, UInt16) {
        (this.checkedAdd(y).isNone(), wrappingAdd(this, y))
    }
    /*
     * @noThrow
     */
    public func carryingSub(y: UInt16): (Bool, UInt16) {
        (this.checkedSub(y).isNone(), wrappingSub(this, y))
    }
    /*
     * @noThrow
     */
    public func carryingMul(y: UInt16): (Bool, UInt16) {
        (this.checkedMul(y).isNone(), wrappingMul(this, y))
    }
    /*
     * @noThrow
     */
    public func carryingDiv(y: UInt16): (Bool, UInt16) {
        (this.checkedDiv(y).isNone(), wrappingDiv(this, y))
    }
    /*
     * @noThrow
     */
    public func carryingMod(y: UInt16): (Bool, UInt16) {
        (this.checkedMod(y).isNone(), wrappingMod(this, y))
    }
    /*
     * @noThrow
     */
    public func carryingInc(): (Bool, UInt16) {
        (this.checkedInc().isNone(), wrappingInc(this))
    }
    /*
     * @noThrow
     */
    public func carryingDec(): (Bool, UInt16) {
        (this.checkedDec().isNone(), wrappingDec(this))
    }
    /*
     * @noThrow
     */
    public func carryingNeg(): (Bool, UInt16) {
        (this.checkedNeg().isNone(), wrappingNeg(this))
    }

    /*
     * @noThrow
     */
    public func carryingShl(y: UInt64): (Bool, UInt16) {
        (this.checkedShl(y).isNone(), wrappingShl(y))
    }

    /*
     * @noThrow
     */
    public func carryingShr(y: UInt64): (Bool, UInt16) {
        (this.checkedShr(y).isNone(), wrappingShr(y))
    }
}

extend UInt32 <: CarryingOp<UInt32> {
    /*
     * @noThrow
     */
    public func carryingAdd(y: UInt32): (Bool, UInt32) {
        (this.checkedAdd(y).isNone(), wrappingAdd(this, y))
    }
    /*
     * @noThrow
     */
    public func carryingSub(y: UInt32): (Bool, UInt32) {
        (this.checkedSub(y).isNone(), wrappingSub(this, y))
    }
    /*
     * @noThrow
     */
    public func carryingMul(y: UInt32): (Bool, UInt32) {
        (this.checkedMul(y).isNone(), wrappingMul(this, y))
    }
    /*
     * @noThrow
     */
    public func carryingDiv(y: UInt32): (Bool, UInt32) {
        (this.checkedDiv(y).isNone(), wrappingDiv(this, y))
    }
    /*
     * @noThrow
     */
    public func carryingMod(y: UInt32): (Bool, UInt32) {
        (this.checkedMod(y).isNone(), wrappingMod(this, y))
    }
    /*
     * @noThrow
     */
    public func carryingInc(): (Bool, UInt32) {
        (this.checkedInc().isNone(), wrappingInc(this))
    }
    /*
     * @noThrow
     */
    public func carryingDec(): (Bool, UInt32) {
        (this.checkedDec().isNone(), wrappingDec(this))
    }
    /*
     * @noThrow
     */
    public func carryingNeg(): (Bool, UInt32) {
        (this.checkedNeg().isNone(), wrappingNeg(this))
    }

    /*
     * @noThrow
     */
    public func carryingShl(y: UInt64): (Bool, UInt32) {
        (this.checkedShl(y).isNone(), wrappingShl(y))
    }

    /*
     * @noThrow
     */
    public func carryingShr(y: UInt64): (Bool, UInt32) {
        (this.checkedShr(y).isNone(), wrappingShr(y))
    }
}

extend UInt64 <: CarryingOp<UInt64> {
    /*
     * @noThrow
     */
    public func carryingAdd(y: UInt64): (Bool, UInt64) {
        (this.checkedAdd(y).isNone(), wrappingAdd(this, y))
    }
    /*
     * @noThrow
     */
    public func carryingSub(y: UInt64): (Bool, UInt64) {
        (this.checkedSub(y).isNone(), wrappingSub(this, y))
    }
    /*
     * @noThrow
     */
    public func carryingMul(y: UInt64): (Bool, UInt64) {
        (this.checkedMul(y).isNone(), wrappingMul(this, y))
    }
    /*
     * @noThrow
     */
    public func carryingDiv(y: UInt64): (Bool, UInt64) {
        (this.checkedDiv(y).isNone(), wrappingDiv(this, y))
    }
    /*
     * @noThrow
     */
    public func carryingMod(y: UInt64): (Bool, UInt64) {
        (this.checkedMod(y).isNone(), wrappingMod(this, y))
    }
    /*
     * @noThrow
     */
    public func carryingInc(): (Bool, UInt64) {
        (this.checkedInc().isNone(), wrappingInc(this))
    }
    /*
     * @noThrow
     */
    public func carryingDec(): (Bool, UInt64) {
        (this.checkedDec().isNone(), wrappingDec(this))
    }
    /*
     * @noThrow
     */
    public func carryingNeg(): (Bool, UInt64) {
        (this.checkedNeg().isNone(), wrappingNeg(this))
    }

    /*
     * @noThrow
     */
    public func carryingShl(y: UInt64): (Bool, UInt64) {
        (this.checkedShl(y).isNone(), wrappingShl(y))
    }

    /*
     * @noThrow
     */
    public func carryingShr(y: UInt64): (Bool, UInt64) {
        (this.checkedShr(y).isNone(), wrappingShr(y))
    }
}

extend UIntNative <: CarryingOp<UIntNative> {
    /*
     * @noThrow
     */
    public func carryingAdd(y: UIntNative): (Bool, UIntNative) {
        (this.checkedAdd(y).isNone(), wrappingAdd(this, y))
    }
    /*
     * @noThrow
     */
    public func carryingSub(y: UIntNative): (Bool, UIntNative) {
        (this.checkedSub(y).isNone(), wrappingSub(this, y))
    }
    /*
     * @noThrow
     */
    public func carryingMul(y: UIntNative): (Bool, UIntNative) {
        (this.checkedMul(y).isNone(), wrappingMul(this, y))
    }
    /*
     * @noThrow
     */
    public func carryingDiv(y: UIntNative): (Bool, UIntNative) {
        (this.checkedDiv(y).isNone(), wrappingDiv(this, y))
    }
    /*
     * @noThrow
     */
    public func carryingMod(y: UIntNative): (Bool, UIntNative) {
        (this.checkedMod(y).isNone(), wrappingMod(this, y))
    }
    /*
     * @noThrow
     */
    public func carryingInc(): (Bool, UIntNative) {
        (this.checkedInc().isNone(), wrappingInc(this))
    }
    /*
     * @noThrow
     */
    public func carryingDec(): (Bool, UIntNative) {
        (this.checkedDec().isNone(), wrappingDec(this))
    }
    /*
     * @noThrow
     */
    public func carryingNeg(): (Bool, UIntNative) {
        (this.checkedNeg().isNone(), wrappingNeg(this))
    }

    /*
     * @noThrow
     */
    public func carryingShl(y: UInt64): (Bool, UIntNative) {
        (this.checkedShl(y).isNone(), wrappingShl(y))
    }

    /*
     * @noThrow
     */
    public func carryingShr(y: UInt64): (Bool, UIntNative) {
        (this.checkedShr(y).isNone(), wrappingShr(y))
    }
}
