







package std.math.numeric

import std.convert.*
import std.math.*

extend BigInt <: Parsable<BigInt> {





























    /**
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    public static func parse(value: String): BigInt {
        var (isNeg, start) = parseSign(value)
        let (radix, baseLength) = (parseBase(value, start))
        start += baseLength
        let (int, arr) = parseDigits(value, start, radix)
        if (int == 0 && arr.size == 0) {
            isNeg = false
        }
        return BigInt(int, arr, isNeg)
    }

    /**
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    public static func tryParse(value: String): ?BigInt {
        try {
            return parse(value)
        } catch (e: Exception) {
            return None
        }
    }
}

extend BigInt <: RadixConvertible<BigInt> {




























    /**
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    public static func parse(value: String, radix!: Int64): BigInt {
        if (radix < 2 || radix > 36) {
            throw IllegalArgumentException("The radix should in the range of [2, 36].")
        }
        let (int, intArr, negSign) = parseString(value, UInt64(radix))
        return BigInt(int, intArr, negSign)
    }

    /**
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    public static func tryParse(value: String, radix!: Int64): ?BigInt {
        try {
            return parse(value, radix: radix)
        } catch (e: Exception) {
            return None
        }
    }








    /**
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    public func toString(radix!: Int64): String {
        return this.convertToString(radix)
    }
}

private let HEX_LOWER_MAP = "0123456789abcdef".toArray()
private let HEX_UPPER_MAP = "0123456789ABCDEF".toArray()
private let DECIMAL_MAP = "0123456789".toArray()

extend BigInt <: Formattable {






















    /**
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    public func format(fmt: String): String {
        if (!(Verify(fmt).verifyIntFormatArg())) {
            throw IllegalArgumentException("Wrong format string '" + fmt + "' for 'UInt' type.")
        }
        let (flag, width, precision, specifier) = parseFormat(fmt)
        let numberString = toNumberString(specifier, precision)
        let prefix = cacultePrefix(flag, specifier)
        return paddingString(flag, width, prefix, numberString)
    }

    /**
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    private func paddingString(flag: Flags, width: Int64, prefix: String, numberString: String): String {
        let paddingSize = width - (prefix.size + numberString.size)
        if (paddingSize <= 0) {
            return match (prefix.isEmpty()) {
                case true => numberString
                case false => prefix + numberString
            }
        }

        let paddingString = match (flag) {
            case Flags.Zero => String(Array<Rune>(paddingSize, repeat: r'0'))
            case _ => String(Array<Rune>(paddingSize, repeat: r' '))
        }

        return match (flag) {
            case Flags.Minus => prefix + numberString + paddingString
            case Flags.Zero => prefix + paddingString + numberString
            case _ => paddingString + prefix + numberString
        }
    }

    /**
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    private func toNumberString(specifier: Rune, precision: Int64): String {
        func fillZeroByPrecision(numberString: String, precision: Int64): String {
            if (precision <= numberString.size) {
                return numberString
            }
            return String(Array<Rune>(precision - numberString.size, repeat: r'0')) + numberString
        }
        if (int == 0 && intArr.size == 0) {
            return fillZeroByPrecision("0", precision)
        }

        let numberString = match (specifier) {
            case r'b' | r'B' => toBinary()
            case r'o' | r'O' => toOctal()
            case r'x' | r'X' => toHex(specifier == r'X')
            case _ => toDecimal()
        }
        return fillZeroByPrecision(numberString, precision)
    }

    /**
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    private func toBinary(): String {
        return toStringByBits(1, DECIMAL_MAP)
    }

    /**
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    private func toOctal(): String {
        return toStringByBits(3, DECIMAL_MAP)
    }

    /**
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    private func toHex(upper: Bool): String {
        let hexMap = match (upper) {
            case true => HEX_UPPER_MAP
            case false => HEX_LOWER_MAP
        }

        return toStringByBits(4, hexMap)
    }

    /**
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    private func toStringByBits(stepSize: Int64, map: Array<Byte>) {
        let reader = BitsReader(this, stepSize)
        let length = reader.caculateSteps()
        let buffer = Array<Byte>(length, repeat: 0)

        reader.forEach {
            idx, byte => buffer[idx] = map[Int64(byte)]
        }
        return unsafe { String.fromUtf8Unchecked(buffer) }
    }

    /**
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    private func toDecimal(): String {
        let numberStringWithSign = toString(radix: 10)
        return match (negSign) {
            case true => numberStringWithSign[1..]
            case false => numberStringWithSign
        }
    }

    /**
     * @throws IllegalArgumentException
     */
    private func cacultePrefix(flag: Flags, specifier: Rune) {
        let sign = match ((this.negSign, flag)) {
            case (true, _) => "-"
            case (_, Flags.Plus) => "+"
            case (_, _) => ""
        }
        let ns = match ((flag, specifier)) {
            case (Flags.Sharp, r'b') => "0b"
            case (Flags.Sharp, r'B') => "0B"
            case (Flags.Sharp, r'o') => "0o"
            case (Flags.Sharp, r'O') => "0O"
            case (Flags.Sharp, r'x') => "0x"
            case (Flags.Sharp, r'X') => "0X"
            case _ => ""
        }
        return match ((sign, ns)) {
            case ("", "") => ""
            case (_, "") => sign
            case ("", _) => ns
            case _ => sign + ns
        }
    }
}







