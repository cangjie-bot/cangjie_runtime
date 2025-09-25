






package std.unittest.mock




public abstract class ArgumentMatcher {
    private var description: Option<String> = None
    private var parameterName: Option<String> = None

    /*
     * @noThrow
     */
    ArgumentMatcher() {}

    /*
     * @noThrow
     */
    func getDescription(): Option<String> {
        description
    }



    /*
     * @noThrow
     */
    public func withDescription(description: String): ArgumentMatcher {
        this.description = Some(description)
        return this
    }

    /*
     * @noThrow
     */
    func getParameterName(): Option<String> {
        parameterName
    }



    /*
     * @noThrow
     */
    public func forParameter(name: String): ArgumentMatcher {
        this.parameterName = Some(name)
        return this
    }



    /*
     * @noThrow
     */
    public func matchesAny(arg: Any): Bool
}



interface ListeningMatcher {
    prop valueListener: Option<ListenerInternal>
}


public abstract class TypedMatcher<T> <: ArgumentMatcher {
    /*
     * @noThrow
     */
    TypedMatcher(
        private let expectedBooleanValue: Bool
    ) {}



    /*
     * @noThrow
     */
    public func matches(arg: T): Bool

    /*
     * @noThrow
     */
    public override func matchesAny(arg: Any): Bool {
        match (unwrapValue<T>(arg)) {
            case Some(typed) => matches(typed) == expectedBooleanValue
            case None => !expectedBooleanValue
        }
    }
}

class PredicateMatcher<T> <: TypedMatcher<T> & ListeningMatcher {
    /*
     * @noThrow
     */
    PredicateMatcher(
        private let predicate: (T) -> Bool,
        private let expectedBooleanValue!: Bool = true,
        private let listener!: Option<ListenerInternal> = None
    ) {
        super(expectedBooleanValue)
    }

    /*
     * @noThrow
     */
    public override func matches(arg: T): Bool {
        return predicate(arg)
    }

    public prop valueListener: Option<ListenerInternal> {
        /*
         * @noThrow
         */
        get() { listener }
    }
}


             /*
              * @noThrow
              */
public class AnyMatcher <: ArgumentMatcher {
    /*
     * @noThrow
     */
    public func matchesAny(_: Any) {
        return true
    }
}



public class Matchers {
    /*
     * @noThrow
     */
    private Matchers() {}




    /*
     * @noThrow
     */
    public static func argThat<T>(predicate: (T) -> Bool): TypedMatcher<T> {
        return PredicateMatcher(predicate, expectedBooleanValue: true)
    }




    /*
     * @noThrow
     */
    public static func argThatNot<T>(predicate: (T) -> Bool): TypedMatcher<T> {
        return PredicateMatcher(predicate, expectedBooleanValue: false)
    }








    /*
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





    /*
     * @noThrow
     */
    public static func same<T>(target: T): TypedMatcher<T> where T <: Object {
        return argThat<T> {
            arg: T => refEq(target, arg)
        }
    }





    /*
     * @noThrow
     */
    public static func eq<T>(target: T): TypedMatcher<T> where T <: Equatable<T> {
        return argThat<T> {
            arg: T => target == arg
        }
    }




    /*
     * @noThrow
     */
    public static func ofType<T>(): TypedMatcher<T> {
        return argThat<T> {
            arg: T => true
        }
    }




    /*
     * @noThrow
     */
    public static func any(): AnyMatcher {
        return AnyMatcher()
    }






    /*
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








    /*
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
    /*
     * @noThrow
     */
    public func value(): T {
        return unsafe { zeroValue<T>() }
    }
}

extend AnyMatcher {
    /*
     * @noThrow
     */
    public func value<T>(): T {
        return unsafe { zeroValue<T>() }
    }
}
