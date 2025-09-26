









package std.collection

public class ArrayQueue<T> <: Queue<T> {
    let _data: ArrayDeque<T>

    public init() {
        _data = ArrayDeque<T>()
    }

    /**
     * @throws IllegalArgumentException
     */
    public init(capacity: Int64) {
        _data = ArrayDeque<T>(capacity)
    }

    public func peek(): ?T {
        _data.first
    }

    /**
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    public func add(element: T): Unit {
        _data.addLast(element)
    }

    public func remove(): ?T {
        _data.removeFirst()
    }

    public prop size: Int64 {
        get() {
            _data.size
        }
    }

    public prop capacity: Int64 {
        get() {
            _data.capacity
        }
    }

    public func isEmpty(): Bool {
        _data.isEmpty()
    }

    public func clear(): Unit {
        _data.clear()
    }

    @Frozen
    public func iterator(): Iterator<T> {
        _data.iterator()
    }

    /**
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    public func toArray(): Array<T> {
        _data.toArray()
    }

    /**
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    public func reserve(additional: Int64): Unit {
        _data.reserve(additional)
    }
}

extend<T> ArrayQueue<T> <: ToString where T <: ToString {
    /**
     * @throws NoneValueException
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    public func toString(): String {
        this._data.toString()
    }
}
