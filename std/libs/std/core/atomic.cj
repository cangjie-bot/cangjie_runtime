







package std.core

enum MemoryOrder {
    SeqCst
}

@Intrinsic
/*
 * @noThrow
 */
func load<ATOMIC_TYPE, TYPE>(atomicType: ATOMIC_TYPE, memoryOrder: MemoryOrder): TYPE

@Intrinsic
/*
 * @noThrow
 */
func store<ATOMIC_TYPE, TYPE>(atomicType: ATOMIC_TYPE, value: TYPE, memoryOrder: MemoryOrder): Unit

@Intrinsic
/*
 * @noThrow
 */
func fetchAdd<ATOMIC_TYPE, TYPE>(atomicType: ATOMIC_TYPE, value: TYPE, memoryOrder: MemoryOrder): TYPE

@Intrinsic
/*
 * @noThrow
 */
func compareAndSwap<ATOMIC_TYPE, TYPE>(
    atomicType: ATOMIC_TYPE,
    oldValue: TYPE,
    newValue: TYPE,
    successOrder: MemoryOrder,
    failureOrder: MemoryOrder
): Bool

class AtomicBool {
    private var value: Int8 = 0
    /*
     * @noThrow
     */
    init(val: Bool) {
        var valInt8: Int8 = if (val) {
            1
        } else {
            0
        }
        store<AtomicBool, Int8>(this, valInt8, MemoryOrder.SeqCst)
    }

    /*
     * @noThrow
     */
    func load(): Bool {
        var v = load<AtomicBool, Int8>(this, MemoryOrder.SeqCst)
        return v != 0
    }

    /*
     * @noThrow
     */
    func store(val: Bool): Unit {
        var valInt8: Int8 = if (val) {
            1
        } else {
            0
        }
        store<AtomicBool, Int8>(this, valInt8, MemoryOrder.SeqCst)
    }
}

class AtomicInt64 {
    private var value: Int64

    /*
     * @noThrow
     */
    init(val: Int64) {
        value = val
        store<AtomicInt64, Int64>(this, val, MemoryOrder.SeqCst)
    }

    /*
     * @noThrow
     */
    func fetchAdd(val: Int64): Int64 {
        fetchAdd<AtomicInt64, Int64>(this, val, MemoryOrder.SeqCst)
    }

    /*
     * @noThrow
     */
    func load(): Int64 {
        load<AtomicInt64, Int64>(this, MemoryOrder.SeqCst)
    }

    /*
     * @noThrow
     */
    func store(val: Int64): Unit {
        store<AtomicInt64, Int64>(this, val, MemoryOrder.SeqCst)
    }

    /*
     * @noThrow
     */
    func compareAndSwap(old: Int64, new: Int64): Bool {
        return compareAndSwap<AtomicInt64, Int64>(this, old, new, MemoryOrder.SeqCst, MemoryOrder.SeqCst)
    }
}

class AtomicReference<T> where T <: Object {
    private var value: T

    /*
     * @noThrow
     */
    init(val: T) {
        value = val
        store<AtomicReference<T>, T>(this, val, MemoryOrder.SeqCst)
    }

    /*
     * @noThrow
     */
    func load(): T {
        load<AtomicReference<T>, T>(this, MemoryOrder.SeqCst)
    }

    /*
     * @noThrow
     */
    func store(val: T): Unit {
        store<AtomicReference<T>, T>(this, val, MemoryOrder.SeqCst)
    }
}


class AtomicBox<T> {
    private let boxRef: AtomicReference<Box<T>>

    /*
     * @noThrow
     */
    init(val: T) {
        boxRef = AtomicReference((Box(val)))
    }

    /*
     * @noThrow
     */
    func load(): T {
        boxRef.load().value
    }

    /*
     * @noThrow
     */
    func store(val: T): Unit {
        boxRef.store(Box<T>(val))
    }
}
