







package std.reflect

public open class ReflectException <: Exception {
    /*
     * @noThrow
     */
    public init() {
        super()
    }

    /*
     * @noThrow
     */
    public init(message: String) {
        super(message)
    }

    /*
     * @noThrow
     */
    protected override open func getClassName(): String {
        return "ReflectException "
    }
}

public class InfoNotFoundException <: ReflectException {
    /*
     * @noThrow
     */
    public init() {
        super()
    }

    /*
     * @noThrow
     */
    public init(message: String) {
        super(message)
    }

    /*
     * @noThrow
     */
    protected override func getClassName(): String {
        return "InfoNotFoundException"
    }
}

public class MisMatchException <: ReflectException {
    /*
     * @noThrow
     */
    public init() {
        super()
    }

    /*
     * @noThrow
     */
    public init(message: String) {
        super(message)
    }

    /*
     * @noThrow
     */
    protected override func getClassName(): String {
        return "MisMatchException"
    }
}

public class IllegalSetException <: ReflectException {
    /*
     * @noThrow
     */
    public init() {
        super()
    }

    /*
     * @noThrow
     */
    public init(message: String) {
        super(message)
    }

    /*
     * @noThrow
     */
    protected override func getClassName(): String {
        return "IllegalSetException"
    }
}

public class IllegalTypeException <: ReflectException {
    /*
     * @noThrow
     */
    public init() {
        super()
    }

    /*
     * @noThrow
     */
    public init(message: String) {
        super(message)
    }

    /*
     * @noThrow
     */
    protected override func getClassName(): String {
        return "IllegalTypeException"
    }
}

public class InvocationTargetException <: ReflectException {
    /*
     * @noThrow
     */
    public init() {
        super()
    }

    /*
     * @noThrow
     */
    public init(message: String) {
        super(message)
    }

    /*
     * @noThrow
     */
    protected override func getClassName(): String {
        return "InvocationTargetException"
    }
}
