







package std.net

import std.binary.*

/*
 * @throws IndexOutOfBoundsException
 * @throws IllegalArgumentException
 */
func findLastNoneZeroIdx(path: Array<Byte>): Int64 {
    let len = path.size
    if (len > 108) {
        throw IllegalArgumentException("Path size(${len}) is too long, expect <= 108.")
    }
    var lastNoneZeroIdx = 0
    for (i in path.size - 1..=0 : -1) {
        if (path[i] != 0) {
            lastNoneZeroIdx = i + 1
            break
        }
    }
    return lastNoneZeroIdx
}

public class UnixSocketAddress <: SocketAddress & Equatable<UnixSocketAddress> {
    let _path: String
    let _len: Int64

    /*
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    public init(path: Array<Byte>) {
        this(unsafe { String.fromUtf8Unchecked(path[..findLastNoneZeroIdx(path)]) })
    }
    /*
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    public init(path: String) {
        _len = path.size
        if (_len > 108) {
            throw IllegalArgumentException("Path size(${_len}) is too long, expect <= 108.")
        }
        if (_len == 0) {
            _path = ""
        } else if (path[0] == 0) {
            let un = path[1..]
            if (let Some(idx) <- un.indexOf(0)) {
                throw IllegalArgumentException(
                    "Unix domain socket path must not contain interior null bytes: ${un.toArray()}")
            }
            _path = path
        } else {
            if (let Some(idx) <- path.indexOf(0)) {
                throw IllegalArgumentException(
                    "Unix domain socket path must not contain interior null bytes: ${path.toArray()}")
            }
            _path = path
        }
    }
    public prop size: Int64 {
        /*
         * @noThrow
         */
        get() {
            2 + _len
        }
    }
    public prop family: AddressFamily {
        /*
         * @noThrow
         */
        get() {
            AddressFamily.UNIX
        }
    }
    /*
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    public operator func ==(rhs: UnixSocketAddress): Bool {
        return _path[0.._len] == rhs._path[0..rhs._len]
    }
    /*
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    public operator func !=(rhs: UnixSocketAddress): Bool {
        return !(this == rhs)
    }
    /*
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    public func getAddressBytes(): Array<Byte> {
        let buf = Array<Byte>(this.size, repeat: 0)
        this.family.value.writeLittleEndian(buf)
        buf[2..] = _path[.._len].toArray()
        return buf
    }
    /*
     * @throws IndexOutOfBoundsException
     */
    public func hashCode(): Int64 {
        var df = DefaultHasher()
        for (i in 0.._len) {
            df.write(_path[i])
        }
        df.finish()
    }
    /*
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    public func toString(): String {
        _path[0.._len]
    }
}
