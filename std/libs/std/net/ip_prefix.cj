







package std.net

import std.overflow.{CheckedOp, WrappingOp}
import std.convert.Parsable

sealed abstract class IPPrefix <: Equatable<IPPrefix> & Hashable & ToString {
    public prop address: IPAddress
    public prop prefixLength: UInt8
    /**
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     * @throws Exception
     * @throws IllegalFormatException
     */
    public static func parse(s: String): IPPrefix {
        match (tryParse(s)) {
            case Some(prefix) => return prefix
            case _ => throw IllegalFormatException("${s} is not a valid CIDR network string.")
        }
    }
    /**
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     * @throws IllegalFormatException
     * @throws Exception
     */
    public static func tryParse(s: String): ?IPPrefix {
        match (s.indexOf("/")) {
            case Some(i) =>
                let ipstr = s[..i]
                let prefixStr = s[i + 1..]
                let u8 = UInt8.tryParse(prefixStr) ?? return None
                let ip = IPAddress.tryParse(ipstr) ?? return None
                match (ip) {
                    case v4: IPv4Address => IPv4Prefix(v4, u8)
                    case v6: IPv6Address => IPv6Prefix(v6, u8)
                    case _ => throw Exception()
                }
            case _ => None
        }
    }

    /**
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    public func contains(rhs: IPAddress): Bool {
        match ((this, rhs)) {
            case (lv4: IPv4Prefix, rv4: IPv4Address) => return lv4.contains(rv4)
            case (lv6: IPv6Prefix, rv6: IPv6Address) => return lv6.contains(rv6)
            case _ => false
        }
    }
    /**
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    public func contains(rhs: IPPrefix): Bool {
        match ((this, rhs)) {
            case (lv4: IPv4Prefix, rv4: IPv4Prefix) => return lv4.contains(rv4)
            case (lv6: IPv6Prefix, rv6: IPv6Prefix) => return lv6.contains(rv6)
            case _ => false
        }
    }
    /**
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    public func overlaps(rhs: IPPrefix): Bool {
        match ((this, rhs)) {
            case (lv4: IPv4Prefix, rv4: IPv4Prefix) => return lv4.overlaps(rv4)
            case (lv6: IPv6Prefix, rv6: IPv6Prefix) => return lv6.overlaps(rv6)
            case _ => false
        }
    }

    /**
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     * @throws Exception
     */
    public open func netmask(): IPAddress {
        match (this) {
            case v4: IPv4Prefix => return v4.netmask()
            case v6: IPv6Prefix => return v6.netmask()
            case _ => throw Exception()
        }
    }
    /**
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     * @throws Exception
     */
    public open func hostmask(): IPAddress {
        match (this) {
            case v4: IPv4Prefix => return v4.hostmask()
            case v6: IPv6Prefix => return v6.hostmask()
            case _ => throw Exception()
        }
    }
    /**
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     * @throws Exception
     */
    public open func broadcast(): IPAddress {
        match (this) {
            case v4: IPv4Prefix => return v4.broadcast()
            case v6: IPv6Prefix => return v6.broadcast()
            case _ => throw Exception()
        }
    }
    /**
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     * @throws Exception
     */
    public open func network(): IPAddress {
        match (this) {
            case v4: IPv4Prefix => return v4.network()
            case v6: IPv6Prefix => return v6.network()
            case _ => throw Exception()
        }
    }
    /**
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     * @throws IllegalFormatException
     * @throws Exception
     */
    public open func masked(): IPPrefix {
        match (this) {
            case v4: IPv4Prefix => return v4.masked()
            case v6: IPv6Prefix => return v6.masked()
            case _ => throw Exception()
        }
    }
    /**
     * @throws IndexOutOfBoundsException
     */
    public operator func ==(rhs: IPPrefix): Bool {
        match ((this, rhs)) {
            case (lv4: IPv4Prefix, rv4: IPv4Prefix) => lv4 == rv4
            case (lv6: IPv6Prefix, rv6: IPv6Prefix) => lv6 == rv6
            case _ => false
        }
    }
    /**
     * @throws IndexOutOfBoundsException
     */
    public operator func !=(rhs: IPPrefix): Bool {
        return !(this == rhs)
    }
    public func toString(): String
}

class IPv4Prefix <: IPPrefix & Equatable<IPv4Prefix> & Hashable & ToString {
    let _ip: IPv4Address
    let _prefixLength: UInt8

    /**
     * @throws IllegalArgumentException
     */
    init(ip: IPv4Address, prefixLength: UInt8) {
        if (prefixLength > 32) {
            throw IllegalArgumentException("IPv4 prefix length must be >= 0 and <= 32.")
        }
        _ip = ip
        _prefixLength = prefixLength
    }

    public prop address: IPAddress {
        get() {
            return _ip
        }
    }

    public prop prefixLength: UInt8 {
        get() {
            _prefixLength
        }
    }
    /**
     * @throws IndexOutOfBoundsException
     */
    public func contains(rhs: IPv4Address): Bool {
        return this.network() <= rhs && rhs <= this.broadcast()
    }
    /**
     * @throws IndexOutOfBoundsException
     */
    public func contains(rhs: IPv4Prefix): Bool {
        return this.network() <= rhs.network() && rhs.broadcast() <= this.broadcast()
    }

