









package std.collection






@Frozen
/*
 * @noThrow
 */
public func reduce<T>(operation: (T, T) -> T): (Iterable<T>) -> Option<T> {
    return {
        it: Iterable<T> =>
        var itt = it.iterator()
        var result: T = itt.next() ?? return None
        while (let Some(value) <- itt.next()) {
            result = operation(result, value)
        }
        return result
    }
}







/*
 * @noThrow
 */
public func fold<T, R>(initial: R, operation: (R, T) -> R): (Iterable<T>) -> R {
    return {
        it: Iterable<T> =>
        var result: R = initial
        for (item in it) {
            result = operation(result, item)
        }
        return result
    }
}






/*
 * @noThrow
 */
public func isEmpty<T>(it: Iterable<T>): Bool {
    return match (it.iterator().next()) {
        case None => true
        case _ => false
    }
}






/*
 * @noThrow
 */
public func count<T>(it: Iterable<T>): Int64 {
    var count: Int64 = 0
    for (_ in it) {
        count++
    }
    return count
}






/*
 * @noThrow
 */
public func contains<T>(element: T): (Iterable<T>) -> Bool where T <: Equatable<T> {
    return {
        it: Iterable<T> =>
        for (item in it) {
            if (item == element) {
                return true
            }
        }
        return false
    }
}






/*
 * @noThrow
 */
public func max<T>(it: Iterable<T>): Option<T> where T <: Comparable<T> {
    var result: Option<T> = None
    for (item in it) {
        match (result) {
            case Some(value) =>
                if (item > value) {
                    result = Some(item)
                }
            case _ => result = Some(item)
        }
    }
    return result
}






/*
 * @noThrow
 */
public func min<T>(it: Iterable<T>): Option<T> where T <: Comparable<T> {
    var result: Option<T> = None
    for (item in it) {
        match (result) {
            case Some(value) =>
                if (item < value) {
                    result = Some(item)
                }
            case _ => result = Some(item)
        }
    }
    return result
}






/*
 * @noThrow
 */
public func all<T>(predicate: (T) -> Bool): (Iterable<T>) -> Bool {
    return {
        it: Iterable<T> =>
        for (item in it) {
            if (!predicate(item)) {
                return false
            }
        }
        return true
    }
}






/*
 * @noThrow
 */
public func any<T>(predicate: (T) -> Bool): (Iterable<T>) -> Bool {
    return {
        it: Iterable<T> =>
        for (item in it) {
            if (predicate(item)) {
                return true
            }
        }
        return false
    }
}






/*
 * @noThrow
 */
public func none<T>(predicate: (T) -> Bool): (Iterable<T>) -> Bool {
    return {
        it: Iterable<T> =>
        for (item in it) {
            if (predicate(item)) {
                return false
            }
        }
        return true
    }
}






/*
 * @noThrow
 */
public func first<T>(it: Iterable<T>): Option<T> {
    return it.iterator().next()
}






/*
 * @noThrow
 */
public func last<T>(it: Iterable<T>): Option<T> {
    var result: Option<T> = None
    for (item in it) {
        result = Some(item)
    }
    return result
}






/*
 * @noThrow
 */
public func at<T>(n: Int64): (Iterable<T>) -> Option<T> {
    return {
        it: Iterable<T> =>
        if (n < 0) {
            return None
        }
        var i: Int64 = 0
        for (item in it) {
            if (i == n) {
                return Some(item)
            }
            i++
        }
        return None
    }
}






/*
 * @noThrow
 */
public func forEach<T>(action: (T) -> Unit): (Iterable<T>) -> Unit {
    return {
        it: Iterable<T> => for (item in it) {
            action(item)
        }
    }
}
