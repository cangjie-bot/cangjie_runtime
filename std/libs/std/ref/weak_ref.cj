






package std.ref

func getEagerWeakRefPolicy(): CleanupPolicy {
    return EAGER
}

func getDeferredWeakRefPolicy(): CleanupPolicy {
    return DEFERRED
}


sealed abstract class WeakRefBase {
    var _value: Option<Object>

    let _cleanupPolicy: CleanupPolicy

    init(value: Option<Object>, cleanupPolicy: CleanupPolicy) {
        _value = value
        _cleanupPolicy = cleanupPolicy
    }
}






public enum CleanupPolicy <: Equatable<CleanupPolicy> {
    EAGER | DEFERRED

    public operator func ==(that: CleanupPolicy): Bool {
        match ((this, that)) {
            case (EAGER, EAGER) => true
            case (DEFERRED, DEFERRED) => true
            case _ => false
        }
    }

    public operator func !=(that: CleanupPolicy): Bool {
        !(this == that)
    }
}



public class WeakRef<T> <: WeakRefBase where T <: Object {


    public init(value: T, cleanupPolicy: CleanupPolicy) {
        super(Some(value), cleanupPolicy)
    }


    public prop cleanupPolicy: CleanupPolicy {
        get() {
            _cleanupPolicy
        }
    }



        /**
         * @throws NoneValueException
         */
    public prop value: Option<T> {
        get() {
            match (_value) {
                case Some(x) => Some((x as T).getOrThrow())
                case None => None
            }
        }
    }


    public func clear(): Unit {
        _value = None
    }
}