    /**
     * @throws IndexOutOfBoundsException
     */
    public func overlaps(rhs: IPv4Prefix): Bool {
        rhs.contains(this._ip) || rhs.contains(this.broadcast()) || this.contains(rhs._ip) || this.contains(
            rhs.broadcast())
    }
    /**
     * @throws IndexOutOfBoundsException
     * @throws Exception
     */
    public func hashCode(): Int64 {
        var df = DefaultHasher()
        df.write(_ip.hashCode())
        df.write(_prefixLength)
        df.finish()
    }
    func hostmaskBits(): UInt32 {
        UInt32.Max.checkedShr(UInt64(_prefixLength)).getOrDefault({=> 0})
    }
    func netmaskBits(): UInt32 {
        UInt32.Max.checkedShl(32 - UInt64(_prefixLength)).getOrDefault({=> 0})
    }
    public func netmask(): IPv4Address {
        IPv4Address(netmaskBits())
    }
    public func hostmask(): IPv4Address {
        IPv4Address(hostmaskBits())
    }
    public func broadcast(): IPv4Address {
        IPv4Address(_ip.toBits() | hostmaskBits())
    }
    public func network(): IPv4Address {
        IPv4Address(_ip.toBits() & netmaskBits())
    }
    /**
     * @throws IllegalArgumentException
     */
    public func masked(): IPv4Prefix {
        IPv4Prefix(network(), _prefixLength)
    }
    /**
     * @throws IllegalArgumentException
     */
    func supernet(): IPv4Prefix {
        IPv4Prefix(this._ip, _prefixLength.wrappingSub(1)).masked()
    }
    /**
     * @throws IndexOutOfBoundsException
     */
    public operator func ==(rhs: IPv4Prefix): Bool {
        return this._ip == rhs._ip && this._prefixLength == rhs._prefixLength
    }
    /**
     * @throws IndexOutOfBoundsException
     */
    public operator func !=(rhs: IPv4Prefix): Bool {
        return !(this == rhs)
    }
    public func toString(): String {
        return "${_ip}/${_prefixLength}"
    }
}

class IPv6Prefix <: IPPrefix & Equatable<IPv6Prefix> & Hashable & ToString {
    let _ip: IPv6Address
    let _prefixLength: UInt8

    /**
     * @throws IllegalFormatException
     */
    init(ip: IPv6Address, prefixLength: UInt8) {
        if (prefixLength > 128) {
            throw IllegalFormatException("IPv6 prefix length must be >= 0 and <= 128.")
        }
        _ip = ip
        _prefixLength = prefixLength
    }

    public prop address: IPAddress {
        get() {
            return _ip
        }
    }

    public prop prefixLength: UInt8 {
        get() {
            _prefixLength
        }
    }
    /**
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    public func contains(rhs: IPv6Address): Bool {
        return this.network() <= rhs && rhs <= this.broadcast()
    }
    /**
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    public func contains(rhs: IPv6Prefix): Bool {
        return this.network() <= rhs.network() && rhs.broadcast() <= this.broadcast()
    }

    /**
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    func overlaps(rhs: IPv6Prefix): Bool {
        rhs.contains(this._ip) || rhs.contains(this.broadcast()) || this.contains(rhs._ip) || this.contains(
            rhs.broadcast())
    }
    /**
     * @throws IndexOutOfBoundsException
     * @throws Exception
     */
    public func hashCode(): Int64 {
        var df = DefaultHasher()
        df.write(_ip.hashCode())
        df.write(_prefixLength)
        df.finish()
    }
    func hostmaskBits(): UInt128 {
        UInt128.Max.checkedShr(UInt64(_prefixLength)).getOrDefault({=> UInt128.Min})
    }
    func netmaskBits(): UInt128 {
        UInt128.Max.checkedShl(128 - UInt64(_prefixLength)).getOrDefault({=> UInt128.Min})
    }
    /**
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    public func netmask(): IPv6Address {
        IPv6Address(netmaskBits())
    }
    /**
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    public func hostmask(): IPv6Address {
        IPv6Address(hostmaskBits())
    }

    /**
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    public func broadcast(): IPv6Address {
        IPv6Address(this._ip.toBits() | hostmaskBits())
    }

    /**
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    public func network(): IPv6Address {
        IPv6Address(_ip.toBits() & netmaskBits())
    }
    /**
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     * @throws IllegalFormatException
     */
    public func masked(): IPv6Prefix {
        IPv6Prefix(network(), _prefixLength)
    }
    /**
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     * @throws IllegalFormatException
     */
    func supernet(): IPv6Prefix {
        IPv6Prefix(this._ip, _prefixLength.wrappingSub(1)).masked()
    }
    /**
     * @throws IndexOutOfBoundsException
     */
    public operator func ==(rhs: IPv6Prefix): Bool {
        return this._ip == rhs._ip && this._prefixLength == rhs._prefixLength
    }
    /**
     * @throws IndexOutOfBoundsException
     */
    public operator func !=(rhs: IPv6Prefix): Bool {
        return !(this == rhs)
    }
    public func toString(): String {
        return "${_ip}/${_prefixLength}"
    }
}
