







package std.math.numeric

import std.convert.*
import std.math.*
import std.random.*

let UINT64_TENTH_POWER_ARRAY: Array<UInt64> = [
    1,
    10,
    100,
    1000,
    10000,
    100000,
    1000000,
    10000000,
    100000000,
    1000000000,
    10000000000,
    100000000000,
    1000000000000,
    10000000000000,
    100000000000000,
    1000000000000000,
    10000000000000000,
    100000000000000000,
    1000000000000000000,
    10000000000000000000
]
let BIGINT_TENTH_POWER_ARRAY: Array<BigInt> = [
    BigInt(1u64),
    BigInt(10u64),
    BigInt(100u64),
    BigInt(1000u64),
    BigInt(10000u64),
    BigInt(100000u64),
    BigInt(1000000u64),
    BigInt(10000000u64),
    BigInt(100000000u64),
    BigInt(1000000000u64),
    BigInt(10000000000u64),
    BigInt(100000000000u64),
    BigInt(1000000000000u64),
    BigInt(10000000000000u64),
    BigInt(100000000000000u64),
    BigInt(1000000000000000u64),
    BigInt(10000000000000000u64),
    BigInt(100000000000000000u64),
    BigInt(1000000000000000000u64),
    BigInt(10000000000000000000u64)
]
let BIGINT_ZERO: BigInt = BigInt(UInt64(0))
let BIGINT_ONE: BigInt = BIGINT_TENTH_POWER_ARRAY[0]
let BIGINT_TEN: BigInt = BIGINT_TENTH_POWER_ARRAY[1]

@OverflowWrapping
func reinterpretAsInt(val: Float32): Int32 {
    return Int32(val.toBits())
}

@OverflowWrapping
func reinterpretAsInt(val: Float64): Int64 {
    return Int64(val.toBits())
}




public struct Decimal <: Comparable<Decimal> & Hashable & ToString {
    var _scale: Int32

    var _precision: Int64

    var _value: BigInt

    var _sign: Int64








    public prop scale: Int32 {
        get() {
            this._scale
        }
    }






    public prop precision: Int64 {
        get() {
            this._precision
        }
    }








    public prop value: BigInt {
        get() {
            this._value
        }
    }









    public prop sign: Int64 {
        get() {
            this._sign
        }
    }
































    @Deprecated[message: "Use member function `public static func parse(value: String): Decimal` instead."]
    public init(val: String) {
        if (val.isEmpty()) {
            throw IllegalArgumentException("String value cannot be empty.")
        }

        var val_scale: Int32 = 0
        var val_precision: Int64 = 0

        var newValArr: Array<UInt8> = Array<UInt8>(val.size, repeat: 0)
        var isPositive: Bool = true
        var offset = 0
        var newArrIndex = 0
        if (val[offset] == b'-') {
            offset++
            isPositive = false
            newValArr[newArrIndex] = b'-'
            newArrIndex++
        } else if (val[offset] == b'+') {
            offset++
            newValArr[newArrIndex] = b'+'
            newArrIndex++
        }

        let valLen = val.size
        var hasDot = false
        var exponent = 0
        var hasHeadZero = false
        while (offset < valLen) {
            let c = val[offset]
            if (c >= b'0' && c <= b'9') {
                if (c == b'0') {
                    if (val_precision == 0) {
                        hasHeadZero = true
                    } else {
                        newValArr[newArrIndex] = c
                        newArrIndex++
                        val_precision++
                    }
                } else {
                    newValArr[newArrIndex] = c
                    newArrIndex++
                    val_precision++
                }

                if (hasDot) {
                    val_scale++
                }
                offset++
                continue
            }
            if (c == b'.') {
                if (hasDot) {
                    throw IllegalArgumentException("String value not allow contains more than one dot.")
                }

                hasDot = true
                offset++
                continue
            }
            if (c == b'e' || c == b'E') {
                exponent = parseExponent(val, offset)
                break
            }

            throw IllegalArgumentException(
                "String value not allow contains other character beyond [digit, \'.\', e, sign].")
        }
        if (val_precision == 0 && hasHeadZero) {
            newValArr[newArrIndex] = b'0'
            newArrIndex++
            val_precision++
        }
        if (val_precision == 0) {
            throw IllegalArgumentException("String value not allow without digits.")
        }

        if (exponent != 0) {
            val_scale = checkAndRtnScale(val_scale, exponent)
        }
        let valString = String.fromUtf8(newValArr[0..newArrIndex])
        var val_bigint = BigInt(valString)
        this._scale = val_scale
        this._precision = val_precision
        this._value = val_bigint
        this._sign = this._value.sign
    }











    public init(val: BigInt, scale: Int32) {
        var val_precision = calcNumberOfDigits(val)
        this._scale = scale
        this._precision = val_precision
        this._value = val
        this._sign = this._value.sign
    }

    public init(val: BigInt) {
        var val_precision = calcNumberOfDigits(val)
        this._scale = 0
        this._precision = val_precision
        this._value = val
        this._sign = this._value.sign
    }








    public init(val: Int8) {
        this(Int64(val))
    }








    public init(val: Int16) {
        this(Int64(val))
    }








    public init(val: Int32) {
        this(Int64(val))
    }








    public init(val: IntNative) {
        this(Int64(val))
    }








    public init(val: Int64) {
        var val_precision: Int64 = calcNumberOfDigits(val)
        var val_scale: Int32 = 0
        var val_int64 = val
        this._precision = val_precision
        this._value = BigInt(val_int64)
        this._scale = val_scale
        this._sign = this._value.sign
    }








    public init(val: UInt8) {
        this(UInt64(val))
    }








    public init(val: UInt16) {
        this(UInt64(val))
    }








    public init(val: UInt32) {
        this(UInt64(val))
    }








    public init(val: UIntNative) {
        this(UInt64(val))
    }








    public init(val: UInt64) {
        var val_precision: Int64 = calcNumberOfDigits(val)
        var val_scale: Int32 = 0
        this._precision = val_precision
        this._value = BigInt(val)
        this._scale = val_scale
        this._sign = this._value.sign
    }

















