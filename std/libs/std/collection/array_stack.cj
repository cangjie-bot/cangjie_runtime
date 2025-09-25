









package std.collection

public class ArrayStack<T> <: Stack<T> {
    var _data: Array<T> = Array<T>()
    var _size: Int64 = 0
    var _version: Int64 = 0
    private static const DEFAULT_CAPACITY: Int64 = 8





    public init(capacity: Int64) {
        if (capacity < 0) {
            throw IllegalArgumentException("The capacity must be greater than or equal to 0: ${capacity}.")
        }
        let cap: Int64 = if (capacity >= DEFAULT_CAPACITY) {
            capacity
        } else {
            DEFAULT_CAPACITY
        }
        _data = Array<T>(cap, repeat: unsafe { zeroValue<T>() })
    }


    public init() {
        _data = Array<T>(DEFAULT_CAPACITY, repeat: unsafe { zeroValue<T>() })
    }




    public func peek(): ?T {
        if (_size > 0) {
            return _data[_size - 1]
        }
        return None
    }




    public func remove(): ?T {
        if (_size > 0) {
            let result = _data[_size - 1]
            _data[_size - 1] = unsafe { zeroValue<T>() }
            _size--
            incModCount()
            return result
        }
        None
    }




    public func add(element: T): Unit {
        if (_size == _data.size) {
            grow(_size + 1)
        }
        _data[_size] = element
        _size++
        incModCount()
    }




    public prop capacity: Int64 {
        get() {
            _data.size
        }
    }




    public prop size: Int64 {
        get() {
            _size
        }
    }




    public func isEmpty(): Bool {
        _size == 0
    }




    public func reserve(additional: Int64): Unit {
        if (_data.size - _size >= additional) {
            return
        }
        grow(_size + additional)
        incModCount()
    }


    public func clear(): Unit {
        for (i in 0.._size) {
            unsafe { _data.setUnchecked(i, zeroValue<T>()) }
        }
        _size = 0
        incModCount()
    }




    public func toArray(): Array<T> {
        let arr = _data[0..size].clone()
        arr.reverse()
        return arr
    }




    @Frozen
    public func iterator(): Iterator<T> {
        return ArrayStackIterator<T>(this)
    }

    private func grow(minCapacity: Int64, startIndex!: Int64 = 0): Unit {
        let oldCapacity: Int64 = _data.size
        var newCapacity: Int64 = oldCapacity + (oldCapacity >> 1)
        if (newCapacity < minCapacity) {
            newCapacity = minCapacity
        }
        let newArr: Array<T> = Array<T>(newCapacity, repeat: unsafe { zeroValue<T>() })
        _data.copyTo(newArr, 0, startIndex, _size)
        _data = newArr
    }

    @OverflowWrapping
    private func incModCount(): Unit {
        _version++
    }
}

class ArrayStackIterator<T> <: Iterator<T> {
    private let _stack: ArrayStack<T>
    private var _position: Int64
    private let _lockVersion: Int64



    init(data: ArrayStack<T>) {
        _stack = data
        _position = data._size
        _lockVersion = data._version
    }




    @Frozen
    @OverflowWrapping
    public func next(): Option<T> {
        if (_stack._version != _lockVersion) {
            throw ConcurrentModificationException()
        }

        if (_position > 0) {
            _position--
            return _stack._data[_position]
        }
        return None
    }
}

extend<T> ArrayStack<T> <: ToString where T <: ToString {
    public func toString(): String {
        if (size == 0) {
            return "[]"
        }

        let sb = StringBuilder()
        sb.append(r'[')
        sb.append(_data[_size - 1])
        for (i in size - 2..=0 : -1) {
            sb.append(", ")
            sb.append(_data[i])
        }
        sb.append(r']')
        return sb.toString()
    }
}
