









package std.fs

import std.io.*

const SEEK_SET: Int32 = 0 
const SEEK_CUR: Int32 = 1 
const SEEK_END: Int32 = 2 

const READ_ONLY: Int32 = 0
const WRITE_ONLY: Int32 = 1
const APPEND: Int32 = 2
const READ_WRITE: Int32 = 3

public enum OpenMode <: ToString & Equatable<OpenMode> {
    | Read
    | Write
    | Append
    | ReadWrite

    /*
     * @noThrow
     */
    public operator func ==(that: OpenMode): Bool {
        return match ((this, that)) {
            case (Read, Read)           => true
            case (Write, Write)         => true
            case (Append, Append)       => true
            case (ReadWrite, ReadWrite) => true
            case _                      => false
        }
    }

    /*
     * @noThrow
     */
    public operator func !=(that: OpenMode): Bool {
        return !(this == that)
    }

    /*
     * @noThrow
     */
    public func toString(): String {
        return match (this) {
            case Read      => "Read"
            case Write     => "Write"
            case Append    => "Append"
            case ReadWrite => "ReadWrite"
        }
    }
}


public struct FileDescriptor {
    var _fileHandle: IntNative = InvalidHandle

    public prop fileHandle: IntNative {
        /*
         * @noThrow
         */
        get() {
            _fileHandle
        }
    }
}

public class File <: Resource & IOStream & Seekable {
    private var _fileInfo: FileInfo
    private var _openMode: OpenMode
    var _fileDescriptor: FileDescriptor = FileDescriptor()
    private var _canRead: Bool = true
    private var _canWrite: Bool = true
    private var _canSeek: Bool = true

    /*
     * @noThrow
     */
    ~init() {
        if (isHandleValid(_fileDescriptor._fileHandle)) {
            unsafe { CJ_FS_CloseFile(_fileDescriptor._fileHandle) }
            _fileDescriptor._fileHandle = InvalidHandle
        }
    }











    /*
     * @throws IllegalMemoryException
     * @throws IndexOutOfBoundsException
     * @throws FSException
     * @throws IllegalArgumentException
     */
    public init(path: String, mode: OpenMode) {
        if (path.isEmpty()) {
            throw IllegalArgumentException("The file path cannot be empty.")
        }
        if (path.contains(NULL_BYTE)) {
            throw IllegalArgumentException("The file path cannot contain null character.")
        }
        let filePath: Path = Path(path)
        let parent = filePath.parent
        if (!parent.isEmpty() && !exists(parent)) {
            throw FSException("The path `${parent}` does not exist.")
        }
        _fileInfo = FileInfo(filePath, false)
        _openMode = mode
        openFile()
    }











    /*
     * @throws IllegalMemoryException
     * @throws IndexOutOfBoundsException
     * @throws FSException
     * @throws IllegalArgumentException
     */
    public init(path: Path, mode: OpenMode) {
        this(path.toString(), mode)
    }

    /*
     * @throws IllegalMemoryException
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     * @throws FSException
     */
    private init(path: String, mode: OpenMode, fd: FileHandle) {
        if (!isHandleValid(fd)) {
            throw FSException("Invalid File Handle!")
        }
        let filePath: Path = Path(path)
        _fileInfo = FileInfo(filePath, false)
        _openMode = mode
        fileHandle = fd
    }

    public prop info: FileInfo {
        /*
         * @noThrow
         */
        get() {
            _fileInfo
        }
    }

    public prop fileDescriptor: FileDescriptor {
        /*
         * @noThrow
         */
        get() {
            _fileDescriptor
        }
    }

    mut prop fileHandle: FileHandle {
        /*
         * @noThrow
         */
        get() {
            _fileDescriptor._fileHandle
        }
        /*
         * @noThrow
         */
        set(v) {
            _fileDescriptor._fileHandle = v
        }
    }

    public prop length: Int64 {
        /*
         * @noThrow
         */
        get() {
            getsize()
        }
    }

    /*
     * @throws FSException
     * @throws IllegalArgumentException
     */
    public func setLength(length: Int64): Unit {
        if (length < 0) {
            throw IllegalArgumentException("Invalid length: ${length}.")
        }
        checkCanTruncate()

        unsafe {
            let resultPtr = CJ_FS_Truncate(_fileDescriptor.fileHandle, length)
            if (resultPtr.isNull()) {
                throw FSException("Failed to tuncate the file.")
            }
            let result = resultPtr.read()
            LibC.free(resultPtr)

            try {
                if (result.rtnCode != 0) {
                    throw FSException("Failed to tuncate the file: ${result.msg}.")
                }
            } finally {
                LibC.free(result.msg)
            }
        }
    }











    /*
     * @throws FSException
     * @throws IllegalArgumentException
     */
    public func read(buffer: Array<Byte>): Int64 {
        checkCanRead()
        if (buffer.size == 0) {
            throw IllegalArgumentException("The buffer is empty.")
        }
        var readBytes: Int64 = directRead(buffer)
        if (readBytes == 0) {
            return 0
        } else if (readBytes < 0) {
            throw FSException("The file read Error.")
        }
        return readBytes
    }




