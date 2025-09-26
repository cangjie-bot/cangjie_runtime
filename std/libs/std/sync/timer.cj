









package std.sync

import std.time.MonoTime

const TIMER_BLOCK_BUFFER_SIZE = 1 << 7
const TIMER_LIST_DEFAULT_CAPACITY = 16














public class Timer <: Equatable<Timer> & Hashable {
    private static let INSTANCE_ID = AtomicInt64(1)
    private let id = INSTANCE_ID.fetchAdd(1)

    private let scheduler: TimerScheduler
    let task: () -> ?Duration
    var endTime: MonoTime
    var isEnabled = true

    /**
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     * @throws ArithmeticException
     * @throws IllegalSynchronizationStateException
     */
    init(delay: Duration, task: () -> ?Duration) {
        let realDelay = if (delay > Duration.Zero) {
            delay
        } else {
            Duration.Zero
        }

        this.scheduler = TimerScheduler.getScheduler(id)
        this.task = task
        try {
            this.endTime = MonoTime.now() + realDelay
        } catch (e: ArithmeticException) {
            this.endTime = MonoTime.now() + realDelay / 2
        }

        this.scheduler.add(this)
    }











    /**
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     * @throws ArithmeticException
     * @throws IllegalSynchronizationStateException
     */
    public static func after(delay: Duration, task: () -> Option<Duration>): Timer {
        Timer(delay, task)
    }






    /**
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     * @throws ArithmeticException
     * @throws IllegalSynchronizationStateException
     */
    public static func once(delay: Duration, task: () -> Unit): Timer {
        Timer(delay) {
            task()
            None
        }
    }










    /**
     * @throws IndexOutOfBoundsException
     * @throws IllegalSynchronizationStateException
     * @throws ArithmeticException
     * @throws IllegalArgumentException
     */
    public static func repeat(delay: Duration, interval: Duration, task: () -> Unit, style!: CatchupStyle = Burst): Timer {
        if (interval <= Duration.Zero) {
            throw IllegalArgumentException("Interval cannot be less than or equal to Duration.Zero.")
        }

        let nextTick = match (style) {
            case Delay => delayStyleTick(interval)
            case Burst => burstStyleTick(delay, interval)
            case Skip => skipStyleTick(delay, interval)
        }

        Timer(delay) {
            task()
            nextTick()
        }
    }












    /**
     * @throws IndexOutOfBoundsException
     * @throws IllegalSynchronizationStateException
     * @throws ArithmeticException
     * @throws IllegalArgumentException
     */
    public static func repeatDuring(period: Duration, delay: Duration, interval: Duration, task: () -> Unit,
        style!: CatchupStyle = Burst): Timer {
        if (period <= Duration.Zero) {
            throw IllegalArgumentException("Period cannot be less than or equal to Duration.Zero.")
        }
        if (interval <= Duration.Zero) {
            throw IllegalArgumentException("Interval cannot be less than or equal to Duration.Zero.")
        }

        let innerTick = match (style) {
            case Delay => delayStyleTick(interval)
            case Burst => burstStyleTick(delay, interval)
            case Skip => skipStyleTick(delay, interval)
        }
        let nextTick = tickDuring(delay, period, innerTick)

        Timer(delay) {
            task()
            nextTick()
        }
    }












    /**
     * @throws IndexOutOfBoundsException
     * @throws IllegalSynchronizationStateException
     * @throws ArithmeticException
     * @throws IllegalArgumentException
     */
    public static func repeatTimes(count: Int64, delay: Duration, interval: Duration, task: () -> Unit,
        style!: CatchupStyle = Burst): Timer {
        if (count <= 0) {
            throw IllegalArgumentException("Count cannot be less than or equal to 0.")
        }
        if (interval <= Duration.Zero) {
            throw IllegalArgumentException("Interval cannot be less than or equal to Duration.Zero.")
        }

        let innerTick = match (style) {
            case Delay => delayStyleTick(interval)
            case Burst => burstStyleTick(delay, interval)
            case Skip => skipStyleTick(delay, interval)
        }
        let nextTick = tickTimes(count, innerTick)

        Timer(delay) {
            task()
            nextTick()
        }
    }





    public func cancel(): Unit {
        if (isEnabled) {
            isEnabled = false
            scheduler.addCancelCount()
        }
    }


    public operator func ==(rhs: Timer): Bool {
        refEq(this, rhs)
    }


    public operator func !=(rhs: Timer): Bool {
        !refEq(this, rhs)
    }


