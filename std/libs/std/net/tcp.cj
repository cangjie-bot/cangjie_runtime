







package std.net

import std.sync.*








public class TcpSocket <: StreamingSocket & Equatable<TcpSocket> & Hashable {
    private let id = counter.fetchAdd(1)
    private static let counter = AtomicInt64(1)


    /**
     * @throws ArithmeticException
     * @throws IllegalArgumentException
     * @throws IllegalSynchronizationStateException
     * @throws IllegalStateException
     * @throws OverflowException
     * @throws SocketException
     */
    TcpSocket(private let impl: SocketCommon<ActualTcpPlatformSocket>) {
        noDelay = true
    }


    /**
     * @throws OutOfMemoryError
     * @throws Exception
     * @throws IllegalMemoryException
     * @throws IllegalFormatException
     * @throws ArithmeticException
     * @throws IllegalSynchronizationStateException
     * @throws IndexOutOfBoundsException
     * @throws IllegalStateException
     * @throws OverflowException
     * @throws SocketException
     * @throws IllegalArgumentException
     */
    public init(address: String, port: UInt16) {
        this(IPSocketAddress(resolveHelper(address), port))
    }


    /**
     * @throws ArithmeticException
     * @throws IllegalSynchronizationStateException
     * @throws IndexOutOfBoundsException
     * @throws IllegalStateException
     * @throws OverflowException
     * @throws SocketException
     * @throws IllegalArgumentException
     */
    public init(address: SocketAddress) {
        this(address, localAddress: None)
    }









    /**
     * @throws ArithmeticException
     * @throws IllegalSynchronizationStateException
     * @throws IndexOutOfBoundsException
     * @throws IllegalStateException
     * @throws OverflowException
     * @throws SocketException
     * @throws IllegalArgumentException
     */
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




        /**
         * @throws IllegalStateException
         * @throws ArithmeticException
         * @throws IllegalArgumentException
         * @throws IllegalSynchronizationStateException
         * @throws SocketException
         */
    public override prop remoteAddress: SocketAddress {
        get() {
            impl.remoteAddress ?? SocketException.notYetConnected()
        }
    }





        /**
         * @throws IllegalStateException
         * @throws ArithmeticException
         * @throws IllegalArgumentException
         * @throws IllegalSynchronizationStateException
         * @throws SocketException
         */
    public override prop localAddress: SocketAddress {
        get() {
            impl.localAddress ?? SocketException.notYetConnected()
        }
    }








    /**
     * @throws [set] ArithmeticException
     * @throws [set] IllegalArgumentException
     * @throws [get|set] SocketException
     */
    public override mut prop readTimeout: ?Duration {
        get() {
            impl.readTimeout
        }
        set(timeout) {
            impl.readTimeout = timeout?.throwIfNegative("Read timeout").toNanosecondGranularity()
        }
    }









    /**
     * @throws [set] ArithmeticException
     * @throws [set] IllegalArgumentException
     * @throws [get|set] SocketException
     */
    public override mut prop writeTimeout: ?Duration {
        get() {
            impl.writeTimeout
        }
        set(timeout) {
            impl.writeTimeout = timeout?.throwIfNegative("Write timeout").toNanosecondGranularity()
        }
    }










    /**
     * @throws [get|set] SocketException
     */
    public mut prop bindToDevice: ?String {
        get() {
            impl.bindToDevice
        }
        set(newDevice) {
            impl.bindToDevice = newDevice
        }
    }





    /**
     * @throws [set] OverflowException
     * @throws [set] IllegalStateException
     * @throws [set] IllegalSynchronizationStateException
     * @throws [set] IllegalArgumentException
     * @throws [set] ArithmeticException
     * @throws [get|set] SocketException
     */
    public mut prop keepAlive: ?SocketKeepAliveConfig {
        get() {
            impl.keepAlive
        }
        set(newConfig) {
            impl.keepAlive = newConfig
        }
    }












    /**
     * @throws [get|set] SocketException
     * @throws [get|set] OverflowException
     * @throws [get|set] IllegalStateException
     * @throws [get|set] IllegalSynchronizationStateException
     * @throws [get|set] IllegalArgumentException
     * @throws [get|set] ArithmeticException
     */
    public mut prop noDelay: Bool {
        get() {
            impl.getSocketOptionBool(IPPROTO_TCP, SOCK_TCP_NODELAY)
        }
        set(newState) {
            impl.setSocketOptionBool(IPPROTO_TCP, SOCK_TCP_NODELAY, newState)
        }
    }
















    /**
     * @throws [get|set] SocketException
     * @throws [get|set] OverflowException
     * @throws [get|set] IllegalStateException
     * @throws [get|set] IllegalSynchronizationStateException
     * @throws [get|set] IllegalArgumentException
     * @throws [get|set] ArithmeticException
     */
    public mut prop quickAcknowledge: Bool {
        get() {
            impl.getSocketOptionBool(IPPROTO_TCP, SOCK_TCP_QUICKACK)
        }
        set(newState) {
            impl.setSocketOptionBool(IPPROTO_TCP, SOCK_TCP_QUICKACK, newState)
        }
    }












