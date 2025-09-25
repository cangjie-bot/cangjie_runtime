







package std.collection.concurrent

import std.sync.*
import std.collection.ArrayList





enum ENTRY<E> {
    | BlockDone
    | NoEntry
      /*
       * @noThrow
       */
    | ELEM(E)
}





enum PushRes {
    | BlockDone
    | CONFLICT
    | SUCCEED
}

const BUF_SIZE_BITS = 7
const BUF_SIZE: Int64 = 1 << BUF_SIZE_BITS


class Block<E> {
    let version: UInt64

    let isExtended = AtomicBool(false)
    let next = AtomicOptionReference<Block<E>>(None)
    private let allocated = AtomicInt64(0)
    let committed = AtomicInt64(0)
    let reserved = AtomicInt64(0)
    let buffer = unsafe { Array<E>(BUF_SIZE, repeat: zeroValue<E>()) }

    /*
     * @noThrow
     */
    init(version: UInt64) {
        this.version = version
    }








    /*
     * @throws IndexOutOfBoundsException
     */
    func push(element: E): Bool {
        if (allocated.load() >= BUF_SIZE) {
            return false
        }

        let index = allocated.fetchAdd(1)
        if (index >= BUF_SIZE) {
            return false
        }

        buffer[index] = element
        committed.fetchAdd(1)

        return true
    }










    /*
     * @throws IndexOutOfBoundsException
     */
    func pushAt(element: E, index: Int64): PushRes {
        if (index >= BUF_SIZE) {
            return BlockDone
        }
        if (!allocated.compareAndSwap(index, index + 1)) {
            return CONFLICT
        }

        buffer[index] = element
        committed.fetchAdd(1)

        return SUCCEED
    }







    /*
     * @throws IndexOutOfBoundsException
     */
    func pop(): ENTRY<E> {
        while (true) {
            let index = reserved.load()
            if (index >= BUF_SIZE) {
                return BlockDone
            }

            let currentCommitted = committed.load()
            if (currentCommitted != BUF_SIZE) {
                if (currentCommitted != allocated.load()) {
                    continue
                }
            }
            if (index == currentCommitted) {
                return NoEntry
            }
            if (reserved.compareAndSwap(index, index + 1)) {
                let elem = ELEM(buffer[index])
                buffer[index] = unsafe { zeroValue<E>() }
                return elem
            }
        }

        return BlockDone
    }







    /*
     * @throws IndexOutOfBoundsException
     */
    func front(): ENTRY<E> {
        while (true) {
            let index = reserved.load()
            if (index >= BUF_SIZE) {
                return BlockDone
            }

            let currentCommitted = committed.load()
            if (currentCommitted != BUF_SIZE) {
                if (currentCommitted != allocated.load()) {
                    continue
                }
            }
            if (index == currentCommitted) {
                return NoEntry
            }
            return ELEM(buffer[index])
        }

        return BlockDone
    }

    /*
     * @noThrow
     */
    func getAllocated(): (UInt64, Int64) {
        return (version, allocated.load())
    }

    /*
     * @noThrow
     */
    func getReserved(): (UInt64, Int64) {
        return (version, reserved.load())
    }
}

@Deprecated[message: "Use ConcurrentLinkedQueue instead."]
public type NonBlockingQueue<E> = ConcurrentLinkedQueue<E>


public class ConcurrentLinkedQueue<E> <: Collection<E> {
    private let front: AtomicReference<Block<E>>
    private let rear: AtomicReference<Block<E>>


    /*
     * @noThrow
     */
    public init() {
        let block = Block<E>(0)
        front = AtomicReference<Block<E>>(block)
        rear = AtomicReference<Block<E>>(block)
    }


    @Deprecated[message: "Use the other version of `init` instead."]
    /*
     * @throws IndexOutOfBoundsException
     */
    public init(elements: Collection<E>) {
        this()
        for (element in elements) {
            enqueue(element)
        }
    }







    public prop size: Int64 {
        /*
         * @noThrow
         */
        get() {
            let headBlock = front.load()
            let tailBlock = rear.load()
            let (headBlockVersion, headBlockReserved) = headBlock.getReserved()
            let (tailBlockVersion, tailBlockAllocated) = tailBlock.getAllocated()
            return (tailBlockAllocated - headBlockReserved) + (Int64(tailBlockVersion - headBlockVersion) <<
                BUF_SIZE_BITS)
        }
    }









