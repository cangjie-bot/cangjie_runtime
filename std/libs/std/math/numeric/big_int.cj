







package std.math.numeric

import std.convert.*
import std.math.*
import std.random.*

const DIGIT_DIFF: UInt8 = 0x30
const LETTER_UPPER_DIFF: UInt8 = 0x41 - 0x0A
const LETTER_LOWER_DIFF: UInt8 = 0x61 - 0x0A
let EMPTY_ARRAY: Array<UInt32> = Array<UInt32>()

public struct BigInt <: Comparable<BigInt> & Hashable & ToString {







    public prop sign: Int64 {
        /*
         * @noThrow
         */
        get() {
            if (int == 0 && intArr.size == 0) {
                return 0
            }
            return if (negSign) {
                -1
            } else {
                1
            }
        }
    }






    public prop bitLen: Int64 {
        /*
         * @throws IndexOutOfBoundsException
         */
        get() {
            if (sign == 0) {
                return 1
            }
            if (negSign) {
                let oneMore = if (isPowerOfTwo()) {
                    0
                } else {
                    1
                }
                if (intArr.size == 0) {
                    if (int == 1) {
                        return 2
                    }
                    return Int64(64 - leadingZeros(int)) + oneMore
                } else {
                    return 32 * intArr.size - Int64(leadingZeros(intArr[intArr.size - 1])) + 64 + oneMore
                }
            } else {
                if (intArr.size == 0) {
                    return Int64(64 - leadingZeros(int))
                } else {
                    return 32 * intArr.size - Int64(leadingZeros(intArr[intArr.size - 1])) + 64
                }
            }
        }
    }

    /*
     * @noThrow
     */
    BigInt(
        let int: UInt64,
        let intArr: Array<UInt32>,
        let negSign: Bool
    ) {}









    /*
     * @throws ArithmeticException
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    public static func randomProbablePrime(bitLen: Int64, certainty: UInt64, rand!: Random = Random()): BigInt {
        if (bitLen <= 1) {
            throw IllegalArgumentException("The bitLen of the BigInt must > 1.")
        }
        var randBig = BigInt(true, bitLen, rand: rand)
        while (!randBig.isProbablePrime(certainty)) {
            randBig = BigInt(true, bitLen, rand: rand)
        }
        return randBig
    }








    /*
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    public init(bytes: Array<Byte>) {
        if (bytes.size == 0) {
            throw IllegalArgumentException("The size of bytes cannot be zero!")
        }
        let negSign: Bool
        let byteArray: Array<Byte>
        if ((bytes[0] >> 7) == 1) {
            negSign = true
            byteArray = removeLeftZero(compToMag(bytes))
        } else {
            negSign = false
            byteArray = removeLeftZero(bytes)
        }
        if (byteArray.size <= 8) {
            this.int = fromBigBytesToU64(byteArray)
            this.intArr = EMPTY_ARRAY
        } else {
            this.int = fromBigBytesToU64(removeLeftZero(byteArray[byteArray.size - 8..]))
            this.intArr = fromBigBytesToSmallU32Array(byteArray[..byteArray.size - 8])
        }
        this.negSign = negSign
    }









    /*
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    public init(sign: Bool, magnitude: Array<Byte>) {
        this.negSign = !sign
        let byteArray = removeLeftZero(magnitude)
        if (byteArray.size == 0) {
            if (sign) {
                this.int = 0
                this.intArr = EMPTY_ARRAY
                return
            } else {
                throw IllegalArgumentException("The size or the value of magnitude cannot be zero if sign is true!")
            }
        }
        if (byteArray.size <= 8) {
            this.int = fromBigBytesToU64(byteArray)
            this.intArr = EMPTY_ARRAY
        } else {
            this.int = fromBigBytesToU64(removeLeftZero(byteArray[byteArray.size - 8..]))
            this.intArr = fromBigBytesToSmallU32Array(byteArray[..byteArray.size - 8])
        }
    }




    /*
     * @noThrow
     */
    public init(n: Int8) {
        this.intArr = EMPTY_ARRAY
        (this.int, this.negSign) = if (n >= 0) {
            (UInt64(n), false)
        } else {
            if (n == Int8.Min) {
                (UInt64(0x80), true)
            } else {
                (UInt64(-n), true)
            }
        }
    }




    /*
     * @noThrow
     */
    public init(n: Int16) {
        this.intArr = EMPTY_ARRAY
        (this.int, this.negSign) = if (n >= 0) {
            (UInt64(n), false)
        } else {
            if (n == Int16.Min) {
                (UInt64(0x8000), true)
            } else {
                (UInt64(-n), true)
            }
        }
    }




    /*
     * @noThrow
     */
    public init(n: Int32) {
        this.intArr = EMPTY_ARRAY
        (this.int, this.negSign) = if (n >= 0) {
            (UInt64(n), false)
        } else {
            if (n == Int32.Min) {
                (UInt64(0x8000_0000), true)
            } else {
                (UInt64(-n), true)
            }
        }
    }




    /*
     * @noThrow
     */
    public init(n: Int64) {
        this.intArr = EMPTY_ARRAY
        (this.int, this.negSign) = if (n >= 0) {
            (UInt64(n), false)
        } else {
            if (n == Int64.Min) {
                (UInt64(1) << 63, true)
            } else {
                (UInt64(-n), true)
            }
        }
    }




    /*
     * @noThrow
     */
    public init(n: UInt8) {
        this(UInt64(n))
    }




    /*
     * @noThrow
     */
    public init(n: UInt16) {
        this(UInt64(n))
    }




    /*
     * @noThrow
     */
    public init(n: UInt32) {
        this(UInt64(n))
    }




    /*
     * @noThrow
     */
    public init(n: UInt64) {
        this.int = n
        this.intArr = EMPTY_ARRAY
        this.negSign = false
    }




    /*
     * @noThrow
     */
    public init(n: UIntNative) {
        this(UInt64(n))
    }




    /*
     * @noThrow
     */
    public init(n: IntNative) {
        this.intArr = EMPTY_ARRAY
        (this.int, this.negSign) = if (n >= 0) {
            (UInt64(n), false)
        } else {
            if (n == IntNative.Min) {
                (!UInt64(UIntNative.Max >> 1), true)
            } else {
                (UInt64(-n), true)
            }
        }
    }





    /*
     * @throws ArithmeticException
     * @throws PrecisionMismatchException
     * @throws IllegalArgumentException
     * @throws OverflowException
     * @throws IndexOutOfBoundsException
     */
    public init(n: Float16) {
        let tmp = Decimal(n).toBigInt()
        (this.int, this.intArr, this.negSign) = (tmp.int, tmp.intArr, tmp.negSign)
    }





    /*
     * @throws ArithmeticException
     * @throws PrecisionMismatchException
     * @throws IllegalArgumentException
     * @throws OverflowException
     * @throws IndexOutOfBoundsException
     */
    public init(n: Float32) {
        let tmp = Decimal(n).toBigInt()
        (this.int, this.intArr, this.negSign) = (tmp.int, tmp.intArr, tmp.negSign)
    }





    /*
     * @throws ArithmeticException
     * @throws PrecisionMismatchException
     * @throws IllegalArgumentException
     * @throws OverflowException
     * @throws IndexOutOfBoundsException
     */
    public init(n: Float64) {
        let tmp = Decimal(n).toBigInt()
        (this.int, this.intArr, this.negSign) = (tmp.int, tmp.intArr, tmp.negSign)
    }









    /*
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    public init(sign: Bool, bitLen: Int64, rand!: Random = Random()) {
        if (bitLen <= 0) {
            throw IllegalArgumentException("The bitLen of the BigInt must > 0.")
        }
        if (bitLen <= 64) {
            int = rand.next(UInt64(bitLen))
            intArr = EMPTY_ARRAY
            if (int == 0) {
                negSign = false
            } else {
                negSign = !sign
            }
            return
        }
        let (arrIndex, uInt32Len) = arrIndexAndU32Index(bitLen)
        int = rand.nextUInt64()
        let uInt32Arr: Array<UInt32>
        if (uInt32Len == 0) {
            uInt32Arr = Array<UInt32>(arrIndex, repeat: 0)
        } else {
            uInt32Arr = Array<UInt32>(arrIndex + 1, repeat: 0)
            uInt32Arr[arrIndex] = UInt32(rand.next(UInt64(uInt32Len)))
        }
        for (i in 0..arrIndex) {
            uInt32Arr[i] = rand.nextUInt32()
        }
        intArr = normalize(uInt32Arr)
        if (int == 0 && intArr.size == 0) {
            negSign = false
        } else {
            negSign = !sign
        }
    }




























    @Deprecated[message: "Use member function `public static func parse(value: String, radix!: Int64): BigInt` instead."]
    /*
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    public init(s: String, base!: Int64 = 10) {
        if (base < 2 || base > 36) {
            throw IllegalArgumentException("The base should in the range of [2, 36].")
        }
        (this.int, this.intArr, this.negSign) = parseString(s, UInt64(base))
    }








    /*
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    public func testBit(index: Int64): Bool {
        if (index < 0) {
            throw IllegalArgumentException("The index must >= 0.")
        }
        if (sign == 0) {
            return false
        }
        if (negSign) {
            let (bitInt, bitArr) = subOne(int, intArr, false)
            if (index < 64) {
                return (bitInt & (1 << index)) == 0
            }
            let (arrIndex, u32Index) = arrIndexAndU32Index(index)
            if (arrIndex > bitArr.size - 1) {
                return true
            }
            return (bitArr[arrIndex] & (1 << u32Index)) == 0
        } else {
            if (index < 64) {
                return (int & (1 << index)) != 0
            }
            let (arrIndex, u32Index) = arrIndexAndU32Index(index)
            if (arrIndex > intArr.size - 1) {
                return false
            }
            return (intArr[arrIndex] & (1 << u32Index)) != 0
        }
    }







    @Deprecated[message: "Use global function `public func trailingZeros(x: BigInt): Int64` instead."]
    /*
     * @throws IndexOutOfBoundsException
     */
    public func lowestOneBit(): Int64 {
        return trailingZeros(this)
    }








    /*
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    public func setBit(index: Int64): BigInt {
        if (index < 0) {
            throw IllegalArgumentException("The index must >= 0.")
        }
        if (sign == 0) {
            if (index < 64) {
                return BigInt(UInt64(1) << index, EMPTY_ARRAY, false)
            }
            let (arrIndex, u32Index) = arrIndexAndU32Index(index)
            let arr = Array<UInt32>(arrIndex + 1, repeat: 0)
            arr[arrIndex] = UInt32(1) << u32Index
            return BigInt(0, arr, false)
        }
        if (negSign) {
            let arrIndex = (index - 64) >> 5
            if (index >= 64 && arrIndex > intArr.size - 1) {
                return BigInt(int, intArr.clone(), true)
            }
            let (bitInt, bitArr) = subOne(int, intArr, true)
            if (index < 64) {
                return BigInt((!(UInt64(1) << index) & (bitInt)) + 1, normalize(bitArr), true)
            }
            let u32Index = (index - 64) & 0x1F
            bitArr[arrIndex] = !(UInt32(1) << u32Index) & bitArr[arrIndex]
            if (bitInt == 0xFFFF_FFFF_FFFF_FFFF) {
                return BigInt(0, addInSitu(bitArr, EMPTY_ARRAY, 1), true)
            }
            return BigInt(bitInt + 1, normalize(bitArr), true)
        } else {
            return posBitOrOrXor(this, index, Or)
        }
    }








    /*
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    public func clearBit(index: Int64): BigInt {
        if (index < 0) {
            throw IllegalArgumentException("The index must >= 0.")
        }
        if (sign == 0) {
            return BigInt(0, EMPTY_ARRAY, false)
        }
        if (negSign) {
            return negBitOrOrXor(this, index, Or)
        } else {
            let arrIndex = (index - 64) >> 5
            let bitArr = intArr.clone()
            if (index >= 64 && arrIndex > bitArr.size - 1) {
                return BigInt(int, bitArr, false)
            }
            if (index < 64) {
                return BigInt(!(UInt64(1) << index) & int, bitArr, false)
            }
            let u32Index = (index - 64) & 0x1F
            bitArr[arrIndex] = !(UInt32(1) << u32Index) & bitArr[arrIndex]
            return BigInt(int, normalize(bitArr), false)
        }
    }








    /*
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    public func flipBit(index: Int64): BigInt {
        if (index < 0) {
            throw IllegalArgumentException("The index must >= 0.")
        }
        if (sign == 0) {
            return setBit(index)
        }
        if (negSign) {
            return negBitOrOrXor(this, index, Xor)
        } else {
            return posBitOrOrXor(this, index, Xor)
        }
    }





    /*
     * @throws ArithmeticException
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    public func isProbablePrime(certainty: UInt64): Bool {
        if (certainty == 0) {
            return true
        }
        if (sign <= 0) {
            return false
        }
        if (int == 1 && intArr.size == 0) {
            return false
        }
        if (int == 2 && intArr.size == 0) {
            return true
        }
        if ((int & 1) == 0) {
            return false
        }
        var certaintyTimes = certainty
        while (certaintyTimes > 0x7FFF_FFFF_FFFF_FFFF) {
            if (!checkCertaintyTimes(0x7FFF_FFFF_FFFF_FFFF)) {
                return false
            }
            certaintyTimes -= 0x7FFF_FFFF_FFFF_FFFF
        }
        if (!checkCertaintyTimes(Int64(certaintyTimes))) {
            return false
        }
        return true
    }

    /*
     * @throws ArithmeticException
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    func checkCertaintyTimes(certainty: Int64): Bool {
        for (_ in 0..Int64(certainty)) {
            var a: BigInt
            do {
                a = BigInt(true, bitLen)
            } while (a.int == 0 || a.int == 1 && a.intArr.size == 0 || a == this)
            if (witness(a, this)) {
                return false
            }
        }
        return true
    }






    /*
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    public operator func +(that: BigInt): BigInt {
        if (this.sign == 0) {
            return BigInt(that.int, that.intArr.clone(), that.negSign)
        }
        if (that.sign == 0) {
            return BigInt(this.int, this.intArr.clone(), this.negSign)
        }
        if (this.sign == that.sign) {
            let (int, intArr) = addAbs(this.int, this.intArr, that.int, that.intArr)
            return BigInt(int, intArr, this.negSign)
        } else {
            let (int, resultArr, isNeg) = subAbs(this.int, this.intArr, that.int, that.intArr, this.negSign)
            return BigInt(int, resultArr, isNeg)
        }
    }






    /*
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    public operator func -(that: BigInt): BigInt {
        if (this.sign == 0) {
            return -that
        }
        if (that.sign == 0) {
            return BigInt(this.int, this.intArr.clone(), this.negSign)
        }
        if (this.sign == that.sign) {
            let (int, resultArr, isNeg) = subAbs(this.int, this.intArr, that.int, that.intArr, this.negSign)
            return BigInt(int, resultArr, isNeg)
        } else {
            let (int, intArr) = addAbs(this.int, this.intArr, that.int, that.intArr)
            return BigInt(int, intArr, this.negSign)
        }
    }






    /*
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    public operator func *(that: BigInt): BigInt {
        if (this.sign == 0 || that.sign == 0) {
            return BigInt(0, EMPTY_ARRAY, false)
        }
        let (rInt, rArr) = mul(this.int, this.intArr, that.int, that.intArr)
        return BigInt(rInt, rArr, this.negSign != that.negSign)
    }










    /*
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     * @throws ArithmeticException
     */
    public operator func /(that: BigInt): BigInt {
        let (dInt, dArr, dNegSign) = div(that.int, that.intArr, that.negSign)
        return BigInt(dInt, dArr, dNegSign)
    }












