







package std.core

@FastNative
foreign func strcmp(source: CPointer<UInt8>, target: CPointer<UInt8>): Int32

@FastNative
foreign func strncmp(source: CPointer<UInt8>, target: CPointer<UInt8>, cmpSize: UIntNative): Int32

@FastNative
foreign func strcasecmp(source: CPointer<UInt8>, target: CPointer<UInt8>): Int32

@Intrinsic
/*
 * @noThrow
 */
func convertCStr2Ptr(cs: CString): CPointer<UInt8>

@OverflowWrapping
/*
 * @throws IllegalArgumentException
 */
func createStrFromCPointer(cp: CPointer<UInt8>): String {
    if (cp.isNull()) {
        return String()
    }
    var len: Int64 = unsafe { Int64(strlen(cp)) }
    return String(cp, len)
}

extend CString <: ToString {
    /*
     * @noThrow
     */
    public func getChars(): CPointer<UInt8> {
        return convertCStr2Ptr(this)
    }

    /*
     * @noThrow
     */
    public func isNull(): Bool {
        return getChars().isNull()
    }

    /*
     * @noThrow
     */
    public func size(): Int64 {
        let chars = getChars()
        if (chars.isNull()) {
            return 0
        }
        let len = unsafe { strlen(chars) }
        return Int64(len)
    }

    /*
     * @noThrow
     */
    public func isEmpty(): Bool {
        return size() == 0
    }

    /*
     * @noThrow
     */
    public func isNotEmpty(): Bool {
        return !isEmpty()
    }

    /*
     * @noThrow
     */
    public func startsWith(prefix: CString): Bool {
        let chars = getChars()
        if (chars.isNull()) {
            return false
        }
        let prefixChars = prefix.getChars()
        if (prefixChars.isNull()) {
            return false
        }
        let len = unsafe { strlen(chars) }
        let prefixLen = unsafe { strlen(prefixChars) }
        if (len < prefixLen) {
            return false
        }
        let cmpRet = unsafe { CJ_CORE_StringMemcmp(chars, prefixChars, prefixLen) }
        return cmpRet == 0
    }

    /*
     * @noThrow
     */
    public func endsWith(suffix: CString): Bool {
        let chars = getChars()
        if (chars.isNull()) {
            return false
        }
        let suffixChars = suffix.getChars()
        if (suffixChars.isNull()) {
            return false
        }
        let len = unsafe { strlen(chars) }
        let suffixLen = unsafe { strlen(suffixChars) }
        if (len < suffixLen) {
            return false
        }
        let cmpRet = unsafe { strncmp(chars + Int64(len - suffixLen), suffixChars, suffixLen) }
        return cmpRet == 0
    }

    /*
     * @noThrow
     */
    public func equals(rhs: CString): Bool {
        let chars = getChars()
        if (chars.isNull() || rhs.isNull()) {
            return false
        }
        let cmpRet = unsafe { strcmp(chars, rhs.getChars()) }
        return cmpRet == 0
    }

    /*
     * @noThrow
     */
    public func equalsLower(rhs: CString): Bool {
        let chars = getChars()
        if (chars.isNull() || rhs.isNull()) {
            return false
        }
        let cmpRet = unsafe { strcasecmp(chars, rhs.getChars()) }
        return cmpRet == 0
    }



    /*
     * @throws IllegalArgumentException
     * @throws IllegalMemoryException
     * @throws IndexOutOfBoundsException
     */
    public func subCString(beginIndex: UIntNative): CString {
        var len = UIntNative(size())
        if (beginIndex > len) {
            throw IndexOutOfBoundsException(
                "The begin index is ${beginIndex}, which is greater than the CString length of ${len}.")
        }
        return subCString(beginIndex, len - beginIndex)
    }



    /*
     * @throws IllegalArgumentException
     * @throws IllegalMemoryException
     * @throws IndexOutOfBoundsException
     */
    public func subCString(beginIndex: UIntNative, subLen: UIntNative): CString {
        var buffer = CPointer<UInt8>()
        var len = UIntNative(size())
        if (beginIndex > len) {
            throw IndexOutOfBoundsException(
                "The begin index is ${beginIndex}, which is greater than the CString length of ${len}.")
        } else if (beginIndex == len || subLen == 0) {
            return CString(buffer)
        }
        var actualLen = len - beginIndex
        if (actualLen > subLen) {
            actualLen = subLen
        }
        unsafe {
            buffer = LibC.malloc(count: Int64(actualLen + 1))
            if (buffer.isNull()) {
                throw IllegalMemoryException("Malloc in CString::subCString failed.")
            }
            var rc = memcpy_s(buffer, actualLen + 1, getChars() + Int64(beginIndex), actualLen)
            if (rc != 0) {
                LibC.free(buffer)
                throw IllegalMemoryException("The memcpy_s in subCString failed with error code: ${rc}.")
            }
            buffer.write(Int64(actualLen), UInt8(0))
        }
        return CString(buffer)
    }


    /*
     * @throws IllegalMemoryException
     */
    public func compare(str: CString): Int32 {
        let chars = getChars()
        if (chars.isNull() || str.isNull()) {
            throw IllegalMemoryException("The two CString values to be compared cannot be null.")
        }
        let ret = unsafe { strcmp(chars, str.getChars()) }
        if (ret > 0) {
            return 1
        }
        if (ret < 0) {
            return -1
        }
        return 0
    }

    /*
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    public func toString(): String {
        let chars = getChars()
        if (chars.isNull()) {
            return String()
        }
        let len = unsafe { Int64(strlen(chars)) }
        if (len == 0) {
            return String()
        }
        let data: Array<UInt8> = Array<UInt8>(len, repeat: 0)
        if (len < STRING_C_THRESHOLD) {
            var i: Int64 = 0
            while (i < len) {
                data[i] = unsafe { chars.read(i) }
                i++
            }
        } else {
            unsafe {
                let rawData: CPointerHandle<UInt8> = acquireArrayRawData(data)
                var remain = len
                var offset = 0
                while (remain >= SECUREC_MEM_MAX_LEN) {
                    memcpy_s(rawData.pointer + offset, UIntNative(SECUREC_MEM_MAX_LEN), chars + offset,
                        UIntNative(SECUREC_MEM_MAX_LEN))
                    offset += SECUREC_MEM_MAX_LEN
                    remain -= SECUREC_MEM_MAX_LEN
                }
                if (remain > 0) {
                    memcpy_s(rawData.pointer + offset, UIntNative(remain), chars + offset, UIntNative(remain))
                }
                releaseArrayRawData(rawData)
            }
        }
        checkInvalid(data.rawptr, data.start, data.start + data.size)
        return String(data)
    }

    /*
     * @noThrow
     */
    public func asResource(): CStringResource {
        return CStringResource(this)
    }
}

public struct CStringResource <: Resource {
    public let value: CString
    private let isFree: Box<Bool> = Box(false)

    /*
     * @noThrow
     */
    init(p: CString) {
        this.value = p
    }

    /*
     * @noThrow
     */
    public func isClosed(): Bool {
        return isFree.value
    }

    /*
     * @noThrow
     */
    public func close(): Unit {
        if (isFree.value) {
            return
        }
        unsafe { LibC.free(value.getChars()) }
        isFree.value = true
    }
}
