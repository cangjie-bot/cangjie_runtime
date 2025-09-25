






package std.unittest.prop_test




enum Thunk<T> {
    | Uncalculated(() -> ?T)
    | Calculated(T)
    | EmptyThunk

    func get(): ?T {
        match (this) {
            case Calculated(value) => value
            case _ => None
        }
    }
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


    init(value: T) {
        thunk = Calculated(value)
    }


    init(fun: () -> ?T) {
        thunk = Uncalculated(fun)
    }


    init() {
        thunk = EmptyThunk
    }




    public mut func get(): ?T {
        thunk = thunk.force()
        thunk.get()
    }


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
