









package std.collection






public func enumerate<T>(it: Iterable<T>): Iterator<(Int64, T)> {
    return it.iterator().enumerate()
}






@Frozen
public func filter<T>(predicate: (T) -> Bool): (Iterable<T>) -> Iterator<T> {
    return {it: Iterable<T> => it.iterator().filter(predicate)}
}






public func filterMap<T, R>(transform: (T) -> ?R): (Iterable<T>) -> Iterator<R> {
    return {it: Iterable<T> => it.iterator().filterMap<R>(transform)}
}






@Frozen
public func map<T, R>(transform: (T) -> R): (Iterable<T>) -> Iterator<R> {
    return {it: Iterable<T> => it.iterator().map<R>(transform)}
}






public func flatten<T, R>(it: Iterable<T>): Iterator<R> where T <: Iterable<R> {
    return FlattenIterator<T, R>(it)
}






public func flatMap<T, R>(transform: (T) -> Iterable<R>): (Iterable<T>) -> Iterator<R> {
    return {it: Iterable<T> => FlatMapIterator<T, R>(it, transform)}
}






public func zip<T, R>(other: Iterable<R>): (Iterable<T>) -> Iterator<(T, R)> {
    return {it: Iterable<T> => it.iterator().zip<R>(other.iterator())}
}






@Frozen
public func concat<T>(other: Iterable<T>): (Iterable<T>) -> Iterator<T> {
    return {it: Iterable<T> => it.iterator().concat(other.iterator())}
}










public func skip<T>(count: Int64): (Iterable<T>) -> Iterator<T> {
    return {it: Iterable<T> => it.iterator().skip(count)}
}






public func take<T>(count: Int64): (Iterable<T>) -> Iterator<T> {
    return {it: Iterable<T> => it.iterator().take(count)}
}






public func step<T>(count: Int64): (Iterable<T>) -> Iterator<T> {
    return {it: Iterable<T> => it.iterator().step(count)}
}






public func inspect<T>(action: (T) -> Unit): (Iterable<T>) -> Iterator<T> {
    return {it: Iterable<T> => it.iterator().inspect(action)}
}

class FlattenIterator<T, R> <: Iterator<R> where T <: Iterable<R> {
    private var subIt: Option<Iterator<R>> = None
    private let it: Iterator<T>





    init(it: Iterable<T>) {
        this.it = it.iterator()
    }




    @Frozen
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







    init(it: Iterable<T>, transform: (T) -> Iterable<R>) {
        this.it = it.iterator()
        this.transform = transform
    }




    @Frozen
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
