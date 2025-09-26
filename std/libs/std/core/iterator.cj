







package std.core


public interface Iterable<E> {
    
    func iterator(): Iterator<E>
}


public abstract class Iterator<T> <: Iterable<T> {
    public func next(): Option<T>

    @Frozen
    public init() {}




    @Frozen
    public func iterator(): Iterator<T> { this }
}

class FilterIterator<T> <: Iterator<T> {
    private let predicate: (T) -> Bool
    private let it: Iterator<T>






    init(it: Iterator<T>, predicate: (T) -> Bool) {
        this.it = it
        this.predicate = predicate
    }




    public func next(): Option<T> {
        while (let Some(value) <- it.next()) {
            
            if (predicate(value)) {
                return Some(value)
            }
        }
        return None
    }
}

class MapIterator<T, R> <: Iterator<R> {
    private let transform: (T) -> R
    private let it: Iterator<T>







    @Frozen
    init(it: Iterator<T>, transform: (T) -> R) {
        this.it = it
        this.transform = transform
    }




    @Frozen
    public func next(): Option<R> {
        return match (it.next()) {
            case Some(value) => Some(transform(value))
            case _ => None
        }
    }
}

class StepIterator<T> <: Iterator<T> {
    private let _count: Int64
    private let it: Iterator<T>
    private var index: Int64 = 0







    /**
     * @throws IllegalArgumentException
     */
    init(it: Iterator<T>, count: Int64) {
        if (count <= 0) {
            throw IllegalArgumentException("Step count must be greater than 0!")
        }
        this.it = it
        this._count = count
        this.index = count
    }




    public func next(): Option<T> {
        while (let Some(v) <- it.next()) {
            if (index < _count) {
                index++
                continue
            }
            index = 1
            return Some(v)
        }
        return None
    }
}

class SkipIterator<T> <: Iterator<T> {
    private var _count: Int64
    private let it: Iterator<T>







    /**
     * @throws IllegalArgumentException
     */
    init(it: Iterator<T>, count: Int64) {
        if (count < 0) {
            throw IllegalArgumentException("Skip count cannot less than 0!")
        }
        this.it = it
        this._count = count
    }




    public func next(): Option<T> {



        while (_count > 0) {
            match (it.next()) {
                case None => return None
                case _ => _count--
            }
        }
        return it.next()
    }
}




class TakeIterator<T> <: Iterator<T> {
    private var _count: Int64
    private let it: Iterator<T>







    /**
     * @throws IllegalArgumentException
     */
    init(it: Iterator<T>, count: Int64) {
        if (count < 0) {
            throw IllegalArgumentException("Take count cannot less than 0!")
        }
        this.it = it
        this._count = count
    }




    public func next(): Option<T> {
        
        if (_count == 0) {
            return None
        }
        _count--
        return it.next()
    }
}

class ConcatIterator<T> <: Iterator<T> {
    private let it: Iterator<T>
    private let other: Iterator<T>

    
    private var itOver: Bool = false






    init(it: Iterator<T>, other: Iterator<T>) {
        this.it = it
        this.other = other
    }




    public func next(): Option<T> {
        if (itOver) {
            return other.next()
        }

        match (it.next()) {
            case Some(value) => return Some(value)
            case _ =>
                itOver = true
                return other.next()
        }
    }
}

class FlatMapIterator<T, R> <: Iterator<R> {
    private var subIt: Option<Iterator<R>> = None
    private let transform: (T) -> Iterable<R>
    private let it: Iterator<T>







    init(it: Iterable<T>, transform: (T) -> Iterable<R>) {
        this.it = it.iterator()
        this.transform = transform
    }




    public func next(): Option<R> {




        while (true) {
            match (subIt) {
                case Some(result) => match (result.next()) {
                    case Some(v) => return Some(v)
                    case _ => ()
                }
                case _ => ()
            }

            match (it.next()) {
                case Some(sub) => subIt = Some(transform(sub).iterator())
                case _ => return None
            }
        }
        return None
    }
}

class ZipIterator<T, R> <: Iterator<(T, R)> {
    private let itt: Iterator<T>
    private let itr: Iterator<R>






    init(itt: Iterator<T>, itr: Iterator<R>) {
        this.itt = itt
        this.itr = itr
    }




    public func next(): Option<(T, R)> {
        match ((itt.next(), itr.next())) {
            case (Some(t), Some(r)) => return Some((t, r))
            case _ => return None
        }
    }
}

class EnumerateIterator<T> <: Iterator<(Int64, T)> {
    
    private var index: Int64 = -1
    private let it: Iterator<T>





    init(it: Iterator<T>) {
        this.it = it
    }




    public func next(): Option<(Int64, T)> {
        return match (it.next()) {
            case Some(value) =>
                index++
                Some((index, value))
            case _ => return None
        }
    }
}

class FilterMapIterator<T, R> <: Iterator<R> {
    private let transform: (T) -> Option<R>
    private let it: Iterator<T>

    init(it: Iterator<T>, transform: (T) -> Option<R>) {
        this.it = it
        this.transform = transform
    }

    public func next(): Option<R> {
        while (let Some(t) <- it.next()) {
            match (transform(t)) {
                case Some(r) => return Some(r)
                case _ => continue
            }
        }
        return None
    }
}

class InspectIterator<T> <: Iterator<T> {
    private let action: (T) -> Unit
    private let it: Iterator<T>

