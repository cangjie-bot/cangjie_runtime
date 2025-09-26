







package std.ast

public interface ToBytes {
    func toBytes(): Array<UInt8>
}

/**
 * @throws IndexOutOfBoundsException
 */
func castUInt32ToBytes(v: UInt32): Array<UInt8> {
    var b: Array<UInt8> = Array<UInt8>(4, repeat: 0)
    
    var n = v
    for (i in 0..4) {
        b[i] = UInt8(n)
        n = (n >> 8)
    }
    return b
}

/**
 * @throws IndexOutOfBoundsException
 */
func castInt32ToBytes(v: Int32): Array<UInt8> {
    return castUInt32ToBytes(UInt32(v))
}

/**
 * @throws IndexOutOfBoundsException
 * @throws IllegalArgumentException
 */
func castUInt16ToBytes(v: UInt16): Array<UInt8> {
    var b: Array<UInt8> = castUInt32ToBytes(UInt32(v))
    return b[0..2]
}

/**
 * @throws IndexOutOfBoundsException
 */
@OverflowWrapping
func castUInt32ToBytes(arr: Array<UInt8>, start: Int64, v: UInt32) {
    
    var n = v
    for (i in start..start + 4) {
        arr[i] = UInt8(n)
        n = (n >> 8)
    }
    return start + 4
}

/**
 * @throws IndexOutOfBoundsException
 */
func castInt32ToBytes(arr: Array<UInt8>, start: Int64, v: Int32) {
    return castUInt32ToBytes(arr, start, UInt32(v))
}

/**
 * @throws IndexOutOfBoundsException
 */
@OverflowWrapping
func castUInt16ToBytes(arr: Array<UInt8>, start: Int64, v: UInt16) {
    
    var n = v
    for (i in start..start + 2) {
        arr[i] = UInt8(n)
        n = (n >> 8)
    }
    return start + 2
}

/**
 * @throws IndexOutOfBoundsException
 */
func castStringToBytes(arr: Array<UInt8>, start1: Int64, s: String) {
    let len: Int64 = s.size
    var start = start1
    
    start = castUInt32ToBytes(arr, start, UInt32(len))
    
    for (data in s) {
        arr[start] = data
        start++
    }
    return start
}

/**
 * @throws IndexOutOfBoundsException
 */
func concatBytes(l: Array<UInt8>, r: Array<UInt8>): Array<UInt8> {
    if (l.size == 0) {
        return r
    }
    if (r.size == 0) {
        return l
    }
    var b: Array<UInt8> = Array<UInt8>(l.size + r.size, repeat: 0)
    var i: Int64 = 0
    for (v in l) {
        b[i] = v
        i = i + 1
    }
    for (v in r) {
        b[i] = v
        i = i + 1
    }
    return b
}

/**
 * @throws IndexOutOfBoundsException
 */
func castStringToBytes(s: String): Array<UInt8> {
    let len: Int64 = s.size
    var b: Array<UInt8> = Array<UInt8>(len + 4, repeat: 0)
    var idx = 0
    
    let bsl: Array<UInt8> = castUInt32ToBytes(UInt32(len))
    for (data in bsl) {
        b[idx] = data
        idx++
    }
    
    for (data in s) {
        b[idx] = data
        idx++
    }
    return b
}
