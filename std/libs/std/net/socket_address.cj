







package std.net

                      /*
                       * @noThrow
                       */
sealed abstract class SocketAddress <: ToString & Equatable<SocketAddress> & Hashable {
    public prop size: Int64

    public prop family: AddressFamily

    /*
     * @noThrow
     */
    public func getAddressBytes(): Array<Byte>

    /*
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    public operator func ==(rhs: SocketAddress): Bool {
        match ((this, rhs)) {
            case (lip: IPSocketAddress, rip: IPSocketAddress) => lip == rip
            case (lip: UnixSocketAddress, rip: UnixSocketAddress) => lip == rip
            case _ => false
        }
    }
    /*
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    public operator func !=(rhs: SocketAddress): Bool {
        return !(this == rhs)
    }
}