    /*
     * @throws FSException
     */
    public func write(buffer: Array<Byte>): Unit {
        if (!isHandleValid(fileHandle)) {
            throw FSException("The file not opened, can not be written.")
        }
        if (!_canWrite) {
            throw FSException("The file does not have the write permission.")
        }
        if (buffer.size == 0) {
            return
        }
        directWrite(buffer)
    }

    /*
     * @noThrow
     */
    public func flush(): Unit {}




    /*
     * @throws FSException
     */
    public func seek(sp: SeekPosition): Int64 {
        if (!canSeek()) {
            throw FSException("The file can not seek.")
        }
        var (whence, offset): (Int32, Int64) = match (sp) {
            case Current(cOffset) => (SEEK_CUR, cOffset)
            case Begin(bOffset) => (SEEK_SET, bOffset)
            case End(eOffset) => (SEEK_END, eOffset)
        }
        var val: Int64 = unsafe { CJ_FS_Seek(fileHandle, whence, offset) }
        if (val < 0) {
            throw FSException("Failed to seek: errno is ${0 - val}.")
        }
        return val
    }

    /*
     * @noThrow
     */
    private func canSeek(): Bool {
        if (isClosed()) {
            return false
        }
        return _canSeek
    }

    /*
     * @noThrow
     */
    public func canRead(): Bool {
        if (isClosed()) {
            return false
        }
        return _canRead
    }

    /*
     * @noThrow
     */
    public func canWrite(): Bool {
        if (isClosed()) {
            return false
        }
        return _canWrite
    }


    /*
     * @throws FSException
     */
    public func close(): Unit {
        if (!isHandleValid(fileHandle)) {
            return
        }
        flush()

        
        if (unsafe { CJ_FS_CloseFile(fileHandle) } < 0) {
            throw FSException("Failed to close file.")
        }
        fileHandle = InvalidHandle
    }

    /*
     * @noThrow
     */
    public func isClosed(): Bool {
        return !isHandleValid(fileHandle)
    }



    /*
     * @throws IllegalMemoryException
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     * @throws FSException
     */
    public static func create(path: Path): File {
        return create(path.toString())
    }



    /*
     * @throws IllegalMemoryException
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     * @throws FSException
     */
    public static func create(path: String): File {
        if (exists(path)) {
            throw FSException("The file already exists!")
        }
        return File(path, Write)
    }



    /*
     * @throws IllegalArgumentException
     * @throws IllegalMemoryException
     * @throws IndexOutOfBoundsException
     * @throws FSException
     */
    public static func createTemp(directoryPath: String): File {
        return createTemp(Path(directoryPath))
    }



    /*
     * @throws IllegalArgumentException
     * @throws IllegalMemoryException
     * @throws IndexOutOfBoundsException
     * @throws FSException
     */
    public static func createTemp(directoryPath: Path): File {
        var utf8View = unsafe { canonicalize(directoryPath).toString().rawData() }
        var appendStrUtf8View = TMP_FILE
        var tempArrSize = utf8View.size + appendStrUtf8View.size
        var tempArr = Array<Byte>(tempArrSize, repeat: 0)
        utf8View.copyTo(tempArr, 0, 0, utf8View.size)
        appendStrUtf8View.copyTo(tempArr, 0, utf8View.size, appendStrUtf8View.size)
        var ret: FileHandle = InvalidHandle
        unsafe {
            var arrPtr: CPointerHandle<Byte> = acquireArrayRawData(tempArr)
            ret = CJ_FS_CreateTempFile(arrPtr.pointer)
            releaseArrayRawData(arrPtr)
            if (!isHandleValid(ret)) {
                throw FSException("Failed to create the temporary file!")
            }
        }
        var tempPath = String.fromUtf8(tempArr.slice(0, tempArrSize - 1))
        return File(tempPath, ReadWrite, ret)
    }



    /*
     * @throws IllegalMemoryException
     * @throws FSException
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    static func copy(sourcePath: String, destinationPath: String, overwrite: Bool): Unit {
        if (overwrite) {
            callNativeFunc(sourcePath, destinationPath, CJ_FS_CopyREF,
                "Failed to copy file from `${sourcePath}` to `${destinationPath}`")
            return
        }

        try (srcFile = File(sourcePath, Read), dstFile = File(destinationPath, Write)) {
            copy(srcFile, to: dstFile)
        }
    }



    /*
     * @throws IllegalMemoryException
     * @throws IllegalArgumentException
     * @throws OverflowException
     * @throws IndexOutOfBoundsException
     * @throws FSException
     */
    public static func readFrom(path: Path): Array<Byte> {
        File.readFrom(path.toString())
    }





