






package std.unittest.common



public interface DataProvider<T> {



    /*
     * @noThrow
     */
    func provide(): Iterable<T>
}



public interface DataShrinker<T> {





    /*
     * @noThrow
     */
    func shrink(value: T): Iterable<T>
}


      /*
       * @noThrow
       */
class NoShrinker<T> <: DataShrinker<T> {




    /*
     * @noThrow
     */
    public override func shrink(_: T): Iterable<T> { [] }


    /*
     * @noThrow
     */
    static func instance(): DataShrinker<T> {
        NoShrinker<T>()
    }
}



public interface DataStrategy<T> {




    /*
     * @noThrow
     */
    func provider(configuration: Configuration): DataProvider<T>




    /*
     * @noThrow
     */
    func shrinker(configuration: Configuration): DataShrinker<T> {
        NoShrinker<T>.instance()
    }



    prop isInfinite: Bool {
        /*
         * @noThrow
         */
        get() { false }
    }
}







extend<T> Array<T> <: DataStrategy<T> & DataProvider<T> {



    /*
     * @noThrow
     */
    public func provide(): Iterable<T> { this }



    public prop isInfinite: Bool {
        /*
         * @noThrow
         */
        get() { false }
    }



    /*
     * @noThrow
     */
    public func provider(_: Configuration): DataProvider<T> { this }
}







extend<T> Range<T> <: DataStrategy<T> & DataProvider<T> {



    /*
     * @noThrow
     */
    public func provide(): Iterable<T> { this }



    public prop isInfinite: Bool {
        /*
         * @noThrow
         */
        get() { false }
    }



    /*
     * @noThrow
     */
    public func provider(_: Configuration): DataProvider<T> { this }
}
