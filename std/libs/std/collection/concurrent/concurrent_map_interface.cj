







package std.collection.concurrent

import std.collection.MapEntryView



public interface ConcurrentMap<K, V> {








    /*
     * @noThrow
     */
    func get(key: K): ?V








    /*
     * @noThrow
     */
    func contains(key: K): Bool










    @Deprecated[message: "Use member function `func add(key: K, value: V): ?V` instead."]
    /*
     * @noThrow
     */
    func put(key: K, value: V): ?V
    /*
     * @noThrow
     */
    func add(key: K, value: V): ?V













    @Deprecated[message: "Use member function `func addIfAbsent(key: K, value: V): ?V` instead."]
    /*
     * @noThrow
     */
    func putIfAbsent(key: K, value: V): ?V
    /*
     * @noThrow
     */
    func addIfAbsent(key: K, value: V): ?V








    /*
     * @noThrow
     */
    func remove(key: K): ?V











    @Deprecated[message: "Use member function `func entryView(key: K, fn: (MapEntryView<K, V>)->Unit): ?V` instead."]
    /*
     * @noThrow
     */
    func remove(key: K, predicate: (V) -> Bool): ?V













    /*
     * @noThrow
     */
    func replace(key: K, value: V): ?V














    @Deprecated[message: "Use member function `func entryView(key: K, fn: (MapEntryView<K, V>)->Unit): ?V` instead."]
    /*
     * @noThrow
     */
    func replace(key: K, eval: (V) -> V): ?V













    @Deprecated[message: "Use member function `func entryView(key: K, fn: (MapEntryView<K, V>)->Unit): ?V` instead."]
    /*
     * @noThrow
     */
    func replace(key: K, predicate: (V) -> Bool, eval: (V) -> V): ?V










    /*
     * @noThrow
     */
    func entryView(key: K, fn: (MapEntryView<K, V>) -> Unit): ?V







    /*
     * @noThrow
     */
    operator func [](key: K): V






    /*
     * @noThrow
     */
    operator func [](key: K, value!: V): Unit
}