    /*
     * @throws IllegalMemoryException
     * @throws IllegalArgumentException
     * @throws OverflowException
     * @throws IndexOutOfBoundsException
     * @throws FSException
     */
    public static func readFrom(path: String): Array<Byte> {
        var file = File(path, Read)
        try {
            return readToEnd(file)
        } finally {
            file.close()
        }
    }




    /*
     * @throws IllegalMemoryException
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     * @throws FSException
     */
    public static func writeTo(path: Path, buffer: Array<Byte>): Unit {
        writeTo(path.toString(), buffer)
    }




    /*
     * @throws IllegalMemoryException
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     * @throws FSException
     */
    public static func writeTo(path: String, buffer: Array<Byte>): Unit {
        writeTo(path, buffer, Write)
    }




    /*
     * @throws IllegalMemoryException
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     * @throws FSException
     */
    public static func appendTo(path: Path, buffer: Array<Byte>): Unit {
        appendTo(path.toString(), buffer)
    }




    /*
     * @throws IllegalMemoryException
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     * @throws FSException
     */
    public static func appendTo(path: String, buffer: Array<Byte>): Unit {
        writeTo(path, buffer, OpenMode.Append)
    }




    /*
     * @throws IllegalMemoryException
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     * @throws FSException
     */
    private static func writeTo(path: String, buffer: Array<Byte>, mode: OpenMode): Unit {
        var file = File(path, mode)
        try {
            file.write(buffer)
        } finally {
            file.close()
        }
    }









    /*
     * @throws IllegalArgumentException
     * @throws IllegalMemoryException
     * @throws FSException
     */
    private func openFile(): Unit {
        let isExists = exists(_fileInfo.path)
        let (r, w, s, openMode): (Bool, Bool, Bool, Int32) = match ((_openMode, isExists)) {
            case (Read, false)        => throw FSException("The file does not exist or permission denied!")
            case (Read, _)            => (true, false, true, READ_ONLY)
            case (Write, _)           => (false, true, true, WRITE_ONLY)
            case (OpenMode.Append, _) => (false, true, false, APPEND)
            case (ReadWrite, _)       => (true, true, true, READ_WRITE)
        }
        _canRead = r
        _canWrite = w
        _canSeek = s
        var fsInfoCp: CPointer<FsInfo>
        var fsInfo: FsInfo
        var fsInfoErrMsg = ""

        unsafe {
            let pathStr = _fileInfo.path.toString()
            let cPath = LibC.mallocCString(pathStr)
            fsInfoCp = CJ_FS_OpenFile(cPath, openMode)
            LibC.free(cPath)
            if (fsInfoCp.isNull()) {
                throw FSException("Failed to open the file.")
            }
            fsInfo = fsInfoCp.read()
            LibC.free(fsInfoCp)
            try {
                fsInfoErrMsg = fsInfo.msg.toString()
            } finally {
                LibC.free(fsInfo.msg)
            }
            _fileDescriptor._fileHandle = fsInfo.fd
        }
        if (!isHandleValid(_fileDescriptor._fileHandle)) {
            var errMsg = "Failed to open the file."
            if (fsInfoErrMsg != "") {
                errMsg = "Failed to open the file. ${fsInfoErrMsg}"
            }
            throw FSException(errMsg)
        }
    }

    /*
     * @noThrow
     */
    private func getsize(): Int64 {
        if (!isHandleValid(_fileDescriptor._fileHandle)) {
            return -1
        }
        unsafe {
            return CJ_FS_GetFileSize(_fileDescriptor._fileHandle)
        }
    }



    /*
     * @throws FSException
     */
    private func checkCanRead(): Unit {
        if (!isHandleValid(_fileDescriptor._fileHandle)) {
            throw FSException("The file not opened, can not to read.")
        }
        if (!_canRead) {
            throw FSException("The file does not have the read permission.")
        }
    }



    /*
     * @throws FSException
     */
    private func checkCanTruncate(): Unit {
        if (!isHandleValid(_fileDescriptor._fileHandle)) {
            throw FSException("The file not opened, can not to read.")
        }

        match (_openMode) {
            case Write | ReadWrite => ()
            case _ => throw FSException("The file does not have the write permission.")
        }
    }







    /*
     * @noThrow
     */
    private func directRead(buffer: Array<Byte>): Int64 {
        unsafe {
            let bufPtr: CPointerHandle<Byte> = acquireArrayRawData(buffer)
            let readSize: Int64 = CJ_FS_FileRead(fileHandle, bufPtr.pointer, UIntNative(buffer.size))
            releaseArrayRawData(bufPtr)
            return readSize
        }
    }








    /*
     * @throws FSException
     */
    private func directWrite(buffer: Array<Byte>): Unit {
        unsafe {
            let bufSize: Int64 = buffer.size
            var bufPtr: CPointerHandle<Byte> = acquireArrayRawData(buffer)
            let writeSuccess: Bool = CJ_FS_FileWrite(fileHandle, bufPtr.pointer, UIntNative(bufSize))
            releaseArrayRawData(bufPtr)
            if (!writeSuccess) {
                throw FSException("The file write error.")
            }
        }
    }
}
