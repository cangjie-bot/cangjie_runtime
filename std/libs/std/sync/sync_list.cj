







package std.sync

import std.time.DateTime

const MAX_TIMEOUT_NS: Int64 = 0x7FFF_FFFF_FFFF_FFFF
let MAX_TIMEOUT_DURATION: Duration = Duration.nanosecond * MAX_TIMEOUT_NS

class NotifyOnce {
    let m = Monitor()
    var notified: Bool = false

    /**
     * @throws IllegalSynchronizationStateException
     */
    func notify(): Unit {
        synchronized(m) {
            if (!notified) {
                notified = true
                m.notify()
            }
        }
    }

    /**
     * @throws IllegalArgumentException
     * @throws ArithmeticException
     * @throws IllegalSynchronizationStateException
     */
    func wait(timeout!: Duration = Duration.Max): Bool {
        if (timeout >= MAX_TIMEOUT_DURATION) {
            waitWithoutTimeout()
        } else {
            waitWithTimeout(timeout)
        }
        return notified
    }

    /**
     * @throws ArithmeticException
     * @throws IllegalArgumentException
     * @throws IllegalSynchronizationStateException
     */
    private func waitWithoutTimeout(): Unit {
        synchronized(m) {
            while (!notified) {
                m.wait()
            }
        }
    }

    /**
     * @throws IllegalArgumentException
     * @throws ArithmeticException
     * @throws IllegalSynchronizationStateException
     */
    private func waitWithTimeout(timeout: Duration): Unit {
        var restOfTimeout = timeout
        synchronized(m) {
            while (!notified && restOfTimeout > Duration.Zero) {
                let startTime = DateTime.nowUTC()
                m.wait(timeout: timeout)
                let endTime = DateTime.nowUTC()
                restOfTimeout -= (endTime - startTime)
            }
        }
    }
}
class SyncNode {
    let n = NotifyOnce()
    var next: ?SyncNode = None
}
class SyncList {
    private var head: ?SyncNode = None
    private let m = Monitor()

    private func addWaiter(node: SyncNode) {
        node.next = head
        head = node
    }

    /**
     * @throws IllegalArgumentException
     * @throws ArithmeticException
     * @throws IllegalSynchronizationStateException
     */
    func waitIf(pred: () -> Bool, timeout!: Duration = Duration.Max): Unit {
        if (!pred()) {
            return
        }
        let node = SyncNode()
        synchronized(m) {
            if (!pred()) {
                return
            }
            addWaiter(node)
        }
        node.n.wait(timeout: timeout)
    }

    /**
     * @throws IllegalArgumentException
     * @throws ArithmeticException
     * @throws IllegalSynchronizationStateException
     */
    func waitInLock(unlock: () -> Unit, timeout!: Duration = Duration.Max): Bool {
        let node = SyncNode()
        synchronized(m) {
            addWaiter(node)
        }
        unlock()
        node.n.wait(timeout: timeout)
    }
    /**
     * @throws IllegalSynchronizationStateException
     */
    func notifyOne(): Bool {
        synchronized(m) {
            if (let Some(current) <- head) {
                head = current.next
                current.n.notify()
                return true
            }
            return false
        }
    }
    /**
     * @throws IllegalSynchronizationStateException
     */
    func notifyAll(): Bool {
        synchronized(m) {
            if (let None <- head) {
                return false
            }
            while (let Some(current) <- head) {
                head = current.next
                current.n.notify()
            }
            return true
        }
    }
}