    @Deprecated[message: "Use member function `func addIfAbsent(key: K, value: V): ?V` instead."]
    /*
     * @throws IndexOutOfBoundsException
     */
    public func enqueue(element: E): Bool {
        add(element)
    }

    /*
     * @throws IndexOutOfBoundsException
     */
    public func add(element: E): Bool {
        while (true) {
            let tailBlock = rear.load()
            if (tailBlock.push(element)) {
                return true
            }
            newBlock(tailBlock, rear)
        }
        return false
    }






    @Deprecated[message: "Use member function `public func remove(): Option<E>` instead."]
    /*
     * @throws IndexOutOfBoundsException
     */
    public func dequeue(): Option<E> {
        remove()
    }

    /*
     * @throws IndexOutOfBoundsException
     */
    public func remove(): Option<E> {
        while (true) {
            let headBlock = front.load()
            match (headBlock.pop()) {
                case BlockDone =>
                    if (!nextBlock(headBlock, front, rear)) {
                        return None
                    }
                case NoEntry => break
                case ELEM(e) => return Some(e)
            }
        }
        return None
    }








    @Deprecated[message: "Use member function `public func peek(): Option<E>` instead."]
    /*
     * @throws IndexOutOfBoundsException
     */
    public func head(): Option<E> {
        peek()
    }

    /*
     * @throws IndexOutOfBoundsException
     */
    public func peek(): Option<E> {
        while (true) {
            let headBlock = front.load()
            match (headBlock.front()) {
                case ELEM(e) => return Some(e)
                case NoEntry => break
                case BlockDone =>
                    if (!nextBlock(headBlock, front, rear)) {
                        break
                    }
            }
        }
        return None<E>
    }

    /*
     * @throws IndexOutOfBoundsException
     */
    public func isEmpty(): Bool {
        peek().isNone()
    }

    /*
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    public func toArray(): Array<E> {
        let arr = ArrayList<E>()
        for (e in this) {
            arr.add(e)
        }
        return arr.toArray()
    }

    @Frozen
    /*
     * @noThrow
     */
    public func iterator(): Iterator<E> {
        ConcurrentLinkedQueueIterator<E>(this, front.load())
    }
}


/*
 * @noThrow
 */
func newBlock<E>(tailBlock: Block<E>, tail: AtomicReference<Block<E>>): Unit {
    if (!tailBlock.isExtended.compareAndSwap(false, true)) {
        while (true) {
            if (let Some(_) <- tailBlock.next.load()) {
                return
            }
        }
    }

    let newBlock = Block<E>(tailBlock.version + 1)
    tailBlock.next.store(newBlock)
    tail.store(newBlock)
}


/*
 * @noThrow
 */
func nextBlock<E>(headBlock: Block<E>, head: AtomicReference<Block<E>>, tail: AtomicReference<Block<E>>): Bool {
    if (!refEq(head.load(), headBlock)) {
        return true
    }

    if (let Some(next) <- headBlock.next.load()) {
        while (refEq(headBlock, tail.load())) {}
        head.compareAndSwap(headBlock, next)
        return true
    }

    return false
}

class ConcurrentLinkedQueueIterator<E> <: Iterator<E> {
    let queue: ConcurrentLinkedQueue<E>
    var curBlock: Block<E>
    var curIndex: Int64
    var hasNext: Bool = true

    /*
     * @noThrow
     */
    init(queue: ConcurrentLinkedQueue<E>, front: Block<E>) {
        this.queue = queue
        this.curBlock = front
        this.curIndex = curBlock.reserved.load()
    }

    @Frozen
    /*
     * @throws IndexOutOfBoundsException
     */
    public func next(): ?E {
        while (hasNext) {
            if (curIndex >= BUF_SIZE && !getNextBlock() || curIndex >= curBlock.committed.load()) {
                hasNext = false
                break
            }
            let curElement = curBlock.buffer[curIndex]
            let reserved = curBlock.reserved.load()
            if (curIndex >= reserved) {
                curIndex++
                return curElement
            }
            curIndex = reserved
        }
        return None
    }

    /*
     * @noThrow
     */
    func getNextBlock(): Bool {
        match (curBlock.next.load()) {
            case None => false
            case Some(block) =>
                curBlock = block
                curIndex = 0
                true
        }
    }
}
