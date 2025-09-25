







package std.core

extend Rune {


    public func isAsciiLetter(): Bool {
        return (this >= r'A' && this <= r'Z') || (this >= r'a' && this <= r'z')
    }


    public func isAsciiNumber(): Bool {
        return this >= r'0' && this <= r'9'
    }


    public func isAsciiHex(): Bool {
        return this.isAsciiNumber() || (this >= r'a' && this <= r'f') || (this >= r'A' && this <= r'F')
    }


    public func isAsciiOct(): Bool {
        return this >= r'0' && this <= r'7'
    }


    public func isAsciiPunctuation(): Bool {
        return (this >= r'!' && this <= r'/') || (this >= r':' && this <= r'@') || (this >= r'[' && this <= r'`') || (this >=
            r'{' && this <= r'~')
    }


    public func isAsciiGraphic(): Bool {
        return this >= r'!' && this <= r'~'
    }


    public func isAsciiControl(): Bool {
        return (this >= r'\u{0000}' && this <= r'\u{001F}') || this == r'\u{007F}'
    }


    public func isAsciiNumberOrLetter(): Bool {
        return this.isAsciiLetter() || this.isAsciiNumber()
    }

    
    public func isAsciiLowerCase(): Bool {
        return this >= r'a' && this <= r'z'
    }

    
    public func isAsciiUpperCase(): Bool {
        return this >= r'A' && this <= r'Z'
    }

    
    public func isAscii(): Bool {
        return this >= r'\u{0000}' && this <= r'\u{007F}'
    }

    
    public func isAsciiWhiteSpace(): Bool {
        return (this >= r'\u{0009}' && this <= r'\u{000D}') || this == r'\u{0020}'
    }

    
    public func toAsciiUpperCase(): Rune {
        return if (this.isAsciiLowerCase()) {
            Rune(UInt32(this) - UInt32(ASCII_UPPER_TO_LOWER_DIFF))
        } else {
            this
        }
    }

    
    public func toAsciiLowerCase(): Rune {
        return if (this.isAsciiUpperCase()) {
            Rune(UInt32(this) + UInt32(ASCII_UPPER_TO_LOWER_DIFF))
        } else {
            this
        }
    }



    public static func utf8Size(arr: Array<UInt8>, index: Int64): Int64 {
        if (index >= arr.size) {
            throw IllegalArgumentException("Invalid utf8 byte sequence.")
        }
        let byte = arr[index]
        if (byte < HIGH_1_UInt8) {
            return 1
        }
        if (byte < HIGH_2_UInt8) {
            var (char, _) = getPreviousFromUtf8(arr, index)
            throw IllegalArgumentException("Byte index ${index} is not a Rune boundary, it is inside '${char}'.")
        }
        if (byte >= HIGH_6_UInt8) {
            throw IllegalArgumentException("Invalid UTF-8 character.")
        }
        return utf8SizeUnchecked(byte)
    }
    static func utf8SizeUnchecked(byte: Byte): Int64 {
        return match {
            case byte < HIGH_1_UInt8 => 1
            case byte < HIGH_3_UInt8 => 2
            case byte < HIGH_4_UInt8 => 3
            case byte < HIGH_5_UInt8 => 4
            case byte < HIGH_6_UInt8 => 5
            case _ => 6
        }
    }

    @OverflowWrapping
    public static func utf8Size(c: Rune): Int64 {
        var ch = UInt32(c)
        match {
            case ch <= UTF8_1_MAX => 1
            case ch <= UTF8_2_MAX => 2
            case ch <= UTF8_3_MAX => 3
            case ch <= UTF8_4_MAX => 4
            case ch <= UTF8_5_MAX => 5
            case _ => 6
        }
    }



    @OverflowWrapping
    public static func fromUtf8(arr: Array<UInt8>, index: Int64): (Rune, Int64) {
        if (index >= arr.size) {
            throw IllegalArgumentException("Invalid utf8 byte sequence.")
        }
        return fromUtf8(arr.rawptr, arr.start + index, arr.start + arr.len)
    }

    static func fromUtf8(arr: RawArray<UInt8>, startIndex: Int64, endIndex: Int64): (Rune, Int64) {
        let byte0: UInt8 = arrayGetUnchecked(arr, startIndex)
        return match {
            case byte0 < HIGH_1_UInt8 => (Rune(byte0), 1)
            case byte0 < HIGH_2_UInt8 => throw IllegalArgumentException("Invalid utf8 byte sequence.")
            case byte0 < HIGH_3_UInt8 => (checkUtf8Of2Bytes(arr, startIndex, endIndex), 2)
            case byte0 < HIGH_4_UInt8 => (checkUtf8Of3Bytes(arr, startIndex, endIndex), 3)
            case byte0 < HIGH_5_UInt8 => (checkUtf8Of4Bytes(arr, startIndex, endIndex), 4)
            case _ => throw IllegalArgumentException("Invalid unicode scalar value.")
        }
    }



    @OverflowWrapping
    public static func getPreviousFromUtf8(arr: Array<UInt8>, index: Int64): (Rune, Int64) {
        var i: Int64 = index - 1
        var nowByte: UInt8
        var res: (Rune, Int64) = (r'\0', -1)
        while (i >= 0) {
            nowByte = arr[i]
            if (nowByte >= HIGH_1_UInt8 && nowByte < HIGH_2_UInt8) {
                i--
                continue
            } else {
                res = fromUtf8(arr, i)
                break
            }
        }
        if (res[0] == r'\0' && res[1] == -1) {
            throw IllegalArgumentException("Invalid utf8 byte sequence.")
        }
        return res
    }


    @OverflowWrapping
    public static func intoUtf8Array(c: Rune, arr: Array<UInt8>, index: Int64): Int64 {
        var ch = UInt32(c)
        checkIndexValid(c, arr, index)
        if (ch <= UTF8_1_MAX) {
            arr[index] = UInt8(ch)
            return 1
        } else if (ch <= UTF8_2_MAX) {
            arr[index] = UInt8(((ch >> SHIFT_6) & LOW_5_MASK) | HIGH_2_MASK)
            arr[index + 1] = UInt8(((ch) & LOW_6_MASK) | HIGH_1_MASK)
            return 2
        } else if (ch <= UTF8_3_MAX) {
            arr[index] = UInt8(((ch >> SHIFT_12) & LOW_4_MASK) | HIGH_3_MASK)
            arr[index + 1] = UInt8(((ch >> SHIFT_6) & LOW_6_MASK) | HIGH_1_MASK)
            arr[index + 2] = UInt8((ch & LOW_6_MASK) | HIGH_1_MASK)
            return 3
        } else if (ch <= UTF8_4_MAX) {
            arr[index] = UInt8(((ch >> SHIFT_18) & LOW_3_MASK) | HIGH_4_MASK)
            arr[index + 1] = UInt8(((ch >> SHIFT_12) & LOW_6_MASK) | HIGH_1_MASK)
            arr[index + 2] = UInt8(((ch >> SHIFT_6) & LOW_6_MASK) | HIGH_1_MASK)
            arr[index + 3] = UInt8((ch & LOW_6_MASK) | HIGH_1_MASK)
            return 4
        } else if (ch <= UTF8_5_MAX) {
            arr[index] = UInt8(((ch >> SHIFT_24) & LOW_2_MASK) | HIGH_5_MASK)
            arr[index + 1] = UInt8(((ch >> SHIFT_18) & LOW_6_MASK) | HIGH_1_MASK)
            arr[index + 2] = UInt8(((ch >> SHIFT_12) & LOW_6_MASK) | HIGH_1_MASK)
            arr[index + 3] = UInt8(((ch >> SHIFT_6) & LOW_6_MASK) | HIGH_1_MASK)
            arr[index + 4] = UInt8((ch & LOW_6_MASK) | HIGH_1_MASK)
            return 5
        } else {
            arr[index] = UInt8(((ch >> SHIFT_30) & LOW_1_MASK) | HIGH_6_MASK)
            arr[index + 1] = UInt8(((ch >> SHIFT_24) & LOW_6_MASK) | HIGH_1_MASK)
            arr[index + 2] = UInt8(((ch >> SHIFT_18) & LOW_6_MASK) | HIGH_1_MASK)
            arr[index + 3] = UInt8(((ch >> SHIFT_12) & LOW_6_MASK) | HIGH_1_MASK)
            arr[index + 4] = UInt8(((ch >> SHIFT_6) & LOW_6_MASK) | HIGH_1_MASK)
            arr[index + 5] = UInt8((ch & LOW_6_MASK) | HIGH_1_MASK)
            return 6
        }
    }


    private static func checkIndexValid(c: Rune, arr: Array<UInt8>, index: Int64): Unit {
        if (index < 0) {
            throw IllegalArgumentException("The index cannot be less than 0.")
        }
        let ch = UInt32(c)
        let arrSize = arr.size
        let lengthOfCharBytes = if (ch <= UTF8_1_MAX) {
            1
        } else if (ch <= UTF8_2_MAX) {
            2
        } else if (ch <= UTF8_3_MAX) {
            3
        } else if (ch <= UTF8_4_MAX) {
            4
        } else if (ch <= UTF8_5_MAX) {
            5
        } else {
            6
        }
        if (lengthOfCharBytes + index > arrSize) {
            throw IllegalArgumentException(
                "The bytecode position occupied by this character is outside the range of the array.")
        }
    }
}

extend Rune <: Comparable<Rune> {







    public func compare(rhs: Rune): Ordering {
        match {
            case this < rhs => Ordering.LT
            case this > rhs => Ordering.GT
            case _ => Ordering.EQ
        }
    }
}
