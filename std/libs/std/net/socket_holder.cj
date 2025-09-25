







package std.net

import std.sync.*

enum InternalHolderState<NS> {
      /*
       * @noThrow
       */
    | NotCreated(() -> NS)
      /*
       * @noThrow
       */
    | Ready(NS)
    | Disposed
}

enum HolderState <: Equatable<HolderState> {
    | SocketNotCreated
    | SocketPrepared
    | SocketClosing
    | SocketDisposed

    /*
     * @noThrow
     */
    public override operator func ==(other: HolderState): Bool {
        match ((this, other)) {
            case (SocketNotCreated, SocketNotCreated) => true
            case (SocketPrepared, SocketPrepared) => true
            case (SocketClosing, SocketClosing) => true
            case (SocketDisposed, SocketDisposed) => true
            case _ => false
        }
    }

    /*
     * @noThrow
     */
    public override operator func !=(other: HolderState): Bool {
        !(this == other)
    }
}



class SocketHolder<NS> <: Resource where NS <: PlatformSocket<NS> {
    private let socketCreationLock = NonReentrantWriteLock()
    private let useCounter = AtomicUInt32(0)
    private var state_: InternalHolderState<NS>

    /*
     * @noThrow
     */
    SocketHolder(create: () -> NS) {
        state_ = NotCreated(create)
    }

    /*
     * @noThrow
     */
    init(acceptedSocket!: NS) {
        state_ = Ready(acceptedSocket)
        useCounter.store(SocketState.JustAccepted.value)
    }

    prop state: SocketState {
        /*
         * @noThrow
         */
        get() {
            SocketState(useCounter.load())
        }
    }

    /*
     * @throws SocketException
     */
    func markConnected(): Unit {
        while (true) {
            let before = SocketState(useCounter.load())
            if (before.connected) {
                SocketException.alreadyConnected()
            }
            var new = before
            new.connected = true
            if (useCounter.compareAndSwap(before.value, new.value)) {
                break
            }
        }
    }

    /*
     * @throws IllegalArgumentException
     */
    private func markCreated() {
        while (true) {
            let before = SocketState(useCounter.load())
            if (before.nativeState != HolderState.SocketNotCreated) {
                return
            }
            var new = before
            new.nativeState = HolderState.SocketPrepared
            if (useCounter.compareAndSwap(before.value, new.value)) {
                break
            }
        }
    }

    /*
     * @noThrow
     */
    func unmarkConnected() {
        while (true) {
            let before = SocketState(useCounter.load())
            if (!before.connected) {
                break
            }

            var new = before
            new.connected = false
            if (useCounter.compareAndSwap(before.value, new.value)) {
                break
            }
        }
    }

    /*
     * @throws IllegalStateException
     */
    func markBound(): Unit {
        while (true) {
            let before = SocketState(useCounter.load())
            if (before.bound) {
                throw IllegalStateException("Socket was already bound")
            }
            var new = before
            new.bound = true
            if (useCounter.compareAndSwap(before.value, new.value)) {
                break
            }
        }
    }

    /*
     * @noThrow
     */
    func markFailed(): Unit {
        while (true) {
            let before = SocketState(useCounter.load())
            var new = before
            new.failed = true
            if (before.failed || useCounter.compareAndSwap(before.value, new.value)) {
                break
            }
        }
    }

    /*
     * @noThrow
     */
    public override func isClosed(): Bool {
        SocketState(useCounter.load()).disposedOrShuttingDown
    }

    /*
     * @throws IllegalArgumentException
     * @throws IllegalStateException
     * @throws OverflowException
     */
    public override func close(): Unit {
        tryClose()
    }










    /*
     * @throws ArithmeticException
     * @throws IllegalSynchronizationStateException
     * @throws IllegalArgumentException
     * @throws IllegalStateException
     * @throws OverflowException
     */
    func use<R>(block: (NS, SocketState) -> R): ?R {
        let (socket, state) = startUsingSocket() ?? return None
        try {
            block(socket, state)
        } finally {
            leave()
        }
    }

    @OverflowWrapping
    /*
     * @throws ArithmeticException
     * @throws IllegalSynchronizationStateException
     * @throws IllegalArgumentException
     * @throws IllegalStateException
     * @throws OverflowException
     */
    private func startUsingSocket(): ?(NS, SocketState) {
        var state: SocketState

        do {
            let before = SocketState(useCounter.load())
            if (before.disposedOrShuttingDown) {
                return None
            }

            state = before
            state.useCounter++

            if (useCounter.compareAndSwap(before.value, state.value)) {
                break
            }
        } while (true)

        if (let Ready(socket) <- state_) {
            return (socket, state)
        }

        return createSocketUsingSession(state)
    }

