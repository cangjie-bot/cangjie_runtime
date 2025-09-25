






package std.ref

/*
 * @noThrow
 */
func getEagerWeakRefPolicy(): CleanupPolicy {
    return EAGER
}

/*
 * @noThrow
 */
func getDeferredWeakRefPolicy(): CleanupPolicy {
    return DEFERRED
}


sealed abstract class WeakRefBase {
    var _value: Option<Object>

    let _cleanupPolicy: CleanupPolicy

    /*
     * @noThrow
     */
    init(value: Option<Object>, cleanupPolicy: CleanupPolicy) {
        _value = value
        _cleanupPolicy = cleanupPolicy
    }
}






public enum CleanupPolicy <: Equatable<CleanupPolicy> {
    EAGER | DEFERRED

    /*
     * @noThrow
     */
    public operator func ==(that: CleanupPolicy): Bool {
        match ((this, that)) {
            case (EAGER, EAGER) => true
            case (DEFERRED, DEFERRED) => true
            case _ => false
        }
    }

    /*
     * @noThrow
     */
    public operator func !=(that: CleanupPolicy): Bool {
        !(this == that)
    }
}



public class WeakRef<T> <: WeakRefBase where T <: Object {


    /*
     * @noThrow
     */
    public init(value: T, cleanupPolicy: CleanupPolicy) {
        super(Some(value), cleanupPolicy)
    }


    public prop cleanupPolicy: CleanupPolicy {
        /*
         * @noThrow
         */
        get() {
            _cleanupPolicy
        }
    }



    public prop value: Option<T> {
        /*
         * @throws NoneValueException
         */
        get() {
            match (_value) {
                case Some(x) => Some((x as T).getOrThrow())
                case None => None
            }
        }
    }


    /*
     * @noThrow
     */
    public func clear(): Unit {
        _value = None
    }
}
