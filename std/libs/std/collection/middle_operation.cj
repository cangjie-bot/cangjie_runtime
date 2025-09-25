









package std.collection






/*
 * @noThrow
 */
public func enumerate<T>(it: Iterable<T>): Iterator<(Int64, T)> {
    return it.iterator().enumerate()
}






@Frozen
/*
 * @noThrow
 */
public func filter<T>(predicate: (T) -> Bool): (Iterable<T>) -> Iterator<T> {
    return {it: Iterable<T> => it.iterator().filter(predicate)}
}






/*
 * @noThrow
 */
public func filterMap<T, R>(transform: (T) -> ?R): (Iterable<T>) -> Iterator<R> {
    return {it: Iterable<T> => it.iterator().filterMap<R>(transform)}
}






@Frozen
/*
 * @noThrow
 */
public func map<T, R>(transform: (T) -> R): (Iterable<T>) -> Iterator<R> {
    return {it: Iterable<T> => it.iterator().map<R>(transform)}
}






/*
 * @noThrow
 */
public func flatten<T, R>(it: Iterable<T>): Iterator<R> where T <: Iterable<R> {
    return FlattenIterator<T, R>(it)
}






/*
 * @noThrow
 */
public func flatMap<T, R>(transform: (T) -> Iterable<R>): (Iterable<T>) -> Iterator<R> {
    return {it: Iterable<T> => FlatMapIterator<T, R>(it, transform)}
}






/*
 * @noThrow
 */
public func zip<T, R>(other: Iterable<R>): (Iterable<T>) -> Iterator<(T, R)> {
    return {it: Iterable<T> => it.iterator().zip<R>(other.iterator())}
}






@Frozen
/*
 * @noThrow
 */
public func concat<T>(other: Iterable<T>): (Iterable<T>) -> Iterator<T> {
    return {it: Iterable<T> => it.iterator().concat(other.iterator())}
}










/*
 * @throws IllegalArgumentException
 */
public func skip<T>(count: Int64): (Iterable<T>) -> Iterator<T> {
    return {it: Iterable<T> => it.iterator().skip(count)}
}






/*
 * @throws IllegalArgumentException
 */
public func take<T>(count: Int64): (Iterable<T>) -> Iterator<T> {
    return {it: Iterable<T> => it.iterator().take(count)}
}






/*
 * @throws IllegalArgumentException
 */
public func step<T>(count: Int64): (Iterable<T>) -> Iterator<T> {
    return {it: Iterable<T> => it.iterator().step(count)}
}






/*
 * @noThrow
 */
public func inspect<T>(action: (T) -> Unit): (Iterable<T>) -> Iterator<T> {
    return {it: Iterable<T> => it.iterator().inspect(action)}
}

class FlattenIterator<T, R> <: Iterator<R> where T <: Iterable<R> {
    private var subIt: Option<Iterator<R>> = None
    private let it: Iterator<T>





    /*
     * @noThrow
     */
    init(it: Iterable<T>) {
        this.it = it.iterator()
    }




    @Frozen
    /*
     * @noThrow
     */
    public func next(): Option<R> {




        while (true) {
            match (subIt) {
                case Some(result) => match (result.next()) {
                    case Some(v) => return Some(v)
                    case _ => ()
                }
                case _ => ()
            }

            match (it.next()) {
                case Some(sub) => subIt = Some(sub.iterator())
                case _ => return None
            }
        }
        return None
    }
}

class FlatMapIterator<T, R> <: Iterator<R> {
    private var subIt: Option<Iterator<R>> = None
    private let transform: (T) -> Iterable<R>
    private let it: Iterator<T>







    /*
     * @noThrow
     */
    init(it: Iterable<T>, transform: (T) -> Iterable<R>) {
        this.it = it.iterator()
        this.transform = transform
    }




    @Frozen
    /*
     * @noThrow
     */
    public func next(): Option<R> {




        while (true) {
            match (subIt) {
                case Some(result) => match (result.next()) {
                    case Some(v) => return Some(v)
                    case _ => ()
                }
                case _ => ()
            }

            match (it.next()) {
                case Some(sub) => subIt = Some(transform(sub).iterator())
                case _ => return None
            }
        }
        return None
    }
}
