









package std.collection






public func collectString<T>(delimiter!: String = ""): (Iterable<T>) -> String where T <: ToString {
    return {
        it: Iterable<T> =>
        let iter = it.iterator()
        let first = iter.next()
        let builder = StringBuilder()
        match (first) {
            case Some(item) => builder.append(item.toString())
            case None => return ""
        }
        while (true) {
            match (iter.next()) {
                case Some(item) =>
                    builder.append(delimiter)
                    builder.append(item.toString())
                case None => break
            }
        }
        return builder.toString()
    }
}






@Frozen
public func collectArray<T>(it: Iterable<T>): Array<T> {
    return collectArrayList<T>(it).toArray()
}






@Frozen
public func collectArrayList<T>(it: Iterable<T>): ArrayList<T> {
    let collector: ArrayList<T> = ArrayList<T>()
    for (item in it) {
        collector.add(item)
    }
    return collector
}






@Frozen
public func collectHashSet<T>(it: Iterable<T>): HashSet<T> where T <: Hashable & Equatable<T> {
    let set: HashSet<T> = HashSet<T>()
    for (item in it) {
        set.add(item)
    }
    return set
}






@Frozen
public func collectHashMap<K, V>(it: Iterable<(K, V)>): HashMap<K, V> where K <: Hashable & Equatable<K> {
    let map: HashMap<K, V> = HashMap<K, V>()
    for ((key, value) in it) {
        map.add(key, value)
    }
    return map
}
