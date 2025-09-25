






package std.unittest.prop_test





      /*
       * @noThrow
       */
class EmptyIterator<T> <: Iterator<T> {
    /*
     * @noThrow
     */
    public override func next(): ?T { None }
}


/*
 * @noThrow
 */
public func emptyIterable<T>(): Iterable<T> { EmptyIterator<T>() }
