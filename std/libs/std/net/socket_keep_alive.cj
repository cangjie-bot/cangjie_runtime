







package std.net


public struct SocketKeepAliveConfig <: ToString & Equatable<SocketKeepAliveConfig> {


    public let idle: Duration


    public let interval: Duration


    public let count: UInt32






    /*
     * @throws ArithmeticException
     * @throws IllegalArgumentException
     */
    public init(
        idle!: Duration = Duration.second * 45,
        interval!: Duration = Duration.second * 5,
        count!: UInt32 = 5
    ) {
        this.idle = idle.throwIfNegative("Idle")
        this.interval = interval.throwIfNegative("Interval")
        this.count = count
    }

    /*
     * @noThrow
     */
    public override func toString(): String {
        "SocketKeepAliveConfig(idle: ${idle}, interval: ${interval}, count: ${count})"
    }

    /*
     * @noThrow
     */
    public override operator func ==(other: SocketKeepAliveConfig): Bool {
        idle == other.idle && interval == other.interval && count == other.count
    }

    /*
     * @noThrow
     */
    public override operator func !=(other: SocketKeepAliveConfig): Bool {
        !(this == other)
    }
}
