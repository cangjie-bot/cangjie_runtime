







package std.net


public enum SocketNet <: ToString & Equatable<SocketNet> {
    | TCP
    | UDP
    | UNIX

    public func toString(): String {
        match (this) {
            case TCP => return "tcp"
            case UDP => return "udp"
            case UNIX => return "domain"
        }
    }

    public operator func ==(that: SocketNet): Bool {
        match ((this, that)) {
            case (TCP, TCP) => true
            case (UDP, UDP) => true
            case (UNIX, UNIX) => true
            case _ => false
        }
    }

    public operator func !=(that: SocketNet): Bool {
        return !(this == that)
    }
}

enum SocketMode <: Equal<SocketMode> {
    | StreamingMode
    | DatagramMode
    | SequentialMode

    public override operator func ==(other: SocketMode): Bool {
        match ((this, other)) {
            case (StreamingMode, StreamingMode) => true
            case (DatagramMode, DatagramMode) => true
            case (SequentialMode, SequentialMode) => true
            case _ => false
        }
    }
}

extend Duration {
    /**
     * @throws IllegalArgumentException
     */
    func throwIfNegative(what: String): Duration {
        if (this < Duration.Zero) {
            throw IllegalArgumentException("${what} duration cannot be negative.")
        }
        if (this > MAX_TIMEOUT_DURATION) {
            return MAX_TIMEOUT_DURATION
        }
        return this
    }

    func bumpAtLeast(other: Duration): Duration {
        if (this < other) {
            return other
        }

        return this
    }

    /**
     * @throws ArithmeticException
     */
    func toNanosecondGranularity(): Duration {
        this.toNanoseconds() * Duration.nanosecond
    }
}
