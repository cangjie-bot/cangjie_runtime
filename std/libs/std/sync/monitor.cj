







package std.sync


@Deprecated[message: "Use `public interface Condition` instead."]
public class Monitor <: ReentrantMutex {
    public init() {
        var isNull = unsafe { monitorInit(this) }
        if (isNull) {
            throw IllegalSynchronizationStateException("Initialization failed.")
        }
    }

    init(mutex: Mutex) {
        super(mutex)
        let isNull = unsafe { monitorInit(this) }
        if (isNull) {
            throw IllegalSynchronizationStateException("Initialization failed.")
        }
    }






    public func wait(timeout!: Duration = Duration.Max): Bool {
        checkMutexStatus()
        if (timeout <= Duration.Zero) {
            throw IllegalArgumentException("Timeout cannot be less than or equal to `Duration.Zero`.")
        }
        let timeoutNanos = if (timeout > MAX_TIMEOUT_DURATION) {
            MAX_TIMEOUT_NS
        } else {
            timeout.toNanoseconds()
        }
        return unsafe { monitorWait(this, timeoutNanos) }
    }



    public func notify(): Unit {
        checkMutexStatus()
        unsafe { monitorNotify(this) }
    }



    public func notifyAll(): Unit {
        checkMutexStatus()
        unsafe { monitorNotifyAll(this) }
    }
}



@Deprecated[message: "Use `public interface Condition` instead."]
public struct ConditionID {
    init(m: MultiConditionMonitor, wqPtr: WaitQueue) {
        monitor = m
        waitQueue = wqPtr
    }

    let monitor: MultiConditionMonitor
    let waitQueue: WaitQueue
}

class WaitQueue {
    init() {
        var isNull = unsafe { waitQueueInit(this) }
        if (isNull) {
            throw IllegalSynchronizationStateException("Initialization failed.")
        }
    }
}


@Deprecated[message: "Use `public class Mutex` instead."]
public class MultiConditionMonitor <: ReentrantMutex {
    public init() {}



    public func newCondition(): ConditionID {
        checkMutexStatus()
        let waitQueue = WaitQueue()
        return ConditionID(this, waitQueue)
    }







    public func wait(condID: ConditionID, timeout!: Duration = Duration.Max): Bool {
        if (!refEq(this, condID.monitor)) {
            throw IllegalSynchronizationStateException("Invalid condition.")
        }
        checkMutexStatus()
        if (timeout <= Duration.Zero) {
            throw IllegalArgumentException("Timeout cannot be less than or equal to `Duration.Zero`.")
        }
        let timeoutNanos = if (timeout > MAX_TIMEOUT_DURATION) {
            MAX_TIMEOUT_NS
        } else {
            timeout.toNanoseconds()
        }
        return unsafe { multiConditionMonitorWait(this, condID.waitQueue, timeoutNanos) }
    }




    public func notify(condID: ConditionID): Unit {
        if (!refEq(this, condID.monitor)) {
            throw IllegalSynchronizationStateException("Invalid condition.")
        }
        checkMutexStatus()
        unsafe {
            multiConditionMonitorNotify(this, condID.waitQueue)
        }
    }




    public func notifyAll(condID: ConditionID): Unit {
        if (!refEq(this, condID.monitor)) {
            throw IllegalSynchronizationStateException("Invalid condition.")
        }
        checkMutexStatus()
        unsafe {
            multiConditionMonitorNotifyAll(this, condID.waitQueue)
        }
    }
}