    /*
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    public operator func %(that: BigInt): BigInt {
        let (mInt, mArr) = mod(int, intArr, that.int, that.intArr)
        let mNegSign = if (mInt == 0 && mArr.size == 0) {
            false
        } else {
            negSign
        }
        return BigInt(mInt, mArr, mNegSign)
    }









    /*
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     * @throws ArithmeticException
     */
    public func divAndMod(that: BigInt): (BigInt, BigInt) {
        let (dInt, dArr, dNegSign, mInt, mArr, mNegSign) = privateDivAndMod(that.int, that.intArr, that.negSign)
        return (BigInt(dInt, dArr, dNegSign), BigInt(mInt, mArr, mNegSign))
    }









    @Deprecated[message: "Use member function `public func divAndMod(that: BigInt): (BigInt, BigInt)` instead."]
    /*
     * @throws ArithmeticException
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    public func quo(that: BigInt): BigInt {
        let (dInt, dArr, dNegSign, mInt, mArr, _) = privateDivAndMod(that.int, that.intArr, that.negSign)
        if (sign == -1 && !(mInt == 0 && mArr.size == 0)) {
            let (qInt, qArr) = addOneAndOverSize(dInt, dArr)
            return BigInt(qInt, qArr, negSign != that.negSign)
        }
        return BigInt(dInt, dArr, dNegSign)
    }









    @Deprecated[message: "Use member function `public func divAndMod(that: BigInt): (BigInt, BigInt)` instead."]
    /*
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    public func rem(that: BigInt): BigInt {
        let (mInt, mArr) = mod(int, intArr, that.int, that.intArr)
        if (sign == -1 && !(mInt == 0 && mArr.size == 0)) {
            return modAddAbsOfDivisor(mInt, mArr, that)
        }
        return BigInt(mInt, mArr, false)
    }









    @Deprecated[message: "Use member function `public func divAndMod(that: BigInt): (BigInt, BigInt)` instead."]
    /*
     * @throws ArithmeticException
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    public func quoAndRem(that: BigInt): (BigInt, BigInt) {
        let (dInt, dArr, dNegSign, mInt, mArr, _) = privateDivAndMod(that.int, that.intArr, that.negSign)
        if (sign == -1 && !(mInt == 0 && mArr.size == 0)) {
            let (qInt, qArr) = addOneAndOverSize(dInt, dArr)
            let rBig = modAddAbsOfDivisor(mInt, mArr, that)
            return (BigInt(qInt, qArr, negSign != that.negSign), rBig)
        }
        return (BigInt(dInt, dArr, dNegSign), BigInt(mInt, mArr, false))
    }








    /*
     * @throws ArithmeticException
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    public func modInverse(that: BigInt): BigInt {
        if (that.int == 1 && that.intArr.size == 0) {
            return BigInt(0, EMPTY_ARRAY, false)
        }
        if (this.sign == 0 || that.sign == 0) {
            throw IllegalArgumentException("The BigInt is not relatively prime with the input.")
        }
        let (x, _) = exgcdToInverse(this, that)
        if (this.negSign != x.negSign) {
            let (rInt, rArr, _) = subAbs(that.int, that.intArr, x.int, x.intArr, false)
            return BigInt(rInt, rArr, negSign)
        }
        return x
    }




    /*
     * @noThrow
     */
    public operator func -(): BigInt {
        if (sign == 0) {
            return BigInt(0, EMPTY_ARRAY, false)
        }
        return BigInt(this.int, this.intArr.clone(), !this.negSign)
    }






    /*
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    public operator func **(n: UInt64): BigInt {
        if (n == 0) {
            return BigInt(1, EMPTY_ARRAY, false)
        }
        if (sign == 0) {
            return BigInt(0, EMPTY_ARRAY, false)
        }
        let isNeg = (n & 1) == 1 && negSign
        if (int == 1 && intArr.size == 0) {
            return BigInt(1, EMPTY_ARRAY, isNeg)
        }
        var resultInt: UInt64 = 1
        var resultArr: Array<UInt32> = EMPTY_ARRAY
        var powerInt: UInt64 = this.int
        var powerArr: Array<UInt32> = this.intArr
        var exponent = n
        while (exponent != 0) {
            if ((exponent & 1) == 1) {
                (resultInt, resultArr) = mul(resultInt, resultArr, powerInt, powerArr)
            }
            (powerInt, powerArr) = mul(powerInt, powerArr, powerInt, powerArr)
            exponent = exponent >> 1
        }
        return BigInt(resultInt, resultArr, isNeg)
    }











    /*
     * @throws IndexOutOfBoundsException
     * @throws ArithmeticException
     * @throws IllegalArgumentException
     */
    public func modPow(n: BigInt, m!: ?BigInt = None): BigInt {
        if (n.sign == -1) {
            throw IllegalArgumentException("The exponent can not be negative.")
        }
        if (m?.sign == 0) {
            throw ArithmeticException("Divided by zero!")
        }
        if (m?.int == 1 && m?.intArr.size == 0) {
            return BigInt(0, EMPTY_ARRAY, false)
        }
        if (n.sign == 0) {
            return BigInt(1, EMPTY_ARRAY, false)
        }
        if (sign == 0) {
            return BigInt(0, EMPTY_ARRAY, false)
        }
        let isNeg = ((n.int & 1) == 1 && negSign)
        if (int == 1 && intArr.size == 0) {
            return BigInt(1, EMPTY_ARRAY, isNeg)
        }
        var resultInt: UInt64 = 1
        var resultArr: Array<UInt32> = EMPTY_ARRAY
        var (powerInt, powerArr) = modOption(int, intArr, m)
        var eInt = n.int
        var eArr = n.intArr.clone()
        while (eInt != 0 || eArr.size != 0) {
            if ((eInt & 1) == 1) {
                (resultInt, resultArr) = mul(resultInt, resultArr, powerInt, powerArr)
                (resultInt, resultArr) = modOption(resultInt, resultArr, m)
            }
            (powerInt, powerArr) = mul(powerInt, powerArr, powerInt, powerArr)
            (powerInt, powerArr) = modOption(powerInt, powerArr, m)
            (eInt, eArr) = divBy2Insitu(eInt, eArr)
            eArr = normalize(eArr)
        }
        return BigInt(resultInt, resultArr, isNeg)
    }






    /*
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    public operator func &(that: BigInt): BigInt {
        if (sign == 0 || that.sign == 0) {
            return BigInt(0, EMPTY_ARRAY, false)
        }
        if (negSign == that.negSign) {
            if (!negSign) {
                let (rInt, rArr) = and(int, intArr, that.int, that.intArr)
                return BigInt(rInt, rArr, false)
            }
            let (rInt, rArr) = subOneOrOrXor(int, intArr, that.int, that.intArr, Or)
            let (rIntPlus, rArrPlus) = addOneAndOverSize(rInt, normalize(rArr))
            return BigInt(rIntPlus, rArrPlus, true)
        }
        if (!negSign) {
            let (intSubOne, rArr) = resetSizeAndSubOne(that.int, that.intArr, intArr.size, true)
            let rInt = !intSubOne & int
            for (i in 0..intArr.size) {
                rArr[i] = !rArr[i] & intArr[i]
            }
            return BigInt(rInt, normalize(rArr), false)
        }
        let (intSubOne, rArr) = resetSizeAndSubOne(int, intArr, that.intArr.size, true)
        let rInt = !intSubOne & that.int
        for (i in 0..that.intArr.size) {
            rArr[i] = !rArr[i] & that.intArr[i]
        }
        return BigInt(rInt, normalize(rArr), false)
    }






    /*
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    public operator func |(that: BigInt): BigInt {
        if (sign == 0) {
            return BigInt(that.int, that.intArr.clone(), that.negSign)
        }
        if (that.sign == 0) {
            return BigInt(int, intArr.clone(), negSign)
        }
        if (negSign == that.negSign) {
            if (!negSign) {
                let (rInt, rArr) = orOrXor(this, that, Or)
                return BigInt(rInt, rArr, false)
            }
            let (rInt, rArr) = subOneAnd(int, intArr, that.int, that.intArr)
            let (rIntPlus, rArrPlus) = addOneAndOverSize(rInt, normalize(rArr))
            return BigInt(rIntPlus, rArrPlus, true)
        }
        let rInt: UInt64
        let intSubOne: UInt64
        let rArr: Array<UInt32>
        if (!negSign) {
            (intSubOne, rArr) = subOne(that.int, that.intArr, true)
            rInt = !int & intSubOne
            for (i in 0..min(rArr.size, intArr.size)) {
                rArr[i] = !intArr[i] & rArr[i]
            }
        } else {
            (intSubOne, rArr) = subOne(int, intArr, true)
            rInt = !that.int & intSubOne
            for (i in 0..min(rArr.size, that.intArr.size)) {
                rArr[i] = !that.intArr[i] & rArr[i]
            }
        }
        let (rIntPlus, rArrPlus) = addOneAndOverSize(rInt, normalize(rArr))
        return BigInt(rIntPlus, rArrPlus, true)
    }






    /*
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    public operator func ^(that: BigInt): BigInt {
        if (sign == 0) {
            return BigInt(that.int, that.intArr.clone(), that.negSign)
        }
        if (that.sign == 0) {
            return BigInt(int, intArr.clone(), negSign)
        }
        if (negSign == that.negSign) {
            if (!negSign) {
                let (rInt, rArr) = orOrXor(this, that, Xor)
                return BigInt(rInt, normalize(rArr), false)
            }
            let (rInt, rArr) = subOneOrOrXor(int, intArr, that.int, that.intArr, Xor)
            return BigInt(rInt, normalize(rArr), false)
        }
        let rInt: UInt64
        let intSubOne: UInt64
        let rArr: Array<UInt32>
        let (maxSize, minSize) = if (intArr.size >= that.intArr.size) {
            (intArr.size, that.intArr.size)
        } else {
            (that.intArr.size, intArr.size)
        }
        if (!negSign) {
            (intSubOne, rArr) = resetSizeAndSubOne(that.int, that.intArr, maxSize, true)
            rInt = int ^ intSubOne
            for (i in 0..minSize) {
                rArr[i] = intArr[i] ^ rArr[i]
            }
            if (intArr.size >= that.intArr.size) {
                intArr.copyTo(rArr, minSize, minSize, maxSize - minSize)
            }
        } else {
            (intSubOne, rArr) = resetSizeAndSubOne(int, intArr, maxSize, true)
            rInt = that.int ^ intSubOne
            for (i in 0..minSize) {
                rArr[i] = that.intArr[i] ^ rArr[i]
            }
            if (intArr.size < that.intArr.size) {
                that.intArr.copyTo(rArr, minSize, minSize, maxSize - minSize)
            }
        }
        let (rIntPlus, rArrPlus) = addOneAndOverSize(rInt, normalize(rArr))
        return BigInt(rIntPlus, rArrPlus, true)
    }




    /*
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    public operator func !(): BigInt {
        if (!negSign) {
            let (rInt, rArr) = addOneAndOverSize(int, intArr.clone())
            return BigInt(rInt, rArr, true)
        }
        let (rInt, rArr) = subOne(int, intArr, true)
        return BigInt(rInt, normalize(rArr), false)
    }






    /*
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     * @throws ArithmeticException
     */
    public operator func >>(n: Int64): BigInt {
        if (n < 0) {
            throw ArithmeticException("The parameter n must >= 0.")
        }
        if (sign == 0) {
            return BigInt(0, EMPTY_ARRAY, false)
        }
        let (intT, intArrT) = if (negSign) {
            subOne(int, intArr, false)
        } else {
            (int, intArr)
        }
        var leadingZeros = if (intArrT.size > 0) {
            Int64(leadingZeros(intArrT[intArrT.size - 1]))
        } else {
            0
        }
        var (deltaSize, shift) = deltaSizeAndU32Shift(n)
        let delta = deltaSize
        if (shift >= 32 - leadingZeros) {
            deltaSize += 1
        }
        let rArr = if (intArrT.size - deltaSize > 0) {
            Array<UInt32>(intArrT.size - deltaSize, repeat: 0)
        } else {
            EMPTY_ARRAY
        }
        var carryRight: UInt32 = 0
        for (i in intArrT.size - 1..=delta : -1) {
            let shiftResult = (intArrT[i] >> shift) | carryRight
            carryRight = if (shift > 0) {
                intArrT[i] << (32 - shift)
            } else {
                0
            }
            if (i - delta >= rArr.size) {
                continue
            }
            rArr[i - delta] = shiftResult
        }
        let rInt = shiftRightToUInt64(intT, intArrT, delta, shift, carryRight)
        if (!negSign) {
            return BigInt(rInt, rArr, false)
        }
        let (rIntPlus, rArrPlus) = addOneAndOverSize(rInt, normalize(rArr))
        return BigInt(rIntPlus, rArrPlus, true)
    }