    public func hashCode(): Int64 {
        return id
    }

    /**
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     * @throws ArithmeticException
     * @throws IllegalSynchronizationStateException
     */
    func reload(duration: Duration): Unit {
        endTime = MonoTime.now() + duration
        isEnabled = true
        scheduler.add(this)
    }
}


public enum CatchupStyle {
    | Delay
    | Burst
    | Skip
}






func delayStyleTick(interval: Duration): () -> ?Duration {
    return {=> interval}
}






/**
 * @throws ArithmeticException
 */
func burstStyleTick(delay: Duration, interval: Duration): () -> ?Duration {
    let lastTime: Box<MonoTime>
    try {
        lastTime = Box<MonoTime>(MonoTime.now() + delay)
    } catch (e: ArithmeticException) {
        return {=> None}
    }

    return {
        =>
        let now = MonoTime.now()
        let nextTime = lastTime.value + interval
        if (nextTime >= now) {
            lastTime.value = nextTime
            return nextTime - now
        }
        lastTime.value = nextTime
        return Duration.Zero
    }
}






/**
 * @throws ArithmeticException
 */
func skipStyleTick(delay: Duration, interval: Duration): () -> ?Duration {
    let lastTime: Box<MonoTime>
    try {
        lastTime = Box<MonoTime>(MonoTime.now() + delay)
    } catch (e: ArithmeticException) {
        return {=> None}
    }

    return {
        =>
        let now = MonoTime.now()
        var nextTime = lastTime.value + interval
        if (nextTime >= now) {
            lastTime.value = nextTime
            return nextTime - now
        }
        while (nextTime < now) {
            nextTime += interval
        }
        lastTime.value = nextTime - interval
        return Duration.Zero
    }
}

/**
 * @throws ArithmeticException
 */
func tickDuring(delay: Duration, period: Duration, nextTick: () -> ?Duration): () -> ?Duration {
    let firstTickTime: MonoTime
    try {
        firstTickTime = MonoTime.now() + delay
    } catch (e: ArithmeticException) {
        return {=> None}
    }
    let finalTime: MonoTime
    try {
        finalTime = firstTickTime + period
    } catch (e: ArithmeticException) {
        return {=> nextTick()}
    }

    return {
        =>
        let now = MonoTime.now()
        if (now > finalTime) {
            return None
        }

        if (let Some(interval) <- nextTick()) {
            if (now + interval > finalTime) {
                return None
            }
            return interval
        }
        return None
    }
}

func tickTimes(count: Int64, nextTick: () -> ?Duration): () -> ?Duration {
    let cnt = Box<Int64>(1)
    return {
        =>
        if (cnt.value >= count) {
            return None
        }
        cnt.value++
        nextTick()
    }
}

class TimerScheduler {
    private static const SCHEDULER_COUNT = 64
    private static let schedulers: Array<TimerScheduler>
    static init() {
        schedulers = Array<TimerScheduler>(SCHEDULER_COUNT) {_ => TimerScheduler()}
    }
    /**
     * @throws IndexOutOfBoundsException
     */
    static func getScheduler(id: Int64) {
        schedulers[id % SCHEDULER_COUNT]
    }

    private let queue = TimerQueue()
    private var heap = TimerHeap()
    private let monitor = Monitor()
    private let isRunning = AtomicBool(false)
    private let cancelCount = AtomicInt64(0)

    /**
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     * @throws ArithmeticException
     * @throws IllegalSynchronizationStateException
     */
    func add(timer: Timer) {
        if (MonoTime.now() > timer.endTime) {
            execute(timer)
            return
        }
        synchronized(monitor) {
            queue.add(timer)
            monitor.notify()
        }
        start()
    }

    /**
     * @throws IllegalArgumentException
     * @throws IllegalSynchronizationStateException
     * @throws IndexOutOfBoundsException
     * @throws ArithmeticException
     */
    private func start() {
        if (!isRunning.compareAndSwap(false, true)) {
            return
        }
        spawn {
            while (true) {
                consume()
                schedule()
                let count = cancelCount.load()
                if (count > heap.size / 4 && count > 10) {
                    clearCancelledTimers()
                }
            }
        }
    }

