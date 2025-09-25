







package std.net

import std.overflow.*

extend Byte {
    /*
     * @noThrow
     */
    func toDigit(radix: UInt32): ?UInt32 {
        var digit = UInt32(this).wrappingSub(UInt32(b'0'))
        if (radix > 10) {
            if (digit < 10) {
                return digit
            }
            digit = (UInt32(this) | 0b10_0000).wrappingSub(UInt32(b'a')).saturatingAdd(10)
        }
        if (digit < radix) {
            return digit
        }
        None
    }
}
