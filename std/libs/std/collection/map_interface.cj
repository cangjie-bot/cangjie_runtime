









package std.collection

public interface MapEntryView<K, V> {
    prop key: K
    mut prop value: ?V
}

public interface ReadOnlyMap<K, V> <: Collection<(K, V)> {
    func get(key: K): ?V
    func contains(key: K): Bool
    func contains(all!: Collection<K>): Bool
    func keys(): EquatableCollection<K>
    func values(): Collection<V>

    operator func [](key: K): V
}





public interface Map<K, V> <: ReadOnlyMap<K, V> {







    func add(key: K, value: V): ?V







    func add(all!: Collection<(K, V)>): Unit







    func remove(key: K): Option<V>






    func remove(all!: Collection<K>): Unit






    func removeIf(predicate: (K, V) -> Bool): Unit




    func clear(): Unit







    operator func [](key: K, value!: V): Unit

    func entryView(k: K): MapEntryView<K, V>











    @Frozen
    func addIfAbsent(key: K, value: V): ?V {
        var view = entryView(key)
        return match (view.value) {
            case None =>
                view.value = value
                None
            case _ => view.value
        }
    }













    @Frozen
    func replace(key: K, value: V): ?V {
        var view = entryView(key)
        return match (view.value) {
            case Some(v) =>
                view.value = value
                v
            case _ => None
        }
    }
}




public interface EquatableCollection<T> <: Collection<T> {







    func contains(element: T): Bool







    func contains(all!: Collection<T>): Bool
}

public interface OrderedMap<K, V> <: Map<K, V> {
    prop first: ?(K, V)
    prop last: ?(K, V)
    func removeFirst(): ?(K, V)
    func removeLast(): ?(K, V)

    func backward(mark: K, inclusive!: Bool): Iterator<(K, V)>
    func forward(mark: K, inclusive!: Bool): Iterator<(K, V)>
}