/**
 * @throws IndexOutOfBoundsException
 */
private func caculateBitsLen(bigInt: BigInt): Int64 {
    if (bigInt.intArr.size == 0) {
        if (bigInt.int == 0) {
            return 1
        }
        return 64 - leadingZeros(bigInt.int)
    }

    return (64 - leadingZeros(bigInt.intArr[bigInt.intArr.size - 1])) + (bigInt.intArr.size - 1) * 32 + 64
}




class BitsReader {
    private let int: UInt64
    private let bitsLen: Int64
    private let stepSize: Int64

    private let intArr: Array<UInt32>
    private var intArrReadIdx: Int64

    private var buffer: UInt64 = 0
    private var bufferReadIdx = 0

    private var readBits = 0

    /**
     * @throws IndexOutOfBoundsException
     */
    init(bigInt: BigInt, stepSize: Int64) {
        this.int = bigInt.int
        this.intArr = bigInt.intArr
        this.bitsLen = caculateBitsLen(bigInt)
        this.stepSize = stepSize
        this.intArrReadIdx = intArr.size - 1
    }

    func caculateSteps(): Int64 {
        return match (bitsLen % stepSize == 0) {
            case true => bitsLen / stepSize
            case false => bitsLen / stepSize + 1
        }
    }

    /**
     * @throws IndexOutOfBoundsException
     */
    func forEach(action: (Int64, Byte) -> Unit): Unit {
        var step = 0
        action(step, first())
        while (hasNext()) {
            step++
            action(step, next(stepSize))
        }
    }

    /**
     * @throws IndexOutOfBoundsException
     */
    private func first(): Byte {
        var firstStepBits = bitsLen % stepSize
        if (firstStepBits == 0) {
            firstStepBits = stepSize
        }
        if (intArrReadIdx < 0) {
            buffer = int
        } else if (intArrReadIdx == 0) {
            buffer = UInt64(intArr[intArrReadIdx])
            intArrReadIdx--
        } else {
            buffer = (UInt64(intArr[intArrReadIdx]) << 32) | UInt64(intArr[intArrReadIdx - 1])
            intArrReadIdx -= 2
        }
        bufferReadIdx = leadingZeros(buffer)

        return next(firstStepBits)
    }

    /**
     * @throws IndexOutOfBoundsException
     */
    private func next(n: Int64): Byte {
        let remainLen = 64 - bufferReadIdx
        if (remainLen >= n) {
            return read(n)
        }

        var byte = read(remainLen) << (n - remainLen)
        fill()
        byte |= read(n - remainLen)
        return byte
    }

    /**
     * @throws IndexOutOfBoundsException
     */
    private func fill(): Unit {
        if (intArrReadIdx < 0) {
            buffer = int
            bufferReadIdx = 0
        } else if (intArrReadIdx == 0) {
            buffer = UInt64(intArr[intArrReadIdx])
            intArrReadIdx--
            bufferReadIdx = 32
        } else {
            buffer = (UInt64(intArr[intArrReadIdx]) << 32) | UInt64(intArr[intArrReadIdx - 1])
            intArrReadIdx -= 2
            bufferReadIdx = 0
        }
    }

    @OverflowWrapping
    private func read(n: Int64): Byte {
        let byte = UInt8((buffer << bufferReadIdx) >> (64 - n))
        bufferReadIdx += n
        readBits += n
        return byte
    }

    private func hasNext(): Bool {
        return readBits < bitsLen
    }
}
