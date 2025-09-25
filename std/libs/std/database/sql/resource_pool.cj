







package std.database.sql

import std.collection.{Map, ArrayList}
import std.collection.concurrent.{BlockingQueue, LinkedBlockingQueue}
import std.time.DateTime
import std.sync.{Timer, CatchupStyle, AtomicBool, ReentrantMutex}

class ResourcePool<T> <: Pool<T> & Equatable<ResourcePool<T>> {

    let mux = ReentrantMutex()
    let entryQueue: LinkedBlockingQueue<Entry<T>>
    let idleEntry: BlockingQueue<Entry<T>>
    var options: Options<T>
    var ticker: Timer
    var entryCount: Int32
    var isclosed = AtomicBool(false)

    /*
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     * @throws ArithmeticException
     * @throws IllegalSynchronizationStateException
     */
    public init(options: Options<T>) {
        this.options = options
        entryQueue = LinkedBlockingQueue<Entry<T>>(Int64(options.maxSize))
        idleEntry = BlockingQueue<Entry<T>>(Int64(options.maxSize))
        entryCount = 0
        ticker = Timer.once(Duration.hour) {=> ()}
        backgroundCheckIdleLife()
    }



    public mut prop maxSize: Int32 {
        /*
         * @noThrow
         */
        get() {
            options.maxSize
        }
        /*
         * @noThrow
         */
        set(value) {
            if (value <= 0) {
                options.maxSize = Int32.Max
            } else {
                options.maxSize = value
            }
        }
    }



    public mut prop maxIdleSize: Int32 {
        /*
         * @noThrow
         */
        get() {
            options.maxIdleSize
        }
        /*
         * @noThrow
         */
        set(value) {
            if (value <= 0) {
                options.maxIdleSize = Int32.Max
            } else {
                options.maxIdleSize = value
            }
        }
    }

    /*
     * @throws IndexOutOfBoundsException
     * @throws ArithmeticException
     * @throws IllegalSynchronizationStateException
     * @throws IllegalArgumentException
     */
    func backgroundCheckIdleLife() {
        ticker.cancel()
        ticker = Timer.repeat(Duration.second, options.keepaliveTime, checkLife, style: Delay)
    }

    /*
     * @throws IndexOutOfBoundsException
     * @throws ArithmeticException
     * @throws IllegalArgumentException
     * @throws IllegalSynchronizationStateException
     * @throws OutOfMemoryError
     * @throws SqlException
     */
    func checkLife(): Unit {
        checkMaxLifeTime()
        checkIdleTimeout()
    }

    /*
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     * @throws ArithmeticException
     * @throws IllegalSynchronizationStateException
     * @throws OutOfMemoryError
     * @throws SqlException
     */
    func checkMaxLifeTime() {
        let count: Int64
        synchronized(mux) {
            count = entryQueue.size
        }
        for (_ in 0..count) {
            let item = entryQueue.tryRemove()
            match (item) {
                case Some(v) => 
                     if (v.isValid && DateTime.now().toUnixTimeStamp() - v.creationTime > options.maxLifeTime) {
                        v.isValid = false
                        this.discard(v)
                     }
                case _ =>
                    eprintln("can not try get idle entry")
                    break
            }
        }
    }

    /*
     * @throws IndexOutOfBoundsException
     * @throws ArithmeticException
     * @throws IllegalArgumentException
     * @throws IllegalSynchronizationStateException
     * @throws OutOfMemoryError
     * @throws SqlException
     */
    func checkIdleTimeout() {
        let idleCount: Int64
        synchronized(mux) {
            idleCount = idleEntry.size
        }
        let list = ArrayList<Entry<T>>()

        for (_ in 0..idleCount) {
            let item = idleEntry.tryDequeue()
            match (item) {
                case Some(v) =>
                    if (v.isValid) {
                        appendLegalIdleEntry(v, idleCount, list)
                    }
                case _ =>
                    eprintln("can not try get idle entry")
                    break
            }
        }
        for (entry in list) {
            this.release(entry)
        }
    }

