







package std.sort

import std.collection.*







@Frozen
public func sort<T>(data: Array<T>, stable!: Bool = false, descending!: Bool = false): Unit where T <: Comparable<T> {
    if (descending) {
        let comparator = {l: T, r: T => r.compare(l)}
        if (stable) {
            stableSort(data, comparator)
        } else {
            unstableSort(data, comparator)
        }
    } else {
        if (stable) {
            stableSort(data)
        } else {
            unstableSort(data)
        }
    }
}








@Frozen
public func sort<T>(data: Array<T>, by!: (T, T) -> Ordering, stable!: Bool = false, descending!: Bool = false): Unit {
    var comparator = by
    if (descending) {
        comparator = {l: T, r: T => match (by(l, r)) {
                case GT => LT
                case LT => GT
                case _ => EQ
            }
        }
    }
    if (stable) {
        stableSort(data, comparator)
    } else {
        unstableSort(data, comparator)
    }
}








public func sort<T>(data: Array<T>, lessThan!: (T, T) -> Bool, stable!: Bool = false, descending!: Bool = false): Unit {
    let comparator = {l: T, r: T => match (lessThan(l, r)) {
            case true => LT
            case false => if (lessThan(r, l)) {
                    GT
                } else {
                    EQ
                }
        }
    }
    sort(data, by: comparator, stable: stable, descending: descending)
}








public func sort<T, K>(data: Array<T>, key!: (T) -> K, stable!: Bool = false, descending!: Bool = false): Unit where K <: Comparable<K> {
    let comparator = if (descending) {
        {l: T, r: T => key(r).compare(key(l))}
    } else {
        {l: T, r: T => key(l).compare(key(r))}
    }
    if (stable) {
        stableSort(data, comparator)
    } else {
        unstableSort(data, comparator)
    }
}







public func sort<T>(data: List<T>, stable!: Bool = false, descending!: Bool = false): Unit where T <: Comparable<T> {
    var dataArray = data.toArray()
    sort(dataArray, stable: stable, descending: descending)
    data.clear()
    for (i in dataArray) {
        data.add(i)
    }
}








public func sort<T>(data: List<T>, by!: (T, T) -> Ordering, stable!: Bool = false, descending!: Bool = false): Unit {
    var dataArray = data.toArray()
    data.clear()
    sort(dataArray, by: by, stable: stable, descending: descending)
    for (i in dataArray) {
        data.add(i)
    }
}








public func sort<T>(data: List<T>, lessThan!: (T, T) -> Bool, stable!: Bool = false, descending!: Bool = false): Unit {
    var dataArray = data.toArray()
    data.clear()
    sort(dataArray, lessThan: lessThan, stable: stable, descending: descending)
    for (i in dataArray) {
        data.add(i)
    }
}








public func sort<T, K>(data: List<T>, key!: (T) -> K, stable!: Bool = false, descending!: Bool = false): Unit where K <: Comparable<K> {
    var dataArray = data.toArray()
    data.clear()
    sort(dataArray, key: key, stable: stable, descending: descending)
    for (i in dataArray) {
        data.add(i)
    }
}







public func sort<T>(data: ArrayList<T>, stable!: Bool = false, descending!: Bool = false): Unit where T <: Comparable<T> {
    unsafe {
        var dataArray = data.getRawArray()
        sort(dataArray[0..data.size], stable: stable, descending: descending)
        data.updateVersion()
    }
}








public func sort<T>(data: ArrayList<T>, by!: (T, T) -> Ordering, stable!: Bool = false, descending!: Bool = false): Unit {
    unsafe {
        var dataArray = data.getRawArray()
        sort(dataArray[0..data.size], by: by, stable: stable, descending: descending)
        data.updateVersion()
    }
}








public func sort<T>(data: ArrayList<T>, lessThan!: (T, T) -> Bool, stable!: Bool = false, descending!: Bool = false): Unit {
    unsafe {
        var dataArray = data.getRawArray()
        sort(dataArray[0..data.size], lessThan: lessThan, stable: stable, descending: descending)
        data.updateVersion()
    }
}








public func sort<T, K>(data: ArrayList<T>, key!: (T) -> K, stable!: Bool = false, descending!: Bool = false): Unit where K <: Comparable<K> {
    unsafe {
        var dataArray = data.getRawArray()
        sort(dataArray[0..data.size], key: key, stable: stable, descending: descending)
        data.updateVersion()
    }
}

@Deprecated[message: "The interface is deprecated, no substitutions."]
public interface SortByExtension<T> {






    func sortBy(comparator!: (T, T) -> Ordering): Unit







    func sortBy(stable!: Bool, comparator!: (T, T) -> Ordering): Unit
}

@Deprecated[message: "The interface is deprecated, no substitutions."]
public interface SortExtension {




    func sort(): Unit






    func sort(stable!: Bool): Unit




    func sortDescending(): Unit






    func sortDescending(stable!: Bool): Unit
}

extend<T> Array<T> <: SortByExtension<T> {
    @Deprecated[message: "Use global function `public func sort<T>(data: Array<T>, by!: (T, T) -> Ordering, stable!: Bool = false, descending!: Bool = false): Unit` instead."]
    public func sortBy(comparator!: (T, T) -> Ordering): Unit {
        unstableSort(this, comparator)
    }

    @Deprecated[message: "Use global function `public func sort<T>(data: Array<T>, by!: (T, T) -> Ordering, stable!: Bool = false, descending!: Bool = false): Unit` instead."]
    public func sortBy(stable!: Bool, comparator!: (T, T) -> Ordering): Unit {
        if (stable) {
            stableSort(this, comparator)
        } else {
            unstableSort(this, comparator)
        }
    }
}

extend<T> Array<T> <: SortExtension where T <: Comparable<T> {
    @Deprecated[message: "Use global function `public func sort<T>(data: Array<T>, stable!: Bool = false, descending!: Bool = false): Unit where T <: Comparable<T>` instead."]
    public func sort(): Unit {
        unstableSort(this)
    }

    @Deprecated[message: "Use global function `public func sort<T>(data: Array<T>, stable!: Bool = false, descending!: Bool = false): Unit where T <: Comparable<T>` instead."]
    public func sort(stable!: Bool): Unit {
        if (stable) {
            stableSort(this)
        } else {
            unstableSort(this)
        }
    }

    @Deprecated[message: "Use global function `public func sort<T>(data: Array<T>, stable!: Bool = false, descending!: Bool = false): Unit where T <: Comparable<T>` instead."]
    public func sortDescending(): Unit {
        let comparator = {l: T, r: T => r.compare(l)}
        unstableSort(this, comparator)
    }

    @Deprecated[message: "Use global function `public func sort<T>(data: Array<T>, stable!: Bool = false, descending!: Bool = false): Unit where T <: Comparable<T>` instead."]
    public func sortDescending(stable!: Bool): Unit {
        let comparator = {l: T, r: T => r.compare(l)}
        if (stable) {
            stableSort(this, comparator)
        } else {
            unstableSort(this, comparator)
        }
    }
}
