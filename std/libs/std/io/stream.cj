









package std.io

const DEFAULT_BUFFER_CAPACITY: Int64 = 4096







public interface InputStream {










    /*
     * @noThrow
     */
    func read(buffer: Array<Byte>): Int64
}


public interface OutputStream {




    /*
     * @noThrow
     */
    func write(buffer: Array<Byte>): Unit


    /*
     * @noThrow
     */
    func flush(): Unit {}
}


public interface IOStream <: InputStream & OutputStream {}


public interface Seekable {






    /*
     * @noThrow
     */
    func seek(sp: SeekPosition): Int64


    prop position: Int64 {
        /*
         * @noThrow
         */
        get() {
            seek(Current(0))
        }
    }


    prop remainLength: Int64 {
        /*
         * @noThrow
         */
        get() {
            let oldPos = this.seek(Current(0))
            let length = this.seek(End(0))
            if (length != oldPos) {
                this.seek(Begin(oldPos))
            }

            length - oldPos
        }
    }


    prop length: Int64 {
        /*
         * @noThrow
         */
        get() {
            let oldPos = this.seek(Current(0))
            let length = this.seek(End(0))
            if (length != oldPos) {
                this.seek(Begin(oldPos))
            }

            length
        }
    }
}
