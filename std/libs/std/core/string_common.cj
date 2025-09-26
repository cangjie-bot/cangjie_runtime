







package std.core

const ASCII_A: UInt8 = 'A'
const ASCII_Z: UInt8 = 'Z'
const ASCII_a: UInt8 = 'a'
const ASCII_z: UInt8 = 'z'
const ASCII_UPPER_LOWER_DIFFERENCE: UInt8 = b'a' - b'A'

const HIGH_1_MASK: UInt32 = 0b10000000
const HIGH_2_MASK: UInt32 = 0b11000000
const HIGH_3_MASK: UInt32 = 0b11100000
const HIGH_4_MASK: UInt32 = 0b11110000
const HIGH_5_MASK: UInt32 = 0b11111000
const HIGH_6_MASK: UInt32 = 0b11111100
const SHIFT_30: UInt32 = 30
const SHIFT_24: UInt32 = 24
const SHIFT_18: UInt32 = 18
const SHIFT_12: UInt32 = 12
const SHIFT_6: UInt32 = 6
const LOW_6_MASK: UInt32 = 0b00111111
const LOW_5_MASK: UInt32 = 0b00011111
const LOW_4_MASK: UInt32 = 0b00001111
const LOW_3_MASK: UInt32 = 0b00000111
const LOW_2_MASK: UInt32 = 0b00000011
const LOW_1_MASK: UInt32 = 0b00000001
const UTF8_5_MAX: UInt32 = 0x3FFFFFF
const UTF8_4_MAX: UInt32 = 0x10FFFF
const UTF8_3_MAX: UInt32 = 0xFFFF
const UTF8_2_MAX: UInt32 = 0x07FF
const UTF8_1_MAX: UInt32 = 0x7F
const HIGH_1_UInt8: UInt8 = 0b10000000
const HIGH_2_UInt8: UInt8 = 0b11000000
const HIGH_3_UInt8: UInt8 = 0b11100000
const HIGH_4_UInt8: UInt8 = 0b11110000
const HIGH_5_UInt8: UInt8 = 0b11111000
const HIGH_6_UInt8: UInt8 = 0b11111100

@ConstSafe
const EMPTY_UINT8_ARRAY: Array<UInt8> = Array<UInt8>()
@ConstSafe
const EMPTY_UINT8_RAW_ARRAY: RawArray<UInt8> = RawArray<UInt8>()
let EMPTY_INT64_ARRAY: Array<Int64> = Array<Int64>()
let EMPTY_STRING_ARRAY: Array<String> = Array<String>()
const STRING_C_THRESHOLD = 32





/**
 * @throws IllegalArgumentException
 */
func checkUtf8Of2Bytes(arr: RawArray<UInt8>, startIndex: Int64, endIndex: Int64): Rune {
    if (startIndex + 2 > endIndex) {
        throw IllegalArgumentException("Invalid utf8 byte sequence.")
    }
    let byte1 = arrayGetUnchecked<UInt8>(arr, startIndex)
    let byte2 = arrayGetUnchecked<UInt8>(arr, startIndex + 1)
    if ((byte1 & 0x1e) == 0 || (byte2 & 0xc0) != 0x80) {
        throw IllegalArgumentException("Invalid unicode scalar value.")
    }
    Rune(((UInt32(byte1) & LOW_5_MASK) << SHIFT_6) | (UInt32(byte2) & LOW_6_MASK))
}






/**
 * @throws IllegalArgumentException
 */