    /**
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    private func consume() {
        while (let Some(t) <- queue.remove()) {
            heap.add(t)
        }
    }

    /**
     * @throws IllegalArgumentException
     * @throws IllegalSynchronizationStateException
     * @throws IndexOutOfBoundsException
     * @throws ArithmeticException
     */
    private func schedule(): Unit {
        if (heap.isEmpty) {
            synchronized(monitor) {
                if (queue.isEmpty()) {
                    monitor.wait()
                }
            }
            return
        }
        let timer = heap.top()
        if (!timer.isEnabled) {
            heap.poll()
            cancelCount.fetchSub(1)
            return
        }

        let time = MonoTime.now()
        if (time >= timer.endTime) {
            execute(timer)
            heap.poll()
            return
        }
        synchronized(monitor) {
            monitor.wait(timeout: timer.endTime - time)
        }
    }

    /**
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     * @throws ArithmeticException
     * @throws IllegalSynchronizationStateException
     */
    private func execute(timer: Timer) {
        spawn {
            var duration: ?Duration
            try {
                duration = timer.task()
            } finally {
                timer.isEnabled = false
            }
            if (let Some(d) <- duration) {
                timer.reload(d)
            }
        }
    }

    func addCancelCount() {
        cancelCount.fetchAdd(1)
    }

    /**
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    private func clearCancelledTimers() {
        cancelCount.store(0)
        let source = heap
        heap = TimerHeap()
        while (!source.isEmpty) {
            let timer = source.poll()
            if (timer.isEnabled) {
                heap.add(timer)
            }
        }
    }
}

class TimerHeap {
    private static const NODE_SIZE = 4

    private let data = TimerList()
    prop size: Int64 {
        get() {
            return data.size
        }
    }
    prop isEmpty: Bool {
        get() {
            return data.isEmpty()
        }
    }

    /**
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    func add(e: Timer) {
        data.add(e)
        siftUp()
    }
    /**
     * @throws IndexOutOfBoundsException
     */
    func top(): Timer {
        data[0]
    }
    /**
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    func poll(): Timer {
        let top = data[0]
        data[0] = data[data.size - 1]
        data.remove(at: data.size - 1)
        siftDown()
        return top
    }

    /**
     * @throws IndexOutOfBoundsException
     */
    private func siftUp() {
        var i = size - 1
        while (i > 0) {
            var parent = (i - 1) / NODE_SIZE
            if (!(data[i].endTime < data[parent].endTime)) {
                break
            }
            (data[parent], data[i]) = (data[i], data[parent])
            i = parent
        }
    }

    /**
     * @throws IndexOutOfBoundsException
     */
    private func siftDown() {
        var i = 0
        while (true) {
            let childIndex = NODE_SIZE * i + 1
            if (childIndex > size - 1) {
                break
            }

            let min = getMinIndex(childIndex)
            if (!(data[min].endTime < data[i].endTime)) {
                break
            }
            (data[min], data[i]) = (data[i], data[min])
            i = min
        }
    }

    /**
     * @throws IndexOutOfBoundsException
     */
    private func getMinIndex(index: Int64) {
        var min = index
        for (i in (index + 1)..(index + NODE_SIZE)) {
            if (i < size && data[i].endTime < data[min].endTime) {
                min = i
            }
        }
        return min
    }
}





enum PushResult {
    | BlockDone
    | Conflict
    | Succeed
}





enum PopResult {
    | BlockDone
    | NoEntry
    | Element(Timer)
}


class TimerBlock {
    let isExtended = AtomicBool(false)
    let next = AtomicOptionReference<TimerBlock>(None)
    private let allocated = AtomicInt64(0)
    let committed = AtomicInt64(0)
    let reserved = AtomicInt64(0)
    let buffer = unsafe { Array<Timer>(TIMER_BLOCK_BUFFER_SIZE, repeat: zeroValue<Timer>()) }

    TimerBlock(let version: UInt64) {}

    /**
     * @throws IndexOutOfBoundsException
     */
    func push(element: Timer): Bool {
        if (allocated.load() >= TIMER_BLOCK_BUFFER_SIZE) {
            return false
        }

        let index = allocated.fetchAdd(1)

        if (index >= TIMER_BLOCK_BUFFER_SIZE) {
            return false
        }

        buffer[index] = element
        committed.fetchAdd(1)

        return true
    }

    /**
     * @throws IndexOutOfBoundsException
     */
    func pop(): PopResult {
        while (true) {
            let index = reserved.load()

            if (index >= TIMER_BLOCK_BUFFER_SIZE) {
                return BlockDone
            }

            let currentCommitted = committed.load()
            if (currentCommitted != TIMER_BLOCK_BUFFER_SIZE) {
                if (currentCommitted != allocated.load()) {
                    continue
                }
            }

            if (index == currentCommitted) {
                return NoEntry
            }

            if (reserved.compareAndSwap(index, index + 1)) {
                let elem = Element(buffer[index])
                buffer[index] = unsafe { zeroValue<Timer>() }
                return elem
            }
        }

        return BlockDone
    }

