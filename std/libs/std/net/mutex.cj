







package std.net

import std.sync.*









struct NonReentrantReadWriteMutex {
    let readMutex: NonReentrantReadLock
    let writeMutex: NonReentrantWriteLock

    /**
     * @throws IllegalSynchronizationStateException
     */
    init() {
        let m = Monitor()
        let useCounter = AtomicInt64(0)

        this.readMutex = NonReentrantReadLock(m, useCounter)
        this.writeMutex = NonReentrantWriteLock(m, useCounter)
    }
}

struct NonReentrantReadLock <: IReentrantMutex {
    NonReentrantReadLock(
        private let m: Monitor,
        private let useCounter: AtomicInt64
    ) {}

    /**
     * @throws ArithmeticException
     * @throws IllegalArgumentException
     * @throws IllegalSynchronizationStateException
     */
    public override func lock(): Unit {
        if (!tryLock()) {
            lockSlowpath()
        }
    }

    /**
     * @throws ArithmeticException
     * @throws IllegalArgumentException
     * @throws IllegalSynchronizationStateException
     */
    private func lockSlowpath(): Unit {
        synchronized(m) {
            while (!tryLock()) {
                m.wait()
            }
        }
    }

    public override func tryLock(): Bool {
        while (true) {
            let current = useCounter.load()
            if (hasActiveWriter(current)) {
                break
            }
            if (useCounter.compareAndSwap(current, current + 1)) {
                return true
            }
        }

        return false
    }

    /**
     * @throws IllegalStateException
     * @throws IllegalSynchronizationStateException
     */
    public override func unlock(): Unit {
        if (decrementAndGet() == 0) {
            synchronized(m) {
                m.notify()
            }
        }
    }

    /**
     * @throws IllegalStateException
     */
    @OverflowWrapping
    private func decrementAndGet(): Int64 {
        var value: Int64 = 0

        do {
            let before = useCounter.load()
            if (before <= 0) {
                beforeCheckFailed()
            }
            let newValue = before - 1
            if (useCounter.compareAndSwap(before, newValue)) {
                value = newValue
                break
            }
        } while (true)

        return value
    }

    /**
     * @throws IllegalStateException
     */
    private static func beforeCheckFailed(): Nothing {
        throw IllegalStateException("Unbalanced lock-unlock invocations")
    }

    private static func hasActiveWriter(counter: Int64) {
        counter < 0
    }
}

struct NonReentrantWriteLock <: IReentrantMutex {
    NonReentrantWriteLock(
        private let m: Monitor,
        private let useCounter: AtomicInt64
    ) {}

    /**
     * @throws IllegalSynchronizationStateException
     */
    init() {
        this(Monitor(), AtomicInt64(0))
    }

    /**
     * @throws ArithmeticException
     * @throws IllegalArgumentException
     * @throws IllegalSynchronizationStateException
     */
    public override func lock(): Unit {
        if (!tryLock()) {
            lockSlowpath()
        }
    }

    /**
     * @throws ArithmeticException
     * @throws IllegalArgumentException
     * @throws IllegalSynchronizationStateException
     */
    private func lockSlowpath(): Unit {
        synchronized(m) {
            while (!tryLock()) {
                m.wait()
            }
        }
    }

    public override func tryLock(): Bool {
        while (true) {
            let current = useCounter.load()
            if (hasActiveCompetetors(current)) {
                break
            }

            if (useCounter.compareAndSwap(current, WRITER_MARK)) {
                return true
            }
            break
        }

        return false
    }

    /**
     * @throws IllegalSynchronizationStateException
     */
    public override func unlock(): Unit {
        useCounter.compareAndSwap(WRITER_MARK, 0)
        synchronized(m) {
            m.notify()
        }
    }

    private static const WRITER_MARK = -1
    private static func hasActiveCompetetors(count: Int64): Bool {
        count != 0
    }
}
