







package std.net

import std.sync.*

enum InternalHolderState<NS> {
    | NotCreated(() -> NS)
    | Ready(NS)
    | Disposed
}

enum HolderState <: Equatable<HolderState> {
    | SocketNotCreated
    | SocketPrepared
    | SocketClosing
    | SocketDisposed

    public override operator func ==(other: HolderState): Bool {
        match ((this, other)) {
            case (SocketNotCreated, SocketNotCreated) => true
            case (SocketPrepared, SocketPrepared) => true
            case (SocketClosing, SocketClosing) => true
            case (SocketDisposed, SocketDisposed) => true
            case _ => false
        }
    }

    public override operator func !=(other: HolderState): Bool {
        !(this == other)
    }
}



class SocketHolder<NS> <: Resource where NS <: PlatformSocket<NS> {
    private let socketCreationLock = NonReentrantWriteLock()
    private let useCounter = AtomicUInt32(0)
    private var state_: InternalHolderState<NS>

    SocketHolder(create: () -> NS) {
        state_ = NotCreated(create)
    }

    init(acceptedSocket!: NS) {
        state_ = Ready(acceptedSocket)
        useCounter.store(SocketState.JustAccepted.value)
    }

    prop state: SocketState {
        get() {
            SocketState(useCounter.load())
        }
    }

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

    public override func isClosed(): Bool {
        SocketState(useCounter.load()).disposedOrShuttingDown
    }

    public override func close(): Unit {
        tryClose()
    }










    func use<R>(block: (NS, SocketState) -> R): ?R {
        let (socket, state) = startUsingSocket() ?? return None
        try {
            block(socket, state)
        } finally {
            leave()
        }
    }

    @OverflowWrapping
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









    func read<R>(block: (NS, SocketState) -> R): ?R {
        let (socket, state) = startReading() ?? return None
        try {
            block(socket, state)
        } finally {
            leaveRead()
        }
    }

    @OverflowWrapping
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

    private static func throwAlreadyReading(): Nothing {
        throw IllegalStateException("Socket is already reading: concurrent read is not allowed")
    }









    func write<R>(block: (NS, SocketState) -> R): ?R {
        let (socket, state) = startWriting() ?? return None
        try {
            block(socket, state)
        } finally {
            leaveWrite()
        }
    }

    @OverflowWrapping
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

    private static func throwAlreadyWriting(): Nothing {
        throw IllegalStateException("Socket is already writing: concurrent write is not allowed")
    }
    private func ensureSocket(): ?NS {

        return match (state_) {
            case NotCreated(_) => tryCreate()
            case Ready(s) => s
            case Disposed =>
                return None
        }
    }

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

    private static func throwLeaveWithoutEnter(): Nothing {
        throw IllegalStateException("leave() invoked without tryEnterXXX() invocation")
    }

    @OverflowWrapping
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

    private func doShutdown() {

        try {
            if (let Ready(s) <- state_) {
                s.shutdown()
            }
        } finally {
            leave()
        }
    }

    private func dispose() {
        if (let Some(s) <- doStealExclusive()) {
            unsafe { s.dispose() }
        }
    }

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
