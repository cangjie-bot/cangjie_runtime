









package std.collection

public class TreeSet<T> <: OrderedSet<T> where T <: Comparable<T> {
    
    private var map: TreeMap<T, Unit>





    public prop size: Int64 {
        get() {
            return this.map.size
        }
    }





        /**
         * @throws NoneValueException
         */
    public prop first: ?T {
        get() {
            this.map.first?[0]
        }
    }





        /**
         * @throws NoneValueException
         */
    public prop last: ?T {
        get() {
            this.map.last?[0]
        }
    }


    public init() {
        map = TreeMap<T, Unit>()
    }





    /**
     * @throws NoneValueException
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    public init(elements: Collection<T>) {
        this.map = TreeMap<T, Unit>()
        for (i in elements) {
            this.map.add(i, ())
        }
    }





    /**
     * @throws NoneValueException
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    private init(elements: Array<T>) {
        this.map = TreeMap<T, Unit>()
        for (i in elements) {
            this.map.add(i, ())
        }
    }






    /**
     * @throws NoneValueException
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    public init(size: Int64, initElement: (Int64) -> T) {
        if (size < 0) {
            throw IllegalArgumentException("Invalid size of TreeSet: ${size}.")
        }
        this.map = TreeMap<T, Unit>(size, {i => (initElement(i), ())})
    }





    /**
     * @throws NoneValueException
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    public static func of(elements: Array<T>): TreeSet<T> {
        return TreeSet(elements)
    }






    /**
     * @throws IndexOutOfBoundsException
     */
    public func contains(element: T): Bool {
        return map.contains(element)
    }






    /**
     * @throws IndexOutOfBoundsException
     */
    public func contains(all!: Collection<T>): Bool {
        return map.contains(all: all)
    }






    /**
     * @throws NoneValueException
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    public func add(element: T): Bool {
        return this.map.add(element, ()).isNone()
    }





    /**
     * @throws NoneValueException
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    public func add(all!: Collection<T>): Unit {
        for (i in all) {
            this.map.add(i, ())
        }
    }






    /**
     * @throws NoneValueException
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    public func remove(element: T): Bool {
        return map.remove(element).isSome()
    }





    /**
     * @throws NoneValueException
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    public func remove(all!: Collection<T>): Unit {
        map.remove(all: all)
    }





    /**
     * @throws IllegalArgumentException
     * @throws NoneValueException
     * @throws IndexOutOfBoundsException
     * @throws ConcurrentModificationException
     */
    public func removeIf(predicate: (T) -> Bool): Unit {
        this.map.removeIf({e, _ => predicate(e)})
    }


    public func clear(): Unit {
        this.map.clear()
    }





    /**
     * @throws NoneValueException
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    public func clone(): TreeSet<T> {
        return TreeSet<T>(this)
    }





    public func isEmpty(): Bool {
        return this.map.isEmpty()
    }





    @Frozen
    public func iterator(): Iterator<T> {
        return this.map.keys().iterator()
    }





    /**
     * @throws NoneValueException
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    public func removeFirst(): ?T {
        return this.map.removeFirst()?[0]
    }





    /**
     * @throws NoneValueException
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    public func removeLast(): ?T {
        return this.map.removeLast()?[0]
    }










    /**
     * @throws IllegalArgumentException
     * @throws NoneValueException
     * @throws IndexOutOfBoundsException
     */
    public func backward(mark: T, inclusive!: Bool = true): Iterator<T> {
        return IteratorForSet<T>(this.map.backward(mark, inclusive: inclusive))
    }










    /**
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     * @throws NoneValueException
     */
    public func forward(mark: T, inclusive!: Bool = true): Iterator<T> {
        return IteratorForSet<T>(this.map.forward(mark, inclusive: inclusive))
    }









    /**
     * @throws IllegalArgumentException
     * @throws NoneValueException
     * @throws IndexOutOfBoundsException
     * @throws ConcurrentModificationException
     */
    public func retain(all!: Set<T>): Unit {
        this.map.removeIf({k, _ => !all.contains(k)})
    }



    public func toArray(): Array<T> {
        return map.keys().toArray()
    }






    public func subsetOf(other: ReadOnlySet<T>): Bool {
        return other.contains(all: this.map.keys())
    }













    /**
     * @throws NoneValueException
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    public operator func &(other: ReadOnlySet<T>): TreeSet<T> {
        let result = TreeSet<T>()
        for (key in this.map.keys() where other.contains(key)) {
            result.add(key)
        }
        return result
    }













    /**
     * @throws NoneValueException
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    public operator func |(other: ReadOnlySet<T>): TreeSet<T> {
        let result = this.clone()
        result.add(all: other)
        return result
    }













    /**
     * @throws NoneValueException
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    public operator func -(other: ReadOnlySet<T>): TreeSet<T> {
        let result = TreeSet<T>()
        for (key in this.map.keys() where !other.contains(key)) {
            result.add(key)
        }
        return result
    }
}

class IteratorForSet<T> <: Iterator<T> where T <: Comparable<T> {
    private let it: Iterator<(T, Unit)>

    init(it: Iterator<(T, Unit)>) {
        this.it = it
    }

    @Frozen
    public func next(): Option<T> {
        return it.next()?[0]
    }
}



extend<T> TreeSet<T> <: Equatable<TreeSet<T>> {
    
    public operator func ==(that: TreeSet<T>): Bool {
        if (this.size != that.size) {
            return false
        }
        let iThis = this.iterator()
        let iThat = that.iterator()
        for (_ in 0..this.size where iThis.next() != iThat.next()) {
            return false
        }
        return true
    }

    
    public operator func !=(that: TreeSet<T>): Bool {
        return !(this == that)
    }
}

extend<T> TreeSet<T> <: ToString where T <: ToString {
    /**
     * @throws NoneValueException
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    public func toString(): String {
        return collectionToString<TreeSet<T>, T>(this)
    }
}
