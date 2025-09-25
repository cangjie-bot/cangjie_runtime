









package std.collection

public class ArrayQueue<T> <: Queue<T> {
    let _data: ArrayDeque<T>

    /*
     * @noThrow
     */
    public init() {
        _data = ArrayDeque<T>()
    }

    /*
     * @throws IllegalArgumentException
     */
    public init(capacity: Int64) {
        _data = ArrayDeque<T>(capacity)
    }

    /*
     * @noThrow
     */
    public func peek(): ?T {
        _data.first
    }

    /*
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    public func add(element: T): Unit {
        _data.addLast(element)
    }

    /*
     * @noThrow
     */
    public func remove(): ?T {
        _data.removeFirst()
    }

    public prop size: Int64 {
        /*
         * @noThrow
         */
        get() {
            _data.size
        }
    }

    public prop capacity: Int64 {
        /*
         * @noThrow
         */
        get() {
            _data.capacity
        }
    }

    /*
     * @noThrow
     */
    public func isEmpty(): Bool {
        _data.isEmpty()
    }

    /*
     * @noThrow
     */
    public func clear(): Unit {
        _data.clear()
    }

    @Frozen
    /*
     * @noThrow
     */
    public func iterator(): Iterator<T> {
        _data.iterator()
    }

    /*
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    public func toArray(): Array<T> {
        _data.toArray()
    }

    /*
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    public func reserve(additional: Int64): Unit {
        _data.reserve(additional)
    }
}

extend<T> ArrayQueue<T> <: ToString where T <: ToString {
    /*
     * @throws NoneValueException
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    public func toString(): String {
        this._data.toString()
    }
}
