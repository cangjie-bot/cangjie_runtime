







package std.reflect

public open class ReflectException <: Exception {
    public init() {
        super()
    }

    public init(message: String) {
        super(message)
    }

    protected override open func getClassName(): String {
        return "ReflectException "
    }
}

public class InfoNotFoundException <: ReflectException {
    public init() {
        super()
    }

    public init(message: String) {
        super(message)
    }

    protected override func getClassName(): String {
        return "InfoNotFoundException"
    }
}

public class MisMatchException <: ReflectException {
    public init() {
        super()
    }

    public init(message: String) {
        super(message)
    }

    protected override func getClassName(): String {
        return "MisMatchException"
    }
}

public class IllegalSetException <: ReflectException {
    public init() {
        super()
    }

    public init(message: String) {
        super(message)
    }

    protected override func getClassName(): String {
        return "IllegalSetException"
    }
}

public class IllegalTypeException <: ReflectException {
    public init() {
        super()
    }

    public init(message: String) {
        super(message)
    }

    protected override func getClassName(): String {
        return "IllegalTypeException"
    }
}

public class InvocationTargetException <: ReflectException {
    public init() {
        super()
    }

    public init(message: String) {
        super(message)
    }

    protected override func getClassName(): String {
        return "InvocationTargetException"
    }
}
