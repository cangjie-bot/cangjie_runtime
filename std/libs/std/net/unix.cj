







package std.net


/**
 * @throws IllegalArgumentException
 */
func checkUnixSocketAddress(address: SocketAddress, name: String): SocketAddress {
    if (!(address is UnixSocketAddress)) {
        throw IllegalArgumentException("${name} should be a Unix Path address but got ${address.family}: ${address}")
    }
    return address
}








public class UnixSocket <: StreamingSocket {
    private let impl: SocketCommon<ActualPlatformSocket>

    /**
     * @throws SocketException
     * @throws ArithmeticException
     * @throws IllegalArgumentException
     * @throws IllegalSynchronizationStateException
     */
    private func setLocalAddress(address: SocketAddress) {
        checkUnixSocketAddress(address, "localAddress")
        impl.localAddress = address
    }




    /**
     * @throws IndexOutOfBoundsException
     * @throws SocketException
     * @throws ArithmeticException
     * @throws IllegalArgumentException
     * @throws IllegalSynchronizationStateException
     */
    public init(path: String, localPath!: ?String = None) {
        this(UnixSocketAddress(path))
        if (let Some(_localPath) <- localPath) {
            setLocalAddress(UnixSocketAddress(_localPath))
        }
    }



    /**
     * @throws SocketException
     * @throws ArithmeticException
     * @throws IllegalArgumentException
     * @throws IllegalSynchronizationStateException
     */
    public init(address: SocketAddress, localAddress!: ?SocketAddress = None) {
        checkUnixSocketAddress(address, "address")
        this.impl = SocketCommon(SocketNet.UNIX, AddressFamily.UNIX, StreamingMode)
        impl.remoteAddress = address
        if (let Some(_localAddress) <- localAddress) {
            setLocalAddress(_localAddress)
        }
    }


    init(impl: SocketCommon<ActualPlatformSocket>) {
        this.impl = impl
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
    public override func write(buffer: Array<Byte>): Unit {
        impl.write(buffer)
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

    /**
     * @throws ArithmeticException
     * @throws IllegalArgumentException
     * @throws IllegalSynchronizationStateException
     * @throws IllegalStateException
     * @throws OverflowException
     */
    public override func toString(): String {
        "UnixSocket(${impl.toString()})"
    }
}












public class UnixServerSocket <: ServerSocket {
    private let impl: SocketCommon<ActualPlatformSocket>
    private var backlogSize_: Int32 = SOCKET_DEFAULT_BACKLOG




        /**
         * @throws IllegalStateException
         * @throws ArithmeticException
         * @throws IllegalArgumentException
         * @throws IllegalSynchronizationStateException
         * @throws SocketException
         */
    public override prop localAddress: SocketAddress {
        get() {
            impl.localAddress ?? SocketException.notYetBound()
        }
    }



    /**
     * @throws IndexOutOfBoundsException
     * @throws SocketException
     * @throws ArithmeticException
     * @throws IllegalArgumentException
     * @throws IllegalSynchronizationStateException
     */
    public init(bindAt!: String) {
        this(bindAt: UnixSocketAddress(bindAt))
    }



    /**
     * @throws SocketException
     * @throws ArithmeticException
     * @throws IllegalArgumentException
     * @throws IllegalSynchronizationStateException
     */
    public init(bindAt!: SocketAddress) {
        checkUnixSocketAddress(bindAt, "bindAt")

        let impl = SocketCommon<ActualPlatformSocket>(UNIX, AddressFamily.UNIX, SocketMode.StreamingMode)
        impl.localAddress = bindAt
        this.impl = impl
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
     * @throws [set] IllegalArgumentException
     * @throws [set] SocketException
     */
    public mut prop backlogSize: Int64 {
        get() {
            Int64(backlogSize_)
        }
        set(newSize) {
            impl.checkNotBound()
            impl.checkNotClosed()
            backlogSize_ = match {
                case newSize <= 0 => throw IllegalArgumentException("BacklogSize should be positive: ${newSize}.")
                case newSize >= Int64(Int32.Max) => Int32.Max - 1
                case _ => Int32(newSize)
            }
        }
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
    public override func bind(): Unit {
        impl.bind(backlogSize_)
    }









    /**
     * @throws ArithmeticException
     * @throws IllegalArgumentException
     * @throws IllegalSynchronizationStateException
     * @throws IllegalStateException
     * @throws OverflowException
     * @throws SocketException
     */
    public override func accept(timeout!: ?Duration): UnixSocket {
        let accepted = impl.accept(timeout) ?? SocketException.throwClosedException()
        return UnixSocket(accepted)
    }






    /**
     * @throws ArithmeticException
     * @throws IllegalArgumentException
     * @throws IllegalSynchronizationStateException
     * @throws IllegalStateException
     * @throws OverflowException
     * @throws SocketException
     */
    public override func accept(): UnixSocket {
        accept(timeout: None)
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
        "UnixServerSocket(${impl.toString()})"
    }
}
