







package std.net

import std.binary.{BigEndianOrder, LittleEndianOrder}
import std.convert.Parsable

public class IPSocketAddress <: SocketAddress & Equatable<IPSocketAddress> {
    let _addr: IPAddress
    let _port: UInt16
    /**
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    public init(address: Array<Byte>, port: UInt16) {
        this._port = port
        if (address.size == 4) {
            this._addr = IPv4Address(address[0], address[1], address[2], address[3])
        } else if (address.size == 16) {
            this._addr = IPv6Address(address)
        } else {
            throw IllegalArgumentException("IPSocketAddress only support IPv4 and IPv6 address.")
        }
    }
    /**
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     * @throws Exception
     * @throws IllegalFormatException
     */
    public init(address: String, port: UInt16) {
        this._addr = IPAddress.parse(address)
        this._port = port
    }
    public init(address: IPAddress, port: UInt16) {
        this._port = port
        this._addr = address
    }
        /**
         * @throws Exception
         */
    public prop size: Int64 {
        get() {
            if (_addr.isIPv4()) {
                Int64(sizeOf<SockAddrIn>())
            } else {
                Int64(sizeOf<SockAddrIn6>())
            }
        }
    }
        /**
         * @throws Exception
         */
    public prop family: AddressFamily {
        get() {
            if (_addr.isIPv4()) {
                AddressFamily.INET
            } else {
                AddressFamily.INET6
            }
        }
    }



    /**
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     * @throws Exception
     * @throws IllegalFormatException
     */
    public static func parse(s: String): IPSocketAddress {
        let (ipstr, portstr, isV6) = innerParse(s).unwrap()
        let port = UInt16.tryParse(portstr) ?? throw IllegalFormatException("Parse (${s}): invalid port.")
        let ipaddr = IPAddress.parse(ipstr)
        if (isV6 && ipaddr.isIPv4()) {
            throw IllegalFormatException("Parse (${s}): invalid IP socket address, only IPv6 can be around [].")
        } else if (!isV6 && ipaddr.isIPv6()) {
            throw IllegalFormatException("Parse (${s}): invalid IP socket address, IPv6 must around [].")
        }
        return IPSocketAddress(ipaddr, port)
    }
    /**
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     * @throws Exception
     */
    public static func tryParse(s: String): ?IPSocketAddress {
        let r = innerParse(s)
        if (r.isErr()) {
            return None
        }
        let (ipstr, portstr, isV6) = r.unwrap()
        if (let Some(ipaddr) <- IPAddress.tryParse(ipstr)) {
            if (isV6 && ipaddr.isIPv4()) {
                return None
            } else if (!isV6 && ipaddr.isIPv6()) {
                return None
            }
            if (let Some(port) <- UInt16.tryParse(portstr)) {
                return IPSocketAddress(ipaddr, port)
            } else {
                return None
            }
        } else {
            return None
        }
    }

    public prop address: IPAddress {
        get() {
            _addr
        }
    }

    public prop port: UInt16 {
        get() {
            _port
        }
    }
    /**
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     * @throws Exception
     */
    public func getAddressBytes(): Array<Byte> {
        let buf = Array<Byte>(this.size, repeat: 0)
        this.family.value.writeLittleEndian(buf)
        this.port.writeBigEndian(buf[2..])
        match (_addr) {
            case v4: IPv4Address =>
                v4.writeBigEndian(buf[4..])
            case v6: IPv6Address =>
                v6.writeBigEndian(buf[8..])
                let scopeId = v6.scopeId ?? 0
                scopeId.writeLittleEndian(buf[24..])
            case _ => throw Exception()
        }

        return buf
    }

    /**
     * @throws Exception
     */
    public func isIPv4(): Bool {
        return _addr.isIPv4()
    }

    /**
     * @throws Exception
     */
    public func isIPv6(): Bool {
        return _addr.isIPv6()
    }
    /**
     * @throws IndexOutOfBoundsException
     */
    public operator func ==(rhs: IPSocketAddress): Bool {
        return _addr == rhs._addr && _port == rhs._port
    }
    /**
     * @throws IndexOutOfBoundsException
     */
    public operator func !=(rhs: IPSocketAddress): Bool {
        return !(this == rhs)
    }
    /**
     * @throws IndexOutOfBoundsException
     * @throws Exception
     */
    public func hashCode(): Int64 {
        var df = DefaultHasher()
        df.write(_addr.hashCode())
        df.write(_port)
        df.finish()
    }
    /**
     * @throws Exception
     */
    public func toString(): String {
        if (this.isIPv6()) {
            return "[${_addr}]:${_port}"
        }
        return "${_addr}:${_port}"
    }
}

/**
 * @throws IllegalArgumentException
 * @throws IndexOutOfBoundsException
 */
func innerParse(s: String): Result<(String, String, Bool)> {
    match (s.lastIndexOf(":")) {
        case Some(i) =>
            let (ip, port) = (s[..i], s[i + 1..])
            if (ip.size == 0) {
                return Err(IllegalFormatException("Expect IP in ${s}"))
            }
            if (port.size == 0) {
                return Err(IllegalFormatException("Expect port in ${s}"))
            }
            if (ip[0] == b'[') {
                if (ip.size < 2 || ip[ip.size - 1] != b']') {
                    return Err(IllegalFormatException("IPv6 must around [] in ${s}"))
                }
                return Ok((ip[1..ip.size - 1], port, true))
            }
            return Ok((ip, port, false))
        case _ => return Err(IllegalFormatException("${s} is not a IP socket address"))
    }
}
