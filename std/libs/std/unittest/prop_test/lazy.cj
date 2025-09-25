






package std.unittest.prop_test




enum Thunk<T> {
      /*
       * @noThrow
       */
    | Uncalculated(() -> ?T)
      /*
       * @noThrow
       */
    | Calculated(T)
    | EmptyThunk

    /*
     * @noThrow
     */
    func get(): ?T {
        match (this) {
            case Calculated(value) => value
            case _ => None
        }
    }
    /*
     * @noThrow
     */
    func force(): Thunk<T> {
        match (this) {
            case EmptyThunk | Calculated(_) => this
            case Uncalculated(fun) =>
                match (fun()) {
                    case None => EmptyThunk
                    case Some(x) => Calculated(x)
                }
        }
    }
}



struct Lazy<T> {


    private var thunk: Thunk<T>


    /*
     * @noThrow
     */
    init(value: T) {
        thunk = Calculated(value)
    }


    /*
     * @noThrow
     */
    init(fun: () -> ?T) {
        thunk = Uncalculated(fun)
    }


    /*
     * @noThrow
     */
    init() {
        thunk = EmptyThunk
    }




    /*
     * @noThrow
     */
    public mut func get(): ?T {
        thunk = thunk.force()
        thunk.get()
    }


    /*
     * @noThrow
     */
    static func flat<T>(body: () -> Lazy<T>): Lazy<T> {
        Lazy<T> {
            var res = body()
            match (res.thunk) {
                case Calculated(v) => v
                case Uncalculated(f) => f()
                case EmptyThunk => None
            }
        }
    }
}
