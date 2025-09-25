










package std.io

const HIGH_1_UInt8: UInt8 = 0b10000000


public class StringReader<T> where T <: InputStream {
    let inputBIS: BufferedInputStream<T>

    /*
     * @throws IllegalArgumentException
     */
    public init(input: T) {
        inputBIS = BufferedInputStream(input)
    }


    @Frozen
    /*
     * @throws IllegalArgumentException
     * @throws ContentFormatException
     * @throws IndexOutOfBoundsException
     */
    public func read(): ?Rune {
        if (isFinished()) {
            return None
        }
        let byte0 = inputBIS.inBuf[inputBIS.curPos]
        if (byte0 < HIGH_1_UInt8) {
            updateInBufInfo(1)
            return Rune(byte0)
        }
        let (char, num): (Rune, Int64) = readCharFromInbuf()
        updateInBufInfo(num)
        return char
    }

    /*
     * @noThrow
     */
    public func runes(): Iterator<Rune> {
        return RunesIterator(this)
    }

    /*
     * @throws OverflowException
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    private func readlnFromBuf(bas: ByteBuffer, haveCR_: Bool): (Bool, Bool) {
        var count = 0
        var done = false
        var haveCR = haveCR_
        while (count < inputBIS.availLen) {
            let char = inputBIS.inBuf[inputBIS.curPos + count]
            count++
            match (char) {
                case '\r' =>
                    if (haveCR) {
                        count--
                        done = true
                        break
                    }
                    haveCR = true
                case '\n' =>
                    done = true
                    break
                case _ =>
                    if (haveCR) {
                        count--
                        done = true
                        break
                    }
            }
        }
        bas.write(inputBIS.inBuf[inputBIS.curPos..inputBIS.curPos + count])
        updateInBufInfo(count)
        (done, haveCR)
    }


    @Frozen
    /*
     * @throws OverflowException
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     * @throws ContentFormatException
     */
    public func readln(): Option<String> {
        if (isFinished()) {
            return Option<String>.None
        }
        let bas = ByteBuffer()
        var haveCR = false
        var done = false
        while (!done && !isFinished()) {
            (done, haveCR) = readlnFromBuf(bas, haveCR)
        }
        var bytes = bas.bytes()
        var pos = bytes.size
        while (pos > 0 && (bytes[pos - 1] == 0x0Au8 || bytes[pos - 1] == 0x0Du8)) {
            pos--
        }
        bytes = bytes[0..pos]
        try {
            return String.fromUtf8(bytes)
        } catch (e: IllegalArgumentException) {
            throw ContentFormatException("${e.message}")
        }
    }

    /*
     * @noThrow
     */
    public func lines(): Iterator<String> {
        return LinesIterator(this)
    }


    @Frozen
    /*
     * @throws OverflowException
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     * @throws ContentFormatException
     */
    public func readToEnd(): String {
        var bas: ByteBuffer = ByteBuffer()
        let buf = Array<Byte>(4096, repeat: 0)
        while (!isFinished()) {
            let len = inputBIS.read(buf)
            bas.write(buf[0..len])
        }
        let content = bas.bytes()
        try {
            return String.fromUtf8(content)
        } catch (e: IllegalArgumentException) {
            throw ContentFormatException("${e.message}")
        }
    }


    /*
     * @throws ContentFormatException
     * @throws OverflowException
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    public func readUntil(v: Rune): Option<String> {
        return readUntil({c: Rune => return c == v})
    }


    /*
     * @throws ContentFormatException
     * @throws OverflowException
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    public func readUntil(predicate: (Rune) -> Bool): Option<String> {
        if (isFinished()) {
            return Option<String>.None
        }
        return Option<String>.Some(readUntilToString(predicate))
    }

    /*
     * @noThrow
     */
    private func isFinished(): Bool {
        if (inputBIS.availLen <= 0) {
            inputBIS.fillInBuf()
        }
        return inputBIS.availLen == -1
    }

    /*
     * @noThrow
     */
    private func updateInBufInfo(readNum: Int64): Unit {
        inputBIS.curPos += readNum
        inputBIS.availLen -= readNum
    }


    /*
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     * @throws ContentFormatException
     */
    private func readCharFromInbuf(): (Rune, Int64) {
        try {
            if (inputBIS.availLen < 4) {
                let size = Rune.utf8Size(inputBIS.inBuf, inputBIS.curPos)
                ensureAvailable(size)
            }
            Rune.fromUtf8(inputBIS.inBuf, inputBIS.curPos)
        } catch (e: IllegalArgumentException) {
            throw ContentFormatException("${e.message}")
        }
    }

    /*
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     * @throws ContentFormatException
     */
    private func ensureAvailable(required: Int64): Unit {
        while (required > inputBIS.availLen) {
            inputBIS.inBuf.copyTo(inputBIS.inBuf, inputBIS.curPos, 0, inputBIS.availLen)
            var readNum = inputBIS
                .inputStream
                .read(inputBIS.inBuf.slice(inputBIS.availLen, inputBIS.inBuf.size - inputBIS.availLen))
            if (readNum < 0) {
                throw ContentFormatException("Input stread finished in the middle of a UTF-8 sequence")
            }
            inputBIS.curPos = 0
            inputBIS.availLen += readNum
        }
    }


    /*
     * @throws ContentFormatException
     * @throws OverflowException
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    private func readUntilToString(predicate: (Rune) -> Bool, isIncludeChar!: Bool = true): String {
        var bas: ByteBuffer = ByteBuffer()
        while (!isFinished()) {
            let (char, num): (Rune, Int64) = readCharFromInbuf()
            let utf8Array: Array<Byte> = inputBIS.inBuf.slice(inputBIS.curPos, num)
            updateInBufInfo(num)
            if (predicate(char)) {
                if (isIncludeChar) {
                    bas.write(utf8Array)
                }
                break
            }
            bas.write(utf8Array)
        }
        return String.fromUtf8(bas.bytes())
    }
}

extend<T> StringReader<T> <: Resource where T <: Resource {


    /*
     * @noThrow
     */
    public func close(): Unit {
        inputBIS.close()
    }




    /*
     * @noThrow
     */
    public func isClosed(): Bool {
        inputBIS.isClosed()
    }
}

extend<T> StringReader<T> <: Seekable where T <: Seekable {






    /*
     * @noThrow
     */
    public func seek(sp: SeekPosition): Int64 {
        inputBIS.seek(sp)
    }











    public prop position: Int64 {
        /*
         * @noThrow
         */
        get() {
            seek(Current(-inputBIS.availLen))
        }
    }
}

class RunesIterator<T> <: Iterator<Rune> where T <: InputStream {
    /*
     * @noThrow
     */
    RunesIterator(let data: StringReader<T>) {}


    /*
     * @throws IllegalArgumentException
     * @throws ContentFormatException
     * @throws IndexOutOfBoundsException
     */
    public func next(): Option<Rune> {
        return data.read()
    }
}

class LinesIterator<T> <: Iterator<String> where T <: InputStream {
    /*
     * @noThrow
     */
    LinesIterator(let data: StringReader<T>) {}


    /*
     * @throws OverflowException
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     * @throws ContentFormatException
     */
    public func next(): Option<String> {
        return data.readln()
    }
}
