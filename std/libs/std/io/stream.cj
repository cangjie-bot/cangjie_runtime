









package std.io

const DEFAULT_BUFFER_CAPACITY: Int64 = 4096







public interface InputStream {










    func read(buffer: Array<Byte>): Int64
}


public interface OutputStream {




    func write(buffer: Array<Byte>): Unit


    func flush(): Unit {}
}


public interface IOStream <: InputStream & OutputStream {}


public interface Seekable {






    func seek(sp: SeekPosition): Int64


    prop position: Int64 {
        get() {
            seek(Current(0))
        }
    }


    prop remainLength: Int64 {
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
