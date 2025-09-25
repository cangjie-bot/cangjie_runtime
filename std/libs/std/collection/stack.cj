









package std.collection



public interface Stack<T> <: Collection<T> {



    func peek(): ?T



    func remove(): ?T




    func add(element: T): Unit
}