    public init(val: Float16) {
        this(Float32(val))
    }


















    public init(val: Float32) {
        if (val.isNaN() || val.isInf()) {
            throw IllegalArgumentException("Float value cannot be Inf or NaN.")
        }
        let f32Bits: Int32 = reinterpretAsInt(val)
        var (f_sign, exponent, fraction): (Int32, Int32, Int32) = parseFloat32Bits(f32Bits)
        if (fraction == 0) {
            this._precision = 1
            this._scale = 0
            this._value = BigInt(0)
            this._sign = 0
            return
        }
        while (fraction % 2 == 0) {
            fraction = fraction >> 1
            exponent++
        }

        var val_bigint: BigInt = BigInt(f_sign * fraction)
        var val_scale: Int32 = 0
        if (exponent > 0) {
            val_bigint = val_bigint * (BigInt(2) ** (UInt64(exponent)))
        } else {
            val_bigint = val_bigint * (BigInt(5) ** (UInt64(abs(exponent))))
            val_scale = abs(exponent)
        }

        var val_precision: Int64 = calcNumberOfDigits(val_bigint)
        this._precision = val_precision
        this._value = val_bigint
        this._scale = val_scale
        this._sign = this._value.sign
    }


















    public init(val: Float64) {
        if (val.isNaN() || val.isInf()) {
            throw IllegalArgumentException("Float value cannot be Inf or NaN.")
        }
        let f64Bits: Int64 = reinterpretAsInt(val)
        var (f_sign, exponent, fraction): (Int64, Int64, Int64) = parseFloat64Bits(f64Bits)
        if (fraction == 0) {
            this._precision = 1
            this._scale = 0
            this._value = BigInt(0)
            this._sign = this._value.sign
            return
        }
        while (fraction % 2 == 0) {
            fraction = fraction >> 1
            exponent++
        }

        if (Int64(Int32(exponent)) != exponent) {
            throw OverflowException("Scale overflow.")
        }

        var val_bigint: BigInt = BigInt(f_sign * fraction)
        var val_scale: Int32 = 0
        if (exponent > 0) {
            val_bigint = val_bigint * (BigInt(2) ** (UInt64(exponent)))
        } else {
            val_bigint = val_bigint * (BigInt(5) ** (UInt64(abs(exponent))))
            val_scale = abs(Int32(exponent))
        }

        var val_precision: Int64 = calcNumberOfDigits(val_bigint)
        this._precision = val_precision
        this._value = val_bigint
        this._scale = val_scale
        this._sign = this._value.sign
    }

    init(val: BigInt, scale: Int32, precision: Int64) {
        this._value = val
        this._scale = scale
        this._precision = precision
        this._sign = this._value.sign
    }













    func add(d: Decimal): Decimal {
        let resValue: BigInt
        let valPrecision: Int64
        var valScale: Int32 = this._scale
        if (this._scale == d.scale) {
            resValue = this._value + d.value
            valPrecision = calcNumberOfDigits(resValue)
            return Decimal(resValue, valScale, valPrecision)
        }

        let diffScale = Int64(this._scale) - Int64(d.scale)
        checkScaleOverFlow(diffScale)

        if (diffScale > 0) {
            resValue = this._value + ailgnBigValue(d.value, diffScale)
        } else {
            resValue = d.value + ailgnBigValue(this._value, -diffScale)
            valScale = d.scale
        }
        valPrecision = calcNumberOfDigits(resValue)
        return Decimal(resValue, valScale, valPrecision)
    }














    public operator func +(d: Decimal): Decimal {
        return this.add(d)
    }













    func sub(d: Decimal): Decimal {
        return this.add(d.neg())
    }

    public operator func -(d: Decimal): Decimal {
        return this.add(d.neg())
    }













    func mul(d: Decimal): Decimal {
        let resScale: Int32 = checkScaleOverFlow(Int64(this._scale) + Int64(d.scale))

        if (this._sign == 0 || d.sign == 0) {
            return Decimal(BIGINT_ZERO, resScale, 1)
        }

        let resValue: BigInt = this._value * d.value
        let resPrecision: Int64 = calcNumberOfDigits(resValue)
        return Decimal(resValue, resScale, resPrecision)
    }

    public operator func *(d: Decimal): Decimal {
        return this.mul(d)
    }

    func mul(d: Decimal, precision: Int64, roundingMode: RoundingMode) {
        var resScale: Int32 = checkScaleOverFlow(Int64(this._scale) + Int64(d.scale))

        if (this._sign == 0 || d.sign == 0) {
            return Decimal(BIGINT_ZERO, resScale, 1)
        }

        var resValue: BigInt = this._value * d.value
        var resPrecision: Int64 = calcNumberOfDigits(resValue)
        if (precision != 0 && resPrecision > precision) {
            var roundPrecision: Int64 = resPrecision - precision
            while (roundPrecision > 0) {
                resScale = checkScaleOverFlow(Int64(resScale) - roundPrecision)
                resValue = doRoundWithCtx(resValue, roundPrecision, roundingMode)
                resPrecision = calcNumberOfDigits(resValue)
                roundPrecision = resPrecision - precision
            }
        }
        return Decimal(resValue, resScale, resPrecision)
    }


















    func div(d: Decimal): Decimal {
        divWithContext(d, RoundingMode.HalfEven)
    }

    public operator func /(d: Decimal): Decimal {
        return this.div(d)
    }















    public func divWithPrecision(d: Decimal, precision: Int64, roundingMode!: RoundingMode = HalfEven): Decimal {
        if (precision == 0) {
            return divWithContext(d, roundingMode)
        }
        if (d.sign == 0) {
            throw ArithmeticException("Divided by zero!")
        }
        let expectedScale: Int64 = Int64(this.scale) - Int64(d.scale)
        if (this.sign == 0) {
            return Decimal(BIGINT_ZERO, saturateI32(expectedScale), 1)
        }

        return div(this, d, expectedScale, precision, roundingMode, false)
    }