func checkUtf8Of3Bytes(arr: RawArray<UInt8>, startIndex: Int64, endIndex: Int64): Rune {
    if (startIndex + 3 > endIndex) {
        throw IllegalArgumentException("Invalid utf8 byte sequence.")
    }
    let byte1 = arrayGetUnchecked<UInt8>(arr, startIndex)
    let byte2 = arrayGetUnchecked<UInt8>(arr, startIndex + 1)
    let byte3 = arrayGetUnchecked<UInt8>(arr, startIndex + 2)
    if ((byte2 & 0xc0) != 0x80 || (byte3 & 0xc0) != 0x80) {
        throw IllegalArgumentException("Invalid unicode scalar value.")
    }
    if ((byte1 & 0b1111) == 0 && (byte2 & 0b00100000) == 0) {
        throw IllegalArgumentException("Invalid unicode scalar value.")
    }
    if ((byte1 & 0b1111) == 0b1101 && (byte2 & 0b00100000) != 0) {
        throw IllegalArgumentException("Invalid unicode scalar value.")
    }

    let code = ((UInt32(byte1) & LOW_4_MASK) << SHIFT_12) |
                ((UInt32(byte2) & LOW_6_MASK) << SHIFT_6) |
                (UInt32(byte3) & LOW_6_MASK)
    Rune(code)
}







/**
 * @throws IllegalArgumentException
 */
func checkUtf8Of4Bytes(arr: RawArray<UInt8>, startIndex: Int64, endIndex: Int64): Rune {
    if (startIndex + 4 > endIndex) {
        throw IllegalArgumentException("Invalid utf8 byte sequence.")
    }

    let byte1 = arrayGetUnchecked<UInt8>(arr, startIndex)
    let byte2 = arrayGetUnchecked<UInt8>(arr, startIndex + 1)
    let byte3 = arrayGetUnchecked<UInt8>(arr, startIndex + 2)
    let byte4 = arrayGetUnchecked<UInt8>(arr, startIndex + 3)
    if ((byte2 & 0xc0) != 0x80 || (byte3 & 0xc0) != 0x80 || (byte4 & 0xc0) != 0x80) {
        throw IllegalArgumentException("Invalid unicode scalar value.")
    }
    if ((byte1 & 0b111) > 0b100) {
        throw IllegalArgumentException("Invalid unicode scalar value.")
    }
    if ((byte1 & 0b111) == 0 && (byte2 & 0b00110000) == 0) {
        throw IllegalArgumentException("Invalid unicode scalar value.")
    }
    if ((byte1 & 0b111) == 0b100 && (byte2 & 0b00110000) != 0) {
        throw IllegalArgumentException("Invalid unicode scalar value.")
    }
    let code = ((UInt32(byte1) & LOW_3_MASK) << SHIFT_18) |
                ((UInt32(byte2) & LOW_6_MASK) << SHIFT_12) |
                ((UInt32(byte3) & LOW_6_MASK) << SHIFT_6) |
                (UInt32(byte4) & LOW_6_MASK)
    Rune(code)
}







/**
 * @throws IllegalArgumentException
 */
func checkInvalid(arr: RawArray<Byte>, startIndex: Int64, endIndex: Int64): Unit {
    var i = startIndex
    while (i < endIndex) {
        var nowByte: UInt8 = arrayGetUnchecked<UInt8>(arr, i)
        match {
            case nowByte < HIGH_1_UInt8 => i += 1
            case nowByte < HIGH_2_UInt8 => throw IllegalArgumentException("Invalid utf8 byte sequence.")
            case nowByte < HIGH_3_UInt8 =>
                checkUtf8Of2Bytes(arr, i, endIndex)
                i += 2
            case nowByte < HIGH_4_UInt8 =>
                checkUtf8Of3Bytes(arr, i, endIndex)
                i += 3
            case nowByte < HIGH_5_UInt8 =>
                checkUtf8Of4Bytes(arr, i, endIndex)
                i += 4
            case _ => throw IllegalArgumentException("Invalid unicode scalar value.")
        }
    }
}

class StringIteratorData {
    let myData: Array<UInt8>
    var end: Int64
    var nextPos: Int64 = 0

    init(data: Array<UInt8>) {
        this.myData = data
        this.end = myData.size
        this.nextPos = 0
    }