    /*
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     * @throws ArithmeticException
     */
    public operator func <<(n: Int64): BigInt {
        if (n < 0) {
            throw ArithmeticException("The parameter n must >= 0.")
        }
        if (sign == 0) {
            return BigInt(0, EMPTY_ARRAY, false)
        }
        var leadingZeros = if (intArr.size > 0) {
            Int64(leadingZeros(intArr[intArr.size - 1]))
        } else {
            Int64(leadingZeros(int))
        }
        if (n <= leadingZeros && intArr.size == 0) {
            return BigInt(int << n, EMPTY_ARRAY, negSign)
        }
        var (deltaSize, shift32) = deltaSizeAndU32Shift(n)
        if (shift32 > leadingZeros) {
            deltaSize += 1
        }
        let rArr = Array<UInt32>(intArr.size + deltaSize, repeat: 0)
        intArr.copyTo(rArr, 0, 0, intArr.size)
        let (rInt, _) = shiftLeftInSitu(int, rArr, n, deltaSize)
        return BigInt(rInt, normalize(rArr), negSign)
    }






    /*
     * @throws IndexOutOfBoundsException
     */
    public operator func ==(that: BigInt): Bool {
        return this.sign == that.sign && this.int == that.int && this.intArr == that.intArr
    }






    /*
     * @throws IndexOutOfBoundsException
     */
    public operator func !=(that: BigInt): Bool {
        return !(this == that)
    }






    /*
     * @throws IndexOutOfBoundsException
     */
    public operator func >(that: BigInt): Bool {
        if (this.sign > that.sign) {
            return true
        }
        if (this.sign < that.sign) {
            return false
        }
        let c = compareAbsArr(this.intArr, that.intArr, 0)
        if (c * this.sign > 0) {
            return true
        }
        if (c == 0 && ((this.int > that.int && this.sign > 0) || (this.int < that.int && this.sign < 0))) {
            return true
        }
        return false
    }






    /*
     * @throws IndexOutOfBoundsException
     */
    public operator func >=(that: BigInt): Bool {
        if (this.sign > that.sign) {
            return true
        }
        if (this.sign < that.sign) {
            return false
        }
        if (this.sign == 0) {
            return true
        }
        let c = compareAbsArr(this.intArr, that.intArr, 0)
        if (c * this.sign > 0) {
            return true
        }
        if (c == 0 && ((this.int >= that.int && this.sign >= 0) || (this.int <= that.int && this.sign <= 0))) {
            return true
        }
        return false
    }






    /*
     * @throws IndexOutOfBoundsException
     */
    public operator func <(that: BigInt): Bool {
        return !(this >= that)
    }






    /*
     * @throws IndexOutOfBoundsException
     */
    public operator func <=(that: BigInt): Bool {
        return !(this > that)
    }






    /*
     * @throws IndexOutOfBoundsException
     */
    public func compare(that: BigInt): Ordering {
        match {
            case this < that => Ordering.LT
            case this > that => Ordering.GT
            case _ => Ordering.EQ
        }
    }




    @OverflowWrapping
    /*
     * @throws IndexOutOfBoundsException
     */
    public func hashCode(): Int64 {
        var hashCode: UInt64 = 0
        for (i in intArr.size - 1..=0 : -1) {
            hashCode *= 31
            hashCode += UInt64(intArr[i])
        }
        hashCode *= 31
        hashCode += int >> 32
        hashCode *= 31
        hashCode += int & 0xFFFF_FFFF
        return Int64(hashCode)
    }




    /*
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    public func toString(): String {
        return convertToString(10)
    }



    /*
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    public func toBytes(): Array<Byte> {
        if (sign == 0) {
            return Array<Byte>(1, repeat: 0)
        }
        if (!negSign) {
            if (intArr.size == 0) {
                let byteArr = Array<Byte>(Int64((64 - leadingZeros(int)) / 8) + 1, repeat: 0)
                fromU64ToBigBytes(byteArr, int)
                return byteArr
            }
            let byteArr = Array<Byte>(intArr.size * 4 + Int64((64 - leadingZeros(intArr[intArr.size - 1])) / 8) + 1,
                repeat: 0)
            fromU64ToBigBytes(byteArr[byteArr.size - 8..], int)
            fromSmallU32ArrayToBigBytes(byteArr[..byteArr.size - 8], intArr)
            return byteArr
        }
        if (intArr.size == 0) {
            let bitLen = 64 - leadingZeros(int)
            let byteArr = if ((bitLen & 0b111) == 0 && (int ^ (1 << (bitLen - 1))) == 0) {
                Array<Byte>(Int64(bitLen / 8), repeat: 0)
            } else {
                Array<Byte>(Int64(bitLen / 8) + 1, repeat: 0)
            }
            fromU64ToBigBytes(byteArr, int)
            return compToMag(byteArr)
        }
        let mostSignificantUInt32 = intArr[intArr.size - 1]
        let bitLen = 32 - leadingZeros(mostSignificantUInt32)
        let byteArr = if ((bitLen & 0b111) == 0 && (mostSignificantUInt32 ^ (1 << (bitLen - 1))) == 0 && isAllZero(
            intArr[..intArr.size - 1])) {
            Array<Byte>(intArr.size * 4 + Int64(bitLen / 8) + 4, repeat: 0)
        } else {
            Array<Byte>(intArr.size * 4 + Int64(bitLen / 8) + 5, repeat: 0)
        }
        fromU64ToBigBytes(byteArr[byteArr.size - 8..], int)
        fromSmallU32ArrayToBigBytes(byteArr[..byteArr.size - 8], intArr)
        return compToMag(byteArr)
    }








    /*
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    func convertToString(radix: Int64): String {
        if (radix < 2 || radix > 36) {
            throw IllegalArgumentException("The radix should in the range of [2, 36].")
        }
        if (int == 0 && intArr.size == 0) {
            return "0"
        }

        var begin = 0
        if (intArr.size == 0) {
            let absStrSize = calculateBaseStrSize(radix)
            let stringUtf8Arr = Array<Byte>(absStrSize + 1, repeat: b'0')
            begin = toBaseString(stringUtf8Arr, absStrSize, int, UInt64(radix))
            if (negSign) {
                stringUtf8Arr[begin] = b'-'
                begin--
            }
            begin++
            return unsafe { String.fromUtf8Unchecked(stringUtf8Arr[begin..]) }
        }

        let (digits, anyBase) = calculateLenAndBase(UInt64(radix))
        let stringArr = Array<UInt64>(calculateStrArrSize(anyBase), repeat: 0)
        let stringArrBound = calculateStrArr(stringArr, this, 1, anyBase)
        let stringUtf8Arr = Array<Byte>(stringArrBound * digits + 1, repeat: b'0')
        begin = toBaseString(stringUtf8Arr, digits, stringArr[stringArrBound - 1], UInt64(radix))
        if (negSign) {
            stringUtf8Arr[begin] = b'-'
            begin--
        }
        begin++
        for (i in stringArrBound - 2..=0 : -1) {
            toBaseString(stringUtf8Arr, digits * (stringArrBound - i), stringArr[i], UInt64(radix))
        }
        return unsafe { String.fromUtf8Unchecked(stringUtf8Arr[begin..]) }
    }








    /*
     * @throws OverflowException
     */
    public func toInt8(overflowHandling!: OverflowStrategy = Throwing): Int8 {
        if (this.intArr.isEmpty()) {
            if (!this.negSign && this.int <= 127) {
                return Int8(this.int)
            }
            if (this.negSign && this.int <= 128) {
                return Int8(-Int64(this.int))
            }
        }
        match (overflowHandling) {
            case Throwing => throw OverflowException("Out of range of the Int8.")
            case Wrapping => toInt8Wrapping()
            case Saturating =>
                if (this.negSign) {
                    Int8.Min
                } else {
                    Int8.Max
                }
        }
    }

    @OverflowWrapping
    /*
     * @noThrow
     */
    private func toInt8Wrapping(): Int8 {
        if (!this.negSign) {
            return Int8(this.int)
        } else {
            let u: UInt8 = UInt8((this.int - 1) & 0xff)
            return Int8(!u)
        }
    }








    /*
     * @throws OverflowException
     */
    public func toInt16(overflowHandling!: OverflowStrategy = Throwing): Int16 {
        if (this.intArr.isEmpty()) {
            if (!this.negSign && this.int <= 32767) {
                return Int16(this.int)
            }
            if (this.negSign && this.int <= 32768) {
                return Int16(-Int64(this.int))
            }
        }
        match (overflowHandling) {
            case Throwing => throw OverflowException("Out of range of the Int16.")
            case Wrapping => toInt16Wrapping()
            case Saturating =>
                if (this.negSign) {
                    Int16.Min
                } else {
                    Int16.Max
                }
        }
    }

    @OverflowWrapping
    /*
     * @noThrow
     */
    private func toInt16Wrapping(): Int16 {
        if (!this.negSign) {
            return Int16(this.int)
        } else {
            let u: UInt16 = UInt16((this.int - 1) & 0xffff)
            return Int16(!u)
        }
    }








    /*
     * @throws OverflowException
     */
    public func toInt32(overflowHandling!: OverflowStrategy = Throwing): Int32 {
        if (this.intArr.isEmpty()) {
            if (!this.negSign && this.int <= 2147483647) {
                return Int32(this.int)
            }
            if (this.negSign && this.int <= 2147483648) {
                return Int32(-Int64(this.int))
            }
        }
        match (overflowHandling) {
            case Throwing => throw OverflowException("Out of range of the Int32.")
            case Wrapping => toInt32Wrapping()
            case Saturating =>
                if (this.negSign) {
                    Int32.Min
                } else {
                    Int32.Max
                }
        }
    }

    @OverflowWrapping
    /*
     * @noThrow
     */
    private func toInt32Wrapping(): Int32 {
        if (!this.negSign) {
            return Int32(this.int)
        } else {
            let u: UInt32 = UInt32((this.int - 1) & 0xffffffff)
            return Int32(!u)
        }
    }








    /*
     * @throws OverflowException
     */
    public func toInt64(overflowHandling!: OverflowStrategy = Throwing): Int64 {
        if (this.intArr.isEmpty()) {
            if (!this.negSign && this.int <= 9223372036854775807) {
                return Int64(this.int)
            }
            if (this.negSign && this.int < 9223372036854775808) {
                return -Int64(this.int)
            }
            if (this.negSign && this.int == 9223372036854775808) {
                return Int64.Min
            }
        }
        match (overflowHandling) {
            case Throwing => throw OverflowException("Out of range of the Int64.")
            case Wrapping => toInt64Wrapping()
            case Saturating =>
                if (this.negSign) {
                    Int64.Min
                } else {
                    Int64.Max
                }
        }
    }

    @OverflowWrapping
    /*
     * @noThrow
     */
    private func toInt64Wrapping(): Int64 {
        if (!this.negSign) {
            return Int64(this.int)
        } else {
            let u: UInt64 = (this.int - 1) & 0xffffffffffffffff
            return Int64(!u)
        }
    }

    /*
     * @throws OverflowException
     * @throws Exception
     */
    public func toIntNative(overflowHandling!: OverflowStrategy = Throwing): IntNative {
        let len: IntNative = intNativeLen()
        return match (len) {
            case 19 => IntNative(this.toInt64(overflowHandling: overflowHandling))
            case 10 => IntNative(this.toInt32(overflowHandling: overflowHandling))
            case _ => throw Exception("Unrecognized IntNative.")
        }
    }

    /*
     * @throws ArithmeticException
     * @throws PrecisionMismatchException
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     * @throws OverflowException
     */
    public func toFloat16(): Float16 {
        return Decimal(this).toFloat16()
    }