    @Deprecated[message: "Use member function `public func divAndMod(d: Decimal): (BigInt, Decimal)` instead."]
    public func divAndRem(d: Decimal): (BigInt, Decimal) {
        return divAndMod(d)
    }













    public func divAndMod(d: Decimal): (BigInt, Decimal) {
        var qu = this.divForRem(d)
        let re = this.sub(qu.mul(d))
        if (qu.scale == 0) {
            return (qu.value, re)
        } else {
            qu = qu.reScale(0, roundingMode: RoundingMode.HalfEven)
            return (qu.value, re)
        }
    }








    func neg(): Decimal {
        return Decimal(-(this._value), this._scale, this._precision)
    }

    public operator func -(): Decimal {
        return this.neg()
    }








    public func shiftPoint(n: Int32): Decimal {
        if (n == 0) {
            return this
        }

        let reScale = checkScaleOverFlow(Int64(this.scale) + Int64(n))
        if (this.sign == 0 && reScale <= 0) {
            return Decimal(BigInt("0"), 0, 1)
        }
        return Decimal(this.value, reScale, this.precision)
    }










    public func roundWithPrecision(precision: Int64, roundingMode!: RoundingMode = RoundingMode.HalfEven): Decimal {
        if (precision == 0 || precision >= this.precision) {
            return this
        }
        var unscaledValue: BigInt = this.value
        var roundPrecision: Int64 = this.precision - precision
        var reScale: Int32 = this.scale
        var rePrecision = this.precision
        while (roundPrecision > 0) {
            reScale = checkScaleOverFlow(Int64(reScale) - roundPrecision)
            unscaledValue = doRoundWithCtx(unscaledValue, roundPrecision, roundingMode)
            rePrecision = calcNumberOfDigits(unscaledValue)
            roundPrecision = rePrecision - precision
        }

        return Decimal(unscaledValue, reScale, rePrecision)
    }








    public operator func <(d: Decimal): Bool {
        return match (this.compare(d)) {
            case Ordering.LT => true
            case _ => false
        }
    }








    public operator func >(d: Decimal): Bool {
        return match (this.compare(d)) {
            case Ordering.GT => true
            case _ => false
        }
    }








    public operator func <=(d: Decimal): Bool {
        return match (this.compare(d)) {
            case Ordering.GT => false
            case _ => true
        }
    }








    public operator func >=(d: Decimal): Bool {
        return match (this.compare(d)) {
            case Ordering.LT => false
            case _ => true
        }
    }








    public operator func ==(d: Decimal): Bool {
        return match (this.compare(d)) {
            case Ordering.EQ => true
            case _ => false
        }
    }








    public operator func !=(d: Decimal): Bool {
        return match (this.compare(d)) {
            case Ordering.EQ => false
            case _ => true
        }
    }








    public func compare(d: Decimal): Ordering {
        if (this.sign == 0 && this.sign == d.sign) {
            return Ordering.EQ
        }

        if (this.sign * d.sign <= 0) {
            if (this.sign > d.sign) {
                return Ordering.GT
            } else {
                return Ordering.LT
            }
        }
        let precisionDiff1: Int64 = this.precision - Int64(this.scale)
        let precisionDiff2: Int64 = d.precision - Int64(d.scale)
        if (precisionDiff1 > precisionDiff2) {
            if (this.sign > 0) {
                return Ordering.GT
            }
            return Ordering.LT
        } else if (precisionDiff1 < precisionDiff2) {
            if (this.sign > 0) {
                return Ordering.LT
            }
            return Ordering.GT
        }

        let diffScale = Int64(this._scale) - Int64(d.scale)
        checkScaleOverFlow(diffScale)

        if (diffScale == 0) {
            return this.value.compare(d.value)
        }

        if (diffScale > 0) {
            return this.value.compare(ailgnBigValue(d.value, diffScale))
        }
        return ailgnBigValue(this.value, -diffScale).compare(d.value)
    }













    func pow(n: Int64): Decimal {
        if (n == 0) {
            return Decimal(BIGINT_ONE, 0)
        }
        if ((Int64(Int32.Min) > n || (Int64(Int32.Max) + 1) < n) && this._scale != 0) {
            throw OverflowException("Scale overflow during calculation.")
        }
        let newScl: Int32 = if (this.scale == 0 || n == Int64.Min) {
            0
        } else {
            checkScaleOverFlow(Int64(this._scale) * abs(n))
        }
        let bi: BigInt = this._value ** toUInt64(n)
        if (n >= 0) {
            return Decimal(bi, newScl)
        } else {
            return Decimal(BIGINT_ONE, 0).div(Decimal(bi, newScl))
        }
    }

    public operator func **(n: Int64): Decimal {
        return this.pow(n)
    }














    public func powWithPrecision(n: Int64, precision: Int64, roundingMode!: RoundingMode = RoundingMode.HalfEven): Decimal {
        if (n == 0) {
            return Decimal(BIGINT_ONE, 0)
        }
        if (precision == 0) {
            return this.pow(n)
        }
        var exponent: UInt64 = toUInt64(n)
        var newPre: Int64 = if (precision > 0) {
            let len = calcNumberOfDigits(exponent)
            precision + len + 1
        } else {
            precision
        }
        var y: Decimal = Decimal(BIGINT_ONE, 0)
        var z: Decimal = this
        while (exponent != 0) {
            if ((exponent & 1) == 1) {
                y = z.mul(y, newPre, roundingMode)
            }
            z = z.mul(z, newPre, roundingMode)
            exponent = exponent >> 1
        }
        if (n >= 0) {
            return y.roundWithPrecision(precision, roundingMode: roundingMode)
        } else {
            return Decimal(BIGINT_ONE, 0).divWithPrecision(y, precision, roundingMode: roundingMode)
        }
    }














