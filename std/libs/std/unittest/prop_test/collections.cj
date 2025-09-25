






package std.unittest.prop_test





class EmptyIterator<T> <: Iterator<T> {
    public override func next(): ?T { None }
}


public func emptyIterable<T>(): Iterable<T> { EmptyIterator<T>() }
