







package std.collection.concurrent

import std.sync.*
import std.time.*

@Deprecated[message: "Use LinkedBlockingQueue instead."]
public type BlockingQueue<E> = LinkedBlockingQueue<E>


public class LinkedBlockingQueue<E> {
    public let capacity: Int64
    private let sendMonitor = Monitor()
    private let receiveMonitor = Monitor()
    private let sendQSize = AtomicInt64(0)
    private let receiveQSize = AtomicInt64(0)
    private let front: AtomicReference<Block<E>>
    private let rear: AtomicReference<Block<E>>

    /**
     * @throws IllegalArgumentException
     */
    public init(capacity: Int64) {
        if (capacity <= 0) {
            throw IllegalArgumentException("Invalid size of BlockingQueue: ${capacity}.")
        }

        this.capacity = capacity
        let block = Block<E>(0)
        front = AtomicReference<Block<E>>(block)
        rear = AtomicReference<Block<E>>(block)
    }

    /**
     * @throws IllegalArgumentException
     */
    public init() {
        this(0x7FFF_FFFF_FFFF_FFFF)
    }

    /**
     * @throws IndexOutOfBoundsException
     * @throws IllegalSynchronizationStateException
     * @throws IllegalArgumentException
     */
    @Deprecated[message: "Use the other version of `init` instead."]
    public init(capacity: Int64, elements: Array<E>) {
        if (capacity <= 0) {
            throw IllegalArgumentException("Invalid size of BlockingQueue: ${capacity}.")
        }

        if (capacity < elements.size) {
            throw IllegalArgumentException("Size of BlockingQueue should be equal or greater than ${elements.size}.")
        }

        this.capacity = capacity
        let block = Block<E>(0)
        front = AtomicReference<Block<E>>(block)
        rear = AtomicReference<Block<E>>(block)

        for (e in elements) {
            tryEnqueue(e)
        }
    }

    /**
     * @throws IndexOutOfBoundsException
     * @throws IllegalSynchronizationStateException
     * @throws IllegalArgumentException
     */
    @Deprecated[message: "Use the other version of `init` instead."]
    public init(capacity: Int64, elements: Collection<E>) {
        if (capacity <= 0) {
            throw IllegalArgumentException("Invalid size of BlockingQueue: ${capacity}.")
        }

        if (capacity < elements.size) {
            throw IllegalArgumentException("Size of BlockingQueue should be equal or greater than ${elements.size}.")
        }

        this.capacity = capacity
        let block = Block<E>(0)
        front = AtomicReference<Block<E>>(block)
        rear = AtomicReference<Block<E>>(block)

        for (e in elements) {
            tryEnqueue(e)
        }
    }







    public prop size: Int64 {
        get() {
            let headBlock = front.load()
            let tailBlock = rear.load()
            let (headBlockVersion, headBlockReserved) = headBlock.getReserved()
            let (tailBlockVersion, tailBlockAllocated) = tailBlock.getAllocated()
            return (tailBlockAllocated - headBlockReserved) + (Int64(tailBlockVersion - headBlockVersion) << BUF_SIZE_BITS)
        }
    }








    /**
     * @throws IndexOutOfBoundsException
     * @throws IllegalSynchronizationStateException
     * @throws ArithmeticException
     * @throws IllegalArgumentException
     */
    @Deprecated[message: "Use member function `public func add(element: E): Unit` instead."]
    public func enqueue(element: E): Unit {
        add(element)
    }

    /**
     * @throws IndexOutOfBoundsException
     * @throws IllegalSynchronizationStateException
     * @throws ArithmeticException
     * @throws IllegalArgumentException
     */
    public func add(element: E): Unit {
        while (true) {
            if (tryAdd(element)) {
                return
            }

            receiveMonitor.lock()
            sendQSize.fetchAdd(1)
            if (isFull()) {
                receiveMonitor.wait()
            }
            sendQSize.fetchSub(1)
            receiveMonitor.unlock()
        }
    }










    /**
     * @throws IndexOutOfBoundsException
     * @throws IllegalSynchronizationStateException
     * @throws IllegalArgumentException
     * @throws ArithmeticException
     */
    @Deprecated[message: "Use member function `public func add(element: E, timeout: Duration): Bool` instead."]
    public func enqueue(element: E, timeout: Duration): Bool {
        add(element, timeout)
    }

    /**
     * @throws IndexOutOfBoundsException
     * @throws IllegalSynchronizationStateException
     * @throws IllegalArgumentException
     * @throws ArithmeticException
     */
    public func add(element: E, timeout: Duration): Bool {
        var total = timeout
        while (true) {
            if (tryAdd(element)) {
                return true
            }
            receiveMonitor.lock()
            let startTime = MonoTime.now()
            if (total <= Duration.Zero) {
                receiveMonitor.unlock()
                break
            }
            sendQSize.fetchAdd(1)
            receiveMonitor.wait(timeout: total)
            sendQSize.fetchSub(1)
            let endTime = MonoTime.now()
            total -= endTime - startTime
            receiveMonitor.unlock()
        }
        return false
    }









    /**
     * @throws IndexOutOfBoundsException
     * @throws ArithmeticException
     * @throws IllegalArgumentException
     * @throws IllegalSynchronizationStateException
     * @throws Exception
     */
    @Deprecated[message: "Use member function `public func remove(): E` instead."]
    public func dequeue(): E {
        remove()
    }