    public func sqrtWithPrecision(precision: Int64, roundingMode!: RoundingMode = RoundingMode.HalfEven): Decimal {
        if (this._sign == 0) {
            return Decimal(BIGINT_ZERO, this._scale >> 1)
        }
        if (this._sign < 0) {
            throw IllegalArgumentException("Negative decimal cannot be squared.")
        }
        let expectedScale: Int32 = this._scale / 2
        var formattedScale: Int32 = checkScaleOverFlow(Int64(this._scale) - this._precision + 1)
        if (formattedScale % 2 != 0) {
            formattedScale = checkScaleOverFlow(Int64(formattedScale) - 1)
        }
        let format: Decimal = Decimal(this._value, checkScaleOverFlow(Int64(this._scale) - Int64(formattedScale)),
            this._precision)
        var ctxPre: Int64 = precision
        let expectedPre: Int64 = if (ctxPre == 0) {
            this._precision / 2 + 1
        } else {
            match (roundingMode) {
                case HalfUp | HalfEven =>
                    if (ctxPre <= (Int64.Max >> 1)) {
                        ctxPre * 2
                    } else {
                        Int64.Max - 2
                    }
                case _ => ctxPre
            }
        }
        var x: Decimal = Decimal(sqrt(Float64.parse(format.toString())))
        var xPre: Int64 = 10
        let fmPre: Int64 = format._precision
        do {
            let temPre = max(max(xPre, expectedPre + 2), fmPre)
            x = Decimal(BigInt("5"), 1).mul(x.add(format.divWithPrecision(x, temPre, roundingMode: HalfEven)), temPre,
                HalfEven)
            xPre *= 2
        } while (xPre < expectedPre + 2)
        var res: Decimal
        if (ctxPre == 0) {
            res = if (expectedPre == 0) {
                Decimal(x._value, checkScaleOverFlow(Int64(x._scale) - Int64(-formattedScale / 2)), x._precision)
            } else {
                Decimal(x.value, checkScaleOverFlow(Int64(x._scale) - Int64(-formattedScale / 2)), x._precision)
                    .roundWithPrecision(expectedPre, roundingMode: roundingMode)
            }
            if (this.sub(res.pow(2)).compare(Decimal(BIGINT_ZERO, 0)) != EQ) {
                return this.sqrtWithPrecision(34, roundingMode: HalfEven)
            }
        } else {
            res = if (expectedPre == 0) {
                Decimal(x._value, checkScaleOverFlow(Int64(x._scale) - Int64(-formattedScale / 2)), x._precision)
            } else {
                Decimal(x._value, checkScaleOverFlow(Int64(x._scale) - Int64(-formattedScale / 2)), x._precision)
                    .roundWithPrecision(precision, roundingMode: roundingMode)
            }
        }
        if (res.scale != expectedScale) {
            res = (res
                .removeExtraZero(res.value, res.scale, expectedScale)
                .add(Decimal(BIGINT_ZERO, expectedScale)))
                .roundWithPrecision(precision, roundingMode: roundingMode)
        }
        return res
    }







    @OverflowWrapping
    public func hashCode(): Int64 {
        let rmvTrailingZerosDecimal = this.removeTrailingZeros()
        return 31 * rmvTrailingZerosDecimal.value.hashCode() + Int64(rmvTrailingZerosDecimal.scale)
    }







    public func toString(): String {
        if (this._scale == 0) {
            return this._value.toString()
        }

        let unscaleValStrArr = this._value.toString().toArray()
        if (this._scale < 0) {
            if (this._sign == 0) {
                return "0"
            }

            let appTailZeroNum = Int64(-this._scale)
            var decimalStrArr: Array<Byte> = Array<Byte>(unscaleValStrArr.size + appTailZeroNum, repeat: b'0')
            unscaleValStrArr.copyTo(decimalStrArr, 0, 0, unscaleValStrArr.size)
            return String.fromUtf8(decimalStrArr)
        }
        let decimalPointIndex = this._precision - Int64(this._scale)

        let decimalStrArr: Array<Byte>
        if (decimalPointIndex == 0) {
            decimalStrArr = Array<Byte>(unscaleValStrArr.size + 2, repeat: b'0')
            if (unscaleValStrArr[0] == b'-') {
                unscaleValStrArr.copyTo(decimalStrArr, 0, 0, 1)
                decimalStrArr[2] = b'.'
                unscaleValStrArr.copyTo(decimalStrArr, 1, 3, unscaleValStrArr.size - 1)
            } else {
                decimalStrArr[1] = b'.'
                unscaleValStrArr.copyTo(decimalStrArr, 0, 2, unscaleValStrArr.size)
            }
        } else if (decimalPointIndex > 0) {
            decimalStrArr = Array<Byte>(unscaleValStrArr.size + 1, repeat: b'0')
            if (unscaleValStrArr[0] == b'-') {
                unscaleValStrArr.copyTo(decimalStrArr, 0, 0, decimalPointIndex + 1)
                decimalStrArr[decimalPointIndex + 1] = b'.'
                unscaleValStrArr.copyTo(decimalStrArr, decimalPointIndex + 1, decimalPointIndex + 2, Int64(this._scale))
            } else {
                unscaleValStrArr.copyTo(decimalStrArr, 0, 0, decimalPointIndex)
                decimalStrArr[decimalPointIndex] = b'.'
                unscaleValStrArr.copyTo(decimalStrArr, decimalPointIndex, decimalPointIndex + 1, Int64(this._scale))
            }
        } else {
            decimalStrArr = Array<Byte>(unscaleValStrArr.size + abs(decimalPointIndex) + 2, repeat: b'0')
            if (unscaleValStrArr[0] == b'-') {
                decimalStrArr[0] = b'-'
                decimalStrArr[2] = b'.'
                unscaleValStrArr.copyTo(decimalStrArr, 1, abs(decimalPointIndex) + 3, unscaleValStrArr.size - 1)
            } else {
                decimalStrArr[1] = b'.'
                unscaleValStrArr.copyTo(decimalStrArr, 0, abs(decimalPointIndex) + 2, unscaleValStrArr.size)
            }
        }

        return String.fromUtf8(decimalStrArr)
    }














