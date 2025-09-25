







package std.net

interface PlatformSocket<Self> where Self <: PlatformSocket<Self> {
    func write(buffer: Array<Byte>, timeout: ?Duration): Unit

    func read(buffer: Array<UInt8>, timeout: ?Duration): ?Int64

    func send(buffer: Array<Byte>, timeout: ?Duration, destination: SocketAddress): Int64

    func receiveFrom(buffer: Array<UInt8>, timeout: ?Duration): ?(SocketAddress, Int64)



    func connect(localAddress: ?SocketAddress, address: SocketAddress, timeout: ?Duration): Unit

    func disconnect(): Unit

    func bindListen(address: SocketAddress, backlogSize: ?Int32, ignoreAlreadyBound!: Bool): Unit

    func accept(timeout: ?Duration): ?Self

    func shutdown(): Unit

    func detectLocalAddress(): ?SocketAddress

    func detectRemoteAddress(): ?SocketAddress

    unsafe func getSocketOption(
        level: Int32,
        option: Int32,
        value: CPointer<Unit>,
        valueLength: CPointer<UIntNative>
    ): Unit

    unsafe func setSocketOption(
        level: Int32,
        option: Int32,
        value: CPointer<Unit>,
        valueLength: UIntNative
    ): Unit

    func getSocketOptionIntNative(
        level: Int32,
        option: Int32
    ): IntNative

    func setSocketOptionIntNative(
        level: Int32,
        option: Int32,
        value: IntNative
    ): Unit

    func setKeepAlive(config: ?SocketKeepAliveConfig): Bool







    unsafe func dispose(): Unit

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

    private SocketCommon(
        private let holder: SocketHolder<NS>,
        let kind: AddressFamily
    ) {}

    private init(
        create: () -> NS,
        kind: AddressFamily
    ) {
        this(SocketHolder<NS>(create), kind)
    }

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

    private init(
        existing: NS,
        kind: AddressFamily
    ) {
        this(SocketHolder<NS>(acceptedSocket: existing), kind)
    }



    mut prop localAddress: ?SocketAddress {
        get() {
            checkNotClosed()
            localAddress_.compute(addressLock, holder, lazyLocalAddress)
        }
        set(newAddress) {
            checkNotClosed()
            checkNotBound()
            localAddress_.putValue(addressLock, newAddress)
        }
    }

    private static func lazyLocalAddress(holder: SocketHolder<NS>): ?SocketAddress {
        holder.use<?SocketAddress> {
            socket, state =>
            state.ensureBound()
            socket.detectLocalAddress()
        } ?? SocketException.throwClosedException()
    }



    mut prop remoteAddress: ?SocketAddress {
        get() {
            checkNotClosed()
            remoteAddress_.compute(addressLock, holder, lazyRemoteAddress)
        }
        set(newAddress) {
            checkNotClosed()
            checkNotConnected()
            remoteAddress_.putValue(addressLock, newAddress)
        }
    }

    private static func lazyRemoteAddress(holder: SocketHolder<NS>): ?SocketAddress {
        holder.use<?SocketAddress> {
            socket, state =>
            state.ensureConnected()
            socket.detectRemoteAddress()
        } ?? SocketException.throwClosedException()
    }

    mut prop bindToDevice: ?String {
        get() {
            checkNotClosed()
            bindToDevice_
        }
        set(newDevice) {
            checkNotClosed()
            checkNotBound()
            bindToDevice_ = newDevice
        }
    }

    prop isBound: Bool {
        get() {
            holder.state.bound
        }
    }

    prop isConnected: Bool {
        get() {
            holder.state.connected
        }
    }
    func checkNotClosed() {
        holder.state.ensureNotClosed()
    }

    func checkNotBound() {
        holder.state.ensureNotBound()
    }

    func checkNotConnected() {
        holder.state.ensureNotConnected()
    }

    mut prop readTimeout: ?Duration {
        get() {
            checkNotClosed()
            readTimeout_
        }
        set(newTimeout) {
            checkNotClosed()
            readTimeout_ = newTimeout
        }
    }

    mut prop writeTimeout: ?Duration {
        get() {
            checkNotClosed()
            writeTimeout_
        }
        set(newTimeout) {
            checkNotClosed()
            writeTimeout_ = newTimeout
        }
    }

    mut prop keepAlive: ?SocketKeepAliveConfig {
        get() {
            checkNotClosed()
            keepAlive_
        }
        set(newValue) {
            holder.use<Unit> {
                socket, _ => if (socket.setKeepAlive(newValue)) {
                    keepAlive_ = newValue
                }
            } ?? SocketException.throwClosedException()
        }
    }

    func write(payload: Array<Byte>): Unit {
        holder.write<Unit> {
            socket, state =>
            state.ensureConnected()
            socket.write(payload, writeTimeout_)
        } ?? SocketException.throwClosedException()
    }

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

    private static func emptyBufferException(): Nothing {
        throw IllegalArgumentException("Buffer shouldn't be empty")
    }

    func send(payload: Array<Byte>, destination: SocketAddress): Int64 {
        return holder.write<Int64> {
            socket, state =>
            state.ensureBound()
            socket.send(payload, writeTimeout_, destination)
        } ?? SocketException.throwClosedException()
    }

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

    private func restoreLocalAddress(socket: NS, before: SocketAddress) {
        if (before.family == AddressFamily.UNIX) {
            return
        }

        localAddress_.directValue = before
        bindImpl(socket, None, bindRequired: true, ignoreAlreadyBound: true)
        localAddress_.directValue = None
    }

    private func populateLocalAddressUnderLock(socket: NS): ?SocketAddress {
        try {
            let address = socket.detectLocalAddress()
            localAddress_.directValue = address
            return address
        } catch (_) {
            return None
        }
    }

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

    func getSocketOptionIntNative(
        level: Int32,
        option: Int32
    ): IntNative {
        holder.use<IntNative> {
            socket, _ => socket.getSocketOptionIntNative(level, option)
        } ?? SocketException.throwClosedException()
    }

    func setSocketOptionIntNative(
        level: Int32,
        option: Int32,
        value: IntNative
    ): Unit {
        holder.use<Unit> {
            socket, _ => socket.setSocketOptionIntNative(level, option, value)
        } ?? SocketException.throwClosedException()
    }

    func getSocketOptionBool(
        level: Int32,
        option: Int32
    ): Bool {
        getSocketOptionIntNative(level, option) != 0
    }

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

    public override func isClosed(): Bool {
        holder.isClosed()
    }

    public override func close(): Unit {
        holder.close()
    }

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
    mut func compute(lock: NonReentrantReadWriteMutex, arg: Arg, provider: (Arg) -> T): T {
        if (let Some(value) <- tryGet(lock)) {
            return value
        }
        return doCompute(lock, arg, provider)
    }

    mut prop directValue: ?T {
        get() {
            value
        }
        set(newValue) {
            value = newValue
        }
    }

    mut func clearWithoutLock(): Unit {
        value = None
    }

    mut func putValue(lock: NonReentrantReadWriteMutex, value: T): Unit {
        lock.writeMutex.lock()
        this.value = value
        lock.writeMutex.unlock()
    }

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
