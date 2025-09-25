







package std.net

import std.sync.*








public class TcpSocket <: StreamingSocket & Equatable<TcpSocket> & Hashable {
    private let id = counter.fetchAdd(1)
    private static let counter = AtomicInt64(1)


    /*
     * @throws ArithmeticException
     * @throws IllegalSynchronizationStateException
     * @throws IllegalArgumentException
     * @throws IllegalStateException
     * @throws OverflowException
     * @throws SocketException
     */
    TcpSocket(private let impl: SocketCommon<ActualTcpPlatformSocket>) {
        noDelay = true
    }


    /*
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


    /*
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









    /*
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




    public override prop remoteAddress: SocketAddress {
        /*
         * @throws IllegalStateException
         * @throws ArithmeticException
         * @throws IllegalArgumentException
         * @throws IllegalSynchronizationStateException
         * @throws SocketException
         */
        get() {
            impl.remoteAddress ?? SocketException.notYetConnected()
        }
    }





    public override prop localAddress: SocketAddress {
        /*
         * @throws IllegalStateException
         * @throws ArithmeticException
         * @throws IllegalArgumentException
         * @throws IllegalSynchronizationStateException
         * @throws SocketException
         */
        get() {
            impl.localAddress ?? SocketException.notYetConnected()
        }
    }








    public override mut prop readTimeout: ?Duration {
        /*
         * @throws SocketException
         */
        get() {
            impl.readTimeout
        }
        /*
         * @throws IllegalArgumentException
         * @throws ArithmeticException
         * @throws SocketException
         */
        set(timeout) {
            impl.readTimeout = timeout?.throwIfNegative("Read timeout").toNanosecondGranularity()
        }
    }









    public override mut prop writeTimeout: ?Duration {
        /*
         * @throws SocketException
         */
        get() {
            impl.writeTimeout
        }
        /*
         * @throws IllegalArgumentException
         * @throws ArithmeticException
         * @throws SocketException
         */
        set(timeout) {
            impl.writeTimeout = timeout?.throwIfNegative("Write timeout").toNanosecondGranularity()
        }
    }










    public mut prop bindToDevice: ?String {
        /*
         * @throws SocketException
         */
        get() {
            impl.bindToDevice
        }
        /*
         * @throws SocketException
         */
        set(newDevice) {
            impl.bindToDevice = newDevice
        }
    }





    public mut prop keepAlive: ?SocketKeepAliveConfig {
        /*
         * @throws SocketException
         */
        get() {
            impl.keepAlive
        }
        /*
         * @throws ArithmeticException
         * @throws IllegalSynchronizationStateException
         * @throws IllegalArgumentException
         * @throws IllegalStateException
         * @throws OverflowException
         * @throws SocketException
         */
        set(newConfig) {
            impl.keepAlive = newConfig
        }
    }












    public mut prop noDelay: Bool {
        /*
         * @throws ArithmeticException
         * @throws IllegalSynchronizationStateException
         * @throws IllegalArgumentException
         * @throws IllegalStateException
         * @throws OverflowException
         * @throws SocketException
         */
        get() {
            impl.getSocketOptionBool(IPPROTO_TCP, SOCK_TCP_NODELAY)
        }
        /*
         * @throws ArithmeticException
         * @throws IllegalSynchronizationStateException
         * @throws IllegalArgumentException
         * @throws IllegalStateException
         * @throws OverflowException
         * @throws SocketException
         */
        set(newState) {
            impl.setSocketOptionBool(IPPROTO_TCP, SOCK_TCP_NODELAY, newState)
        }
    }
















    public mut prop quickAcknowledge: Bool {
        /*
         * @throws ArithmeticException
         * @throws IllegalSynchronizationStateException
         * @throws IllegalArgumentException
         * @throws IllegalStateException
         * @throws OverflowException
         * @throws SocketException
         */
        get() {
            impl.getSocketOptionBool(IPPROTO_TCP, SOCK_TCP_QUICKACK)
        }
        /*
         * @throws ArithmeticException
         * @throws IllegalSynchronizationStateException
         * @throws IllegalArgumentException
         * @throws IllegalStateException
         * @throws OverflowException
         * @throws SocketException
         */
        set(newState) {
            impl.setSocketOptionBool(IPPROTO_TCP, SOCK_TCP_QUICKACK, newState)
        }
    }












    public mut prop linger: ?Duration {
        /*
         * @throws IllegalSynchronizationStateException
         * @throws IllegalStateException
         * @throws OverflowException
         * @throws SocketException
         * @throws ArithmeticException
         * @throws IllegalArgumentException
         * @throws IllegalMemoryException
         */
        get() {
            impl.getLinger()
        }
        /*
         * @throws ArithmeticException
         * @throws IllegalSynchronizationStateException
         * @throws IllegalStateException
         * @throws OverflowException
         * @throws SocketException
         * @throws IllegalArgumentException
         * @throws IllegalMemoryException
         */
        set(newLinger) {
            impl.setLinger(newLinger)
        }
    }











    public mut prop sendBufferSize: Int64 {
        /*
         * @throws ArithmeticException
         * @throws IllegalSynchronizationStateException
         * @throws IllegalArgumentException
         * @throws IllegalStateException
         * @throws OverflowException
         * @throws SocketException
         */
        get() {
            Int64(impl.getSocketOptionIntNative(SOL_SOCKET, SOCK_SNDBUF))
        }
        /*
         * @throws ArithmeticException
         * @throws IllegalSynchronizationStateException
         * @throws IllegalStateException
         * @throws OverflowException
         * @throws SocketException
         * @throws IllegalArgumentException
         */
        set(newSize) {
            if (newSize <= 0) {
                throw IllegalArgumentException("Buffer size should be positive, got ${newSize}.")
            }
            impl.setSocketOptionIntNative(SOL_SOCKET, SOCK_SNDBUF, IntNative(newSize))
        }
    }











    public mut prop receiveBufferSize: Int64 {
        /*
         * @throws ArithmeticException
         * @throws IllegalSynchronizationStateException
         * @throws IllegalArgumentException
         * @throws IllegalStateException
         * @throws OverflowException
         * @throws SocketException
         */
        get() {
            Int64(impl.getSocketOptionIntNative(SOL_SOCKET, SOCK_RCVBUF))
        }
        /*
         * @throws ArithmeticException
         * @throws IllegalSynchronizationStateException
         * @throws IllegalStateException
         * @throws OverflowException
         * @throws SocketException
         * @throws IllegalArgumentException
         */
        set(newSize) {
            if (newSize <= 0) {
                throw IllegalArgumentException("Buffer size should be positive, got ${newSize}.")
            }
            impl.setSocketOptionIntNative(SOL_SOCKET, SOCK_RCVBUF, IntNative(newSize))
        }
    }









    /*
     * @throws SocketException
     * @throws ArithmeticException
     * @throws IllegalSynchronizationStateException
     * @throws IllegalArgumentException
     * @throws IllegalStateException
     * @throws OverflowException
     */
    public override func read(buffer: Array<Byte>): Int64 {
        impl.read(buffer)
    }























    /*
     * @throws ArithmeticException
     * @throws IllegalSynchronizationStateException
     * @throws IllegalArgumentException
     * @throws IllegalStateException
     * @throws OverflowException
     * @throws SocketException
     */
    public override func write(payload: Array<Byte>): Unit {
        impl.write(payload)
    }










    /*
     * @throws IllegalMemoryException
     * @throws ArithmeticException
     * @throws getOrFail
     * @throws IllegalSynchronizationStateException
     * @throws IllegalArgumentException
     * @throws IllegalStateException
     * @throws OverflowException
     * @throws SocketException
     */
    public func connect(timeout!: ?Duration = None): Unit {
        impl.connect(timeout?.throwIfNegative("Timeout"))
    }










    /*
     * @throws ArithmeticException
     * @throws IllegalSynchronizationStateException
     * @throws IllegalArgumentException
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







    /*
     * @throws ArithmeticException
     * @throws IllegalSynchronizationStateException
     * @throws IllegalArgumentException
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







    /*
     * @throws ArithmeticException
     * @throws IllegalSynchronizationStateException
     * @throws IllegalArgumentException
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







    /*
     * @throws ArithmeticException
     * @throws IllegalSynchronizationStateException
     * @throws IllegalArgumentException
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










    /*
     * @throws ArithmeticException
     * @throws IllegalSynchronizationStateException
     * @throws IllegalArgumentException
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









    /*
     * @throws ArithmeticException
     * @throws IllegalSynchronizationStateException
     * @throws IllegalArgumentException
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



    /*
     * @throws IllegalArgumentException
     * @throws IllegalStateException
     * @throws OverflowException
     */
    public func close(): Unit {
        impl.close()
    }


    /*
     * @noThrow
     */
    public func isClosed(): Bool {
        impl.isClosed()
    }

    /*
     * @noThrow
     */
    public override operator func ==(other: TcpSocket): Bool {
        id == other.id
    }

    /*
     * @noThrow
     */
    public override operator func !=(other: TcpSocket): Bool {
        id != other.id
    }

    /*
     * @noThrow
     */
    public override func hashCode(): Int64 {
        id.hashCode()
    }

    /*
     * @throws ArithmeticException
     * @throws IllegalArgumentException
     * @throws OverflowException
     * @throws IllegalStateException
     * @throws IllegalSynchronizationStateException
     */
    public override func toString(): String {
        "TcpSocket(${impl.toString()})"
    }

    /*
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