    /*
     * @throws getOrThrow
     * @throws IndexOutOfBoundsException
     * @throws ArithmeticException
     * @throws IllegalArgumentException
     * @throws IllegalSynchronizationStateException
     * @throws Exception
     * @throws SqlException
     */
    func getIdleEntry(timeout: Duration): Entry<T> {
        var item = idleEntry.dequeue(timeout)

        match (item) {
            case Some(v) =>
            if (v.isValid) {
                return v
            } else {
                mux.lock()
                if (entryCount < options.maxSize) {
                    entryCount++
                    mux.unlock()
                    return createEntry()
                }
                mux.unlock()
                throw SqlException("Acquired entries exceed maxSize(${maxSize})")
            }
            case None => throw SqlException("Acquired entries exceed maxSize(${maxSize})")
        }
    }

    /*
     * @throws SqlException
     * @throws getOrThrow
     * @throws IndexOutOfBoundsException
     * @throws ArithmeticException
     * @throws IllegalArgumentException
     * @throws IllegalSynchronizationStateException
     * @throws Exception
     */
    public func acquire(timeout: Duration): Option<Entry<T>> {
        mux.lock()
        if (idleEntry.size == 0 && entryCount < options.maxSize) {
            entryCount++
            mux.unlock()
            return createEntry()
        }
        mux.unlock()
        return getIdleEntry(timeout)
    }

    /*
     * @throws getOrThrow
     * @throws IndexOutOfBoundsException
     * @throws ArithmeticException
     * @throws IllegalArgumentException
     * @throws IllegalSynchronizationStateException
     * @throws Exception
     */
    func createEntry(): Entry<T> {
        var value = options.constructor()
        match (value) {
            case Some(v) =>
                let entry = Entry<T>(this, v)
                entryQueue.add(entry)
                return entry
            case None => throw Exception("constructor entry failed")
        }
    }

    /*
     * @throws IndexOutOfBoundsException
     * @throws ArithmeticException
     * @throws IllegalArgumentException
     * @throws IllegalSynchronizationStateException
     * @throws SqlException
     */
    public func release(entry: Entry<T>): Option<Unit> {
        match (entry.pool as ResourcePool<T>) {
            case Some(p) => if (p != this) {
                throw SqlException("the entry is owned by another pool")
            }
            case None => throw SqlException("the entry is not owned by any pool")
        }

        if (DateTime.now().toUnixTimeStamp() - entry.creationTime > options.maxLifeTime) {
            entry.isValid = false
            this.discard(entry)
        } else {
            idleEntry.enqueue(entry)
        }
        return
    }

    /*
     * @throws IllegalSynchronizationStateException
     * @throws SqlException
     */
    public func discard(entry: Entry<T>): Option<Unit> {
        match (entry.pool as ResourcePool<T>) {
            case Some(p) => if (p != this) {
                throw SqlException("the entry is owned by another pool")
            }
            case None => throw SqlException("the entry is not owned by any pool")
        }
        synchronized(mux) {
            if (entryCount > 0) {
                entryCount--
            }
        }
        options.destructor(entry.value)
        return
    }

    /*
     * @noThrow
     */
    public func isClosed() {
        return isclosed.load()
    }

    /*
     * @throws IndexOutOfBoundsException
     * @throws IllegalSynchronizationStateException
     * @throws SqlException
     * @throws OutOfMemoryError
     */
    public func close() {
        if (!isclosed.compareAndSwap(false, true)) {
            return
        }
        for (_ in 0..idleEntry.size) {
            var item = idleEntry.tryDequeue()
            match (item) {
                case Some(v) =>
                    if (v.isValid) {
                        v.isValid = false
                       this.discard(v)
                    }
                case None =>
                    eprintln("can not try get idle entry")
                    break
            }
        }
    }

    /*
     * @noThrow
     */
    public operator func !=(rhs: ResourcePool<T>): Bool {
        return !(this == rhs)
    }

    /*
     * @noThrow
     */
    public operator func ==(rhs: ResourcePool<T>): Bool {
        return refEq(this, rhs)
    }

    /*
     * @throws ArithmeticException
     * @throws IllegalSynchronizationStateException
     * @throws SqlException
     * @throws OutOfMemoryError
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    func appendLegalIdleEntry(v: Entry<T>, idleCount: Int64, list: ArrayList<Entry<T>>): Unit {
        var idle = v.idleDuration()
        if ((idle > options.idleTimeout || Int32(idleCount) > options.maxIdleSize) || (DateTime.now().
            toUnixTimeStamp() - v.creationTime > options.maxLifeTime)) {
            try {
                v.isValid = false
                this.discard(v)
            } catch (e: Exception) {
                eprintln("exception ${e.message}")
            }
        } else {
            list.add(v)
        }
    }
}
