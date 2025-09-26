










package std.io

public class MultiOutputStream<T> <: OutputStream where T <: OutputStream {
    private var outputArr: Array<T>


    /**
     * @throws IllegalArgumentException
     */
    public init(output: Array<T>) {
        if (output.isEmpty()) {
            throw IllegalArgumentException("The array of output streams cannot be empty!")
        }
        outputArr = output.clone()
    }

    public func write(buffer: Array<Byte>): Unit {
        for (outputStream in outputArr) {
            outputStream.write(buffer)
        }
    }

    public func flush(): Unit {
        for (outputStream in outputArr) {
            outputStream.flush()
        }
    }
}
