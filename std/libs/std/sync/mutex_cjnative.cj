







package std.sync

import std.time.MonoTime









public class Mutex <: UniqueLock {


    public init() {
        var isNull = mutexInit(this)
        if (isNull) {
            throw IllegalSynchronizationStateException("Mutex initialization failure.")
        }
    }



    public func lock(): Unit {
        mutexLock(this)
    }




    public func tryLock(): Bool {
        return mutexTryLock(this)
    }




    public func unlock(): Unit {
        checkMutexStatus()
        mutexUnlock(this)
    }



    public func condition(): Condition {
        checkMutexStatus()
        return MutexCondition(this)
    }


    func checkMutexStatus(): Unit {
        let status = mutexCheckStatus(this)
        if (!status) {
            throw IllegalSynchronizationStateException("Mutex is not locked by current thread.")
        }
    }
}


class MutexCondition <: Condition {
    private let condition: Monitor

    init(mutex: Mutex) {
        condition = Monitor(mutex)
    }



    public func wait(): Unit {
        condition.checkMutexStatus()
        monitorWait(condition, MAX_TIMEOUT_NS)
    }






    public func wait(timeout!: Duration): Bool {
        let timeoutNanos = getTimeoutNanos(timeout)
        condition.checkMutexStatus()
        return monitorWait(condition, timeoutNanos)
    }



    public func waitUntil(predicate: () -> Bool): Unit {
        condition.checkMutexStatus()
        while (!predicate()) {
            monitorWait(condition, MAX_TIMEOUT_NS)
        }
    }



    public func waitUntil(predicate: () -> Bool, timeout!: Duration): Bool {
        let timeoutNanos = getTimeoutNanos(timeout)
        condition.checkMutexStatus()

        let startTime = MonoTime.now()
        var spentTime = 0
        while (!predicate()) {
            if (spentTime >= timeoutNanos) {
                return false
            }

            let success = monitorWait(condition, timeoutNanos - spentTime)
            if (!success) {
                return false
            }
            spentTime = (MonoTime.now() - startTime).toNanoseconds()
        }
        return true
    }



    public func notify(): Unit {
        condition.checkMutexStatus()
        monitorNotify(condition)
    }



    public func notifyAll(): Unit {
        condition.checkMutexStatus()
        monitorNotifyAll(condition)
    }

    func getTimeoutNanos(timeout: Duration): Int64 {
        if (timeout <= Duration.Zero) {
            throw IllegalArgumentException("Timeout cannot be less than or equal to `Duration.Zero`.")
        }
        return match (timeout > MAX_TIMEOUT_DURATION) {
            case true => MAX_TIMEOUT_NS
            case false => timeout.toNanoseconds()
        }
    }
}
