








package std.net

import std.io.*


public class SocketException <: IOException {
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
        return "SocketException"
    }

    /*
     * @throws SocketException
     */
    static func throwClosedException(): Nothing {
        throw SocketException("Socket is already closed")
    }

    /*
     * @throws SocketException
     */
    static func notYetConnected(): Nothing {
        throw SocketException("Socket is not connected")
    }

    /*
     * @throws SocketException
     */
    static func notYetBound(): Nothing {
        throw SocketException("Socket is not bound")
    }

    /*
     * @throws SocketException
     */
    static func notYetBoundNeedBind(): Nothing {
        throw SocketException("The socket is not bound: invoke bind() first.")
    }

    /*
     * @throws SocketException
     */
    static func alreadyBound(): Nothing {
        throw SocketException("The socket is already bound")
    }

    /*
     * @throws SocketException
     */
    static func alreadyConnected(): Nothing {
        throw SocketException("The socket is already connected")
    }
}


public class SocketTimeoutException <: Exception {
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
        return "SocketTimeoutException"
    }
}
