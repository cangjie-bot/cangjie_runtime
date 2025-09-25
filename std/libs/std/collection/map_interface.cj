









package std.collection

public interface MapEntryView<K, V> {
    prop key: K
    mut prop value: ?V
}

public interface ReadOnlyMap<K, V> <: Collection<(K, V)> {
    /*
     * @noThrow
     */
    func get(key: K): ?V
    /*
     * @noThrow
     */
    func contains(key: K): Bool
    /*
     * @noThrow
     */
    func contains(all!: Collection<K>): Bool
    /*
     * @noThrow
     */
    func keys(): EquatableCollection<K>
    /*
     * @noThrow
     */
    func values(): Collection<V>

    /*
     * @noThrow
     */
    operator func [](key: K): V
}





public interface Map<K, V> <: ReadOnlyMap<K, V> {







    /*
     * @noThrow
     */
    func add(key: K, value: V): ?V







    /*
     * @noThrow
     */
    func add(all!: Collection<(K, V)>): Unit







    /*
     * @noThrow
     */
    func remove(key: K): Option<V>






    /*
     * @noThrow
     */
    func remove(all!: Collection<K>): Unit






    /*
     * @noThrow
     */
    func removeIf(predicate: (K, V) -> Bool): Unit




    /*
     * @noThrow
     */
    func clear(): Unit







    /*
     * @noThrow
     */
    operator func [](key: K, value!: V): Unit

    /*
     * @noThrow
     */
    func entryView(k: K): MapEntryView<K, V>











    @Frozen
    /*
     * @noThrow
     */
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
    /*
     * @noThrow
     */
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







    /*
     * @noThrow
     */
    func contains(element: T): Bool







    /*
     * @noThrow
     */
    func contains(all!: Collection<T>): Bool
}

public interface OrderedMap<K, V> <: Map<K, V> {
    prop first: ?(K, V)
    prop last: ?(K, V)
    /*
     * @noThrow
     */
    func removeFirst(): ?(K, V)
    /*
     * @noThrow
     */
    func removeLast(): ?(K, V)

    /*
     * @noThrow
     */
    func backward(mark: K, inclusive!: Bool): Iterator<(K, V)>
    /*
     * @noThrow
     */
    func forward(mark: K, inclusive!: Bool): Iterator<(K, V)>
}
