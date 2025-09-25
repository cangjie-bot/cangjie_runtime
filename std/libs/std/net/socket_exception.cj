








package std.net

import std.io.*


public class SocketException <: IOException {
    public init() {
        super()
    }
    public init(message: String) {
        super(message)
    }
    protected override func getClassName(): String {
        return "SocketException"
    }

    static func throwClosedException(): Nothing {
        throw SocketException("Socket is already closed")
    }

    static func notYetConnected(): Nothing {
        throw SocketException("Socket is not connected")
    }

    static func notYetBound(): Nothing {
        throw SocketException("Socket is not bound")
    }

    static func notYetBoundNeedBind(): Nothing {
        throw SocketException("The socket is not bound: invoke bind() first.")
    }

    static func alreadyBound(): Nothing {
        throw SocketException("The socket is already bound")
    }

    static func alreadyConnected(): Nothing {
        throw SocketException("The socket is already connected")
    }
}


public class SocketTimeoutException <: Exception {
    public init() {
        super()
    }
    public init(message: String) {
        super(message)
    }
    protected override func getClassName(): String {
        return "SocketTimeoutException"
    }
}