    /*
     * @throws ArithmeticException
     * @throws PrecisionMismatchException
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     * @throws OverflowException
     */
    public func toFloat32(): Float32 {
        return Decimal(this).toFloat32()
    }

    /*
     * @throws ArithmeticException
     * @throws PrecisionMismatchException
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     * @throws OverflowException
     */
    public func toFloat64(): Float64 {
        return Decimal(this).toFloat64()
    }

    /*
     * @noThrow
     */
    private func intNativeLen(): IntNative {
        var num: IntNative = 0
        var n: IntNative = IntNative.Max
        while (n != 0) {
            n /= 10
            num += 1
        }
        return num
    }








    /*
     * @throws OverflowException
     */
    public func toUInt8(overflowHandling!: OverflowStrategy = Throwing): UInt8 {
        if (this.intArr.isEmpty() && !this.negSign && this.int <= 255) {
            return UInt8(this.int)
        }
        match (overflowHandling) {
            case Throwing => throw OverflowException("Out of range of the UInt8.")
            case Wrapping => toUInt8Wrapping()
            case Saturating =>
                if (this.negSign) {
                    UInt8.Min
                } else {
                    UInt8.Max
                }
        }
    }

    @OverflowWrapping
    /*
     * @noThrow
     */
    private func toUInt8Wrapping(): UInt8 {
        if (!this.negSign) {
            return UInt8(this.int)
        } else {
            let u: UInt8 = !UInt8((this.int - 1) & 0xff)
            return u
        }
    }








    /*
     * @throws OverflowException
     */
    public func toUInt16(overflowHandling!: OverflowStrategy = Throwing): UInt16 {
        if (this.intArr.isEmpty() && !this.negSign && this.int <= 65535) {
            return UInt16(this.int)
        }
        match (overflowHandling) {
            case Throwing => throw OverflowException("Out of range of the UInt16.")
            case Wrapping => toUInt16Wrapping()
            case Saturating =>
                if (this.negSign) {
                    UInt16.Min
                } else {
                    UInt16.Max
                }
        }
    }

    @OverflowWrapping
    /*
     * @noThrow
     */
    private func toUInt16Wrapping(): UInt16 {
        if (!this.negSign) {
            return UInt16(this.int)
        } else {
            let u: UInt16 = !UInt16((this.int - 1) & 0xffff)
            return u
        }
    }








    /*
     * @throws OverflowException
     */
    public func toUInt32(overflowHandling!: OverflowStrategy = Throwing): UInt32 {
        if (this.intArr.isEmpty() && !this.negSign && this.int <= 4294967295) {
            return UInt32(this.int)
        }
        match (overflowHandling) {
            case Throwing => throw OverflowException("Out of range of the UInt32.")
            case Wrapping => toUInt32Wrapping()
            case Saturating =>
                if (this.negSign) {
                    UInt32.Min
                } else {
                    UInt32.Max
                }
        }
    }

    @OverflowWrapping
    /*
     * @noThrow
     */
    private func toUInt32Wrapping(): UInt32 {
        if (!this.negSign) {
            return UInt32(this.int)
        } else {
            let u: UInt32 = !UInt32((this.int - 1) & 0xffffffff)
            return u
        }
    }








    /*
     * @throws OverflowException
     */
    public func toUInt64(overflowHandling!: OverflowStrategy = Throwing): UInt64 {
        if (this.intArr.isEmpty() && !this.negSign) {
            return this.int
        }
        match (overflowHandling) {
            case Throwing => throw OverflowException("Out of range of the UInt64.")
            case Wrapping => toUInt64Wrapping()
            case Saturating =>
                if (this.negSign) {
                    UInt64.Min
                } else {
                    UInt64.Max
                }
        }
    }

    @OverflowWrapping
    /*
     * @noThrow
     */
    private func toUInt64Wrapping(): UInt64 {
        if (!this.negSign) {
            return this.int
        } else {
            let u: UInt64 = !(this.int - 1)
            return u
        }
    }

    /*
     * @throws OverflowException
     * @throws Exception
     */
    public func toUIntNative(overflowHandling!: OverflowStrategy = Throwing): UIntNative {
        let len: UIntNative = uintNativeLen()
        return match (len) {
            case 20 => UIntNative(this.toUInt64(overflowHandling: overflowHandling))
            case 10 => UIntNative(this.toUInt32(overflowHandling: overflowHandling))
            case _ => throw Exception("Unrecognized UIntNative.")
        }
    }

    /*
     * @noThrow
     */
    private func uintNativeLen(): UIntNative {
        var num: UIntNative = 0
        var n: UIntNative = UIntNative.Max
        while (n != 0) {
            n /= 10
            num += 1
        }
        return num
    }
    /*
     * @throws IndexOutOfBoundsException
     */
    private func calculateStrArrSize(anyBase: UInt64): Int64 {
        let powerOfTwo = 64 - leadingZeros(anyBase) - 1
        return (32 * (intArr.size + 2) / Int64(powerOfTwo) + 1)
    }

    /*
     * @noThrow
     */
    private func calculateBaseStrSize(base: Int64): Int64 {
        let u64Base = UInt64(base)
        var n: UInt64 = 1
        var uInt = int / u64Base + 1
        var size = 1
        while (n < uInt) {
            size++
            n *= u64Base
        }
        return size
    }

    /*
     * @throws IndexOutOfBoundsException
     */
    func isPowerOfTwo(): Bool {
        if (intArr.size == 0) {
            return (UInt64(1) << trailingZeros(int)) == int
        } else {
            if (int != 0) {
                return false
            }
            for (i in 0..intArr.size - 1) {
                if (intArr[i] != 0) {
                    return false
                }
            }
            return (UInt32(1) << trailingZeros(intArr[intArr.size - 1])) == intArr[intArr.size - 1]
        }
    }

    /*
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     * @throws ArithmeticException
     */
    func div(thatInt: UInt64, thatArr: Array<UInt32>, thatNegSign: Bool): (UInt64, Array<UInt32>, Bool) {
        if (thatInt == 0 && thatArr.size == 0) {
            throw ArithmeticException("Divided by zero!")
        }
        if (this.sign == 0) {
            return (0, EMPTY_ARRAY, false)
        }
        if (this.intArr.size == 0 && thatArr.size == 0) {
            return (this.int / thatInt, EMPTY_ARRAY, this.negSign != thatNegSign)
        }
        let c = compareAbsArr(this.intArr, thatArr, 0)
        if (c == 0) {
            if (this.int >= thatInt) {
                return (1, EMPTY_ARRAY, this.negSign != thatNegSign)
            }
            return (0, EMPTY_ARRAY, false)
        }
        if (c == -1) {
            return (0, EMPTY_ARRAY, false)
        }
        let rArr: Array<UInt32>
        let rInt: UInt64
        if (thatArr.size == 0) {
            if (thatInt <= 0xFFFF_FFFF) {
                let rem: UInt64
                (rArr, rem) = divByUInt32InSitu(this.intArr.clone(), thatInt)
                let remInt0 = ((0x8000_0000_0000_0000 % thatInt) * (2 * rem % thatInt)) % thatInt
                rInt = 2 * rem * (0x8000_0000_0000_0000 / thatInt) + (2 * rem * (0x8000_0000_0000_0000 % thatInt)) /
                    thatInt + (this.int / thatInt) + (this.int % thatInt + remInt0) / thatInt
            } else {
                (rInt, rArr, _, _) = knuthDivAndMod(thatInt, needMod: false)
            }
        } else {
            (rInt, rArr, _, _) = knuthDivAndMod(thatInt, thatArr, needMod: false)
        }
        return (rInt, rArr, this.negSign != thatNegSign)
    }

    /*
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     * @throws ArithmeticException
     */
    private func privateDivAndMod(thatInt: UInt64, thatArr: Array<UInt32>, thatNegSign: Bool): (UInt64, Array<UInt32>, 
        Bool, UInt64, Array<UInt32>, Bool) {
        if (thatInt == 0 && thatArr.size == 0) {
            throw ArithmeticException("Divided by zero!")
        }
        if (this.sign == 0) {
            return (0, EMPTY_ARRAY, false, 0, EMPTY_ARRAY, false)
        }
        if (this.intArr.size == 0 && thatArr.size == 0) {
            return (this.int / thatInt, EMPTY_ARRAY, this.negSign != thatNegSign, this.int % thatInt, EMPTY_ARRAY, this
                    .negSign)
        }
        let c = compareAbsArr(this.intArr, thatArr, 0)
        if (c == 0) {
            if (this.int >= thatInt) {
                return (1, EMPTY_ARRAY, this.negSign != thatNegSign, this.int - thatInt, EMPTY_ARRAY, this.negSign)
            }
            return (0, EMPTY_ARRAY, false, this.int, this.intArr.clone(), this.negSign)
        }
        if (c == -1) {
            return (0, EMPTY_ARRAY, false, this.int, this.intArr.clone(), this.negSign)
        }
        let rArr: Array<UInt32>
        let remArr: Array<UInt32>
        let rInt: UInt64
        let remInt: UInt64
        if (thatArr.size == 0) {
            if (thatInt <= 0xFFFF_FFFF) {
                let rem: UInt64
                (rArr, rem) = divByUInt32InSitu(this.intArr.clone(), thatInt)
                let remInt0 = ((0x8000_0000_0000_0000 % thatInt) * (2 * rem % thatInt)) % thatInt
                rInt = 2 * rem * (0x8000_0000_0000_0000 / thatInt) + (2 * rem * (0x8000_0000_0000_0000 % thatInt)) /
                    thatInt + (this.int / thatInt) + (this.int % thatInt + remInt0) / thatInt
                remInt = (remInt0 + this.int % thatInt) % thatInt
                remArr = EMPTY_ARRAY
            } else {
                (rInt, rArr, remInt, remArr) = knuthDivAndMod(thatInt)
            }
        } else {
            (rInt, rArr, remInt, remArr) = knuthDivAndMod(thatInt, thatArr)
        }
        return (rInt, rArr, this.negSign != thatNegSign, remInt, remArr, this.negSign)
    }
    /*
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    private func knuthDivAndMod(thatInt: UInt64, thatArr: Array<UInt32>, needMod!: Bool = true): (UInt64, Array<UInt32>, 
        UInt64, Array<UInt32>) {
        let sizeDD = intArr.size + 1 + 2
        let sizeD = thatArr.size + 2
        let l = leadingZeros(thatArr[thatArr.size - 1])
        let normalizedDividend = knuthNormalize(sizeDD, this.int, this.intArr, l)
        let normalizedDivisor = knuthNormalize(sizeD, thatInt, thatArr, l)
        var j = sizeDD - sizeD - 1
        var rArr: Array<UInt32> = EMPTY_ARRAY
        var rInt: UInt64 = 0
        if (j >= 2) {
            rArr = Array<UInt32>(j - 1, repeat: 0)
        }
        while (j >= 0) {
            let q = knuthDivGuessQ(normalizedDividend, normalizedDivisor, sizeD, j)
            if (j >= 2) {
                rArr[j - 2] = UInt32(q)
            } else {
                rInt = rInt << 32
                rInt += q
            }
            j--
        }
        if (!needMod) {
            return (rInt, normalize(rArr), 0, EMPTY_ARRAY)
        }
        let remArr = shiftRightInSitu(normalizedDividend, l)
        let remInt = UInt64(remArr[0]) + (UInt64(remArr[1]) << 32)
        return (rInt, normalize(rArr), remInt, normalize(remArr[2..]))
    }
    /*
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    private func knuthDivAndMod(that: UInt64, needMod!: Bool = true): (UInt64, Array<UInt32>, UInt64, Array<UInt32>) {
        let sizeDD = intArr.size + 1 + 2
        let l = leadingZeros(that)
        let normalizedDividend = knuthNormalize(sizeDD, this.int, this.intArr, l)
        let normalizedDivisor = that << l
        var j = intArr.size
        var rArr: Array<UInt32> = EMPTY_ARRAY
        var rInt: UInt64 = 0
        if (j >= 2) {
            rArr = Array<UInt32>(j - 1, repeat: 0)
        }
        while (j >= 0) {
            let q = knuthDivGuessQ(normalizedDividend, normalizedDivisor, j)
            if (j >= 2) {
                rArr[j - 2] = UInt32(q)
            } else {
                rInt = rInt << 32
                rInt += q
            }
            j--
        }
        if (!needMod) {
            return (rInt, normalize(rArr), 0, EMPTY_ARRAY)
        }
        let remArr = shiftRightInSitu(normalizedDividend, l)
        let remInt = UInt64(remArr[0]) + (UInt64(remArr[1]) << 32)
        return (rInt, normalize(rArr), remInt, normalize(remArr[2..]))
    }

    /*
     * @throws IndexOutOfBoundsException
     */
    func compareMagnitude(that: BigInt): Int64 {
        let c = compareAbsArr(this.intArr, that.intArr, 0)
        if (c == 0) {
            return if (this.int > that.int) {
                1
            } else if (this.int < that.int) {
                -1
            } else {
                0
            }
        }
        return c
    }

    /*
     * @throws IllegalArgumentException
     * @throws ArithmeticException
     * @throws IndexOutOfBoundsException
     */
    func compareDouble(that: BigInt): Int64 {
        let double = that << 1
        return -compareMagnitude(double)
    }