    /**
     * @throws IndexOutOfBoundsException
     */
    func front(): PopResult {
        while (true) {
            let index = reserved.load()

            if (index >= TIMER_BLOCK_BUFFER_SIZE) {
                return BlockDone
            }

            let currentCommitted = committed.load()
            if (currentCommitted != TIMER_BLOCK_BUFFER_SIZE) {
                if (currentCommitted != allocated.load()) {
                    continue
                }
            }

            if (index == currentCommitted) {
                return NoEntry
            }

            return Element(buffer[index])
        }

        return BlockDone
    }
}

class TimerQueue {
    private let front: AtomicReference<TimerBlock>
    private let rear: AtomicReference<TimerBlock>

    init() {
        let block = TimerBlock(0)
        front = AtomicReference<TimerBlock>(block)
        rear = AtomicReference<TimerBlock>(block)
    }

    /**
     * @throws IndexOutOfBoundsException
     */
    func add(element: Timer) {
        while (true) {
            let tailBlock = rear.load()
            if (tailBlock.push(element)) {
                return
            }
            newBlock(tailBlock, rear)
        }
    }

    /**
     * @throws IndexOutOfBoundsException
     */
    func remove(): Option<Timer> {
        while (true) {
            let headBlock = front.load()
            match (headBlock.pop()) {
                case BlockDone =>
                    if (!nextBlock(headBlock, front, rear)) {
                        return None
                    }
                case NoEntry => break
                case Element(e) => return Some(e)
            }
        }
        return None
    }

    /**
     * @throws IndexOutOfBoundsException
     */
    func peek(): Option<Timer> {
        while (true) {
            let headBlock = front.load()
            match (headBlock.front()) {
                case Element(e) => return Some(e)
                case NoEntry => break
                case BlockDone =>
                    if (!nextBlock(headBlock, front, rear)) {
                        break
                    }
            }
        }
        return None
    }

    /**
     * @throws IndexOutOfBoundsException
     */
    func isEmpty(): Bool {
        peek().isNone()
    }
}

func newBlock(tailBlock: TimerBlock, tail: AtomicReference<TimerBlock>): Unit {
    if (!tailBlock.isExtended.compareAndSwap(false, true)) {
        while (tailBlock.next.load().isNone()) {}
        return
    }

    let newBlock = TimerBlock(tailBlock.version + 1)
    tailBlock.next.store(newBlock)
    tail.store(newBlock)
}

func nextBlock(headBlock: TimerBlock, head: AtomicReference<TimerBlock>, tail: AtomicReference<TimerBlock>): Bool {
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

class TimerList {
    private var _data: Array<Timer>
    private var _size: Int64

    init() {
        _data = Array<Timer>(TIMER_LIST_DEFAULT_CAPACITY, repeat: unsafe { zeroValue<Timer>() })
        _size = 0
    }

    /**
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    func add(element: Timer): Unit {
        if (_size == _data.size) {
            grow(_size + 1)
        }
        _data[_size] = element
        _size++
    }
    /**
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    func remove(at!: Int64): Timer {
        let len: Int64 = _size - at - 1
        let removed = _data[at]
        _data.copyTo(_data, at + 1, at, len)
        _data[_size - 1] = unsafe { zeroValue<Timer>() }
        _size--
        return removed
    }
    /**
     * @throws IndexOutOfBoundsException
     */
    operator func [](index: Int64): Timer {
        return this._data[index]
    }
    /**
     * @throws IndexOutOfBoundsException
     */
    operator func [](index: Int64, value!: Timer): Unit {
        _data[index] = value
    }

    func isEmpty(): Bool {
        return _size == 0
    }

    prop size: Int64 {
        get() {
            return _size
        }
    }

    /**
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    private func grow(minCapacity: Int64, startIndex!: Int64 = 0): Unit {
        let oldCapacity: Int64 = _data.size
        var newCapacity: Int64 = oldCapacity + (oldCapacity >> 1)
        if (newCapacity < minCapacity) {
            newCapacity = minCapacity
        }
        let newArr: Array<Timer> = Array<Timer>(newCapacity, repeat: unsafe { zeroValue<Timer>() })
        _data.copyTo(newArr, 0, startIndex, _size)
        _data = newArr
    }
}
