






package std.unittest.mock




public abstract class ArgumentMatcher {
    private var description: Option<String> = None
    private var parameterName: Option<String> = None

    ArgumentMatcher() {}

    func getDescription(): Option<String> {
        description
    }



    public func withDescription(description: String): ArgumentMatcher {
        this.description = Some(description)
        return this
    }

    func getParameterName(): Option<String> {
        parameterName
    }



    public func forParameter(name: String): ArgumentMatcher {
        this.parameterName = Some(name)
        return this
    }



    public func matchesAny(arg: Any): Bool
}



interface ListeningMatcher {
    prop valueListener: Option<ListenerInternal>
}


public abstract class TypedMatcher<T> <: ArgumentMatcher {
    TypedMatcher(
        private let expectedBooleanValue: Bool
    ) {}



    public func matches(arg: T): Bool

    public override func matchesAny(arg: Any): Bool {
        match (unwrapValue<T>(arg)) {
            case Some(typed) => matches(typed) == expectedBooleanValue
            case None => !expectedBooleanValue
        }
    }
}

class PredicateMatcher<T> <: TypedMatcher<T> & ListeningMatcher {
    PredicateMatcher(
        private let predicate: (T) -> Bool,
        private let expectedBooleanValue!: Bool = true,
        private let listener!: Option<ListenerInternal> = None
    ) {
        super(expectedBooleanValue)
    }

    public override func matches(arg: T): Bool {
        return predicate(arg)
    }

    public prop valueListener: Option<ListenerInternal> {
        get() { listener }
    }
}


public class AnyMatcher <: ArgumentMatcher {
    public func matchesAny(_: Any) {
        return true
    }
}



public class Matchers {
    private Matchers() {}




    public static func argThat<T>(predicate: (T) -> Bool): TypedMatcher<T> {
        return PredicateMatcher(predicate, expectedBooleanValue: true)
    }




    public static func argThatNot<T>(predicate: (T) -> Bool): TypedMatcher<T> {
        return PredicateMatcher(predicate, expectedBooleanValue: false)
    }








    /**
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     * @throws MockFrameworkException
     */
    public static func argThat<T>(listener: ValueListener<T>, predicate: (T) -> Bool): TypedMatcher<T> {
        if (let Some(listener) <- (listener as ListenerInternal)) {
            return PredicateMatcher<T>(predicate, expectedBooleanValue: true, listener: Some(listener))
        } else {
            illegalInput("Invalid value listener instance")
        }
    }





    public static func same<T>(target: T): TypedMatcher<T> where T <: Object {
        return argThat<T> {
            arg: T => refEq(target, arg)
        }
    }





    public static func eq<T>(target: T): TypedMatcher<T> where T <: Equatable<T> {
        return argThat<T> {
            arg: T => target == arg
        }
    }




    public static func ofType<T>(): TypedMatcher<T> {
        return argThat<T> {
            arg: T => true
        }
    }




    public static func any(): AnyMatcher {
        return AnyMatcher()
    }






    /**
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     * @throws MockFrameworkException
     */
    public static func capture<T>(listener: ValueListener<T>): TypedMatcher<T> {
        if (let Some(listener) <- (listener as ListenerInternal)) {
            return PredicateMatcher<T>({any: T => true}, listener: listener)
        } else {
            illegalInput("Invalid value listener instance")
        }
    }








    /**
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     * @throws MockFrameworkException
     */
    public static func default<T>(target: T): TypedMatcher<T> {
        match (target) {
            case equatable: Equatable<T> =>
                argThat<T> {
                    arg: T => equatable == arg
                }
            case targetObj: Object =>
                argThat<T> {
                    arg : T =>
                        match (arg) {
                            case argObj: Object => refEq(targetObj, argObj)
                            case _ => false
                        }
                }
            case _ => illegalInput("Argument of default matcher should be equatable or reference type")
        }
    }
}



extend<T> TypedMatcher<T> {
    public func value(): T {
        return unsafe { zeroValue<T>() }
    }
}

extend AnyMatcher {
    public func value<T>(): T {
        return unsafe { zeroValue<T>() }
    }
}