    /*
     * @noThrow
     */
    func isOdd() {
        return (this.int & 1) == 1
    }
}




/*
 * @noThrow
 */
public func abs(i: BigInt): BigInt {
    return BigInt(i.int, i.intArr.clone(), false)
}







/*
 * @throws ArithmeticException
 * @throws IndexOutOfBoundsException
 * @throws IllegalArgumentException
 */
public func sqrt(i: BigInt): BigInt {
    if (i.sign == 0) {
        return BigInt(0, EMPTY_ARRAY, false)
    }
    if (i.negSign) {
        throw IllegalArgumentException("The BigInt be used to calculate the square root must >= 0.")
    }
    var xInt = i.int
    if (i.intArr.size == 0) {
        var y: UInt64 = if (xInt == 0xFFFF_FFFF_FFFF_FFFF) {
            0x8000_0000_0000_0000
        } else {
            (xInt + i.int / xInt) / 2
        }
        while (xInt > y) {
            xInt = y
            y = (xInt + i.int / xInt) / 2
        }
        return BigInt(xInt, EMPTY_ARRAY, false)
    }
    var xArr = Array<UInt32>(i.intArr.size + 1, repeat: 0)
    i.intArr.copyTo(xArr, 0, 0, i.intArr.size)
    let (qInt, qArr, _) = i.div(xInt, normalize(xArr), false)
    if (isNoLessThan(qInt, qArr, xInt, xArr)) {
        return BigInt(xInt, normalize(xArr), false)
    }
    let (resultInt, carry) = addUInt64(xInt, qInt)
    addInSitu(xArr, qArr, carry)
    (xInt, xArr) = divBy2Insitu(resultInt, xArr)
    while (true) {
        let (qInt, qArr, _) = i.div(xInt, normalize(xArr), false)
        if (isNoLessThan(qInt, qArr, xInt, xArr)) {
            break
        }
        let (resultInt, carry) = addUInt64(xInt, qInt)
        addInSitu(xArr, qArr, carry)
        (xInt, xArr) = divBy2Insitu(resultInt, xArr)
    }
    return BigInt(xInt, normalize(xArr), false)
}








/*
 * @throws IllegalArgumentException
 * @throws IndexOutOfBoundsException
 */
public func gcd(i1: BigInt, i2: BigInt): BigInt {
    if (i1.sign == 0) {
        return BigInt(i2.int, i2.intArr.clone(), false)
    }
    if (i2.sign == 0) {
        return BigInt(i1.int, i1.intArr.clone(), false)
    }
    let (i1Int, i1Arr) = gcd(i1.int, i1.intArr, i2.int, i2.intArr)
    return BigInt(i1Int, i1Arr, false)
}








/*
 * @throws ArithmeticException
 * @throws IllegalArgumentException
 * @throws IndexOutOfBoundsException
 */
public func lcm(i1: BigInt, i2: BigInt): BigInt {
    if (i1.sign == 0 || i2.sign == 0) {
        return BigInt(0, EMPTY_ARRAY, false)
    }
    let (i1Int, i1Arr) = gcd(i1.int, i1.intArr, i2.int, i2.intArr)
    let (qInt, qArr, _) = i1.div(i1Int, i1Arr, false)
    let (rInt, rArr) = mul(qInt, qArr, i2.int, i2.intArr)
    return BigInt(rInt, rArr, false)
}

@Deprecated[message: "Use global function `public func countOnes(i: BigInt): Int64` instead."]
/*
 * @throws IndexOutOfBoundsException
 */
public func countOne(i: BigInt): Int64 {
    return countOnes(i)
}







/*
 * @throws IndexOutOfBoundsException
 */
public func countOnes(i: BigInt): Int64 {
    if (i.sign == 0) {
        return 0
    }
    if (i.isPowerOfTwo()) {
        return 1
    }
    var count = 0
    if (!i.negSign) {
        count += countOnes(i.int)
        for (index in i.intArr.size - 1..=0 : -1) {
            count += countOnes(i.intArr[index])
        }
        return count
    }
    if (i.intArr.size == 0) {
        count += countZero(i.int)
        return count + 1 - Int64(trailingZeros(i.int)) + 1
    }
    count += 64 - countOnes(i.int)
    for (index in i.intArr.size - 2..=0 : -1) {
        count += 32 - countOnes(i.intArr[index])
    }
    count += countZero(i.intArr[i.intArr.size - 1])
    var bTrailingZeros = Int64(trailingZeros(i.int))
    if (bTrailingZeros == 64) {
        var int32TrailingZeros = 0
        var index = 0
        do {
            int32TrailingZeros = Int64(trailingZeros(i.intArr[index]))
            bTrailingZeros += int32TrailingZeros
            index++
        } while (int32TrailingZeros == 32)
    }
    return count + 1 - bTrailingZeros + 1
}






/*
 * @throws IndexOutOfBoundsException
 */
public func trailingZeros(x: BigInt): Int64 {
    if (x.sign == 0) {
        return -1
    }
    if (x.int != 0) {
        return Int64(trailingZeros(x.int))
    }
    var index = 64
    for (i in 0..x.intArr.size) {
        if (x.intArr[i] == 0) {
            index += 32
        } else {
            index += Int64(trailingZeros(x.intArr[i]))
        }
    }
    return index
}

enum Operator {
    | Xor
    | Or

    /*
     * @noThrow
     */
    func op(x: UInt64, y: UInt64): UInt64 {
        match (this) {
            case Xor => return x ^ y
            case Or => return x | y
        }
    }

    /*
     * @noThrow
     */
    func op(x: UInt32, y: UInt32): UInt32 {
        match (this) {
            case Xor => return x ^ y
            case Or => return x | y
        }
    }
}

/*
 * @noThrow
 */
func countOnes(int64: UInt64): Int64 {
    var count64 = 0
    var val = int64
    while (val != 0) {
        count64 += Int64(val & 1)
        val >>= 1
    }
    return count64
}

/*
 * @noThrow
 */
func countOnes(int: UInt32): Int64 {
    var count32 = 0
    var val = int
    while (val != 0) {
        count32 += Int64(val & 1)
        val >>= 1
    }
    return count32
}


/*
 * @noThrow
 */
func countZero(int64: UInt64): Int64 {
    var countZero64 = 0
    var val = int64
    while (val != 0) {
        countZero64 += Int64((val ^ 1) & 1)
        val >>= 1
    }
    return countZero64
}

/*
 * @noThrow
 */
func countZero(int: UInt32): Int64 {
    var countZero32 = 0
    var val = int
    while (val != 0) {
        countZero32 += Int64((val ^ 1) & 1)
        val >>= 1
    }
    return countZero32
}

/*
 * @throws IndexOutOfBoundsException
 */
func and(thisInt: UInt64, thisArr: Array<UInt32>, thatInt: UInt64, thatArr: Array<UInt32>): (UInt64, Array<UInt32>) {
    let rInt = thisInt & thatInt
    let size = min(thisArr.size, thatArr.size)
    if (size == 0) {
        return (rInt, EMPTY_ARRAY)
    }
    let rArr = Array<UInt32>(size, repeat: 0)
    for (i in 0..size) {
        rArr[i] = thisArr[i] & thatArr[i]
    }
    return (rInt, rArr)
}

/*
 * @throws IndexOutOfBoundsException
 */
func orOrXor(thisBig: BigInt, thatBig: BigInt, bitOperator: Operator): (UInt64, Array<UInt32>) {
    let rInt = bitOperator.op(thisBig.int, thatBig.int)
    if (thisBig.intArr.size == 0 && thatBig.intArr.size == 0) {
        return (rInt, EMPTY_ARRAY)
    }
    let rArr: Array<UInt32>
    if (thisBig.intArr.size > thatBig.intArr.size) {
        rArr = thisBig.intArr.clone()
        for (i in 0..thatBig.intArr.size) {
            rArr[i] = bitOperator.op(rArr[i], thatBig.intArr[i])
        }
    } else {
        rArr = thatBig.intArr.clone()
        for (i in 0..thisBig.intArr.size) {
            rArr[i] = bitOperator.op(rArr[i], thisBig.intArr[i])
        }
    }
    return (rInt, rArr)
}

/*
 * @throws IllegalArgumentException
 * @throws IndexOutOfBoundsException
 */
func subOneAnd(thisInt: UInt64, thisArr: Array<UInt32>, thatInt: UInt64, thatArr: Array<UInt32>): (UInt64, Array<UInt32>) {
    var rInt: UInt64
    let rArr: Array<UInt32>
    let bitInt: UInt64
    let bitArr: Array<UInt32>
    if (thisArr.size < thatArr.size) {
        (rInt, rArr) = subOne(thisInt, thisArr, true)
        (bitInt, bitArr) = resetSizeAndSubOne(thatInt, thatArr, thisArr.size, false)
    } else {
        (rInt, rArr) = subOne(thatInt, thatArr, true)
        (bitInt, bitArr) = resetSizeAndSubOne(thisInt, thisArr, thatArr.size, false)
    }
    rInt &= bitInt
    for (i in 0..rArr.size) {
        rArr[i] &= bitArr[i]
    }
    return (rInt, rArr)
}

/*
 * @throws IndexOutOfBoundsException
 */
func subOneOrOrXor(thisInt: UInt64, thisArr: Array<UInt32>, thatInt: UInt64, thatArr: Array<UInt32>,
    bitOperator: Operator): (UInt64, Array<UInt32>) {
    var rInt: UInt64
    let rArr: Array<UInt32>
    let bitInt: UInt64
    let bitArr: Array<UInt32>
    if (thisArr.size > thatArr.size) {
        (rInt, rArr) = subOne(thisInt, thisArr, true)
        (bitInt, bitArr) = subOne(thatInt, thatArr, false)
    } else {
        (rInt, rArr) = subOne(thatInt, thatArr, true)
        (bitInt, bitArr) = subOne(thisInt, thisArr, false)
    }
    rInt = bitOperator.op(rInt, bitInt)
    for (i in 0..bitArr.size) {
        rArr[i] = bitOperator.op(rArr[i], bitArr[i])
    }
    return (rInt, rArr)
}

/*
 * @throws IndexOutOfBoundsException
 */
func subOne(int: UInt64, intArr: Array<UInt32>, shouldClone: Bool): (UInt64, Array<UInt32>) {
    let rInt: UInt64
    let rArr: Array<UInt32>
    if (int >= 1) {
        rInt = int - 1
        if (shouldClone) {
            rArr = intArr.clone()
        } else {
            rArr = intArr
        }
    } else {
        rInt = 0xFFFF_FFFF_FFFF_FFFF
        rArr = intArr.clone()
        subAndBorrow(rArr, 0, 1)
    }
    return (rInt, rArr)
}

/*
 * @throws IllegalArgumentException
 * @throws IndexOutOfBoundsException
 */
func resetSizeAndSubOne(int: UInt64, intArr: Array<UInt32>, size: Int64, shouldClone: Bool): (UInt64, Array<UInt32>) {
    let rInt: UInt64
    let rArr: Array<UInt32>
    if (int >= 1) {
        rInt = int - 1
        if (shouldClone) {
            rArr = Array<UInt32>(size, repeat: 0)
            intArr.copyTo(rArr, 0, 0, min(intArr.size, size))
        } else {
            rArr = intArr[..size]
        }
    } else {
        rInt = 0xFFFF_FFFF_FFFF_FFFF
        if (size == 0) {
            return (rInt, EMPTY_ARRAY)
        }
        rArr = Array<UInt32>(size, repeat: 0)
        intArr.copyTo(rArr, 0, 0, min(intArr.size, size))
        rArr[0] = if (rArr[0] >= 1) {
            rArr[0] - 1
        } else {
            var j = 1
            while (j < rArr.size && rArr[j] == 0) {
                rArr[j] = 0xFFFF_FFFF
                j++
            }
            if (j < rArr.size) {
                rArr[j] -= 1
            }
            0xFFFF_FFFF
        }
    }
    return (rInt, rArr)
}
/*
 * @throws IllegalArgumentException
 * @throws IndexOutOfBoundsException
 */
func addOneAndOverSize(int: UInt64, intArr: Array<UInt32>): (UInt64, Array<UInt32>) {
    if (int == 0xFFFF_FFFF_FFFF_FFFF) {
        for (i in intArr.size - 1..=0 : -1) {
            if (intArr[i] != 0xFFFF_FFFF) {
                return (0, addInSitu(intArr, EMPTY_ARRAY, 1))
            }
        }
        let oneMoreSizeArr = Array<UInt32>(intArr.size + 1, repeat: 0)
        oneMoreSizeArr[intArr.size] = 1
        return (0, oneMoreSizeArr)
    }
    return (int + 1, intArr)
}

/*
 * @throws IllegalArgumentException
 * @throws IndexOutOfBoundsException
 */
