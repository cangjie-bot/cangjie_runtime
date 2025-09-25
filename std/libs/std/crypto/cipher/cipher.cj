







package std.crypto.cipher

public interface BlockCipher {
    prop blockSize: Int64

    prop algorithm: String

    func encrypt(input: Array<Byte>): Array<Byte> {
        let buf = Array<Byte>(blockSize, repeat: 0)
        this.encrypt(input, to: buf)
        return buf
    }

    func decrypt(input: Array<Byte>): Array<Byte> {
        let buf = Array<Byte>(blockSize, repeat: 0)
        this.decrypt(input, to: buf)
        return buf
    }

    func encrypt(input: Array<Byte>, to!: Array<Byte>): Int64

    func decrypt(input: Array<Byte>, to!: Array<Byte>): Int64
}
