







package std.net

public struct AddressFamily <: ToString & Equatable<AddressFamily> {
    public static const UNSPEC: AddressFamily = AddressFamily("UNSPEC", 0)
    public static const UNIX: AddressFamily = AddressFamily("UNIX", 1)
    public static const INET: AddressFamily = AddressFamily("INET", 2)
    @When[os != "Windows" && os != "macOS"]
    public static const INET6: AddressFamily = AddressFamily("INET6", 10)

    @When[os == "Windows"]
    public static const INET6: AddressFamily = AddressFamily("INET6", 23)

    @When[os == "macOS"]
    public static const INET6: AddressFamily = AddressFamily("INET6", 30)
    @When[os != "Windows" && os != "macOS"]
    public static const NETLINK: AddressFamily = AddressFamily("NETLINK", 16)
    public let name: String
    public let value: UInt16
    public const init(name: String, value: UInt16) {
        this.name = name
        this.value = value
    }

    public operator func ==(rhs: AddressFamily): Bool {
        this.value == rhs.value
    }
    public operator func !=(rhs: AddressFamily): Bool {
        this.value != rhs.value
    }

    public func toString(): String {
        return name
    }
}