    public func reScale(newScale: Int32, roundingMode!: RoundingMode = HalfEven): Decimal {
        let oldScale = this.scale
        if (newScale == oldScale) {
            return this
        }
        if (this.sign == 0) {
            return Decimal(BIGINT_ZERO, newScale, 1)
        }
        if (newScale > oldScale) {
            let raise = checkScaleOverFlow(Int64(newScale) - Int64(oldScale))
            let bd: BigInt = ailgnBigValue(this.value, Int64(raise))
            return Decimal(bd, newScale)
        } else {
            let drop = checkScaleOverFlow(Int64(oldScale) - Int64(newScale))
            return divideAndRound(this.value, tenPowerN(Int64(drop)), newScale, roundingMode, newScale, false)
        }
    }








    public func removeTrailingZeros(): Decimal {
        if (this.sign == 0) {
            return Decimal(BigInt("0"), 0, 1)
        }

        var unscaledValue = this.value
        var scl = scale
        var (quotient, remainder): (BigInt, BigInt)
        while (unscaledValue.compareMagnitude(BIGINT_TEN) >= 0) {
            if (unscaledValue.testBit(0)) {
                break
            }
            (quotient, remainder) = unscaledValue.quoAndRem(BIGINT_TEN)
            if (remainder.sign != 0) {
                break
            }
            unscaledValue = quotient
            scl = checkScaleOverFlow(Int64(scl) - 1)
        }
        return Decimal(unscaledValue, scl)
    }






    public func scaleUnit(): Decimal {
        return Decimal(BIGINT_ONE, this.scale, 1)
    }






    public func isInteger(): Bool {
        if (this.sign == 0 || this.scale <= 0) {
            return true
        }

        var unscaledValue = this.value
        var scl = this.scale
        while (scl > 0) {
            if (this.value.testBit(0)) {
                return false
            }

            let (quotient, remainder): (BigInt, BigInt) = unscaledValue.quoAndRem(BIGINT_TEN)

            if (remainder.sign != 0) {
                return false
            }
            unscaledValue = quotient
            scl--
        }
        return true
    }











    public func toInt8(overflowHandling!: OverflowStrategy = Throwing): Int8 {
        if (this.sign == 0 || Int64(this.scale) >= this.precision || this.scale <= -8) {
            return 0
        }

        return this.toBigInt().toInt8(overflowHandling: overflowHandling)
    }











    public func toInt16(overflowHandling!: OverflowStrategy = Throwing): Int16 {
        if (this.sign == 0 || Int64(this.scale) >= this.precision || this.scale <= -16) {
            return 0
        }

        return this.toBigInt().toInt16(overflowHandling: overflowHandling)
    }











    public func toInt32(overflowHandling!: OverflowStrategy = Throwing): Int32 {
        if (this.sign == 0 || Int64(this.scale) >= this.precision || this.scale <= -32) {
            return 0
        }

        return this.toBigInt().toInt32(overflowHandling: overflowHandling)
    }











    public func toInt64(overflowHandling!: OverflowStrategy = Throwing): Int64 {
        if (this.sign == 0 || Int64(this.scale) >= this.precision || this.scale <= -64) {
            return 0
        }

        return this.toBigInt().toInt64(overflowHandling: overflowHandling)
    }











    public func toIntNative(overflowHandling!: OverflowStrategy = Throwing): IntNative {
        var nativeLen = 64
        if (Int64(IntNative.Max) == Int64(Int32.Max)) {
            nativeLen = 32
        }

        if (this.sign == 0 || Int64(this.scale) >= this.precision || Int64(this.scale) <= -nativeLen) {
            return 0
        }

        return this.toBigInt().toIntNative(overflowHandling: overflowHandling)
    }











    public func toUInt8(overflowHandling!: OverflowStrategy = Throwing): UInt8 {
        if (this.sign == 0 || Int64(this.scale) >= this.precision || this.scale <= -8) {
            return 0
        }

        return this.toBigInt().toUInt8(overflowHandling: overflowHandling)
    }











    public func toUInt16(overflowHandling!: OverflowStrategy = Throwing): UInt16 {
        if (this.sign == 0 || Int64(this.scale) >= this.precision || this.scale <= -16) {
            return 0
        }

        return this.toBigInt().toUInt16(overflowHandling: overflowHandling)
    }











    public func toUInt32(overflowHandling!: OverflowStrategy = Throwing): UInt32 {
        if (this.sign == 0 || Int64(this.scale) >= this.precision || this.scale <= -32) {
            return 0
        }

        return this.toBigInt().toUInt32(overflowHandling: overflowHandling)
    }











    public func toUInt64(overflowHandling!: OverflowStrategy = Throwing): UInt64 {
        if (this.sign == 0 || Int64(this.scale) >= this.precision || this.scale <= -64) {
            return 0
        }

        return this.toBigInt().toUInt64(overflowHandling: overflowHandling)
    }











    public func toUIntNative(overflowHandling!: OverflowStrategy = Throwing): UIntNative {
        var nativeLen = 64
        if (Int64(IntNative.Max) == Int64(Int32.Max)) {
            nativeLen = 32
        }

        if (this.sign == 0 || Int64(this.scale) >= this.precision || Int64(this.scale) <= -nativeLen) {
            return 0
        }

        return this.toBigInt().toUIntNative(overflowHandling: overflowHandling)
    }







    public func toBigInt(): BigInt {
        if (this.sign == 0 || Int64(this.scale) >= this.precision) {
            return BIGINT_ZERO
        }

        return reScale(0, roundingMode: RoundingMode.Down).value
    }








    public func toFloat16(): Float16 {
        if (this.scale <= 0 && this.precision - Int64(this.scale) <= 18) {
            if (this.sign > 0) {
                return Float16(this.toUInt64())
            } else {
                return Float16(this.toInt64())
            }
        }

        return Float16.parse(this.toSciString())
    }








    public func toFloat32(): Float32 {
        if (this.scale <= 0 && this.precision - Int64(this.scale) <= 18) {
            if (this.sign > 0) {
                return Float32(this.toUInt64())
            } else {
                return Float32(this.toInt64())
            }
        }

        return Float32.parse(this.toSciString())
    }








