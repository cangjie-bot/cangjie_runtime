







package std.net

import std.binary.*
public class IPv4Address <: IPAddress & ToString & Equatable<IPv4Address> & LessOrEqual<IPv4Address> {
    public static let localhost: IPv4Address = IPv4Address(0x7F, 0, 0, 0x01)
    public static let unspecified: IPv4Address = IPv4Address(0, 0, 0, 0)
    public static let broadcast: IPv4Address = IPv4Address(0xFF, 0xFF, 0xFF, 0xFF)

    var _octets = Array<Byte>(4, repeat: 0)

    public init(bits: UInt32) {
        bits.writeBigEndian(_octets)
    }

    public init(a: Byte, b: Byte, c: Byte, d: Byte) {
        _octets = [a, b, c, d]
    }
    public func toBits(): UInt32 {
        return UInt32.readBigEndian(_octets)
    }
    /**
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    public func writeBigEndian(buffer: Array<Byte>): Int64 {
        if (buffer.size < 4) {
            throw IllegalArgumentException("Buffer size(${buffer.size}) is too small.")
        }
        for (i in 0.._octets.size) {
            buffer[i] = _octets[i]
        }
        return 4
    }
    /**
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    public static func readBigEndian(buffer: Array<Byte>): IPv4Address {
        if (buffer.size < 4) {
            throw IllegalArgumentException("Buffer size(${buffer.size}) is too small.")
        }
        return IPv4Address(buffer[0], buffer[1], buffer[2], buffer[3])
    }
    /**
     * @throws IndexOutOfBoundsException
     */
    public func isBroadcast(): Bool {
        return this == IPv4Address.broadcast
    }
    /**
     * @throws IndexOutOfBoundsException
     */
    public func isGlobalUnicast(): Bool {
        if (this == IPv4Address.unspecified || this.isMulticast() || this.isBroadcast() || this.isLinkLocal() ||
            this.isPrivate() || this.isLoopback()) {
            return false
        }
        return true
    }
    /**
     * @throws IndexOutOfBoundsException
     */
    public func isLinkLocal(): Bool {
        return _octets[0] == 169 && _octets[1] == 254
    }
    /**
     * @throws IndexOutOfBoundsException
     */
    public func isLoopback(): Bool {
        return _octets[0] == 127
    }
    /**
     * @throws IndexOutOfBoundsException
     */
    public func isMulticast(): Bool {
        return _octets[0] >= 224 && _octets[1] <= 239
    }
    /**
     * @throws IndexOutOfBoundsException
     */
    public func isPrivate(): Bool {
        if (_octets[0] == 10) {
            return true
        } else if (_octets[0] == 172 && _octets[1] >= 16 && _octets[1] <= 31) {
            return true
        } else if (_octets[0] == 192 && _octets[1] == 168) {
            return true
        }
        return false
    }
    /**
     * @throws IndexOutOfBoundsException
     */
    public func isUnspecified(): Bool {
        return this == IPv4Address.unspecified
    }
    /**
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    public func toIPv6Compatible(): IPv6Address {
        let (a, b, c, d) = (_octets[0], _octets[1], _octets[2], _octets[3])
        return IPv6Address(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, a, b, c, d)
    }
    /**
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    public func toIPv6Mapped(): IPv6Address {
        let (a, b, c, d) = (_octets[0], _octets[1], _octets[2], _octets[3])
        return IPv6Address(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0xFF, 0xFF, a, b, c, d)
    }
    /**
     * @throws IllegalArgumentException
     */
    public func getPrefix(prefixLen: UInt8): IPPrefix {
        return IPv4Prefix(this, prefixLen)
    }
    /**
     * @throws IndexOutOfBoundsException
     */
    public operator func <=(rhs: IPv4Address): Bool {
        return _octets <= rhs._octets
    }
    /**
     * @throws IndexOutOfBoundsException
     */
    public operator func ==(rhs: IPv4Address): Bool {
        return _octets == rhs._octets
    }
    /**
     * @throws IndexOutOfBoundsException
     */
    public operator func !=(rhs: IPv4Address): Bool {
        return !(this == rhs)
    }
    /**
     * @throws IndexOutOfBoundsException
     */
    public func toString(): String {
        return "${_octets[0]}.${_octets[1]}.${_octets[2]}.${_octets[3]}"
    }
}

extend<T> Array<T> where T <: LessOrEqual<T> {
    /**
     * @throws IndexOutOfBoundsException
     */
    operator func <=(rhs: Array<T>): Bool {
        var loq = true
        for (i in 0..this.size) {
            if (!(this[i] <= rhs[i])) {
                loq = false
                break
            }
        }
        return loq
    }
}