    init(data: RawArray<UInt8>) {
        this.myData = toArray(data)
        this.end = myData.size
        this.nextPos = 0
    }
}
class StringRuneIterator <: Iterator<Rune> {
    @Frozen
    StringRuneIterator(let iteratorData: StringIteratorData) {}




    /**
     * @throws IllegalArgumentException
     */
    @OverflowWrapping
    @Frozen
    public func next(): Option<Rune> {
        if (iteratorData.nextPos >= iteratorData.end) {
            return None
        }
        var (rune, num): (Rune, Int64) = Rune.fromUtf8(iteratorData.myData, iteratorData.nextPos)
        iteratorData.nextPos += num
        return Some<Rune>(rune)
    }
}
class StringByteIterator <: Iterator<Byte> {
    @Frozen
    StringByteIterator(let iteratorData: StringIteratorData) {}




    @Frozen
    @OverflowWrapping
    public func next(): Option<Byte> {
        if (iteratorData.nextPos >= iteratorData.end) {
            return None
        }
        let byte = iteratorData.myData.get(iteratorData.nextPos)
        iteratorData.nextPos = iteratorData.nextPos + 1
        return byte
    }
}

class StringLineIterator <: Iterator<String> {
    @Frozen
    StringLineIterator(let iteratorData: StringIteratorData) {}

    /**
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    @Frozen
    @OverflowWrapping
    public func next(): Option<String> {
        if (iteratorData.nextPos >= iteratorData.end) {
            return None
        }
        var pos = iteratorData.nextPos
        var haveCR = false
        while (pos < iteratorData.end) {
            match (iteratorData.myData[pos]) {
                case '\r' =>
                    if (haveCR) {
                        let str = String(iteratorData.myData[iteratorData.nextPos..pos - 1])
                        iteratorData.nextPos = pos
                        return Some(str)
                    }
                    haveCR = true
                case '\n' =>
                    let str = if (haveCR) {
                        String(iteratorData.myData[iteratorData.nextPos..pos - 1])
                    } else {
                        String(iteratorData.myData[iteratorData.nextPos..pos])
                    }
                    iteratorData.nextPos = pos + 1
                    return Some(str)
                case _ =>
                    if (haveCR) {
                        let str = String(iteratorData.myData[iteratorData.nextPos..pos - 1])
                        iteratorData.nextPos = pos
                        return Some(str)
                    }
            }
            pos++
        }
        let str = String(iteratorData.myData[iteratorData.nextPos..])
        iteratorData.nextPos = iteratorData.end
        return Some(str)
    }
}
class StringLazySplitIterator <: Iterator<String> {
    private let orgData: Array<UInt8>
    private let separatorLen: Int64
    private var itemArr: Array<Int64>
    private var maxSplits: Int64
    private var removeEmpty: Bool
    private var resLen: Int64 = 0
    private var nextPos: Int64 = 0
    private var itemStart: Int64 = 0
    private var itemIndex: Int64 = 0
    private var itemTotal: Int64 = 0


    /**
     * @throws IndexOutOfBoundsException
     * @throws OutOfMemoryError
     */
    init(orgStrData: Array<UInt8>, orgStrSize: Int64, str: String, maxSplits: Int64, removeEmpty: Bool) {
        this.orgData = orgStrData
        this.separatorLen = str.size
        this.maxSplits = maxSplits
        this.removeEmpty = removeEmpty
        this.itemArr = EMPTY_INT64_ARRAY
        if (this.separatorLen == 0) {
            if (0 < maxSplits && maxSplits < orgStrSize) {
                this.resLen = maxSplits
            } else {
                this.resLen = orgStrSize
            }
        } else {
            unsafe {
                let org: CPointerHandle<UInt8> = acquireArrayRawData<UInt8>(this.orgData)
                let pat: CPointerHandle<UInt8> = acquireArrayRawData<UInt8>(str.rawData())
                var res: CPointer<Int64> = CJ_CORE_CountAndIndexString(
                    org.pointer,
                    pat.pointer,
                    this.orgData.size,
                    this.separatorLen
                )
                releaseArrayRawData(org)
                releaseArrayRawData(pat)
                if (res.isNull()) {
                    throw OutOfMemoryError("Failed malloc in C code!")
                }
                try {
                    convertCPointer2Array(res, maxSplits, removeEmpty)
                } finally {
                    LibC.free(res)
                }
            }
        }
    }

