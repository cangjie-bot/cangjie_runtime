









package std.collection

public interface ReadOnlySet<T> <: Collection<T> {
    func contains(element: T): Bool
    func contains(all!: Collection<T>): Bool
    func subsetOf(other: ReadOnlySet<T>): Bool
}





public interface Set<T> <: ReadOnlySet<T> {







    func add(element: T): Bool







    func add(all!: Collection<T>): Unit






    func remove(element: T): Bool






    func remove(all!: Collection<T>): Unit






    func removeIf(predicate: (T) -> Bool): Unit




    func clear(): Unit






    func retain(all!: Set<T>): Unit
}

public interface OrderedSet<T> <: Set<T> {
    prop first: ?T
    prop last: ?T
    func removeFirst(): ?T
    func removeLast(): ?T
    func backward(mark: T, inclusive!: Bool): Iterator<T>
    func forward(mark: T, inclusive!: Bool): Iterator<T>
}
