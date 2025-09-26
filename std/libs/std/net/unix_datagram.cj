







package std.net















public class UnixDatagramSocket <: DatagramSocket {
    private let impl: SocketCommon<ActualPlatformSocket>




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

        impl = SocketCommon(SocketNet.UNIX, bindAt.family, DatagramMode)
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
     * @throws IllegalArgumentException
     * @throws getOrFail
     * @throws IllegalSynchronizationStateException
     * @throws SocketException
     */
    public func connect(remotePath: String): Unit {
        connect(UnixSocketAddress(remotePath))
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
    public func connect(remote: SocketAddress): Unit {
        checkUnixSocketAddress(remote, "remote")
        try {
            impl.remoteAddress = remote
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
     * @throws IllegalArgumentException
     * @throws IllegalSynchronizationStateException
     * @throws IllegalStateException
     * @throws OverflowException
     * @throws SocketException
     */
    public override func sendTo(recipient: SocketAddress, payload: Array<Byte>): Unit {
        checkUnixSocketAddress(recipient, "recipient")

        impl.send(payload, recipient)
    }





    /**
     * @throws ArithmeticException
     * @throws IllegalArgumentException
     * @throws IllegalSynchronizationStateException
     * @throws IllegalStateException
     * @throws OverflowException
     * @throws SocketException
     */
    public func send(payload: Array<Byte>): Unit {
        if (OS == "macOS") {
            impl.write(payload)
        } else {
            sendTo(impl.remoteAddress ?? SocketException.notYetConnected(), payload)
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
        "UnixDatagramSocket(${impl.toString()})"
    }
}
