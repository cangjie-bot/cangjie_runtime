









package std.collection




public interface Deque<T> <: Collection<T> {




    prop first: ?T




    prop last: ?T




    /*
     * @noThrow
     */
    func addFirst(element: T): Unit




    /*
     * @noThrow
     */
    func addLast(element: T): Unit




    /*
     * @noThrow
     */
    func removeFirst(): ?T




    /*
     * @noThrow
     */
    func removeLast(): ?T
}



public interface Queue<T> <: Collection<T> {




    /*
     * @noThrow
     */
    func add(element: T): Unit



    /*
     * @noThrow
     */
    func peek(): ?T



    /*
     * @noThrow
     */
    func remove(): ?T
}