    public func toFloat64(): Float64 {
        if (this.scale <= 0 && this.precision - Int64(this.scale) <= 18) {
            if (this.sign > 0) {
                return Float64(this.toUInt64())
            } else {
                return Float64(this.toInt64())
            }
        }

        return Float64.parse(this.toSciString())
    }







    public func toEngString(): String {
        let valArr: Array<Byte> = abs(this.value).toString().toArray()
        var resultExponent: Int64 = this.precision - 1 - Int64(this.scale)
        var significantDigit = resultExponent % 3
        if (significantDigit < 0) {
            significantDigit = significantDigit + 3
        }
        resultExponent = resultExponent - significantDigit
        significantDigit++
        let stringBuilder: StringBuilder = StringBuilder()
        if (this.sign < 0) {
            stringBuilder.append(r'-')
        }
        if (this.sign == 0) {
            match (significantDigit) {
                case 1 => stringBuilder.append("0")
                case 2 =>
                    stringBuilder.append("0.00")
                    resultExponent = resultExponent + 3
                case 3 =>
                    stringBuilder.append("0.0")
                    resultExponent = resultExponent + 3
                case _ => throw IllegalArgumentException("Unexpected significant digit value: ${significantDigit}.")
            }
        } else if (significantDigit > this.precision) {
            stringBuilder.append(String.fromUtf8(valArr))
            for (_ in 0..(significantDigit - this.precision)) {
                stringBuilder.append(r'0')
            }
        } else {
            stringBuilder.append(String.fromUtf8(valArr[..significantDigit]))
            if (this.precision > significantDigit) {
                stringBuilder.append(r'.')
                stringBuilder.append(String.fromUtf8(valArr[significantDigit..valArr.size]))
            }
        }

        stringBuilder.append(r'E')
        stringBuilder.append(resultExponent)
        return stringBuilder.toString()
    }







    public func toSciString(): String {
        let valArr: Array<Byte> = abs(this.value).toString().toArray()
        let resultExponent: Int64 = this.precision - 1 - Int64(this.scale)
        let stringBuilder: StringBuilder = StringBuilder()
        if (this.sign < 0) {
            stringBuilder.append(r'-')
        }
        stringBuilder.append(Rune(UInt32(valArr[0])))
        if (this.precision > 1) {
            stringBuilder.append(r'.')
            stringBuilder.append(String.fromUtf8(valArr[1..valArr.size]))
        }

        stringBuilder.append(r'E')
        stringBuilder.append(resultExponent)
        return stringBuilder.toString()
    }

    private func div(
        dividend: Decimal,
        divisor: Decimal,
        expectedScale: Int64,
        cpn: Int64,
        roundingMode: RoundingMode,
        needDegenerate: Bool
    ): Decimal {
        let eScl: Int32 = checkScaleOverFlow(expectedScale)
        let bdividend: BigInt = dividend.value
        let bdivisor: BigInt = divisor.value
        let dScl: Int64 = dividend.precision
        var sScl: Int64 = divisor.precision
        if (compareBySamePrecision(bdividend, dScl, bdivisor, sScl) > 0) {
            sScl -= 1
        }
        let scl = checkScaleOverFlow(expectedScale + sScl - dScl + cpn)
        let res: Decimal = if (checkScaleOverFlow(cpn + sScl - dScl) > 0) {
            let raise = checkScaleOverFlow(cpn + sScl - dScl)
            let bd = ailgnBigValue(bdividend, Int64(raise))
            divideAndRound(bd, bdivisor, scl, roundingMode, eScl, needDegenerate)
        } else {
            let newScale = checkScaleOverFlow(dScl - cpn)
            let raise = checkScaleOverFlow(Int64(newScale) - sScl)
            let bd = ailgnBigValue(bdivisor, Int64(raise))
            divideAndRound(bdividend, bd, scl, roundingMode, eScl, needDegenerate)
        }
        return res.roundWithPrecision(cpn, roundingMode: roundingMode)
    }

    private func divideAndRound(
        dividend: BigInt,
        divisor: BigInt,
        scale: Int32,
        rdm: RoundingMode,
        expectedScale: Int32,
        needDegenerate: Bool
    ): Decimal {
        let (qu, re) = dividend.divAndMod(divisor)
        if (re.sign != 0) {
            if (needDegenerate) {
                throw PrecisionMismatchException()
            }
            let resSign = if (dividend.sign != divisor.sign) {
                -1
            } else {
                1
            }
            if (needIncrement(divisor, rdm, resSign, qu, re)) {
                let (qint, qintArr) = addOneAndOverSize(qu.int, qu.intArr)
                let bigSign = resSign <= 0
                return Decimal(BigInt(qint, qintArr, bigSign), scale)
            }
        } else {
            if (expectedScale != scale) {
                return removeExtraZero(qu, scale, expectedScale)
            }
        }
        return Decimal(qu, scale)
    }

    func removeExtraZero(v: BigInt, scale: Int32, expectedScale: Int32): Decimal {
        var bd = v
        var scl = scale
        var (qu, re): (BigInt, BigInt)
        while (bd.compareMagnitude(BIGINT_TEN) >= 0 && scl > expectedScale) {
            if (bd.testBit(0)) {
                break
            }
            (qu, re) = bd.quoAndRem(BIGINT_TEN)
            if (re.sign != 0) {
                break
            }
            bd = qu
            scl = checkScaleOverFlow(Int64(scl) - 1)
        }
        return Decimal(bd, scl)
    }

    private func needIncrement(divisor: BigInt, rdm: RoundingMode, qsign: Int64, qu: BigInt, re: BigInt): Bool {
        let cmpDouble = divisor.compareDouble(re)
        return needCarry(rdm, qsign, cmpDouble, qu.isOdd())
    }

    private func checkPrecisionOverFlow(arr: Array<Int64>): Int64 {
        try {
            var sum: Int64 = Int64(ceil(Float64(arr[0]) / 3.0f64 * 10.0f64))
            for (i in arr[1..]) {
                sum += i
            }
            return sum
        } catch (e: OverflowException) {
            return Int64.Max
        }
    }

