









package std.collection




public interface Deque<T> <: Collection<T> {




    prop first: ?T




    prop last: ?T




    func addFirst(element: T): Unit




    func addLast(element: T): Unit




    func removeFirst(): ?T




    func removeLast(): ?T
}



public interface Queue<T> <: Collection<T> {




    func add(element: T): Unit



    func peek(): ?T



    func remove(): ?T
}
