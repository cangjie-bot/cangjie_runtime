









package std.collection











public class HashSet<T> <: Set<T> where T <: Hashable & Equatable<T> {
    
    private var map: HashMap<T, Unit>





    @Frozen
    /*
     * @noThrow
     */
    public init() {
        map = HashMap<T, Unit>()
    }






    @Frozen
    /*
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    public init(elements: Collection<T>) {
        this.map = HashMap<T, Unit>(elements.size)
        for (i in elements) {
            this.map.putWithoutResize(i, ())
        }
    }






    @Frozen
    /*
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    public init(elements: Array<T>) {
        this.map = HashMap<T, Unit>(elements.size)
        for (i in elements) {
            this.map.putWithoutResize(i, ())
        }
    }






    @Frozen
    /*
     * @throws IllegalArgumentException
     */
    public init(capacity: Int64) {
        this.map = HashMap<T, Unit>(capacity)
    }







    @Frozen
    /*
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    public init(size: Int64, initElement: (Int64) -> T) {
        this.map = HashMap<T, Unit>(size, {i => (initElement(i), ())})
    }







    @Frozen
    /*
     * @throws IndexOutOfBoundsException
     */
    public func contains(element: T): Bool {
        return map.contains(element)
    }







    @Frozen
    /*
     * @noThrow
     */
    public func subsetOf(other: ReadOnlySet<T>): Bool {
        for (i in this) {
            if (!other.contains(i)) {
                return false
            }
        }
        return true
    }







    @Frozen
    /*
     * @throws IndexOutOfBoundsException
     */
    public func contains(all!: Collection<T>): Bool {
        return map.contains(all: all)
    }







    @Frozen
    /*
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    public func add(element: T): Bool {
        return match (this.map.add(element, ())) {
            case None => true
            case _ => false
        }
    }






    @Frozen
    /*
     * @throws IndexOutOfBoundsException
     */
    public func remove(element: T): Bool {
        return match (map.remove(element)) {
            case None => false
            case _ => true
        }
    }







    @Frozen
    /*
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    public func add(all!: Collection<T>): Unit {
        for (i in all) {
            this.map.add(i, ())
        }
    }






    @Frozen
    /*
     * @throws IndexOutOfBoundsException
     */
    public func remove(all!: Collection<T>): Unit {
        map.remove(all: all)
    }






    @Frozen
    /*
     * @throws IndexOutOfBoundsException
     * @throws ConcurrentModificationException
     */
    public func removeIf(predicate: (T) -> Bool): Unit {
        this.map.removeIf({k, _ => predicate(k)})
    }




    @Frozen
    /*
     * @throws IndexOutOfBoundsException
     */
    public func clear(): Unit {
        this.map.clear()
    }










    @Frozen
    /*
     * @throws IndexOutOfBoundsException
     * @throws ConcurrentModificationException
     */
    public func retain(all!: Set<T>): Unit {
        let it: HashMapIterator<T, Unit> = this.map.iterator()
        for ((k, _) in it where !all.contains(k)) {
            it.remove()
        }
    }






    @Frozen
    /*
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    public func clone(): HashSet<T> {
        return HashSet<T>(this)
    }








    @Frozen
    /*
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    public func reserve(additional: Int64): Unit {
        this.map.reserve(additional)
    }






    @Frozen
    public prop capacity: Int64 {
        /*
         * @noThrow
         */
        get() {
            return this.map.capacity
        }
    }






    @Frozen
    /*
     * @noThrow
     */
    public func iterator(): Iterator<T> {
        return this.map.keys().iterator()
    }






    @Frozen
    public prop size: Int64 {
        /*
         * @noThrow
         */
        get() {
            return this.map.size
        }
    }






    @Frozen
    /*
     * @noThrow
     */
    public func isEmpty(): Bool {
        return map.isEmpty()
    }




    @Frozen
    /*
     * @noThrow
     */
    public func toArray(): Array<T> {
        return map.keys().toArray()
    }













    @Frozen
    /*
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    public operator func &(other: ReadOnlySet<T>): HashSet<T> {
        let result = HashSet<T>()
        for (key in this.map.keys() where other.contains(key)) {
            result.add(key)
        }
        return result
    }













    @Frozen
    /*
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    public operator func |(other: ReadOnlySet<T>): HashSet<T> {
        let result = this.clone()
        result.add(all: other)
        return result
    }













    @Frozen
    /*
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    public operator func -(other: ReadOnlySet<T>): HashSet<T> {
        let result = HashSet<T>()
        for (key in this.map.keys() where !other.contains(key)) {
            result.add(key)
        }
        return result
    }
}




extend<T> HashSet<T> <: Equatable<HashSet<T>> {
    
    @Frozen
    /*
     * @throws IndexOutOfBoundsException
     */
    public operator func ==(that: HashSet<T>): Bool {
        if (this.size != that.size) {
            return false
        }
        for (key in that where !this.contains(key)) {
            return false
        }
        return true
    }

    
    @Frozen
    /*
     * @throws IndexOutOfBoundsException
     */
    public operator func !=(that: HashSet<T>): Bool {
        return !(this == that)
    }
}

extend<T> HashSet<T> <: ToString where T <: ToString {
    @Frozen
    /*
     * @throws NoneValueException
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    public func toString(): String {
        return collectionToString<HashSet<T>, T>(this)
    }
}