    /**
     * @throws IndexOutOfBoundsException
     * @throws ArithmeticException
     * @throws IllegalArgumentException
     * @throws IllegalSynchronizationStateException
     * @throws Exception
     */
    public func remove(): E {
        while (true) {
            if (let Some(e) <- tryRemove()) {
                return e
            }

            sendMonitor.lock()
            receiveQSize.fetchAdd(1)
            if (size == 0) {
                sendMonitor.wait()
            }
            receiveQSize.fetchSub(1)
            sendMonitor.unlock()
        }
        throw Exception("Unreachable code.")
    }









    /**
     * @throws IndexOutOfBoundsException
     * @throws IllegalSynchronizationStateException
     * @throws IllegalArgumentException
     * @throws ArithmeticException
     */
    @Deprecated[message: "Use member function `public func remove(timeout: Duration): Option<E>` instead."]
    public func dequeue(timeout: Duration): Option<E> {
        remove(timeout)
    }

    /**
     * @throws IndexOutOfBoundsException
     * @throws IllegalSynchronizationStateException
     * @throws IllegalArgumentException
     * @throws ArithmeticException
     */
    public func remove(timeout: Duration): Option<E> {
        var total = timeout
        while (true) {
            if (let Some(e) <- tryRemove()) {
                return Some(e)
            }
            sendMonitor.lock()
            let startTime = MonoTime.now()
            if (total <= Duration.Zero) {
                sendMonitor.unlock()
                break
            }
            receiveQSize.fetchAdd(1)
            sendMonitor.wait(timeout: total)
            receiveQSize.fetchSub(1)
            let endTime = MonoTime.now()
            total -= endTime - startTime
            sendMonitor.unlock()
        }
        return None<E>
    }







    /**
     * @throws IndexOutOfBoundsException
     */
    @Deprecated[message: "Use member function `public func peek(): Option<E>` instead."]
    public func head(): Option<E> {
        peek()
    }

    /**
     * @throws IndexOutOfBoundsException
     */
    public func peek(): Option<E> {
        while (true) {
            let headBlock = front.load()
            match (headBlock.front()) {
                case ELEM(e) => return Some(e)
                case NoEntry => break
                case BlockDone =>
                    if (!nextBlock<E>(headBlock, front, rear)) {
                        break
                    }
            }
        }
        return None<E>
    }









    /**
     * @throws IndexOutOfBoundsException
     * @throws IllegalSynchronizationStateException
     */
    @Deprecated[message: "Use member function `public func tryAdd(element: E): Bool` instead."]
    public func tryEnqueue(element: E): Bool {
        tryAdd(element)
    }

    /**
     * @throws IndexOutOfBoundsException
     * @throws IllegalSynchronizationStateException
     */
    public func tryAdd(element: E): Bool {
        while (true) {
            let tailBlock = rear.load()
            let headBlock = front.load()
            let (tailBlockVersion, tailBlockAllocated) = tailBlock.getAllocated()
            let (headBlockVersion, headBlockReserved) = headBlock.getReserved()

            if (tailBlockVersion < headBlockVersion) {
                continue
            }
            if (isFull(tailBlockVersion, tailBlockAllocated, headBlockVersion, headBlockReserved)) {
                return false
            }
            match (tailBlock.pushAt(element, tailBlockAllocated)) {
                case SUCCEED => break
                case BlockDone => newBlock<E>(tailBlock, rear)
                case CONFLICT => ()
            }
        }
        if (receiveQSize.load() > 0) {
            sendMonitor.lock()
            sendMonitor.notify()
            sendMonitor.unlock()
        }
        return true
    }







    /**
     * @throws IndexOutOfBoundsException
     * @throws IllegalSynchronizationStateException
     */
    @Deprecated[message: "Use member function `public func tryRemove(): Option<E>` instead."]
    public func tryDequeue(): Option<E> {
        tryRemove()
    }

    /**
     * @throws IndexOutOfBoundsException
     * @throws IllegalSynchronizationStateException
     */
    public func tryRemove(): Option<E> {
        while (true) {
            let headBlock = front.load()
            match (headBlock.pop()) {
                case BlockDone =>
                    if (!nextBlock<E>(headBlock, front, rear)) {
                        return None<E>
                    }
                case NoEntry => break
                case ELEM(e) =>
                    if (sendQSize.load() > 0) {
                        receiveMonitor.lock()
                        receiveMonitor.notify()
                        receiveMonitor.unlock()
                    }
                    return Some(e)
            }
        }
        return None<E>
    }

    private func isFull(
        tailVersion: UInt64,
        tailAllocated: Int64,
        headVersion: UInt64,
        headReserved: Int64
    ): Bool {
        return (tailAllocated - headReserved) + Int64((tailVersion - headVersion) << BUF_SIZE_BITS) >= capacity
    }

    private func isFull(): Bool {
        let tailBlock = rear.load()
        let headBlock = front.load()
        let (tailBlockVersion, tailBlockAllocated) = tailBlock.getAllocated()
        let (headBlockVersion, headBlockReserved) = headBlock.getReserved()
        return isFull(tailBlockVersion, tailBlockAllocated, headBlockVersion, headBlockReserved)
    }
}
