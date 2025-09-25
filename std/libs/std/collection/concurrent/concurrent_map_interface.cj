







package std.collection.concurrent

import std.collection.MapEntryView



public interface ConcurrentMap<K, V> {








    func get(key: K): ?V








    func contains(key: K): Bool










    @Deprecated[message: "Use member function `func add(key: K, value: V): ?V` instead."]
    func put(key: K, value: V): ?V
    func add(key: K, value: V): ?V













    @Deprecated[message: "Use member function `func addIfAbsent(key: K, value: V): ?V` instead."]
    func putIfAbsent(key: K, value: V): ?V
    func addIfAbsent(key: K, value: V): ?V








    func remove(key: K): ?V











    @Deprecated[message: "Use member function `func entryView(key: K, fn: (MapEntryView<K, V>)->Unit): ?V` instead."]
    func remove(key: K, predicate: (V) -> Bool): ?V













    func replace(key: K, value: V): ?V














    @Deprecated[message: "Use member function `func entryView(key: K, fn: (MapEntryView<K, V>)->Unit): ?V` instead."]
    func replace(key: K, eval: (V) -> V): ?V













    @Deprecated[message: "Use member function `func entryView(key: K, fn: (MapEntryView<K, V>)->Unit): ?V` instead."]
    func replace(key: K, predicate: (V) -> Bool, eval: (V) -> V): ?V










    func entryView(key: K, fn: (MapEntryView<K, V>) -> Unit): ?V







    operator func [](key: K): V






    operator func [](key: K, value!: V): Unit
}
