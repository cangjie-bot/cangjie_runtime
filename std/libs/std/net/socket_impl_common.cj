







package std.net

interface PlatformSocket<Self> where Self <: PlatformSocket<Self> {
    /*
     * @noThrow
     */
    func write(buffer: Array<Byte>, timeout: ?Duration): Unit

    /*
     * @noThrow
     */
    func read(buffer: Array<UInt8>, timeout: ?Duration): ?Int64

    /*
     * @noThrow
     */
    func send(buffer: Array<Byte>, timeout: ?Duration, destination: SocketAddress): Int64

    /*
     * @noThrow
     */
    func receiveFrom(buffer: Array<UInt8>, timeout: ?Duration): ?(SocketAddress, Int64)



    /*
     * @noThrow
     */
    func connect(localAddress: ?SocketAddress, address: SocketAddress, timeout: ?Duration): Unit

    /*
     * @noThrow
     */
    func disconnect(): Unit

    /*
     * @noThrow
     */
    func bindListen(address: SocketAddress, backlogSize: ?Int32, ignoreAlreadyBound!: Bool): Unit

    /*
     * @noThrow
     */
    func accept(timeout: ?Duration): ?Self

    /*
     * @noThrow
     */
    func shutdown(): Unit

    /*
     * @noThrow
     */
    func detectLocalAddress(): ?SocketAddress

    /*
     * @noThrow
     */
    func detectRemoteAddress(): ?SocketAddress

    /*
     * @noThrow
     */
    unsafe func getSocketOption(
        level: Int32,
        option: Int32,
        value: CPointer<Unit>,
        valueLength: CPointer<UIntNative>
    ): Unit

    /*
     * @noThrow
     */
    unsafe func setSocketOption(
        level: Int32,
        option: Int32,
        value: CPointer<Unit>,
        valueLength: UIntNative
    ): Unit

    /*
     * @noThrow
     */
    func getSocketOptionIntNative(
        level: Int32,
        option: Int32
    ): IntNative

    /*
     * @noThrow
     */
    func setSocketOptionIntNative(
        level: Int32,
        option: Int32,
        value: IntNative
    ): Unit

    /*
     * @noThrow
     */
    func setKeepAlive(config: ?SocketKeepAliveConfig): Bool







    /*
     * @noThrow
     */
    unsafe func dispose(): Unit

    /*
     * @noThrow
     */
    static func create(
        net: SocketNet,
        kind: AddressFamily,
        mode: SocketMode
    ): Self
}





class SocketCommon<NS> <: Resource & ToString where NS <: PlatformSocket<NS> {
    private var readTimeout_: ?Duration = None
    private var writeTimeout_: ?Duration = None

    private var bindToDevice_: ?String = None
    private var keepAlive_: ?SocketKeepAliveConfig = None

    private let addressLock = NonReentrantReadWriteMutex()
    private var remoteAddress_ = ExternallyLockedLazy<?SocketAddress, SocketHolder<NS>>()
    private var localAddress_ = ExternallyLockedLazy<?SocketAddress, SocketHolder<NS>>()

    /*
     * @noThrow
     */
    private SocketCommon(
        private let holder: SocketHolder<NS>,
        let kind: AddressFamily
    ) {}

    /*
     * @noThrow
     */
    private init(
        create: () -> NS,
        kind: AddressFamily
    ) {
        this(SocketHolder<NS>(create), kind)
    }

    /*
     * @noThrow
     */
    init(
        net: SocketNet,
        kind: AddressFamily,
        mode: SocketMode
    ) {
        this(
            {=> NS.create(net, kind, mode)},
            kind
        )
    }

    /*
     * @noThrow
     */
    private init(
        existing: NS,
        kind: AddressFamily
    ) {
        this(SocketHolder<NS>(acceptedSocket: existing), kind)
    }