func negBitOrOrXor(thisBig: BigInt, index: Int64, bitOperator: Operator): BigInt {
    if (index == 0 && thisBig.int == 0xFFFF_FFFF_FFFF_FFFF) {
        var rArrPlus = thisBig.intArr.clone()
        for (i in rArrPlus.size - 1..=0 : -1) {
            if (rArrPlus[i] != 0xFFFF_FFFF) {
                addInSitu(rArrPlus, EMPTY_ARRAY, 1)
                return BigInt(0, rArrPlus, true)
            }
        }
        rArrPlus = Array<UInt32>(thisBig.intArr.size + 1, repeat: 0)
        rArrPlus[thisBig.intArr.size] = 1
        return BigInt(0, rArrPlus, true)
    }
    if (index < 64) {
        let (bitInt, bitArr) = subOne(thisBig.int, thisBig.intArr, true)
        let rInt = bitOperator.op((UInt64(1) << index), bitInt)
        if (rInt == 0xFFFF_FFFF_FFFF_FFFF) {
            return BigInt(0, addInSitu(bitArr, EMPTY_ARRAY, 1), true)
        }
        return BigInt(rInt + 1, normalize(bitArr), true)
    }
    let (arrIndex, u32Index) = arrIndexAndU32Index(index)
    let size = max(arrIndex + 1, thisBig.intArr.size)
    let bitArr = Array<UInt32>(size, repeat: 0)
    thisBig.intArr.copyTo(bitArr, 0, 0, thisBig.intArr.size)
    if (thisBig.int == 0) {
        subAndBorrow(bitArr, 0, 1)
    }
    bitArr[arrIndex] = bitOperator.op((UInt32(1) << u32Index), bitArr[arrIndex])
    if (thisBig.int == 0) {
        return BigInt(0, addInSitu(bitArr, EMPTY_ARRAY, 1), true)
    }
    return BigInt(thisBig.int, normalize(bitArr), true)
}

/*
 * @throws IndexOutOfBoundsException
 * @throws IllegalArgumentException
 */
func posBitOrOrXor(thisBig: BigInt, index: Int64, bitOperator: Operator): BigInt {
    if (index < 64) {
        return BigInt(bitOperator.op((UInt64(1) << index), thisBig.int), thisBig.intArr.clone(), false)
    }
    let (arrIndex, u32Index) = arrIndexAndU32Index(index)
    let size = max(arrIndex + 1, thisBig.intArr.size)
    let bitArr = Array<UInt32>(size, repeat: 0)
    thisBig.intArr.copyTo(bitArr, 0, 0, thisBig.intArr.size)
    bitArr[arrIndex] = bitOperator.op((UInt32(1) << u32Index), bitArr[arrIndex])
    return BigInt(thisBig.int, normalize(bitArr), false)
}

/*
 * @noThrow
 */
func arrIndexAndU32Index(index: Int64): (Int64, Int64) {
    return ((index - 64) >> 5, (index - 64) & 0x1F)
}

/*
 * @noThrow
 */
func deltaSizeAndU32Shift(index: Int64): (Int64, Int64) {
    return (index >> 5, index & 0x1F)
}
/*
 * @noThrow
 */
func shiftLeftUInt64(int: UInt64, shift64: Int64): (UInt32, UInt32, UInt32) {
    let carry: UInt32
    let rArr0: UInt32
    let left: UInt32
    if (shift64 >= 32) {
        let carry64 = int >> (64 - shift64)
        carry = UInt32(carry64 >> 32)
        rArr0 = UInt32(carry64 & 0xFFFF_FFFF)
        left = UInt32(int & 0xFFFF_FFFF) << (shift64 - 32)
    } else {
        carry = if (shift64 > 0) {
            UInt32(int >> (64 - shift64))
        } else {
            0
        }
        let left64 = int << shift64
        left = UInt32(left64 & 0xFFFF_FFFF)
        rArr0 = UInt32(left64 >> 32)
    }
    return (carry, rArr0, left)
}
/*
 * @throws IndexOutOfBoundsException
 */
func shiftRightToUInt64(int: UInt64, intArr: Array<UInt32>, delta: Int64, shift: Int64, carryRight: UInt32): UInt64 {
    var rInt: UInt64 = 0
    var carry = carryRight
    if (delta >= 2) {
        var shiftResult: UInt32
        if (intArr.size >= delta) {
            shiftResult = (intArr[delta - 1] >> shift) | carry
            carry = if (shift > 0) {
                intArr[delta - 1] << (32 - shift)
            } else {
                0
            }
            rInt = UInt64(shiftResult) << 32
        }
        if (intArr.size >= delta - 1) {
            shiftResult = (intArr[delta - 2] >> shift) | carry
            rInt |= UInt64(shiftResult)
        }
    } else if (delta == 1) {
        if (intArr.size >= 1) {
            var shiftResult = (intArr[delta - 1] >> shift) | carry
            carry = if (shift > 0) {
                intArr[delta - 1] << (32 - shift)
            } else {
                0
            }
            rInt = (UInt64(shiftResult) << 32)
        }
        rInt |= UInt64(carry)
        rInt |= (int >> (shift + 32))
    } else {
        rInt = (UInt64(carry) << 32) | (int >> shift)
    }
    return rInt
}
/*
 * @throws IndexOutOfBoundsException
 * @throws IllegalArgumentException
 */
func removeLeftZero(bytes: Array<Byte>): Array<Byte> {
    var i = 0
    while (i < bytes.size) {
        if (bytes[i] != 0) {
            break
        }
        i++
    }
    return bytes[i..]
}
/*
 * @throws IndexOutOfBoundsException
 */
func compToMag(bytes: Array<Byte>): Array<Byte> {
    let mag = Array<Byte>(bytes.size, {i => !bytes[i]})
    for (i in mag.size - 1..=0 : -1) {
        if (mag[i] == 255) {
            mag[i] = 0
        } else {
            mag[i] += 1
            break
        }
    }
    return mag
}
/*
 * @throws IndexOutOfBoundsException
 */
func fromBigBytesToSmallU32Array(bytes: Array<Byte>): Array<UInt32> {
    if (bytes.size == 0) {
        return EMPTY_ARRAY
    }
    let oneMore = if ((bytes.size & 3) == 0) {
        0
    } else {
        1
    }
    let size = bytes.size >> 2
    let smallU32 = Array<UInt32>(size + oneMore, repeat: 0)
    var index = bytes.size - 1
    for (i in 0..size) {
        var u32: UInt32 = 0
        for (j in 0..4) {
            u32 = u32 | UInt32(bytes[index]) << (j * 8)
            index--
        }
        smallU32[i] = u32
    }
    if (index >= 0) {
        var u32: UInt32 = UInt32(bytes[0])
        for (i in 1..=index) {
            u32 = u32 << 8
            u32 = u32 | UInt32(bytes[i])
        }
        smallU32[size] = u32
    }
    return smallU32
}
/*
 * @throws IndexOutOfBoundsException
 */
func fromBigBytesToU64(bytes: Array<Byte>): UInt64 {
    if (bytes.size == 0) {
        return 0
    }
    var u64: UInt64 = UInt64(bytes[0])
    for (i in 1..bytes.size) {
        u64 = u64 << 8
        u64 = u64 | UInt64(bytes[i])
    }
    return u64
}
/*
 * @throws IndexOutOfBoundsException
 */
func fromU64ToBigBytes(byteArr: Array<Byte>, int: UInt64) {
    var j = 0
    for (i in byteArr.size - 1..=0 : -1) {
        if (j == 8) {
            return
        }
        byteArr[i] = UInt8((int & (0xFF << (8 * j))) >> (8 * j))
        j++
    }
}
/*
 * @throws IndexOutOfBoundsException
 */
func fromSmallU32ArrayToBigBytes(byteArr: Array<Byte>, intArr: Array<UInt32>) {
    var i = byteArr.size - 1
    var j = 0
    var index = 0
    while (i >= 0) {
        if (j == 4) {
            j = 0
            index++
            if (index >= intArr.size) {
                break
            }
        }
        byteArr[i] = UInt8((intArr[index] & (0xFF << (8 * j))) >> (8 * j))
        j++
        i--
    }
}

/*
 * @throws IndexOutOfBoundsException
 */
func isAllZero(intArr: Array<UInt32>): Bool {
    for (i in intArr.size - 1..=0 : -1) {
        if (intArr[i] != 0) {
            return false
        }
    }
    return true
}
/*
 * @noThrow
 */
func uInt64Mul(thisInt: UInt64, thatInt: UInt64): (UInt64, UInt32, UInt32) {
    let thisInt0: UInt64 = thisInt & 0xFFFF_FFFF
    let thisInt1: UInt64 = thisInt >> 32
    let thatInt0: UInt64 = thatInt & 0xFFFF_FFFF
    let thatInt1: UInt64 = thatInt >> 32
    var resultInt0 = thisInt0 * thatInt0
    var resultInt1 = (thisInt0 * thatInt1) + (resultInt0 >> 32)
    resultInt0 = resultInt0 & 0xFFFF_FFFF
    var resultInt2 = resultInt1 >> 32
    resultInt1 = (resultInt1 & 0xFFFF_FFFF) + (thisInt1 * thatInt0)
    resultInt2 += (resultInt1 >> 32)
    resultInt1 = resultInt1 & 0xFFFF_FFFF
    resultInt2 += (thisInt1 * thatInt1)
    let resultInt3 = (resultInt2 >> 32)
    resultInt2 = (resultInt2 & 0xFFFF_FFFF)
    let int = resultInt0 | (resultInt1 << 32)
    return (int, UInt32(resultInt2), UInt32(resultInt3))
}
/*
 * @throws IndexOutOfBoundsException
 */
func calculateStrArr(stringArr: Array<UInt64>, big: BigInt, bound: Int64, anyBase: UInt64): Int64 {
    var stringArrBound = bound
    var i = big.intArr.size - 1
    while (i >= 0) {
        stringArrBound = calculateStrArr(stringArr, UInt64(big.intArr[i]), stringArrBound, anyBase)
        i--
    }
    stringArrBound = calculateStrArr(stringArr, big.int >> 32, stringArrBound, anyBase)
    return calculateStrArr(stringArr, big.int & 0xFFFF_FFFF, stringArrBound, anyBase)
}

/*
 * @throws IndexOutOfBoundsException
 */
func calculateStrArr(stringArr: Array<UInt64>, int: UInt64, bound: Int64, anyBase: UInt64): Int64 {
    var stringArrBound = bound
    for (j in stringArrBound - 1..=0 : -1) {
        stringArr[j] <<= 32
    }
    stringArr[0] += int
    for (j in 0..stringArrBound - 1) {
        stringArr[j + 1] += stringArr[j] / anyBase
        stringArr[j] %= anyBase
    }
    var rem = stringArr[stringArrBound - 1] / anyBase
    stringArr[stringArrBound - 1] %= anyBase
    while (rem > 0) {
        stringArr[stringArrBound] = rem
        stringArrBound++
        rem = stringArr[stringArrBound - 1] / anyBase
        stringArr[stringArrBound - 1] %= anyBase
    }
    return stringArrBound
}
/*
 * @throws IndexOutOfBoundsException
 */
func toBaseString(stringUtf8Arr: Array<Byte>, index: Int64, int: UInt64, base: UInt64): Int64 {
    var i = index
    var quo = int
    while (quo != 0) {
        let rem = UInt8(quo % UInt64(base))
        if (rem < 10) {
            stringUtf8Arr[i] = rem + DIGIT_DIFF
        } else {
            stringUtf8Arr[i] = rem + LETTER_UPPER_DIFF
        }
        quo = quo / UInt64(base)
        i--
    }
    return i
}

/*
 * @throws IndexOutOfBoundsException
 * @throws IllegalArgumentException
 */
func normalize(value: Array<UInt32>): Array<UInt32> {
    var preZeroNum = value.size - 1
    while (preZeroNum >= 0 && value[preZeroNum] == 0) {
        preZeroNum--
    }
    return value[..=preZeroNum]
}

/*
 * @throws IndexOutOfBoundsException
 * @throws IllegalArgumentException
 */
func parseString(s: String, base: UInt64): (UInt64, Array<UInt32>, Bool) {
    let (isNeg, start) = parseSign(s)
    let (int, arr) = parseDigits(s, start, base)
    if (int == 0 && arr.size == 0) {
        return (int, arr, false)
    }
    return (int, arr, isNeg)
}


/*
 * @throws IndexOutOfBoundsException
 * @throws IllegalArgumentException
 */
func parseDigits(s: String, idx: Int64, radix: UInt64): (UInt64, Array<UInt32>) {
    if (idx >= s.size) {
        throw IllegalArgumentException("Invalid string.")
    }
    var numberArray = initNumArray(s, idx, UInt8(radix))
    let (digits, _) = calculateLenAndBase(radix)
    let size = (s.size - idx) / digits + 1
    if (size <= 2) {
        var int: UInt64 = 0
        for (i in 0..numberArray.size) {
            int *= radix
            int += UInt64(numberArray[i])
        }
        if (int == 0) {
            return (0, EMPTY_ARRAY)
        }
        return (int, EMPTY_ARRAY)
    }
    return calculateUInt32Arr(size - 2, numberArray, radix)
}


/*
 * @throws IndexOutOfBoundsException
 * @throws IllegalArgumentException
 */
func parseSign(s: String): (Bool, Int64) {
    if (s.size == 0) {
        throw IllegalArgumentException("Invalid string.")
    }
    return match (s[0]) {
        case b'-' => (true, 1)
        case b'+' => (false, 1)
        case _ => (false, 0)
    }
}


/*
 * @throws IndexOutOfBoundsException
 * @throws IllegalArgumentException
 */
func parseBase(s: String, idx: Int64): (UInt64, Int64) {
    if (idx >= s.size) {
        throw IllegalArgumentException("Invalid string.")
    }
    if (s[idx] != b'0' || idx + 1 == s.size) {
        return (10, 0)
    }
    return match (s[idx + 1]) {
        case b'b' | b'B' => (2, 2)
        case b'o' | b'O' => (8, 2)
        case b'x' | b'X' => (16, 2)
        case _ => (10, 0)
    }
}

