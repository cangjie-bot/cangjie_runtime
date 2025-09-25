









package std.collection



public interface Stack<T> <: Collection<T> {



    /*
     * @noThrow
     */
    func peek(): ?T



    /*
     * @noThrow
     */
    func remove(): ?T




    /*
     * @noThrow
     */
    func add(element: T): Unit
}
