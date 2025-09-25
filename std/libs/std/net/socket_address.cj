







package std.net

sealed abstract class SocketAddress <: ToString & Equatable<SocketAddress> & Hashable {
    public prop size: Int64

    public prop family: AddressFamily

    public func getAddressBytes(): Array<Byte>

    public operator func ==(rhs: SocketAddress): Bool {
        match ((this, rhs)) {
            case (lip: IPSocketAddress, rip: IPSocketAddress) => lip == rip
            case (lip: UnixSocketAddress, rip: UnixSocketAddress) => lip == rip
            case _ => false
        }
    }
    public operator func !=(rhs: SocketAddress): Bool {
        return !(this == rhs)
    }
}