/*
 * @noThrow
 */
func calculateLenAndBase(base: UInt64): (Int64, UInt64) {
    var anyBase = base
    var digits = 1
    while (anyBase < 0xFFFF_FFFF) {
        anyBase *= base
        digits++
    }
    anyBase /= base
    digits--
    return (digits, anyBase)
}

/*
 * @throws IndexOutOfBoundsException
 * @throws IllegalArgumentException
 */
func calculateUInt32Arr(size: Int64, numberArray: Array<UInt8>, base: UInt64): (UInt64, Array<UInt32>) {
    let resultArr = Array<UInt32>(size, repeat: 0)
    var int: UInt64 = 0
    var index = -2
    var numbers = numberArray
    var numSize = numbers.size
    while (numSize != 0) {
        var nextSize = 0
        var dividend: UInt64 = 0
        var i = 0
        while (i < numSize) {
            dividend *= base
            dividend += UInt64(numbers[i])
            i++
            let quo = dividend >> 32
            if (quo == 0) {
                if (nextSize != 0) {
                    numberArray[nextSize] = UInt8(quo)
                    nextSize++
                }
                continue
            }
            numberArray[nextSize] = UInt8(quo)
            nextSize++
            dividend = dividend & 0xFFFF_FFFF
        }
        if (index == -2) {
            int = dividend & 0xFFFF_FFFF
        } else if (index == -1) {
            int |= (dividend & 0xFFFF_FFFF) << 32
        } else {
            resultArr[index] = UInt32(dividend & 0xFFFF_FFFF)
        }
        index++
        numSize = nextSize
    }
    return (int, normalize(resultArr))
}

/*
 * @throws IndexOutOfBoundsException
 * @throws IllegalArgumentException
 */
func initNumArray(s: String, index: Int64, base: UInt8): Array<UInt8> {
    let numberArray = Array<UInt8>(s.size, repeat: 0)
    for (i in index..s.size) {
        if (s[i].isAsciiNumber() && s[i] - DIGIT_DIFF < base) {
            numberArray[i] = s[i] - DIGIT_DIFF
        } else if (s[i].isAsciiLowerCase() && s[i] - LETTER_LOWER_DIFF < base) {
            numberArray[i] = s[i] - LETTER_LOWER_DIFF
        } else if (s[i].isAsciiUpperCase() && s[i] - LETTER_UPPER_DIFF < base) {
            numberArray[i] = s[i] - LETTER_UPPER_DIFF
        } else {
            throw IllegalArgumentException("Invalid string.")
        }
    }
    return numberArray
}
/*
 * @throws IndexOutOfBoundsException
 * @throws IllegalArgumentException
 */
func modAddAbsOfDivisor(int: UInt64, intArr: Array<UInt32>, thatBig: BigInt): BigInt {
    let isIntNeg: Bool
    var resultIntAbs: UInt64
    if (thatBig.int >= int) {
        isIntNeg = false
        resultIntAbs = thatBig.int - int
    } else {
        isIntNeg = true
        resultIntAbs = int - thatBig.int
    }
    let resultArr = thatBig.intArr.clone()
    if (isIntNeg) {
        subAndBorrow(resultArr, 0, 1)
        resultIntAbs = 0xFFFF_FFFF_FFFF_FFFF - resultIntAbs + 1
    }
    subInSitu(resultArr, intArr, 0)
    return BigInt(resultIntAbs, normalize(resultArr), false)
}
/*
 * @throws IndexOutOfBoundsException
 * @throws IllegalArgumentException
 */
func addAbs(thisInt: UInt64, thisArr: Array<UInt32>, thatInt: UInt64, thatArr: Array<UInt32>): (UInt64, Array<UInt32>) {
    let (resultInt, carry) = addUInt64(thisInt, thatInt)
    if (thisArr.size == 0 && thatArr.size == 0) {
        if (carry == 1) {
            return (resultInt, Array<UInt32>(1, repeat: 1))
        }
        return (resultInt, EMPTY_ARRAY)
    }
    let (addend1, addend2) = if (thisArr.size > thatArr.size) {
        (thisArr, thatArr)
    } else {
        (thatArr, thisArr)
    }
    let resultArr = Array<UInt32>(addend1.size + 1, repeat: 0)
    addend1.copyTo(resultArr, 0, 0, addend1.size)
    addInSitu(resultArr, addend2, carry)
    return (resultInt, normalize(resultArr))
}

/*
 * @noThrow
 */
func addUInt64(thisInt: UInt64, thatInt: UInt64): (UInt64, UInt64) {
    var resultInt = (thisInt & 0x7FFF_FFFF_FFFF_FFFF) + (thatInt & 0x7FFF_FFFF_FFFF_FFFF)
    let leftResult = (resultInt >> 63) + (thisInt >> 63) + (thatInt >> 63)
    let carry: UInt64 = if (leftResult == 3) {
        resultInt = resultInt | 0x8000_0000_0000_0000
        1
    } else if (leftResult == 2) {
        resultInt = resultInt & 0x7FFF_FFFF_FFFF_FFFF
        1
    } else if (leftResult == 1) {
        resultInt = resultInt | 0x8000_0000_0000_0000
        0
    } else {
        0
    }
    return (resultInt, carry)
}

/*
 * @throws IndexOutOfBoundsException
 * @throws IllegalArgumentException
 */
func addInSitu(summand: Array<UInt32>, addend: Array<UInt32>, carry: UInt64): Array<UInt32> {
    var c: UInt64 = carry
    for (i in 0..addend.size) {
        let sum = UInt64(summand[i]) + UInt64(addend[i]) + c
        summand[i] = UInt32(sum & 0xFFFF_FFFF)
        c = sum >> 32
    }
    for (i in addend.size..summand.size) {
        if (c == 0) {
            break
        }
        let sum = UInt64(summand[i]) + c
        summand[i] = UInt32(sum & 0xFFFF_FFFF)
        c = sum >> 32
    }
    return normalize(summand)
}

/*
 * @throws IndexOutOfBoundsException
 * @throws IllegalArgumentException
 */
func subAbs(thisInt: UInt64, thisArr: Array<UInt32>, thatInt: UInt64, thatArr: Array<UInt32>, negSign: Bool): (UInt64, 
    Array<UInt32>, Bool) {
    let isIntNeg: Bool
    var resultIntAbs: UInt64
    if (thisInt >= thatInt) {
        isIntNeg = false
        resultIntAbs = thisInt - thatInt
    } else {
        isIntNeg = true
        resultIntAbs = thatInt - thisInt
    }
    let c = compareAbsArr(thisArr, thatArr, 0)
    if (c == 0) {
        return (resultIntAbs, EMPTY_ARRAY, isIntNeg != negSign)
    }
    let minuend: Array<UInt32>
    let subtrahend: Array<UInt32>
    let isArrNeg: Bool
    if (c == 1) {
        minuend = thisArr
        subtrahend = thatArr
        isArrNeg = false
    } else {
        minuend = thatArr
        subtrahend = thisArr
        isArrNeg = true
    }
    let resultArr = minuend.clone()
    if (isIntNeg != isArrNeg && resultIntAbs != 0) {
        subAndBorrow(resultArr, 0, 1)
        resultIntAbs = 0xFFFF_FFFF_FFFF_FFFF - resultIntAbs + 1
    }
    subInSitu(resultArr, subtrahend, 0)
    return (resultIntAbs, normalize(resultArr), isArrNeg != negSign)
}

/*
 * @throws IndexOutOfBoundsException
 * @throws IllegalArgumentException
 */
func subInSitu(minuend: Array<UInt32>, subtrahend: Array<UInt32>, offset: Int64): Array<UInt32> {
    for (i in 0..subtrahend.size) {
        subAndBorrow(minuend, i + offset, subtrahend[i])
    }
    return normalize(minuend)
}
/*
 * @throws IndexOutOfBoundsException
 */
func subAndBorrow(minuend: Array<UInt32>, index: Int64, subtrahend: UInt32): Unit {
    minuend[index] = if (minuend[index] >= subtrahend) {
        minuend[index] - subtrahend
    } else {
        var j = index + 1
        while (minuend[j] == 0) {
            minuend[j] = 0xFFFF_FFFF
            j++
        }
        minuend[j] -= 1
        0xFFFF_FFFF - subtrahend + minuend[index] + 1
    }
}

/*
 * @throws IllegalArgumentException
 * @throws IndexOutOfBoundsException
 */
func knuthNormalize(size: Int64, int: UInt64, intArr: Array<UInt32>, l: Int64): Array<UInt32> {
    let normalized = Array<UInt32>(size, repeat: 0)
    intArr.copyTo(normalized, 0, 2, intArr.size)
    normalized[0] = UInt32(int & 0xFFFF_FFFF)
    normalized[1] = UInt32(int >> 32)
    shiftLeftInSitu(normalized, l)
    return normalized
}
/*
 * @throws IndexOutOfBoundsException
 */
func shiftLeftInSitu(arr: Array<UInt32>, shift: Int64): Array<UInt32> {
    if (shift == 0) {
        return arr
    }
    var carry: UInt32 = 0
    for (i in 0..arr.size) {
        let shiftResult = (arr[i] << shift) | carry
        carry = arr[i] >> (32 - shift)
        arr[i] = shiftResult
    }
    return arr
}
/*
 * @throws IndexOutOfBoundsException
 */
func shiftLeftInSitu(int: UInt64, rArr: Array<UInt32>, shift: Int64, deltaSize: Int64): (UInt64, Array<UInt32>) {
    let shift64 = shift & 0x3F
    let shift32 = shift & 0x1F
    let delta = shift >> 5
    var carry: UInt32 = if (shift32 > 0 && rArr.size - deltaSize > 0) {
        rArr[rArr.size - deltaSize - 1] >> (32 - shift32)
    } else {
        0
    }
    if (carry != 0) {
        rArr[rArr.size - 1] = carry
    }
    for (i in rArr.size - deltaSize - 1..0 : -1) {
        carry = if (shift32 > 0) {
            rArr[i - 1] >> (32 - shift32)
        } else {
            0
        }
        rArr[i + delta] = (rArr[i] << shift32) | carry
        if (delta != 0) {
            rArr[i] = 0
        }
    }
    let rArr0: UInt32
    let left: UInt32
    (carry, rArr0, left) = shiftLeftUInt64(int, shift64)
    if (delta != rArr.size) {
        rArr[delta] = (rArr[0] << shift32) | carry
        if (delta != 0) {
            rArr[0] = 0
        }
    }

    let rInt: UInt64
    if (delta >= 2) {
        rArr[delta - 1] = rArr0
        rArr[delta - 2] = left
        rInt = 0
    } else if (delta == 1) {
        rArr[delta - 1] = rArr0
        rInt = UInt64(left) << 32
    } else {
        rInt = int << shift64
    }
    return (rInt, rArr)
}
/*
 * @throws IndexOutOfBoundsException
 */
func shiftRightInSitu(arr: Array<UInt32>, shift: Int64): Array<UInt32> {
    if (shift == 0) {
        return arr
    }
    var carry: UInt32 = 0
    for (i in arr.size - 1..=0 : -1) {
        let rightResult = (arr[i] >> shift) | carry
        carry = arr[i] << (32 - shift)
        arr[i] = rightResult
    }
    return arr
}

/*
 * @throws IndexOutOfBoundsException
 */
func divBy2Insitu(int: UInt64, arr: Array<UInt32>): (UInt64, Array<UInt32>) {
    var carry: UInt32 = 0
    for (i in arr.size - 1..=0 : -1) {
        let rightResult = (arr[i] >> 1) | carry
        carry = arr[i] << 31
        arr[i] = rightResult
    }
    let rInt = (int >> 1) | (UInt64(carry) << 32)
    return (rInt, arr)
}

/*
 * @throws IndexOutOfBoundsException
 * @throws IllegalArgumentException
 */
func divByUInt32InSitu(dividend: Array<UInt32>, divisor: UInt64): (Array<UInt32>, UInt64) {
    var rem: UInt64 = 0
    for (i in dividend.size - 1..=0 : -1) {
        let dividendN = UInt64(dividend[i]) + (rem << 32)
        dividend[i] = UInt32(dividendN / divisor)
        rem = dividendN % divisor
    }
    return (normalize(dividend), rem)
}

/*
 * @throws IndexOutOfBoundsException
 */
func modByUInt32(dividend: Array<UInt32>, divisor: UInt64): UInt64 {
    var rem: UInt64 = 0
    for (i in dividend.size - 1..=0 : -1) {
        let dividendN = UInt64(dividend[i]) + (rem << 32)
        rem = dividendN % divisor
    }
    return rem
}
/*
 * @throws IndexOutOfBoundsException
 * @throws IllegalArgumentException
 */
