







package std.net














public class UdpSocket <: DatagramSocket {
    private let impl: SocketCommon<ActualPlatformSocket>













    /**
     * @throws SocketException
     * @throws ArithmeticException
     * @throws IllegalArgumentException
     * @throws IllegalSynchronizationStateException
     */
    public init(bindAt!: UInt16) {
        this(bindAt: IPSocketAddress(IPv4Address.unspecified, bindAt))
    }


    /**
     * @throws SocketException
     * @throws ArithmeticException
     * @throws IllegalArgumentException
     * @throws IllegalSynchronizationStateException
     */
    public init(bindAt!: SocketAddress) {
        checkAddress(bindAt, "bindAt")
        impl = SocketCommon(SocketNet.UDP, bindAt.family, DatagramMode)
        impl.localAddress = bindAt
    }




        /**
         * @throws SocketException
         * @throws IllegalStateException
         * @throws ArithmeticException
         * @throws IllegalArgumentException
         * @throws IllegalSynchronizationStateException
         */
    public override prop remoteAddress: ?SocketAddress {
        get() {
            impl.remoteAddress
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
            impl.localAddress ?? SocketException.notYetBoundNeedBind()
        }
    }








    /**
     * @throws [set] ArithmeticException
     * @throws [set] IllegalArgumentException
     * @throws [get|set] SocketException
     */
    public override mut prop receiveTimeout: ?Duration {
        get() {
            impl.readTimeout
        }
        set(timeout) {
            impl.readTimeout = timeout?.throwIfNegative("Receive timeout").toNanosecondGranularity()
        }
    }









    /**
     * @throws [set] ArithmeticException
     * @throws [set] IllegalArgumentException
     * @throws [get|set] SocketException
     */
    public override mut prop sendTimeout: ?Duration {
        get() {
            impl.writeTimeout
        }
        set(timeout) {
            impl.writeTimeout = timeout?.throwIfNegative("Send timeout").toNanosecondGranularity()
        }
    }



    /**
     * @throws IllegalArgumentException
     * @throws IllegalStateException
     * @throws OverflowException
     */
    public override func close(): Unit {
        impl.close()
    }


    public override func isClosed(): Bool {
        impl.isClosed()
    }


    /**
     * @throws IllegalMemoryException
     * @throws ArithmeticException
     * @throws IllegalStateException
     * @throws OverflowException
     * @throws IllegalSynchronizationStateException
     * @throws SocketException
     * @throws IllegalArgumentException
     */
    public func bind(): Unit {
        impl.bind(None)
    }













    /**
     * @throws IllegalMemoryException
     * @throws IndexOutOfBoundsException
     * @throws IllegalStateException
     * @throws OverflowException
     * @throws ArithmeticException
     * @throws getOrFail
     * @throws IllegalSynchronizationStateException
     * @throws SocketException
     * @throws IllegalArgumentException
     */
    public func connect(remote: SocketAddress): Unit {
        throwIfIPv4ZeroOnWindows(remote)
        checkAddress(remote, "remote")

        if (remote.family != localAddress.family) {
            throw IllegalArgumentException(
                "remote address kind (${remote.family}) should have the same address family as local (${localAddress.family})"
            )
        }

        impl.remoteAddress = remote
        try {
            impl.connect(None, shouldBeBound: true)
        } catch (e: Exception) {
            impl.remoteAddress = None
            throw e
        }
    }



    /**
     * @throws IllegalMemoryException
     * @throws SocketException
     * @throws ArithmeticException
     * @throws IllegalArgumentException
     * @throws IllegalSynchronizationStateException
     * @throws IllegalStateException
     * @throws OverflowException
     */
    public func disconnect(): Unit {
        impl.disconnect()
    }













    /**
     * @throws ArithmeticException
     * @throws IllegalSynchronizationStateException
     * @throws IllegalStateException
     * @throws OverflowException
     * @throws IllegalArgumentException
     * @throws SocketException
     */
    public override func receiveFrom(buffer: Array<Byte>): (SocketAddress, Int64) {
        impl.receiveFrom(buffer) ?? SocketException.throwClosedException()
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
    public override func sendTo(recipient: SocketAddress, payload: Array<Byte>): Unit {
        throwIfIPv4ZeroOnWindows(
            recipient as IPSocketAddress ?? throw IllegalArgumentException(
                "recipient address kind (${recipient.family}) should have " +
                    "the same address family as local (${localAddress.family})"))

        if (payload.size > 65507) {
            throw SocketException("Unable to send datagram larger than 65507.")
        }
        if (recipient.family != impl.kind) {
            throw IllegalArgumentException(
                "recipient address kind (${recipient.family}) should have " +
                    "the same address family as local (${localAddress.family})")
        }

        impl.send(payload, recipient)
    }









    /**
     * @throws IndexOutOfBoundsException
     * @throws OverflowException
     * @throws IllegalStateException
     * @throws ArithmeticException
     * @throws IllegalArgumentException
     * @throws IllegalSynchronizationStateException
     * @throws SocketException
     */
    public func send(payload: Array<Byte>): Unit {
        if (OS == "macOS") {
            impl.write(payload)
        } else {
            sendTo(remoteAddress ?? SocketException.notYetConnected(), payload)
        }
    }







    /**
     * @throws ArithmeticException
     * @throws IllegalSynchronizationStateException
     * @throws IllegalStateException
     * @throws OverflowException
     * @throws IllegalArgumentException
     * @throws SocketException
     */
    public func receive(buffer: Array<Byte>): Int64 {
        let _ = impl.remoteAddress ?? SocketException.notYetConnected()
        let (_, size) = receiveFrom(buffer)
        return size
    }





    /**
     * @throws [get|set] SocketException
     * @throws [get|set] OverflowException
     * @throws [get|set] IllegalStateException
     * @throws [get|set] IllegalSynchronizationStateException
     * @throws [get|set] IllegalArgumentException
     * @throws [get|set] ArithmeticException
     */
    public mut prop reusePort: Bool {
        get() {
            impl.getSocketOptionBool(SOL_SOCKET, SOCK_REUSEPORT)
        }
        set(reuse) {
            impl.setSocketOptionBool(SOL_SOCKET, SOCK_REUSEPORT, reuse)
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
    public mut prop reuseAddress: Bool {
        get() {
            impl.getSocketOptionBool(SOL_SOCKET, SOCK_REUSEADDR)
        }
        set(reuse) {
            impl.setSocketOptionBool(SOL_SOCKET, SOCK_REUSEADDR, reuse)
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
        unsafe { impl.getSocketOption(level, option, value, valueLength) }
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
        unsafe { impl.setSocketOption(level, option, value, valueLength) }
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
     * @throws ArithmeticException
     * @throws IllegalArgumentException
     * @throws IllegalSynchronizationStateException
     * @throws IllegalStateException
     * @throws OverflowException
     */
    public override func toString(): String {
        "UdpSocket(${impl.toString()})"
    }

    /**
     * @throws IllegalArgumentException
     */
    private static func checkAddress(address: SocketAddress, name: String): SocketAddress {
        if (!(address is IPSocketAddress)) {
            throw IllegalArgumentException(
                "${name} should be either IPv4 or IPv6 but got ${address.family}: ${address}")
        }
        return address
    }
}
