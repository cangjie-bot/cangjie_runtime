







package std.crypto.digest

import std.io.{InputStream, OutputStream}




public interface Digest {
    prop size: Int64

    prop blockSize: Int64

    prop algorithm: String

    func write(buffer: Array<Byte>): Unit

    func finish(to!: Array<Byte>): Unit

    func finish(): Array<Byte> {
        let buf = Array<Byte>(size, repeat: 0)
        this.finish(to: buf)
        return buf
    }

    func reset(): Unit
}







@Deprecated[message: "Use global function `public func digest<T>(algorithm: T, input: InputStream): Array<Byte> where T <: Digest` instead."]
public func digest<T>(algorithm: T, data: String): Array<Byte> where T <: Digest {
    digest(algorithm, data.toArray())
}

/**
 * @throws IndexOutOfBoundsException
 * @throws IllegalArgumentException
 */
public func digest<T>(algorithm: T, input: InputStream): Array<Byte> where T <: Digest {
    var buffer = Array<Byte>(algorithm.blockSize, repeat: 0)
    while (true) {
        var len = input.read(buffer)
        if (len == 0) {
            break
        }
        algorithm.write(buffer[..len])
    }
    var result = algorithm.finish()
    algorithm.reset()
    return result
}

public func digest<T>(algorithm: T, data: Array<Byte>): Array<Byte> where T <: Digest {
    var algorithmMutable = algorithm
    algorithmMutable.reset()
    algorithmMutable.write(data)
    let result = algorithmMutable.finish()
    algorithmMutable.reset()
    return result
}