    /**
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    @OverflowWrapping
    public func next(): Option<String> {
        if (this.separatorLen == 0) {
            if (itemStart >= orgData.size || nextPos >= resLen) {
                return None
            }
            if (nextPos == resLen - 1) {
                let res: String
                unsafe {
                    res = String.fromUtf8Unchecked(this.orgData.slice(this.itemStart, this.orgData.size - this.itemStart
                    ))
                }
                nextPos++
                return res
            }
            var oneCharLen = Rune.utf8Size(this.orgData, this.itemStart)
            let res: String
            unsafe { res = String.fromUtf8Unchecked(this.orgData.slice(this.itemStart, oneCharLen)) }
            this.itemStart += oneCharLen
            nextPos++
            return res
        }
        if (this.nextPos >= this.resLen) {
            return None
        }
        var str = getString()
        this.nextPos++
        return Some<String>(str)
    }



    /**
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    @OverflowWrapping
    private func getString(): String {
        if (this.resLen == 1 && this.itemArr.isEmpty()) {
            return unsafe { String.fromUtf8Unchecked(this.orgData) }
        }
        while (this.nextPos < this.resLen - 1) {
            var index = this.itemArr[this.itemIndex]
            this.itemIndex++
            if (removeEmpty && this.itemStart == index) {
                this.itemStart = index + this.separatorLen
                continue
            }
            let res: String
            unsafe { res = String.fromUtf8Unchecked(this.orgData.slice(this.itemStart, index - this.itemStart)) }
            this.itemStart = index + this.separatorLen
            return res
        }
        if (removeEmpty && this.itemIndex < this.itemArr.size && resLen != 1) {
            var index: Int64 = 0
            while (this.itemIndex < this.itemArr.size) {
                index = this.itemArr[this.itemIndex]
                this.itemIndex++
                if (this.itemStart == index) {
                    this.itemStart = index + this.separatorLen
                    continue
                }
                break
            }
            if (this.itemStart > index || (this.maxSplits > 0 && this.resLen != itemTotal)) {
                index = this.orgData.size
            }
            return unsafe { String.fromUtf8Unchecked(this.orgData.slice(this.itemStart, index - this.itemStart)) }
        }
        return unsafe { String.fromUtf8Unchecked(this.orgData.slice(this.itemStart, this.orgData.size - this.itemStart)) }
    }

    /**
     * @throws IndexOutOfBoundsException
     */
    @OverflowWrapping
    private func convertCPointer2Array(res: CPointer<Int64>, maxSplits: Int64, removeEmpty: Bool) {
        var total = unsafe { res.read(0) }
        var indexes: CPointer<Int64> = unsafe { res + 1 }
        if (total == 0) {
            this.resLen = 1
            return
        }
        let resArr: Array<Int64> = Array<Int64>(total, repeat: 0)
        var itemStart: Int64 = 0
        var i: Int64 = 0
        while (i < total) {
            var index = unsafe { indexes.read(i) }
            resArr[i] = index
            i++
            if (removeEmpty && itemStart == index) {
                itemStart = index + separatorLen
                continue
            }
            itemStart = index + separatorLen
            this.itemTotal++
        }
        if (removeEmpty) {
            if (itemStart != this.orgData.size) {
                this.itemTotal++
            }
        } else {
            this.itemTotal = total + 1
        }
        if (0 < maxSplits && maxSplits < itemTotal) {
            this.resLen = maxSplits
        } else {
            this.resLen = itemTotal
        }
        this.itemArr = resArr
    }
}
