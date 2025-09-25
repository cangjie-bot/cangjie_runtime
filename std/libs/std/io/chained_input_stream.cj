










package std.io



public class ChainedInputStream<T> <: InputStream where T <: InputStream {
    private let inputArr: Array<T>
    private var curIndex: Int64




    public init(input: Array<T>) {
        if (input.isEmpty()) {
            throw IllegalArgumentException("The array of input streams cannot be empty!")
        }
        inputArr = input.clone()
        curIndex = 0
    }






    public func read(buffer: Array<Byte>): Int64 {
        let inputArrSize = inputArr.size
        if (curIndex >= inputArrSize) {
            return 0
        }

        if (buffer.isEmpty()) {
            throw IllegalArgumentException("The buffer cannot be empty!")
        }

        while (curIndex < inputArrSize) {
            let readNum = inputArr[curIndex].read(buffer)
            if (readNum > 0) {
                return readNum
            } else if (readNum < 0) {
                throw IOException("Failed to read data!")
            }

            inputArr[curIndex] = unsafe { zeroValue<T>() }
            curIndex++
        }
        return 0
    }
}