    mut prop localAddress: ?SocketAddress {
        /*
         * @throws SocketException
         * @throws IllegalStateException
         * @throws ArithmeticException
         * @throws IllegalArgumentException
         * @throws IllegalSynchronizationStateException
         */
        get() {
            checkNotClosed()
            localAddress_.compute(addressLock, holder, lazyLocalAddress)
        }
        /*
         * @throws SocketException
         * @throws ArithmeticException
         * @throws IllegalArgumentException
         * @throws IllegalSynchronizationStateException
         */
        set(newAddress) {
            checkNotClosed()
            checkNotBound()
            localAddress_.putValue(addressLock, newAddress)
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
    private static func lazyLocalAddress(holder: SocketHolder<NS>): ?SocketAddress {
        holder.use<?SocketAddress> {
            socket, state =>
            state.ensureBound()
            socket.detectLocalAddress()
        } ?? SocketException.throwClosedException()
    }



    mut prop remoteAddress: ?SocketAddress {
        /*
         * @throws SocketException
         * @throws IllegalStateException
         * @throws ArithmeticException
         * @throws IllegalArgumentException
         * @throws IllegalSynchronizationStateException
         */
        get() {
            checkNotClosed()
            remoteAddress_.compute(addressLock, holder, lazyRemoteAddress)
        }
        /*
         * @throws SocketException
         * @throws ArithmeticException
         * @throws IllegalArgumentException
         * @throws IllegalSynchronizationStateException
         */
        set(newAddress) {
            checkNotClosed()
            checkNotConnected()
            remoteAddress_.putValue(addressLock, newAddress)
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
    private static func lazyRemoteAddress(holder: SocketHolder<NS>): ?SocketAddress {
        holder.use<?SocketAddress> {
            socket, state =>
            state.ensureConnected()
            socket.detectRemoteAddress()
        } ?? SocketException.throwClosedException()
    }

    mut prop bindToDevice: ?String {
        /*
         * @throws SocketException
         */
        get() {
            checkNotClosed()
            bindToDevice_
        }
        /*
         * @throws SocketException
         */
        set(newDevice) {
            checkNotClosed()
            checkNotBound()
            bindToDevice_ = newDevice
        }
    }

    prop isBound: Bool {
        /*
         * @noThrow
         */
        get() {
            holder.state.bound
        }
    }

    prop isConnected: Bool {
        /*
         * @noThrow
         */
        get() {
            holder.state.connected
        }
    }
    /*
     * @throws SocketException
     */
    func checkNotClosed() {
        holder.state.ensureNotClosed()
    }

    /*
     * @throws SocketException
     */
    func checkNotBound() {
        holder.state.ensureNotBound()
    }

    /*
     * @throws SocketException
     */
    func checkNotConnected() {
        holder.state.ensureNotConnected()
    }

    mut prop readTimeout: ?Duration {
        /*
         * @throws SocketException
         */
        get() {
            checkNotClosed()
            readTimeout_
        }
        /*
         * @throws SocketException
         */
        set(newTimeout) {
            checkNotClosed()
            readTimeout_ = newTimeout
        }
    }

    mut prop writeTimeout: ?Duration {
        /*
         * @throws SocketException
         */
        get() {
            checkNotClosed()
            writeTimeout_
        }
        /*
         * @throws SocketException
         */
        set(newTimeout) {
            checkNotClosed()
            writeTimeout_ = newTimeout
        }
    }

    mut prop keepAlive: ?SocketKeepAliveConfig {
        /*
         * @throws SocketException
         */
        get() {
            checkNotClosed()
            keepAlive_
        }
        /*
         * @throws ArithmeticException
         * @throws IllegalSynchronizationStateException
         * @throws IllegalArgumentException
         * @throws IllegalStateException
         * @throws OverflowException
         * @throws SocketException
         */
        set(newValue) {
            holder.use<Unit> {
                socket, _ => if (socket.setKeepAlive(newValue)) {
                    keepAlive_ = newValue
                }
            } ?? SocketException.throwClosedException()
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
    func write(payload: Array<Byte>): Unit {
        holder.write<Unit> {
            socket, state =>
            state.ensureConnected()
            socket.write(payload, writeTimeout_)
        } ?? SocketException.throwClosedException()
    }

    /*
     * @throws SocketException
     * @throws ArithmeticException
     * @throws IllegalSynchronizationStateException
     * @throws IllegalArgumentException
     * @throws IllegalStateException
     * @throws OverflowException
     */
    func read(buffer: Array<Byte>): Int64 {
        if (buffer.isEmpty()) {
            emptyBufferException()
        }

        return holder.read<Int64> {
            socket, state =>
            state.ensureConnected()
            socket.read(buffer, readTimeout_) ?? 0
        } ?? 0
    }

    /*
     * @throws IllegalArgumentException
     */
    private static func emptyBufferException(): Nothing {
        throw IllegalArgumentException("Buffer shouldn't be empty")
    }

    /*
     * @throws ArithmeticException
     * @throws IllegalSynchronizationStateException
     * @throws IllegalArgumentException
     * @throws IllegalStateException
     * @throws OverflowException
     * @throws SocketException
     */
    func send(payload: Array<Byte>, destination: SocketAddress): Int64 {
        return holder.write<Int64> {
            socket, state =>
            state.ensureBound()
            socket.send(payload, writeTimeout_, destination)
        } ?? SocketException.throwClosedException()
    }

    /*
     * @throws SocketException
     * @throws ArithmeticException
     * @throws IllegalSynchronizationStateException
     * @throws IllegalStateException
     * @throws OverflowException
     * @throws IllegalArgumentException
     */
    func receiveFrom(buffer: Array<UInt8>): ?(SocketAddress, Int64) {
        if (buffer.isEmpty()) {
            throw IllegalArgumentException("Buffer shouldn't be empty")
        }

        return holder.read {
            socket: NS, state: SocketState =>
            state.ensureBound()
            socket.receiveFrom(buffer, readTimeout_)
        } ?? None
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
    func connect(
        timeout: ?Duration,
        shouldBeBound!: Bool = false,
        mayBeAlreadyConnected!: Bool = false
    ): Unit {
        timeout?.throwIfNegative("Timeout")
        holder.write<Unit> {
            socket, state =>
            if (state.failed) {
                throw SocketException("The bind of the socket has failed.")
            }
            if (shouldBeBound) {
                state.ensureBindInvoked()
            }
            if (!mayBeAlreadyConnected) {
                state.ensureNotConnected()
            }

            addressLock.writeMutex.lock()
            try {
                connectImpl(socket, state, timeout)
            } catch (e: Exception) {
                holder.markFailed()
                throw e
            } finally {
                addressLock.writeMutex.unlock()
            }
        } ?? SocketException.throwClosedException()
    }
    /*
     * @throws IllegalMemoryException
     * @throws ArithmeticException
     * @throws getOrFail
     * @throws IllegalSynchronizationStateException
     * @throws IllegalArgumentException
     * @throws SocketException
     * @throws OverflowException
     * @throws IllegalStateException
     */
    private func connectImpl(socket: NS, state: SocketState, timeout: ?Duration): Unit {
        let address = remoteAddress_.directValue |> unwrapOption |>
            getOrFail<SocketAddress> {
            SocketException("No address to connect to specified")
        }

        let bindAddress: ?SocketAddress = if (state.bound) {
            None
        } else {
            applyBindToDevice()
            localAddress_.directValue |> unwrapOption
        }
        socket.connect(bindAddress, address, timeout)

        if (!state.bound) {
            holder.markBound()
        }
        holder.markConnected()
        localAddress_.clearWithoutLock()
        remoteAddress_.clearWithoutLock()
    }

    /*
     * @throws IllegalMemoryException
     * @throws SocketException
     * @throws ArithmeticException
     * @throws IllegalSynchronizationStateException
     * @throws IllegalArgumentException
     * @throws IllegalStateException
     * @throws OverflowException
     */
    func disconnect(): Unit {
        holder.write<Unit> {
            socket, state =>
            state.ensureBindInvoked()
            if (!state.connected) {
                return
            }

            addressLock.writeMutex.lock()
            try {
                let local = populateLocalAddressUnderLock(socket)
                socket.disconnect()
                holder.unmarkConnected()
                remoteAddress_.clearWithoutLock()

                if (let Some(before) <- local) {
                    restoreLocalAddress(socket, before)
                }
            } catch (e: Exception) {
                holder.markFailed()
                throw e
            } finally {
                addressLock.writeMutex.unlock()
            }
        } ?? SocketException.throwClosedException()
    }

    /*
     * @throws IllegalMemoryException
     * @throws ArithmeticException
     * @throws IllegalSynchronizationStateException
     * @throws IllegalArgumentException
     * @throws IllegalStateException
     * @throws OverflowException
     * @throws SocketException
     */
    private func restoreLocalAddress(socket: NS, before: SocketAddress) {
        if (before.family == AddressFamily.UNIX) {
            return
        }

        localAddress_.directValue = before
        bindImpl(socket, None, bindRequired: true, ignoreAlreadyBound: true)
        localAddress_.directValue = None
    }

    /*
     * @noThrow
     */
    private func populateLocalAddressUnderLock(socket: NS): ?SocketAddress {
        try {
            let address = socket.detectLocalAddress()
            localAddress_.directValue = address
            return address
        } catch (_) {
            return None
        }
    }

    /*
     * @throws IllegalMemoryException
     * @throws ArithmeticException
     * @throws IllegalSynchronizationStateException
     * @throws IllegalStateException
     * @throws OverflowException
     * @throws SocketException
     * @throws IllegalArgumentException
     */
    func bind(backlogSize: ?Int32): Unit {
        if (let Some(backlogSize) <- backlogSize) {
            if (backlogSize < 0) {
                throw IllegalArgumentException("Backlog size shouldn't be negative")
            }
        }

        holder.write<Unit> {
            socket, state =>
            state.ensureNotBound()
            if (state.failed) {
                throw SocketException("Bind couldn't be invoked twice.")
            }

            addressLock.writeMutex.lock()
            try {
                bindImpl(socket, backlogSize, bindRequired: true)
                holder.markBound()
                localAddress_.clearWithoutLock()
            } catch (e: Exception) {
                holder.markFailed()
                throw e
            } finally {
                addressLock.writeMutex.unlock()
            }
        } ?? SocketException.throwClosedException()
    }
    /*
     * @throws IllegalMemoryException
     * @throws ArithmeticException
     * @throws IllegalSynchronizationStateException
     * @throws IllegalArgumentException
     * @throws IllegalStateException
     * @throws OverflowException
     * @throws SocketException
     */
    private func bindImpl(
        socket: NS,
        backlogSize: ?Int32,
        bindRequired!: Bool,
        ignoreAlreadyBound!: Bool = false
    ): Unit {
        applyBindToDevice()

        if (let Some(localAddress) <- (localAddress_.directValue |> unwrapOption)) {
            socket.bindListen(localAddress, backlogSize, ignoreAlreadyBound: ignoreAlreadyBound)
        } else if (bindRequired) {
            throw SocketException("No local address specified to bind at")
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
    func accept(timeout: ?Duration): ?SocketCommon<NS> {
        let accepted = holder.read {
            socket: NS, state: SocketState =>
            state.ensureBound()
            socket.accept(timeout?.throwIfNegative("Timeout"))
        } |> unwrapOption

        if (let Some(accepted) <- accepted) {
            return SocketCommon<NS>(accepted, kind)
        }

        return None
    }

    /*
     * @throws ArithmeticException
     * @throws IllegalSynchronizationStateException
     * @throws IllegalArgumentException
     * @throws IllegalStateException
     * @throws OverflowException
     * @throws SocketException
     */
    unsafe func getSocketOption(
        level: Int32,
        option: Int32,
        value: CPointer<Unit>,
        valueLength: CPointer<UIntNative>
    ): Unit {
        holder.use<Unit> {
            socket, _ => socket.getSocketOption(level, option, value, valueLength)
        } ?? SocketException.throwClosedException()
    }

    /*
     * @throws ArithmeticException
     * @throws IllegalSynchronizationStateException
     * @throws IllegalArgumentException
     * @throws IllegalStateException
     * @throws OverflowException
     * @throws SocketException
     */
    unsafe func setSocketOption(
        level: Int32,
        option: Int32,
        value: CPointer<Unit>,
        valueLength: UIntNative
    ): Unit {
        holder.use<Unit> {
            socket, _ => socket.setSocketOption(level, option, value, valueLength)
        } ?? SocketException.throwClosedException()
    }

    /*
     * @throws ArithmeticException
     * @throws IllegalSynchronizationStateException
     * @throws IllegalArgumentException
     * @throws IllegalStateException
     * @throws OverflowException
     * @throws SocketException
     */
    func getSocketOptionIntNative(
        level: Int32,
        option: Int32
    ): IntNative {
        holder.use<IntNative> {
            socket, _ => socket.getSocketOptionIntNative(level, option)
        } ?? SocketException.throwClosedException()
    }

    /*
     * @throws ArithmeticException
     * @throws IllegalSynchronizationStateException
     * @throws IllegalArgumentException
     * @throws IllegalStateException
     * @throws OverflowException
     * @throws SocketException
     */
    func setSocketOptionIntNative(
        level: Int32,
        option: Int32,
        value: IntNative
    ): Unit {
        holder.use<Unit> {
            socket, _ => socket.setSocketOptionIntNative(level, option, value)
        } ?? SocketException.throwClosedException()
    }

    /*
     * @throws ArithmeticException
     * @throws IllegalSynchronizationStateException
     * @throws IllegalArgumentException
     * @throws IllegalStateException
     * @throws OverflowException
     * @throws SocketException
     */
    func getSocketOptionBool(
        level: Int32,
        option: Int32
    ): Bool {
        getSocketOptionIntNative(level, option) != 0
    }

    /*
     * @throws ArithmeticException
     * @throws IllegalSynchronizationStateException
     * @throws IllegalArgumentException
     * @throws IllegalStateException
     * @throws OverflowException
     * @throws SocketException
     */
    func setSocketOptionBool(
        level: Int32,
        option: Int32,
        value: Bool
    ): Unit {
        setSocketOptionIntNative(level, option, if (value) {
            1
        } else {
            0
        })
    }

    /*
     * @noThrow
     */
    public override func isClosed(): Bool {
        holder.isClosed()
    }

    /*
     * @throws IllegalArgumentException
     * @throws IllegalStateException
     * @throws OverflowException
     */
    public override func close(): Unit {
        holder.close()
    }

    /*
     * @throws ArithmeticException
     * @throws IllegalArgumentException
     * @throws OverflowException
     * @throws IllegalStateException
     * @throws IllegalSynchronizationStateException
     */
    public override func toString(): String {
        var state = match (holder.state.nativeState) {
            case SocketNotCreated => return "unconnected, unbound"
            case SocketPrepared => ""
            case SocketClosing => "closing"
            case SocketDisposed => return "closed"
        }

        var local: ?SocketAddress = None
        var remote: ?SocketAddress = None

        addressLock.readMutex.lock()
        try {
            if (holder.state.bound) {
                local = (localAddress_.directValue |> unwrapOption) ??
                    holder.use<?SocketAddress> {
                    socket, _ => socket.detectLocalAddress()
                } ?? return "closing"
            }
            if (holder.state.connected) {
                remote = (remoteAddress_.directValue |> unwrapOption) ??
                    holder.use<?SocketAddress> {
                    socket, _ => socket.detectRemoteAddress()
                } ?? return "closing"
            }
        } finally {
            addressLock.readMutex.unlock()
        }

        let addressPart = match ((local, remote)) {
            case (Some(local), Some(remote)) => "${local} -> ${remote}"
            case (Some(local), None) => "bound at ${local}"
            case (None, Some(remote)) => "? -> ${remote}"
            case (None, None) => "unconnected, unbound"
        }

        return if (state.isEmpty()) {
            addressPart
        } else {
            state + ", " + addressPart
        }
    }

    /*
     * @throws IllegalMemoryException
     * @throws ArithmeticException
     * @throws IllegalSynchronizationStateException
     * @throws IllegalArgumentException
     * @throws IllegalStateException
     * @throws OverflowException
     * @throws SocketException
     */
    private func applyBindToDevice() {
        if (OS == OS_WINDOWS) {
            return
        }

        unsafe {
            let bindToDevice = bindToDevice_ ?? return ()
            try (s = LibC.mallocCString(bindToDevice).asResource()) {
                if (s.value.isNull()) {
                    throw SocketException("MallocCString failed.")
                }
                setSocketOption(
                    SOL_SOCKET,
                    SOCK_BINDTODEVICE,
                    CPointer(s.value.getChars()),
                    UIntNative(s.value.size())
                )
            }
        }
    }
}


struct ExternallyLockedLazy<T, Arg> {
    private var value: ?T = None
    /*
     * @throws IllegalStateException
     * @throws ArithmeticException
     * @throws IllegalArgumentException
     * @throws IllegalSynchronizationStateException
     */
    mut func compute(lock: NonReentrantReadWriteMutex, arg: Arg, provider: (Arg) -> T): T {
        if (let Some(value) <- tryGet(lock)) {
            return value
        }
        return doCompute(lock, arg, provider)
    }

    mut prop directValue: ?T {
        /*
         * @noThrow
         */
        get() {
            value
        }
        /*
         * @noThrow
         */
        set(newValue) {
            value = newValue
        }
    }

    /*
     * @noThrow
     */
    mut func clearWithoutLock(): Unit {
        value = None
    }

    /*
     * @throws ArithmeticException
     * @throws IllegalArgumentException
     * @throws IllegalSynchronizationStateException
     */
    mut func putValue(lock: NonReentrantReadWriteMutex, value: T): Unit {
        lock.writeMutex.lock()
        this.value = value
        lock.writeMutex.unlock()
    }

    /*
     * @throws ArithmeticException
     * @throws IllegalArgumentException
     * @throws IllegalStateException
     * @throws IllegalSynchronizationStateException
     */
    private func tryGet(lock: NonReentrantReadWriteMutex): ?T {
        lock.readMutex.lock()
        try {
            if (let Some(value) <- value) {
                return value
            }
        } finally {
            lock.readMutex.unlock()
        }
        return None
    }

    /*
     * @throws ArithmeticException
     * @throws IllegalArgumentException
     * @throws IllegalSynchronizationStateException
     */
    private mut func doCompute(lock: NonReentrantReadWriteMutex, arg: Arg, provider: (Arg) -> T): T {
        lock.writeMutex.lock()
        try {
            if (let Some(value) <- value) {
                return value
            }
            let newValue = provider(arg)
            this.value = newValue
            return newValue
        } finally {
            lock.writeMutex.unlock()
        }
    }
}
