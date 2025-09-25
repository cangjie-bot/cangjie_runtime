









package std.collection

public interface ReadOnlySet<T> <: Collection<T> {
    /*
     * @noThrow
     */
    func contains(element: T): Bool
    /*
     * @noThrow
     */
    func contains(all!: Collection<T>): Bool
    /*
     * @noThrow
     */
    func subsetOf(other: ReadOnlySet<T>): Bool
}





public interface Set<T> <: ReadOnlySet<T> {







    /*
     * @noThrow
     */
    func add(element: T): Bool







    /*
     * @noThrow
     */
    func add(all!: Collection<T>): Unit






    /*
     * @noThrow
     */
    func remove(element: T): Bool






    /*
     * @noThrow
     */
    func remove(all!: Collection<T>): Unit






    /*
     * @noThrow
     */
    func removeIf(predicate: (T) -> Bool): Unit




    /*
     * @noThrow
     */
    func clear(): Unit






    /*
     * @noThrow
     */
    func retain(all!: Set<T>): Unit
}

public interface OrderedSet<T> <: Set<T> {
    prop first: ?T
    prop last: ?T
    /*
     * @noThrow
     */
    func removeFirst(): ?T
    /*
     * @noThrow
     */
    func removeLast(): ?T
    /*
     * @noThrow
     */
    func backward(mark: T, inclusive!: Bool): Iterator<T>
    /*
     * @noThrow
     */
    func forward(mark: T, inclusive!: Bool): Iterator<T>
}