    /*
     * @throws ArithmeticException
     * @throws IllegalSynchronizationStateException
     * @throws IllegalArgumentException
     * @throws IllegalStateException
     * @throws OverflowException
     */
    private func createSocketUsingSession(state: SocketState): ?(NS, SocketState) {
        let socket = try {
            ensureSocket()
        } catch (e: Exception) {
            leave()
            throw e
        }

        return match (socket) {
            case Some(socket) => (socket, state)
            case None =>
                leave()
                return None
        }
    }









    /*
     * @throws ArithmeticException
     * @throws IllegalSynchronizationStateException
     * @throws IllegalArgumentException
     * @throws IllegalStateException
     * @throws OverflowException
     */
    func read<R>(block: (NS, SocketState) -> R): ?R {
        let (socket, state) = startReading() ?? return None
        try {
            block(socket, state)
        } finally {
            leaveRead()
        }
    }

    @OverflowWrapping
    /*
     * @throws ArithmeticException
     * @throws IllegalSynchronizationStateException
     * @throws IllegalArgumentException
     * @throws IllegalStateException
     * @throws OverflowException
     */
    private func startReading(): ?(NS, SocketState) {
        var state: SocketState

        do {
            let before = SocketState(useCounter.load())
            if (before.disposedOrShuttingDown) {
                return None
            }
            if (before.hasReaders) {
                throwAlreadyReading()
            }

            state = before
            state.useCounter++
            state.hasReaders = true

            if (useCounter.compareAndSwap(before.value, state.value)) {
                break
            }
        } while (true)

        if (let Ready(socket) <- state_) {
            return (socket, state)
        }

        return createSocketReadSession(state)
    }

    /*
     * @throws ArithmeticException
     * @throws IllegalSynchronizationStateException
     * @throws IllegalArgumentException
     * @throws IllegalStateException
     * @throws OverflowException
     */
    private func createSocketReadSession(state: SocketState): ?(NS, SocketState) {
        let socket = try {
            ensureSocket()
        } catch (e: Exception) {
            leaveRead()
            throw e
        }

        return match (socket) {
            case Some(socket) => (socket, state)
            case None =>
                leaveRead()
                return None
        }
    }

    /*
     * @throws IllegalStateException
     */
    private static func throwAlreadyReading(): Nothing {
        throw IllegalStateException("Socket is already reading: concurrent read is not allowed")
    }









    /*
     * @throws ArithmeticException
     * @throws IllegalSynchronizationStateException
     * @throws IllegalArgumentException
     * @throws IllegalStateException
     * @throws OverflowException
     */
    func write<R>(block: (NS, SocketState) -> R): ?R {
        let (socket, state) = startWriting() ?? return None
        try {
            block(socket, state)
        } finally {
            leaveWrite()
        }
    }

    @OverflowWrapping
    /*
     * @throws ArithmeticException
     * @throws IllegalSynchronizationStateException
     * @throws IllegalArgumentException
     * @throws IllegalStateException
     * @throws OverflowException
     */
    private func startWriting(): ?(NS, SocketState) {
        var state: SocketState

        do {
            let before = SocketState(useCounter.load())
            if (before.disposedOrShuttingDown) {
                return None
            }
            if (before.hasWriters) {
                throwAlreadyWriting()
            }

            state = before
            state.useCounter++
            state.hasWriters = true

            if (useCounter.compareAndSwap(before.value, state.value)) {
                break
            }
        } while (true)

        if (let Ready(socket) <- state_) {
            return (socket, state)
        }

        return createSocketWriteSession(state)
    }

    /*
     * @throws ArithmeticException
     * @throws IllegalSynchronizationStateException
     * @throws IllegalArgumentException
     * @throws IllegalStateException
     * @throws OverflowException
     */
    private func createSocketWriteSession(state: SocketState): ?(NS, SocketState) {
        let socket = try {
            ensureSocket()
        } catch (e: Exception) {
            leaveWrite()
            throw e
        }

        return match (socket) {
            case Some(socket) => (socket, state)
            case None =>
                leaveWrite()
                return None
        }
    }

    /*
     * @throws IllegalStateException
     */
    private static func throwAlreadyWriting(): Nothing {
        throw IllegalStateException("Socket is already writing: concurrent write is not allowed")
    }
    /*
     * @throws ArithmeticException
     * @throws IllegalSynchronizationStateException
     * @throws IllegalArgumentException
     */
    private func ensureSocket(): ?NS {

        return match (state_) {
            case NotCreated(_) => tryCreate()
            case Ready(s) => s
            case Disposed =>
                return None
        }
    }

