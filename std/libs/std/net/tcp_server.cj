







package std.net











public class TcpServerSocket <: ServerSocket {
    private let impl: SocketCommon<ActualTcpPlatformSocket>
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
     * @throws ArithmeticException
     * @throws IllegalArgumentException
     * @throws IllegalSynchronizationStateException
     * @throws IllegalStateException
     * @throws OverflowException
     * @throws SocketException
     */
    public init(bindAt!: UInt16) {
        this(bindAt: IPSocketAddress(IPv4Address.unspecified, bindAt))
    }



    /**
     * @throws ArithmeticException
     * @throws IllegalArgumentException
     * @throws IllegalSynchronizationStateException
     * @throws IllegalStateException
     * @throws OverflowException
     * @throws SocketException
     */
    public init(bindAt!: SocketAddress) {
        checkAddress(bindAt, "bindAt")

        impl = SocketCommon(SocketNet.TCP, bindAt.family, SocketMode.StreamingMode)
        impl.localAddress = bindAt

        setSocketOptionBool(SOL_SOCKET, SOCK_REUSEADDR, true)
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
        set(enabled) {
            impl.setSocketOptionBool(SOL_SOCKET, SOCK_REUSEADDR, enabled)
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
    public mut prop reusePort: Bool {
        get() {
            impl.getSocketOptionBool(SOL_SOCKET, SOCK_REUSEPORT)
        }
        set(enabled) {
            impl.setSocketOptionBool(SOL_SOCKET, SOCK_REUSEPORT, enabled)
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
    public override func accept(timeout!: ?Duration): TcpSocket {
        let accepted = impl.accept(timeout) ?? SocketException.throwClosedException()
        return TcpSocket(accepted)
    }













    /**
     * @throws ArithmeticException
     * @throws IllegalArgumentException
     * @throws IllegalSynchronizationStateException
     * @throws IllegalStateException
     * @throws OverflowException
     * @throws SocketException
     */
    public override func accept(): TcpSocket {
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
        "TcpServerSocket(${impl.toString()})"
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