    /**
     * @throws [get|set] IllegalMemoryException
     * @throws [get|set] IllegalArgumentException
     * @throws [get|set] ArithmeticException
     * @throws [get|set] SocketException
     * @throws [get|set] OverflowException
     * @throws [get|set] IllegalStateException
     * @throws [get|set] IllegalSynchronizationStateException
     */
    public mut prop linger: ?Duration {
        get() {
            impl.getLinger()
        }
        set(newLinger) {
            impl.setLinger(newLinger)
        }
    }











    /**
     * @throws [get|set] SocketException
     * @throws [get|set] OverflowException
     * @throws [get|set] IllegalStateException
     * @throws [get|set] IllegalSynchronizationStateException
     * @throws [get|set] IllegalArgumentException
     * @throws [get|set] ArithmeticException
     */
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











    /**
     * @throws [get|set] SocketException
     * @throws [get|set] OverflowException
     * @throws [get|set] IllegalStateException
     * @throws [get|set] IllegalSynchronizationStateException
     * @throws [get|set] IllegalArgumentException
     * @throws [get|set] ArithmeticException
     */
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









    /**
     * @throws SocketException
     * @throws ArithmeticException
     * @throws IllegalArgumentException
     * @throws IllegalSynchronizationStateException
     * @throws IllegalStateException
     * @throws OverflowException
     */
    public override func read(buffer: Array<Byte>): Int64 {
        impl.read(buffer)
    }























    /**
     * @throws ArithmeticException
     * @throws IllegalArgumentException
     * @throws IllegalSynchronizationStateException
     * @throws IllegalStateException
     * @throws OverflowException
     * @throws SocketException
     */
    public override func write(payload: Array<Byte>): Unit {
        impl.write(payload)
    }










    /**
     * @throws IllegalMemoryException
     * @throws IllegalStateException
     * @throws OverflowException
     * @throws ArithmeticException
     * @throws IllegalArgumentException
     * @throws getOrFail
     * @throws IllegalSynchronizationStateException
     * @throws SocketException
     */
    public func connect(timeout!: ?Duration = None): Unit {
        impl.connect(timeout?.throwIfNegative("Timeout"))
    }










    /**
     * @throws ArithmeticException
     * @throws IllegalArgumentException
     * @throws IllegalSynchronizationStateException
     * @throws IllegalStateException
     * @throws OverflowException
     * @throws SocketException
     */
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







    /**
     * @throws ArithmeticException
     * @throws IllegalArgumentException
     * @throws IllegalSynchronizationStateException
     * @throws IllegalStateException
     * @throws OverflowException
     * @throws SocketException
     */
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







    /**
     * @throws ArithmeticException
     * @throws IllegalArgumentException
     * @throws IllegalSynchronizationStateException
     * @throws IllegalStateException
     * @throws OverflowException
     * @throws SocketException
     */
    public func getSocketOptionIntNative(
        level: Int32,
        option: Int32
    ): IntNative {
        impl.getSocketOptionIntNative(level, option)
    }







    /**
     * @throws ArithmeticException
     * @throws IllegalArgumentException
     * @throws IllegalSynchronizationStateException
     * @throws IllegalStateException
     * @throws OverflowException
     * @throws SocketException
     */
    public func setSocketOptionIntNative(
        level: Int32,
        option: Int32,
        value: IntNative
    ): Unit {
        impl.setSocketOptionIntNative(level, option, value)
    }










    /**
     * @throws ArithmeticException
     * @throws IllegalArgumentException
     * @throws IllegalSynchronizationStateException
     * @throws IllegalStateException
     * @throws OverflowException
     * @throws SocketException
     */
    public func getSocketOptionBool(
        level: Int32,
        option: Int32
    ): Bool {
        impl.getSocketOptionBool(level, option)
    }









    /**
     * @throws ArithmeticException
     * @throws IllegalArgumentException
     * @throws IllegalSynchronizationStateException
     * @throws IllegalStateException
     * @throws OverflowException
     * @throws SocketException
     */
    public func setSocketOptionBool(
        level: Int32,
        option: Int32,
        value: Bool
    ): Unit {
        impl.setSocketOptionBool(level, option, value)
    }



    /**
     * @throws IllegalArgumentException
     * @throws IllegalStateException
     * @throws OverflowException
     */
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

    /**
     * @throws ArithmeticException
     * @throws IllegalArgumentException
     * @throws IllegalSynchronizationStateException
     * @throws IllegalStateException
     * @throws OverflowException
     */
    public override func toString(): String {
        "TcpSocket(${impl.toString()})"
    }

    /**
     * @throws IllegalArgumentException
     */
    private static func checkAddress(address: SocketAddress, name: String): SocketAddress {
        if (address.family != AddressFamily.INET && address.family != AddressFamily.INET6) {
            throw IllegalArgumentException(
                "${name} should be either IPv4 or IPv6 but got ${address.family}: ${address}")
        }
        return address
    }
}