func mod(thisInt: UInt64, thisArr: Array<UInt32>, thatInt: UInt64, thatArr: Array<UInt32>): (UInt64, Array<UInt32>) {
    if (thisArr.size == 0 && thatArr.size == 0) {
        return (thisInt % thatInt, EMPTY_ARRAY)
    }
    let c = compareAbsArr(thisArr, thatArr, 0)
    if (c == 0) {
        if (thisInt >= thatInt) {
            return (thisInt - thatInt, EMPTY_ARRAY)
        }
        return (thisInt, thisArr.clone())
    }
    if (c == -1) {
        return (thisInt, thisArr.clone())
    }
    let remArr: Array<UInt32>
    let remInt: UInt64
    if (thatArr.size == 0) {
        if (thatInt <= 0xFFFF_FFFF) {
            let rem = modByUInt32(thisArr, thatInt)
            let remInt0 = ((0x8000_0000_0000_0000 % thatInt) * (2 * rem % thatInt)) % thatInt
            remInt = (remInt0 + thisInt % thatInt) % thatInt
            remArr = EMPTY_ARRAY
        } else {
            let shift = leadingZeros(thatInt)
            let normalizedDividend = knuthNormalize(thisArr.size + 3, thisInt, thisArr, shift)
            let normalizedDivisor = thatInt << shift
            (remInt, remArr) = knuthMod(normalizedDividend, normalizedDivisor, shift)
        }
    } else {
        let shift = leadingZeros(thatArr[thatArr.size - 1])
        let normalizedDividend = knuthNormalize(thisArr.size + 3, thisInt, thisArr, shift)
        let normalizedDivisor = knuthNormalize(thatArr.size + 2, thatInt, thatArr, shift)
        (remInt, remArr) = knuthMod(normalizedDividend, normalizedDivisor, shift)
    }
    return (remInt, remArr)
}

/*
 * @throws IndexOutOfBoundsException
 * @throws IllegalArgumentException
 */
func modOption(int: UInt64, intArr: Array<UInt32>, m: ?BigInt): (UInt64, Array<UInt32>) {
    if (let Some(m_) <- m) {
        if (!isNoLessThan(m_.int, m_.intArr, int, intArr)) {
            return mod(int, intArr, m_.int, m_.intArr)
        }
    }
    return (int, intArr)
}
/*
 * @throws IndexOutOfBoundsException
 * @throws IllegalArgumentException
 */
func knuthMod(normalizedDividend: Array<UInt32>, normalizedDivisor: Array<UInt32>, shift: Int64): (UInt64, Array<UInt32>) {
    let sizeDD = normalizedDividend.size
    let sizeD = normalizedDivisor.size
    var j = sizeDD - sizeD - 1
    while (j >= 0) {
        knuthDivGuessQ(normalizedDividend, normalizedDivisor, sizeD, j)
        j--
    }
    let remArr = shiftRightInSitu(normalizedDividend, shift)
    let remInt = UInt64(remArr[0]) + (UInt64(remArr[1]) << 32)
    return (remInt, normalize(remArr[2..]))
}
/*
 * @throws IndexOutOfBoundsException
 * @throws IllegalArgumentException
 */
func knuthMod(normalizedDividend: Array<UInt32>, normalizedDivisor: UInt64, shift: Int64): (UInt64, Array<UInt32>) {
    let sizeDD = normalizedDividend.size
    var j = sizeDD - 2 - 1
    while (j >= 0) {
        knuthDivGuessQ(normalizedDividend, normalizedDivisor, j)
        j--
    }
    let remArr = shiftRightInSitu(normalizedDividend, shift)
    let remInt = UInt64(remArr[0]) + (UInt64(remArr[1]) << 32)
    return (remInt, normalize(remArr[2..]))
}


/*
 * @throws IndexOutOfBoundsException
 * @throws IllegalArgumentException
 */
func mulByUInt32InSitu(multiplicand: Array<UInt32>, multiplicator: UInt64): Array<UInt32> {
    var carry: UInt64 = 0
    for (i in 0..multiplicand.size) {
        let product = UInt64(multiplicand[i]) * multiplicator + carry
        multiplicand[i] = UInt32(product & 0xFFFF_FFFF)
        carry = product >> 32
    }
    return normalize(multiplicand)
}

/*
 * @throws IndexOutOfBoundsException
 */
func mulByUInt32InSitu(rArr: Array<UInt32>, multiplicand: Array<UInt32>, multiplicator: UInt64, index: Int64) {
    var carry: UInt64 = 0
    for (i in 0..multiplicand.size) {
        let product = UInt64(multiplicand[i]) * multiplicator + UInt64(rArr[i + index]) + carry
        rArr[i + index] = UInt32(product & 0xFFFF_FFFF)
        carry = product >> 32
    }
    var i = 0
    while (carry != 0) {
        let superCarry = UInt64(rArr[multiplicand.size + index + i]) + carry
        rArr[multiplicand.size + index + i] = UInt32(superCarry & 0xFFFF_FFFF)
        carry = superCarry >> 32
        i++
    }
}
/*
 * @throws IllegalArgumentException
 * @throws IndexOutOfBoundsException
 */
func mul(mInt: UInt64, mArr: Array<UInt32>, mulInt: UInt64, mulArr: Array<UInt32>): (UInt64, Array<UInt32>) {
    let (int, rArr0, rArr1) = uInt64Mul(mInt, mulInt)
    if (mArr.size == 0 && mulArr.size == 0) {
        if (rArr0 == 0 && rArr1 == 0) {
            return (int, EMPTY_ARRAY)
        }
        let arr = Array<UInt32>(2, repeat: rArr0)
        arr[1] = rArr1
        return (int, normalize(arr))
    }
    let rArr = Array<UInt32>(mArr.size + mulArr.size + 2, repeat: 0)
    rArr[0] = rArr0
    rArr[1] = rArr1
    mulByUInt32InSitu(rArr, mArr, mulInt & 0xFFFF_FFFF, 0)
    mulByUInt32InSitu(rArr, mArr, mulInt >> 32, 1)
    mulByUInt32InSitu(rArr, mulArr, mInt & 0xFFFF_FFFF, 0)
    mulByUInt32InSitu(rArr, mulArr, mInt >> 32, 1)
    for (i in 0..mArr.size) {
        mulByUInt32InSitu(rArr, mulArr, UInt64(mArr[i]), i + 2)
    }
    return (int, normalize(rArr))
}
/*
 * @throws IndexOutOfBoundsException
 */
func compareAbsArr(thisArr: Array<UInt32>, thatArr: Array<UInt32>, offset: Int64): Int64 {
    if (thisArr.size > thatArr.size + offset) {
        return 1
    } else if (thisArr.size < thatArr.size + offset) {
        return -1
    }
    for (i in thatArr.size - 1..=0 : -1) {
        if (thisArr[i + offset] > thatArr[i]) {
            return 1
        } else if (thisArr[i + offset] < thatArr[i]) {
            return -1
        }
    }
    for (i in 0..offset) {
        if (thisArr[i] != 0) {
            return 1
        }
    }
    return 0
}

/*
 * @throws IllegalArgumentException
 * @throws IndexOutOfBoundsException
 */
func isNoLessThan(thisInt: UInt64, thisArr: Array<UInt32>, thatInt: UInt64, thatArr: Array<UInt32>): Bool {
    let c = compareAbsArr(normalize(thisArr), normalize(thatArr), 0)
    if (c == 0) {
        return thisInt >= thatInt
    }
    return c == 1
}
/*
 * @throws IllegalArgumentException
 * @throws IndexOutOfBoundsException
 */
func gcd(int1: UInt64, int1Arr: Array<UInt32>, int2: UInt64, int2Arr: Array<UInt32>): (UInt64, Array<UInt32>) {
    if (int1Arr.size == 0 && int2Arr.size == 0) {
        return (gcd(int1, int2), EMPTY_ARRAY)
    }
    var i1Int = int1
    var i1Arr = int1Arr.clone()
    var i2Int = int2
    var i2Arr = int2Arr.clone()
    var shift = 0
    while (i1Int != i2Int || normalize(i1Arr) != normalize(i2Arr)) {
        while ((i1Int & 1) == 0) {
            (i1Int, i1Arr) = divBy2Insitu(i1Int, i1Arr)
            if ((i2Int & 1) == 0) {
                (i2Int, i2Arr) = divBy2Insitu(i2Int, i2Arr)
                shift++
            }
        }
        while ((i2Int & 1) == 0) {
            (i2Int, i2Arr) = divBy2Insitu(i2Int, i2Arr)
        }
        if (i1Int == i2Int && normalize(i1Arr) == normalize(i2Arr)) {
            break
        }
        if (!isNoLessThan(i1Int, i1Arr, i2Int, i2Arr)) {
            (i1Int, i2Int) = (i2Int, i1Int)
            (i1Arr, i2Arr) = (i2Arr, i1Arr)
        }
        var isIntNeg = false
        i1Int = if (i1Int >= i2Int) {
            i1Int - i2Int
        } else {
            isIntNeg = true
            i2Int - i1Int
        }
        if (isIntNeg) {
            subAndBorrow(i1Arr, 0, 1)
            i1Int = 0xFFFF_FFFF_FFFF_FFFF - i1Int + 1
        }
        subInSitu(i1Arr, normalize(i2Arr), 0)
    }
    let deltaSize = i1Arr.size - normalize(i1Arr).size
    (i1Int, i1Arr) = shiftLeftInSitu(i1Int, i1Arr, shift, deltaSize)
    return (i1Int, normalize(i1Arr))
}

/*
 * @throws ArithmeticException
 * @throws IndexOutOfBoundsException
 * @throws IllegalArgumentException
 */
func exgcdToInverse(thisBig: BigInt, thatBig: BigInt): (BigInt, BigInt) {
    if (thatBig.sign == 0) {
        if (thisBig.int != 1 || thisBig.intArr.size != 0) {
            throw IllegalArgumentException("The BigInt is not relatively prime with the input.")
        }
        return (BigInt(1), BigInt(0))
    }
    let (quo, rem) = thisBig.quoAndRem(thatBig)
    let (x, y) = exgcdToInverse(thatBig, rem)
    return (y, x - quo * y)
}

/*
 * @throws IndexOutOfBoundsException
 * @throws IllegalArgumentException
 */
func knuthDivGuessQ(normalizedDividend: Array<UInt32>, normalizedDivisor: Array<UInt32>, sizeD: Int64, j: Int64): UInt64 {
    let dd = (UInt64(normalizedDividend[sizeD + j]) << 32) + UInt64(normalizedDividend[sizeD + j - 1])
    let d = UInt64(normalizedDivisor[sizeD - 1])
    var q = dd / d
    if (q == 0) {
        return q
    }

    var r = dd % d
    while (r <= 0xFFFF_FFFF) {
        if (q > 0xFFFF_FFFF || q * UInt64(normalizedDivisor[sizeD - 2]) > (r << 32) + UInt64(normalizedDividend[sizeD + j -
                2])) {
            q--
            r += d
        } else {
            break
        }
    }
    var product = Array<UInt32>(sizeD + 1, repeat: 0)
    normalizedDivisor.copyTo(product, 0, 0, sizeD)
    product = mulByUInt32InSitu(product, q)
    if (compareAbsArr(normalize(normalizedDividend), product, j) == -1) {
        q--
        product = subInSitu(product, normalizedDivisor, 0)
        subInSitu(normalize(normalizedDividend), product, j)
    } else {
        subInSitu(normalize(normalizedDividend), product, j)
    }
    return q
}

/*
 * @throws IndexOutOfBoundsException
 * @throws IllegalArgumentException
 */
func knuthDivGuessQ(normalizedDividend: Array<UInt32>, normalizedDivisor: UInt64, j: Int64): UInt64 {
    let dd = (UInt64(normalizedDividend[j + 2]) << 32) + UInt64(normalizedDividend[j + 1])
    let d = normalizedDivisor >> 32
    let d0 = normalizedDivisor & 0xFFFF_FFFF
    var q = dd / d
    if (q == 0) {
        return q
    }

    var r = dd % d
    while (r <= 0xFFFF_FFFF) {
        if (q > 0xFFFF_FFFF || q * d0 > (r << 32) + UInt64(normalizedDividend[j])) {
            q--
            r += d
        } else {
            break
        }
    }
    var product = Array<UInt32>(3, repeat: 0)
    product[0] = UInt32(d0)
    product[1] = UInt32(d)
    product = mulByUInt32InSitu(product, q)
    subInSitu(normalize(normalizedDividend), product, j)
    return q
}



/*
 * @throws ArithmeticException
 * @throws IllegalArgumentException
 * @throws IndexOutOfBoundsException
 */
func witness(a: BigInt, n: BigInt): Bool {
    let (subOneInt, subOneArr) = subOne(n.int, n.intArr, false)
    let subOne = BigInt(subOneInt, normalize(subOneArr), false)
    let t = subOne.lowestOneBit()
    let u = subOne >> t
    let x0 = a.modPow(u, m: n)
    var x0Int = x0.int
    var x0Arr = x0.intArr
    if (x0Int == 1 && x0Arr.size == 0) {
        return false
    }
    for (_ in 0..t) {
        if (x0Int == subOneInt && x0Arr == subOneArr) {
            return false
        }
        var (x1Int, x1Arr) = mul(x0Int, x0Arr, x0Int, x0Arr)
        (x1Int, x1Arr) = mod(x1Int, x1Arr, n.int, n.intArr)
        if (x1Int == 1 && x1Arr.size == 0) {
            return true
        }
        x0Int = x1Int
        x0Arr = x1Arr
    }
    if (x0Int != 1 || x0Arr.size != 0) {
        return true
    }
    return false
}

extend BigInt <: Number<BigInt> {}

extend BigInt <: Integer<BigInt> {
    /*
     * @noThrow
     */
    public static func isSigned(): Bool {
        true
    }
}