    private func compareBySamePrecision(x: BigInt, xscale: Int64, y: BigInt, yscale: Int64): Int64 {
        let diff = xscale - yscale
        if (diff < 0) {
            return ailgnBigValue(x, -diff).compareMagnitude(y)
        } else {
            return x.compareMagnitude(ailgnBigValue(y, diff))
        }
    }

    @OverflowSaturating
    private func saturateI32(scale: Int64): Int32 {
        return Int32(scale)
    }

    private func divForRem(d: Decimal): Decimal {
        let expectedScale: Int32 = saturateI32(Int64(this._scale) - Int64(d.scale))
        if (this.compareAbsolute(d) < 0) {
            return Decimal(BIGINT_ZERO, expectedScale, 1)
        }
        var tempPre = checkPrecisionOverFlow(d.precision, this.precision, abs(Int64(this.scale) - Int64(d.scale)), 2)
        var res: Decimal = this.divWithPrecision(d, tempPre, roundingMode: RoundingMode.Down)
        if (res.scale > 0) {
            res = res.reScale(0, roundingMode: RoundingMode.Down)
            res = removeExtraZero(res.value, 0, expectedScale)
        }
        if (res.scale < expectedScale) {
            res = res.reScale(expectedScale, roundingMode: RoundingMode.HalfEven)
        }
        return res
    }

    @OverflowThrowing
    private func compareAbsolute(d: Decimal): Int64 {
        if (this.sign == 0 && this.sign == d.sign) {
            return 0
        }

        if (this.sign * d.sign == 0) {
            if (d.sign == 0) {
                return 1
            }
            return -1
        }
        let precisionDiff1: Int64 = this.precision - Int64(this.scale)
        let precisionDiff2: Int64 = d.precision - Int64(d.scale)
        if (precisionDiff1 > precisionDiff2) {
            return 1
        } else if (precisionDiff1 < precisionDiff2) {
            return -1
        }

        let diffScale = Int64(this._scale) - Int64(d.scale)
        checkScaleOverFlow(diffScale)

        if (diffScale == 0) {
            return this.value.compareMagnitude(d.value)
        }

        if (diffScale > 0) {
            return this.value.compareMagnitude(ailgnBigValue(d.value, Int64(diffScale)))
        }
        return ailgnBigValue(this.value, -diffScale).compareMagnitude(d.value)
    }

    private func divWithContext(d: Decimal, rdm: RoundingMode): Decimal {
        if (d.sign == 0) {
            throw ArithmeticException("Divided by zero!")
        }
        let expectedScale: Int32 = saturateI32(Int64(this.scale) - Int64(d.scale))
        if (this.sign == 0) {
            return Decimal(BIGINT_ZERO, expectedScale, 1)
        } else {
            let cpn = checkPrecisionOverFlow(d._precision, this._precision)

            var res: Decimal
            try {
                res = div(this, d, Int64(expectedScale), cpn, rdm, true)
                if (expectedScale > res.scale) {
                    res = reScale(expectedScale, roundingMode: rdm)
                }
            } catch (e: PrecisionMismatchException) {
                res = div(
                    this,
                    d,
                    Int64(expectedScale),
                    34,
                    rdm,
                    false
                )
            }
            return res
        }
    }
}

func parseExponent(val: String, offset: Int64): Int64 {
    var isPositive = true
    var expOffset = offset
    expOffset++
    if (expOffset >= val.size) {
        throw IllegalArgumentException("String value not allow without digits after e.")
    }
    if (val[expOffset] == b'-') {
        isPositive = false
        expOffset++
    } else if (val[expOffset] == b'+') {
        expOffset++
    }
    if (expOffset >= val.size) {
        throw IllegalArgumentException("String value not allow without digits after e.")
    }

    var exponent: Int64 = 0
    while (expOffset < val.size && val[expOffset] == b'0') {
        expOffset++
    }
    if (val.size - expOffset > 10) {
        throw OverflowException("Exponent overflow.")
    }

    while (expOffset < val.size) {
        let c = val[expOffset]
        if (c >= b'0' && c <= b'9') {
            exponent = exponent * 10 + Int64((c - b'0'))
            expOffset++
        } else {
            throw IllegalArgumentException(
                "String exponent value not allow contains other character beyond [digit, sign].")
        }
    }

    if (!isPositive) {
        exponent = -exponent
    }

    if (Int64(Int32(exponent)) != exponent) {
        throw OverflowException("Exponent overflow.")
    }

    return exponent
}

func checkScaleOverFlow(scale: Int64): Int32 {
    try {
        return Int32(scale)
    } catch (e: OverflowException) {
        throw OverflowException("Scale overflow during calculation.")
    }
}

@OverflowWrapping
func checkAndRtnScale(scale: Int32, adjustScale: Int64): Int32 {
    let newScale = Int64(scale) - adjustScale
    if (Int64(Int32(newScale)) != newScale) {
        throw OverflowException("Scale overflow.")
    }
    return Int32(newScale)
}

func doRoundWithCtx(val_bigint: BigInt, roundPrecision: Int64, roundingMode: RoundingMode): BigInt {
    let tenPowerDivisior = tenPowerN(roundPrecision)
    let (quotient, remainder): (BigInt, BigInt) = val_bigint.divAndMod(tenPowerDivisior)
    if (remainder.sign != 0) {
        if (needCarry(roundingMode, val_bigint.sign, (remainder << 1).compareMagnitude(tenPowerDivisior),
            quotient.testBit(0))) {
            if (quotient.sign >= 0) {
                return quotient + BIGINT_ONE
            }
            return quotient - BIGINT_ONE
        }
    }
    return quotient
}

