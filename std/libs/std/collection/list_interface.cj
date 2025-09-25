









package std.collection

public interface ReadOnlyList<T> <: Collection<T> {
    prop first: ?T
    prop last: ?T
    /*
     * @noThrow
     */
    func get(index: Int64): ?T
    /*
     * @noThrow
     */
    operator func [](index: Int64): T
}

public interface List<T> <: ReadOnlyList<T> {
    /*
     * @noThrow
     */
    func add(element: T): Unit
    /*
     * @noThrow
     */
    func add(all!: Collection<T>): Unit
    /*
     * @noThrow
     */
    func add(element: T, at!: Int64): Unit
    /*
     * @noThrow
     */
    func add(all!: Collection<T>, at!: Int64): Unit
    /*
     * @noThrow
     */
    func remove(at!: Int64): T
    /*
     * @noThrow
     */
    func remove(range: Range<Int64>): Unit
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
    operator func [](index: Int64, value!: T): Unit
}