    init(it: Iterator<T>, action: (T) -> Unit) {
        this.it = it
        this.action = action
    }

    public func next(): Option<T> {
        match (it.next()) {
            case Some(value) =>
                action(value)
                return Some(value)
            case _ => ()
        }
        return None
    }
}

class IntersperseIterator<T> <: Iterator<T> {
    private let separator: T
    private let it: Iterator<T>
    private var item: ?T
    private var isInsert = false

    init(it: Iterator<T>, separator: T) {
        this.it = it
        this.separator = separator
        this.item = it.next()
    }

    public func next(): Option<T> {
        if (isInsert) {
            isInsert = false
            item = it.next()
            if (item.isNone()) {
                return None
            }
            return Some(separator)
        }
        isInsert = true
        return item
    }
}

extend<T> Iterator<T> where T <: Equatable<T> {
    @Frozen
    public func contains(element: T): Bool {
        for (item in this.iterator()) {
            if (item == element) {
                return true
            }
        }
        return false
    }
}

extend<T> Iterator<T> where T <: Comparable<T> {
    public func max(): Option<T> {
        var result: Option<T> = None
        for (item in this.iterator()) {
            match (result) {
                case Some(value) =>
                    if (item > value) {
                        result = Some(item)
                    }
                case _ => result = Some(item)
            }
        }
        return result
    }

    public func min(): Option<T> {
        var result: Option<T> = None
        for (item in this.iterator()) {
            match (result) {
                case Some(value) =>
                    if (item < value) {
                        result = Some(item)
                    }
                case _ => result = Some(item)
            }
        }
        return result
    }
}

extend<T> Iterator<T> {
    @Frozen
    public func zip<R>(it: Iterator<R>): Iterator<(T, R)> {
        return ZipIterator<T, R>(this, it)
    }

    @Frozen
    public func enumerate(): Iterator<(Int64, T)> {
        return EnumerateIterator<T>(this)
    }

    @Frozen
    public func filter(predicate: (T) -> Bool): Iterator<T> {
        return FilterIterator<T>(this, predicate)
    }

    @Frozen
    public func filterMap<R>(transform: (T) -> Option<R>): Iterator<R> {
        return FilterMapIterator<T, R>(this, transform)
    }

    @Frozen
    public func map<R>(transform: (T) -> R): Iterator<R> {
        return MapIterator<T, R>(this, transform)
    }

    /**
     * @throws IllegalArgumentException
     */
    @Frozen
    public func step(count: Int64): Iterator<T> {
        return StepIterator<T>(this, count)
    }

    /**
     * @throws IllegalArgumentException
     */
    @Frozen
    public func skip(count: Int64): Iterator<T> {
        return SkipIterator<T>(this, count)
    }

    /**
     * @throws IllegalArgumentException
     */
    @Frozen
    public func take(count: Int64): Iterator<T> {
        return TakeIterator<T>(this, count)
    }

    @Frozen
    public func concat(other: Iterator<T>): Iterator<T> {
        return ConcatIterator<T>(this, other)
    }

    @Frozen
    public func inspect(action: (T) -> Unit): Iterator<T> {
        return InspectIterator<T>(this, action)
    }

    @Frozen
    public func flatMap<R>(transform: (T) -> Iterator<R>): Iterator<R> {
        return FlatMapIterator<T, R>(this, transform)
    }

    @Frozen
    public func intersperse(separator: T): Iterator<T> {
        return IntersperseIterator<T>(this, separator)
    }

    @Frozen
    public func all(predicate: (T) -> Bool): Bool {
        for (item in this) {
            if (!predicate(item)) {
                return false
            }
        }
        return true
    }

    @Frozen
    public func any(predicate: (T) -> Bool): Bool {
        for (item in this) {
            if (predicate(item)) {
                return true
            }
        }
        return false
    }

    @Frozen
    public func none(predicate: (T) -> Bool): Bool {
        for (item in this) {
            if (predicate(item)) {
                return false
            }
        }
        return true
    }

    @Frozen
    public func isEmpty(): Bool {
        return match (this.next()) {
            case None => true
            case _ => false
        }
    }

    @Frozen
    public func count(): Int64 {
        var count: Int64 = 0
        for (_ in this) {
            count++
        }
        return count
    }

    @Frozen
    public func forEach(action: (T) -> Unit): Unit {
        for (item in this) {
            action(item)
        }
    }

    @Frozen
    public func first(): Option<T> {
        return this.next()
    }

    @Frozen
    public func last(): Option<T> {
        var result: Option<T> = None
        for (item in this) {
            result = Some(item)
        }
        return result
    }

    @Frozen
    public func at(n: Int64): Option<T> {
        if (n < 0) {
            return None
        }
        var i: Int64 = 0
        for (item in this) {
            if (i == n) {
                return Some(item)
            }
            i++
        }
        return None
    }

    @Frozen
    public func reduce(operation: (T, T) -> T): Option<T> {
        var it = this.iterator()
        var result: T = it.next() ?? return None
        while (let Some(value) <- it.next()) {
            result = operation(result, value)
        }
        return result
    }

    @Frozen
    public func fold<R>(initial: R, operation: (R, T) -> R): R {
        var result: R = initial
        for (item in this) {
            result = operation(result, item)
        }
        return result
    }
}