func calcNumberOfDigits(val_bigint: BigInt): Int64 {
    if (val_bigint.sign == 0) {
        return 1
    }

    var digitCount = Int64((log10(2.0f64) * Float64(val_bigint.bitLen) + 1.0))
    if (digitCount - 1 < BIGINT_TENTH_POWER_ARRAY.size) {
        if (BIGINT_TENTH_POWER_ARRAY[digitCount - 1].compareMagnitude(val_bigint) > 0) {
            return digitCount - 1
        }
        return digitCount
    }

    if ((BIGINT_TEN ** UInt64(digitCount - 1)).compareMagnitude(val_bigint) > 0) {
        return digitCount - 1
    }
    return digitCount
}

func calcNumberOfDigits(value: UInt64): Int64 {
    if (value == 0) {
        return 1
    }

    var valueNumCount = 0
    while (valueNumCount < UINT64_TENTH_POWER_ARRAY.size && value >= UINT64_TENTH_POWER_ARRAY[valueNumCount]) {
        valueNumCount++
    }
    return valueNumCount
}

func calcNumberOfDigits(value: Int64): Int64 {
    return calcNumberOfDigits(toUInt64(value))
}

func toUInt64(i64: Int64): UInt64 {
    if (i64 == Int64.Min) {
        return 0x8000000000000000u64
    }

    return UInt64(abs(i64))
}

func tenPowerN(n: Int64): BigInt {
    if (n < 0) {
        return BIGINT_ZERO
    }

    let tenPowerValue: BigInt
    if (n < BIGINT_TENTH_POWER_ARRAY.size) {
        tenPowerValue = BIGINT_TENTH_POWER_ARRAY[n]
    } else {
        tenPowerValue = BIGINT_TEN ** UInt64(n)
    }

    return tenPowerValue
}









func needCarry(roundingMode: RoundingMode, sign: Int64, halfFlag: Int64, isOdd: Bool): Bool {
    match (roundingMode) {
        case Up => true
        case Down => false
        case Ceiling => sign > 0
        case Floor => sign < 0
        case HalfUp => return halfFlag >= 0
        case HalfEven =>
            if (halfFlag > 0) {
                return true
            } else if (halfFlag < 0) {
                return false
            } else {
                return isOdd
            }
    }
}

func parseFloat32Bits(f32Bits: Int32): (Int32, Int32, Int32) {
    let sign: Int32
    if ((f32Bits >> 31) == 0) {
        sign = 1
    } else {
        sign = -1
    }
    let E: Int32 = (f32Bits >> 23) & 0xff
    var fraction: Int32
    if (E == 0) {
        fraction = (f32Bits & 0x7fffff) << 1
    } else {
        fraction = (f32Bits & 0x7fffff) | 0x800000
    }
    let exponent = E - 150

    return (sign, exponent, fraction)
}

func parseFloat64Bits(f64Bits: Int64): (Int64, Int64, Int64) {
    let sign: Int64
    if ((f64Bits >> 63) == 0) {
        sign = 1
    } else {
        sign = -1
    }
    let E: Int64 = (f64Bits >> 52) & 0x7ff
    var fraction: Int64
    if (E == 0) {
        fraction = (f64Bits & 0xfffffffffffff) << 1
    } else {
        fraction = (f64Bits & 0xfffffffffffff) | 0x10000000000000
    }
    let exponent = E - 1075

    return (sign, exponent, fraction)
}

func ailgnBigValue(val: BigInt, diffScale: Int64): BigInt {
    if (diffScale <= 0) {
        return val
    }

    return val * tenPowerN(diffScale)
}

class PrecisionMismatchException <: Exception {
    public init() {
        super()
    }

    public init(message: String) {
        super(message)
    }

    protected override func getClassName(): String {
        return "PrecisionMismatchException"
    }
}









public func abs(d: Decimal): Decimal {
    return Decimal(abs(d.value), d.scale, d.precision)
}










public func round(d: Decimal, roundingMode!: RoundingMode = RoundingMode.HalfEven): Decimal {
    if (Int64(d.scale) >= d.precision) {
        return d.reScale(0, roundingMode: roundingMode)
    }

    let roundingPre = d.precision - Int64(d.scale)
    return d.roundWithPrecision(roundingPre, roundingMode: roundingMode)
}
















public func sqrt(d: Decimal): Decimal {
    if (d.sign == 0) {
        return Decimal(BIGINT_ZERO, d.scale >> 1)
    }
    if (d.sign < 0) {
        throw IllegalArgumentException("Negative decimal cannot be squared.")
    }
    let expectedScale: Int32 = d.scale / 2
    var formattedScale: Int32 = checkScaleOverFlow(Int64(d.scale) - d.precision + 1)
    if (formattedScale % 2 != 0) {
        formattedScale = checkScaleOverFlow(Int64(formattedScale) - 1)
    }
    let format: Decimal = Decimal(d.value, checkScaleOverFlow(Int64(d.scale) - Int64(formattedScale)), d.precision)

    let expectedPre: Int64 = d.precision / 2 + 1

    var x: Decimal = Decimal(sqrt(Float64.parse(format.toString())))
    var xPre: Int64 = 10
    let fmPre: Int64 = format.precision
    do {
        let temPre = max(max(xPre, expectedPre + 2), fmPre)
        x = Decimal(BigInt("5"), 1).mul(x.add(format.divWithPrecision(x, temPre, roundingMode: HalfEven)))
        xPre *= 2
    } while (xPre < expectedPre + 2)
    var res: Decimal
    res = if (expectedPre == 0) {
        Decimal(x.value, checkScaleOverFlow(Int64(x.scale) - Int64(-formattedScale / 2)), x.precision)
    } else {
        Decimal(x.value, checkScaleOverFlow(Int64(x.scale) - Int64(-formattedScale / 2)), x.precision)
            .roundWithPrecision(expectedPre)
    }
    if (d.sub(res.pow(2)).compare(Decimal(BIGINT_ZERO, 0)) != EQ) {
        return d.sqrtWithPrecision(34, roundingMode: RoundingMode.HalfEven)
    }
    if (res.scale != expectedScale) {
        res = res.removeExtraZero(res.value, res.scale, expectedScale).add(Decimal(BIGINT_ZERO, expectedScale))
    }
    return res
}

extend Decimal <: Number<Decimal> {}