    /*
     * @throws ArithmeticException
     * @throws IllegalSynchronizationStateException
     * @throws IllegalArgumentException
     */
    private func tryCreate(): ?NS {
        socketCreationLock.lock()
        try {
            match (state_) {
                case NotCreated(create) =>
                    let s: NS = create()
                    if (state.disposedOrShuttingDown) {
                        state_ = Disposed
                        unsafe { s.dispose() }
                        return None
                    }

                    state_ = Ready(s)
                    markCreated()
                    return s
                case Ready(s) => return s
                case Disposed =>
                    return None
            }
        } finally {
            socketCreationLock.unlock()
        }
    }

    @OverflowWrapping
    /*
     * @throws IllegalStateException
     * @throws OverflowException
     */
    private func leaveRead(): Unit {
        var doDispose: Bool = false

        while (true) {
            let before = SocketState(useCounter.load())
            if (before.useCounter == 0) {
                throwLeaveWithoutEnter()
            }

            var new: SocketState
            if (before.disposedOrShuttingDown && before.useCounter == 1) {
                doDispose = true
                new = SocketState.Terminal
            } else {
                doDispose = false
                new = before
                new.useCounter--
                new.hasReaders = false
            }

            if (useCounter.compareAndSwap(before.value, new.value)) {
                break
            }
        }

        if (doDispose) {
            dispose()
        }
    }
    @OverflowWrapping
    /*
     * @throws IllegalStateException
     * @throws OverflowException
     */
    private func leaveWrite(): Unit {
        var doDispose: Bool = false

        while (true) {
            let before = SocketState(useCounter.load())
            if (before.useCounter == 0) {
                throwLeaveWithoutEnter()
            }

            var new: SocketState
            if (before.disposedOrShuttingDown && before.useCounter == 1) {
                doDispose = true
                new = SocketState.Terminal
            } else {
                doDispose = false
                new = before
                new.useCounter--
                new.hasWriters = false
            }

            if (useCounter.compareAndSwap(before.value, new.value)) {
                break
            }
        }

        if (doDispose) {
            dispose()
        }
    }

    @OverflowWrapping
    /*
     * @throws IllegalStateException
     * @throws OverflowException
     */
    private func leave(): Unit {
        var doDispose: Bool = false

        while (true) {
            let before = SocketState(useCounter.load())
            if (before.useCounter == 0) {
                throwLeaveWithoutEnter()
            }

            var new: SocketState
            if (before.disposedOrShuttingDown && before.useCounter == 1) {
                doDispose = true
                new = SocketState.Terminal
            } else {
                doDispose = false
                new = before
                new.useCounter--
            }

            if (useCounter.compareAndSwap(before.value, new.value)) {
                break
            }
        }

        if (doDispose) {
            dispose()
        }
    }

    /*
     * @throws IllegalStateException
     */
    private static func throwLeaveWithoutEnter(): Nothing {
        throw IllegalStateException("leave() invoked without tryEnterXXX() invocation")
    }

    @OverflowWrapping
    /*
     * @throws IllegalArgumentException
     * @throws IllegalStateException
     * @throws OverflowException
     */
    private func tryClose(): Unit {
        var terminated = false

        while (true) {
            let before = SocketState(useCounter.load())
            if (before.disposedOrShuttingDown) {
                return
            }

            var new: SocketState
            if (before.useCounter == 0) {
                terminated = true
                new = SocketState.Terminal
            } else {
                terminated = false
                new = before
                new.nativeState = SocketClosing
                new.useCounter++
            }

            if (useCounter.compareAndSwap(before.value, new.value)) {
                break
            }
        }

        if (terminated) {
            dispose()
        } else {
            doShutdown()
        }
    }

    /*
     * @throws IllegalStateException
     * @throws OverflowException
     */
    private func doShutdown() {

        try {
            if (let Ready(s) <- state_) {
                s.shutdown()
            }
        } finally {
            leave()
        }
    }

    /*
     * @noThrow
     */
    private func dispose() {
        if (let Some(s) <- doStealExclusive()) {
            unsafe { s.dispose() }
        }
    }

    /*
     * @noThrow
     */
    private func doStealExclusive(): ?NS {
        match (state_) {
            case Ready(s) =>
                this.state_ = Disposed
                s
            case NotCreated(_) =>
                this.state_ = Disposed
                None
            case Disposed => None
        }
    }
}
