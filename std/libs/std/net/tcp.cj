







package std.net

import std.sync.*








public class TcpSocket <: StreamingSocket & Equatable<TcpSocket> & Hashable {
    private let id = counter.fetchAdd(1)
    private static let counter = AtomicInt64(1)


    TcpSocket(private let impl: SocketCommon<ActualTcpPlatformSocket>) {
        noDelay = true
    }


    public init(address: String, port: UInt16) {
        this(IPSocketAddress(resolveHelper(address), port))
    }


    public init(address: SocketAddress) {
        this(address, localAddress: None)
    }









    public init(address: SocketAddress, localAddress!: ?SocketAddress) {
        checkAddress(address, "address")
        if (let Some(localAddress) <- localAddress) {
            checkAddress(localAddress, "localAddress")
            if (address.family != localAddress.family) {
                throw IllegalArgumentException(
                    "remote address kind (${address.family}) should have the same address " +
                    " family as local (${localAddress.family})")
            }
        }
        throwIfIPv4ZeroOnWindows(address)

        this.impl = SocketCommon(SocketNet.TCP, address.family, SocketMode.StreamingMode)
        impl.remoteAddress = address
        if (let Some(localAddress) <- localAddress) {
            impl.localAddress = localAddress
            setSocketOptionBool(SOL_SOCKET, SOCK_REUSEADDR, true)
        }

        noDelay = true
    }




    public override prop remoteAddress: SocketAddress {
        get() {
            impl.remoteAddress ?? SocketException.notYetConnected()
        }
    }





    public override prop localAddress: SocketAddress {
        get() {
            impl.localAddress ?? SocketException.notYetConnected()
        }
    }








    public override mut prop readTimeout: ?Duration {
        get() {
            impl.readTimeout
        }
        set(timeout) {
            impl.readTimeout = timeout?.throwIfNegative("Read timeout").toNanosecondGranularity()
        }
    }









    public override mut prop writeTimeout: ?Duration {
        get() {
            impl.writeTimeout
        }
        set(timeout) {
            impl.writeTimeout = timeout?.throwIfNegative("Write timeout").toNanosecondGranularity()
        }
    }










    public mut prop bindToDevice: ?String {
        get() {
            impl.bindToDevice
        }
        set(newDevice) {
            impl.bindToDevice = newDevice
        }
    }





    public mut prop keepAlive: ?SocketKeepAliveConfig {
        get() {
            impl.keepAlive
        }
        set(newConfig) {
            impl.keepAlive = newConfig
        }
    }












    public mut prop noDelay: Bool {
        get() {
            impl.getSocketOptionBool(IPPROTO_TCP, SOCK_TCP_NODELAY)
        }
        set(newState) {
            impl.setSocketOptionBool(IPPROTO_TCP, SOCK_TCP_NODELAY, newState)
        }
    }
















    public mut prop quickAcknowledge: Bool {
        get() {
            impl.getSocketOptionBool(IPPROTO_TCP, SOCK_TCP_QUICKACK)
        }
        set(newState) {
            impl.setSocketOptionBool(IPPROTO_TCP, SOCK_TCP_QUICKACK, newState)
        }
    }












    public mut prop linger: ?Duration {
        get() {
            impl.getLinger()
        }
        set(newLinger) {
            impl.setLinger(newLinger)
        }
    }











    public mut prop sendBufferSize: Int64 {
        get() {
            Int64(impl.getSocketOptionIntNative(SOL_SOCKET, SOCK_SNDBUF))
        }
        set(newSize) {
            if (newSize <= 0) {
                throw IllegalArgumentException("Buffer size should be positive, got ${newSize}.")
            }
            impl.setSocketOptionIntNative(SOL_SOCKET, SOCK_SNDBUF, IntNative(newSize))
        }
    }











    public mut prop receiveBufferSize: Int64 {
        get() {
            Int64(impl.getSocketOptionIntNative(SOL_SOCKET, SOCK_RCVBUF))
        }
        set(newSize) {
            if (newSize <= 0) {
                throw IllegalArgumentException("Buffer size should be positive, got ${newSize}.")
            }
            impl.setSocketOptionIntNative(SOL_SOCKET, SOCK_RCVBUF, IntNative(newSize))
        }
    }









    public override func read(buffer: Array<Byte>): Int64 {
        impl.read(buffer)
    }























    public override func write(payload: Array<Byte>): Unit {
        impl.write(payload)
    }










    public func connect(timeout!: ?Duration = None): Unit {
        impl.connect(timeout?.throwIfNegative("Timeout"))
    }










    public func getSocketOption(
        level: Int32,
        option: Int32,
        value: CPointer<Unit>,
        valueLength: CPointer<UIntNative>
    ): Unit {
        unsafe {
            impl.getSocketOption(level, option, value, valueLength)
        }
    }







    public func setSocketOption(
        level: Int32,
        option: Int32,
        value: CPointer<Unit>,
        valueLength: UIntNative
    ): Unit {
        unsafe {
            impl.setSocketOption(level, option, value, valueLength)
        }
    }







    public func getSocketOptionIntNative(
        level: Int32,
        option: Int32
    ): IntNative {
        impl.getSocketOptionIntNative(level, option)
    }







    public func setSocketOptionIntNative(
        level: Int32,
        option: Int32,
        value: IntNative
    ): Unit {
        impl.setSocketOptionIntNative(level, option, value)
    }










    public func getSocketOptionBool(
        level: Int32,
        option: Int32
    ): Bool {
        impl.getSocketOptionBool(level, option)
    }









    public func setSocketOptionBool(
        level: Int32,
        option: Int32,
        value: Bool
    ): Unit {
        impl.setSocketOptionBool(level, option, value)
    }



    public func close(): Unit {
        impl.close()
    }


    public func isClosed(): Bool {
        impl.isClosed()
    }

    public override operator func ==(other: TcpSocket): Bool {
        id == other.id
    }

    public override operator func !=(other: TcpSocket): Bool {
        id != other.id
    }

    public override func hashCode(): Int64 {
        id.hashCode()
    }

    public override func toString(): String {
        "TcpSocket(${impl.toString()})"
    }

    private static func checkAddress(address: SocketAddress, name: String): SocketAddress {
        if (address.family != AddressFamily.INET && address.family != AddressFamily.INET6) {
            throw IllegalArgumentException(
                "${name} should be either IPv4 or IPv6 but got ${address.family}: ${address}")
        }
        return address
    }
}
