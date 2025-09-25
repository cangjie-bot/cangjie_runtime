







package std.crypto.cipher

public interface BlockCipher {
    prop blockSize: Int64

    prop algorithm: String

    /*
     * @noThrow
     */
    func encrypt(input: Array<Byte>): Array<Byte> {
        let buf = Array<Byte>(blockSize, repeat: 0)
        this.encrypt(input, to: buf)
        return buf
    }

    /*
     * @noThrow
     */
    func decrypt(input: Array<Byte>): Array<Byte> {
        let buf = Array<Byte>(blockSize, repeat: 0)
        this.decrypt(input, to: buf)
        return buf
    }

    /*
     * @noThrow
     */
    func encrypt(input: Array<Byte>, to!: Array<Byte>): Int64

    /*
     * @noThrow
     */
    func decrypt(input: Array<Byte>, to!: Array<Byte>): Int64
}
