






package std.unittest.common



public interface DataProvider<T> {



    func provide(): Iterable<T>
}



public interface DataShrinker<T> {





    func shrink(value: T): Iterable<T>
}


class NoShrinker<T> <: DataShrinker<T> {




    public override func shrink(_: T): Iterable<T> { [] }


    static func instance(): DataShrinker<T> {
        NoShrinker<T>()
    }
}



public interface DataStrategy<T> {




    func provider(configuration: Configuration): DataProvider<T>




    func shrinker(configuration: Configuration): DataShrinker<T> {
        NoShrinker<T>.instance()
    }



    prop isInfinite: Bool {
        get() { false }
    }
}







extend<T> Array<T> <: DataStrategy<T> & DataProvider<T> {



    public func provide(): Iterable<T> { this }



    public prop isInfinite: Bool {
        get() { false }
    }



    public func provider(_: Configuration): DataProvider<T> { this }
}







extend<T> Range<T> <: DataStrategy<T> & DataProvider<T> {



    public func provide(): Iterable<T> { this }



    public prop isInfinite: Bool {
        get() { false }
    }



    public func provider(_: Configuration): DataProvider<T> { this }
}
