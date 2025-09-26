










package std.posix

@FastNative
foreign func CJ_OS_GetOs(): CString

const NULL_BYTE = "\0"


@Deprecated
public const O_RDONLY: Int32 = 0x0


@Deprecated
public const O_RDWR: Int32 = 0x2


@Deprecated
public const O_WRONLY: Int32 = 0x1



@When[os != "Windows" && os != "macOS"]
@Deprecated
public const O_APPEND: Int32 = 0x400
@When[os == "macOS"]
@Deprecated
public const O_APPEND: Int32 = 0x00000008
@When[os == "Windows"]
@Deprecated
public const O_APPEND: Int32 = 0x8




@When[os != "Windows" && os != "macOS"]
@Deprecated
public const O_CLOEXEC: Int32 = 0x80000
@When[os == "macOS"]
@Deprecated
public const O_CLOEXEC: Int32 = 0x01000000


@When[os != "Windows" && os != "macOS"]
@Deprecated
public const O_CREAT: Int32 = 0x40
@When[os == "macOS"]
@Deprecated
public const O_CREAT: Int32 = 0x00000200
@When[os == "Windows"]
@Deprecated
public const O_CREAT: Int32 = 0x100


@When[os != "Windows" && os != "macOS"]
@Deprecated
public const O_DIRECTORY: Int32 = 0x10000
@When[os == "macOS"]
@Deprecated
public const O_DIRECTORY: Int32 = 0x00100000




@When[os != "Windows" && os != "macOS"]
@Deprecated
public const O_DSYNC: Int32 = 0x1000
@When[os == "macOS"]
@Deprecated
public const O_DSYNC: Int32 = 0x400000




@When[os != "Windows" && os != "macOS"]
@Deprecated
public const O_EXCL: Int32 = 0x80
@When[os == "macOS"]
@Deprecated
public const O_EXCL: Int32 = 0x00000800
@When[os == "Windows"]
@Deprecated
public const O_EXCL: Int32 = 0x400


@When[os != "Windows" && os != "macOS"]
@Deprecated
public const O_NOCTTY: Int32 = 0x100
@When[os == "macOS"]
@Deprecated
public const O_NOCTTY: Int32 = 0x00020000


@When[os != "Windows" && os != "macOS"]
@Deprecated
public const O_NOFOLLOW: Int32 = 0x20000
@When[os == "macOS"]
@Deprecated
public const O_NOFOLLOW: Int32 = 0x00000100


@When[os != "Windows" && os != "macOS"]
@Deprecated
public const O_NONBLOCK: Int32 = 0x800
@When[os == "macOS"]
@Deprecated
public const O_NONBLOCK: Int32 = 0x00000004


@When[os != "Windows" && os != "macOS"]
@Deprecated
public const O_SYNC: Int32 = 0x101000
@When[os == "macOS"]
@Deprecated
public const O_SYNC: Int32 = 0x0080



@When[os != "macOS"]
@Deprecated
public const O_TRUNC: Int32 = 0x200
@When[os == "macOS"]
@Deprecated
public const O_TRUNC: Int32 = 0x00000400




@When[os != "Windows" && os != "macOS"]
@Deprecated
public const O_RSYNC: Int32 = 0x101000


@Deprecated
public const S_IRUSR: UInt32 = 0x100


@Deprecated
public const S_IWUSR: UInt32 = 0x80


@Deprecated
public const S_IXUSR: UInt32 = 0x40


@Deprecated
public const S_IRWXU: UInt32 = 0x1C0


@Deprecated
public const S_IRGRP: UInt32 = 0x20


@Deprecated
public const S_IWGRP: UInt32 = 0x10


@Deprecated
public const S_IXGRP: UInt32 = 0x8


@Deprecated
public const S_IRWXG: UInt32 = 0x38


@Deprecated
public const S_IROTH: UInt32 = 0x4


@Deprecated
public const S_IWOTH: UInt32 = 0x2


@Deprecated
public const S_IXOTH: UInt32 = 0x1


@Deprecated
public const S_IRWXO: UInt32 = 0x7


@Deprecated
public const SEEK_SET: Int32 = 0x0


@Deprecated
public const SEEK_CUR: Int32 = 0x1


@Deprecated
public const SEEK_END: Int32 = 0x2













/**
 * @throws IllegalArgumentException
 * @throws IllegalMemoryException
 */
@Deprecated
public func `open`(path: String, oflag: Int32, flag: UInt32): Int32 {
    checkPath(path)
    var p: CString = unsafe { LibC.mallocCString(path) }
    let r: Int32 = unsafe { open(p, oflag, flag) }
    unsafe { LibC.free(p) }
    return r
}











/**
 * @throws IllegalArgumentException
 * @throws IllegalMemoryException
 */
@Deprecated
public func `open`(path: String, oflag: Int32): Int32 {
    checkPath(path)
    var p: CString = unsafe { LibC.mallocCString(path) }
    let r: Int32 = unsafe { open(p, oflag) }
    unsafe { LibC.free(p) }
    return r
}













/**
 * @throws IllegalArgumentException
 * @throws IllegalMemoryException
 */
@When[os != "Windows" && os != "macOS"]
@Deprecated
public func open64(path: String, oflag: Int32, flag: UInt32): Int32 {
    checkPath(path)
    var p: CString = unsafe { LibC.mallocCString(path) }
    let r: Int32 = unsafe { open64(p, oflag, flag) }
    unsafe { LibC.free(p) }
    return r
}











/**
 * @throws IllegalArgumentException
 * @throws IllegalMemoryException
 */
@When[os != "Windows" && os != "macOS"]
@Deprecated
public func open64(path: String, oflag: Int32): Int32 {
    checkPath(path)
    var p: CString = unsafe { LibC.mallocCString(path) }
    let r: Int32 = unsafe { open64(p, oflag) }
    unsafe { LibC.free(p) }
    return r
}













/**
 * @throws IllegalArgumentException
 * @throws IllegalMemoryException
 */
@When[os != "Windows"]
@Deprecated
public func openat(fd: Int32, path: String, oflag: Int32, flag: UInt32): Int32 {
    checkPath(path)
    var p: CString = unsafe { LibC.mallocCString(path) }
    let r: Int32 = unsafe { openat(fd, p, oflag, flag) }
    unsafe { LibC.free(p) }
    return r
}












/**
 * @throws IllegalArgumentException
 * @throws IllegalMemoryException
 */
@When[os != "Windows"]
@Deprecated
public func openat(fd: Int32, path: String, oflag: Int32): Int32 {
    checkPath(path)
    var p: CString = unsafe { LibC.mallocCString(path) }
    let r: Int32 = unsafe { openat(fd, p, oflag) }
    unsafe { LibC.free(p) }
    return r
}













/**
 * @throws IllegalArgumentException
 * @throws IllegalMemoryException
 */
@When[os != "Windows" && os != "macOS"]
@Deprecated
public func openat64(fd: Int32, path: String, oflag: Int32, flag: UInt32): Int32 {
    checkPath(path)
    var p: CString = unsafe { LibC.mallocCString(path) }
    let r: Int32 = unsafe { openat64(fd, p, oflag, flag) }
    unsafe { LibC.free(p) }
    return r
}












/**
 * @throws IllegalArgumentException
 * @throws IllegalMemoryException
 */
@When[os != "Windows" && os != "macOS"]
@Deprecated
public func openat64(fd: Int32, path: String, oflag: Int32): Int32 {
    checkPath(path)
    var p: CString = unsafe { LibC.mallocCString(path) }
    let r: Int32 = unsafe { openat64(fd, p, oflag) }
    unsafe { LibC.free(p) }
    return r
}










/**
 * @throws IllegalArgumentException
 * @throws IllegalMemoryException
 */
@Deprecated
public func creat(path: String, flag: UInt32): Int32 {
    checkPath(path)
    var p: CString = unsafe { LibC.mallocCString(path) }
    let r: Int32 = unsafe { creat(p, flag) }
    unsafe { LibC.free(p) }
    return r
}









@Deprecated
public func close(fd: Int32): Int32 {
    return unsafe { CJ_OS_Close(fd) }
}















@Deprecated
public func lseek(fd: Int32, offset: Int64, whence: Int32): Int64 {
    return unsafe { CJ_OS_Lseek(fd, offset, whence) }
}










@Deprecated
public func dup(fd: Int32): Int32 {
    return unsafe { CJ_OS_Dup(fd) }
}










@Deprecated
public func dup2(fd: Int32, fd2: Int32): Int32 {
    return unsafe { CJ_OS_Dup2(fd, fd2) }
}















@Deprecated
public unsafe func read(fd: Int32, buffer: CPointer<UInt8>, nbyte: UIntNative): IntNative {
    return CJ_OS_Read(fd, buffer, nbyte)
}
















@When[os != "Windows"]
@Deprecated
public unsafe func pread(fd: Int32, buffer: CPointer<UInt8>, nbyte: UIntNative, offset: Int32): IntNative {
    return CJ_OS_Pread(fd, buffer, nbyte, offset)
}














@Deprecated
public unsafe func write(fd: Int32, buffer: CPointer<UInt8>, nbyte: UIntNative): IntNative {
    return CJ_OS_Write(fd, buffer, nbyte)
}















@When[os != "Windows"]
@Deprecated
public unsafe func pwrite(fd: Int32, buffer: CPointer<UInt8>, nbyte: UIntNative, offset: Int32): IntNative {
    return CJ_OS_Pwrite(fd, buffer, nbyte, offset)
}

@Deprecated
public const S_IFREG: UInt32 = 0x8000


@Deprecated
public const S_IFDIR: UInt32 = 0x4000


@Deprecated
public const S_IFCHR: UInt32 = 0x2000


@Deprecated
public const S_IFBLK: UInt32 = 0x6000


@Deprecated
public const S_IFIFO: UInt32 = 0x1000


@Deprecated
public const S_IFLNK: UInt32 = 0xA000


@Deprecated
public const S_IFSOCK: UInt32 = 0xC000










/**
 * @throws IllegalArgumentException
 * @throws IllegalMemoryException
 */
@When[os != "Windows"]
@Deprecated
public func isType(path: String, mode: UInt32): Bool {
    if (path.contains(NULL_BYTE)) {
        return false
    }
    var p: CString = unsafe { LibC.mallocCString(path) }
    let r: Bool = unsafe { CJ_OS_IsType(p, mode) }
    unsafe { LibC.free(p) }
    return r
}

const REG: Int32 = 1
const DIR: Int32 = 2
const CHR: Int32 = 3
const BLK: Int32 = 4
const FIFO: Int32 = 5
const LNK: Int32 = 6
const SOCK: Int32 = 7








/**
 * @throws IllegalArgumentException
 * @throws IllegalMemoryException
 */
@Deprecated
public func isReg(path: String): Bool {
    if (path.contains(NULL_BYTE)) {
        return false
    }
    var p: CString = unsafe { LibC.mallocCString(path) }
    let r: Bool = unsafe { CJ_OS_IsTypeFunc(p, REG) }
    unsafe { LibC.free(p) }
    return r
}








/**
 * @throws IllegalArgumentException
 * @throws IllegalMemoryException
 */
@Deprecated
public func isDir(path: String): Bool {
    if (path.contains(NULL_BYTE)) {
        return false
    }
    var p: CString = unsafe { LibC.mallocCString(path) }
    let r: Bool = unsafe { CJ_OS_IsTypeFunc(p, DIR) }
    unsafe { LibC.free(p) }
    return r
}








/**
 * @throws IllegalArgumentException
 * @throws IllegalMemoryException
 */
@Deprecated
public func isChr(path: String): Bool {
    if (path.contains(NULL_BYTE)) {
        return false
    }
    var p: CString = unsafe { LibC.mallocCString(path) }
    let r: Bool = unsafe { CJ_OS_IsTypeFunc(p, CHR) }
    unsafe { LibC.free(p) }
    return r
}








/**
 * @throws IllegalArgumentException
 * @throws IllegalMemoryException
 */
@Deprecated
public func isBlk(path: String): Bool {
    if (path.contains(NULL_BYTE)) {
        return false
    }
    var p: CString = unsafe { LibC.mallocCString(path) }
    let r: Bool = unsafe { CJ_OS_IsTypeFunc(p, BLK) }
    unsafe { LibC.free(p) }
    return r
}








/**
 * @throws IllegalArgumentException
 * @throws IllegalMemoryException
 */
@Deprecated
public func isFIFO(path: String): Bool {
    if (path.contains(NULL_BYTE)) {
        return false
    }
    var p: CString = unsafe { LibC.mallocCString(path) }
    let r: Bool = unsafe { CJ_OS_IsTypeFunc(p, FIFO) }
    unsafe { LibC.free(p) }
    return r
}








/**
 * @throws IllegalArgumentException
 * @throws IllegalMemoryException
 */
@When[os != "Windows"]
@Deprecated
public func isSock(path: String): Bool {
    if (path.contains(NULL_BYTE)) {
        return false
    }
    var p: CString = unsafe { LibC.mallocCString(path) }
    let r: Bool = unsafe { CJ_OS_IsTypeFunc(p, SOCK) }
    unsafe { LibC.free(p) }
    return r
}








/**
 * @throws IllegalArgumentException
 * @throws IllegalMemoryException
 */
@When[os != "Windows"]
@Deprecated
public func isLnk(path: String): Bool {
    if (path.contains(NULL_BYTE)) {
        return false
    }
    var p: CString = unsafe { LibC.mallocCString(path) }
    let r: Bool = unsafe { CJ_OS_IsTypeFunc(p, LNK) }
    unsafe { LibC.free(p) }
    return r
}









/**
 * @throws IllegalArgumentException
 * @throws IllegalMemoryException
 */
@Deprecated
public func chdir(path: String): Int32 {
    checkPath(path)
    var p: CString = unsafe { LibC.mallocCString(path) }
    let r: Int32 = unsafe { chdir(p) }
    unsafe { LibC.free(p) }
    return r
}









@When[os != "Windows"]
@Deprecated
public func fchdir(fd: Int32): Int32 {
    return unsafe { CJ_OS_Fchdir(fd) }
}







@Deprecated
public func getcwd(): String {
    var s: CString = unsafe { CJ_OS_GetCwd() }
    try {
        return s.toString()
    } finally {
        unsafe { LibC.free(s) }
    }
}








@When[os == "Linux"]
@Deprecated
public func getos(): String {
    unsafe {
        let os = CJ_OS_GetOs()
        if (os.isNull()) {
            return String()
        }
        try {
            return os.toString()
        } finally {
            LibC.free(os)
        }
    }
}








/**
 * @throws IndexOutOfBoundsException
 * @throws IllegalArgumentException
 * @throws IllegalMemoryException
 */
@When[os != "Windows"]
@Deprecated
public func gethostname(): String {
    var strArr: Array<Rune> = Array<Rune>(1024, {_ => r'\0'})
    var array: Array<Rune> = strArr
    var cstr: CString = unsafe { LibC.mallocCString(String(array)) }
    var res: Int32 = unsafe { gethostname(cstr, 1024) }
    if (res == -1) {
        unsafe { LibC.free(cstr) }
        return String.empty
    }
    try {
        return cstr.toString()
    } finally {
        unsafe { LibC.free(cstr) }
    }
}









/**
 * @throws IllegalArgumentException
 * @throws IllegalMemoryException
 */
@When[os != "Windows"]
@Deprecated
public func sethostname(buf: String): Int32 {
    checkPath(buf)
    var b: CString = unsafe { LibC.mallocCString(buf) }
    let r: Int32 = unsafe { sethostname(b, UIntNative(b.size())) }
    unsafe { LibC.free(b) }
    return r
}







@When[os != "Windows"]
@Deprecated
public func getlogin(): String {
    var s: CString = unsafe { CJ_OS_Getlogin() }
    let res: String = s.toString()
    return res
}











/**
 * @throws IllegalArgumentException
 * @throws IllegalMemoryException
 */
@When[os != "Windows"]
@Deprecated
public func link(path: String, newpath: String): Int32 {
    checkPath(path)
    checkPath(newpath)
    unsafe {
        var r: Int32 = -1
        try (oldp = LibC.mallocCString(path).asResource(), newp = LibC.mallocCString(newpath).asResource()) {
            r = link(oldp.value, newp.value)
        }
        return r
    }
}















/**
 * @throws IllegalArgumentException
 * @throws IllegalMemoryException
 */
@When[os != "Windows"]
@Deprecated
public func unlink(path: String): Int32 {
    checkPath(path)
    var p: CString = unsafe { LibC.mallocCString(path) }
    let r: Int32 = unsafe { unlink(p) }
    unsafe { LibC.free(p) }
    return r
}





@When[os != "macOS"]
@Deprecated
public const AT_EMPTY_PATH: Int32 = 0x1000




@When[os != "macOS"]
@Deprecated
public const AT_SYMLINK_FOLLOW: Int32 = 0x400
@When[os == "macOS"]
@Deprecated
public const AT_SYMLINK_FOLLOW: Int32 = 0x040


@When[os != "macOS"]
@Deprecated
public const AT_FDCWD: Int32 = -0x64
@When[os == "macOS"]
@Deprecated
public const AT_FDCWD: Int32 = -2














/**
 * @throws IllegalArgumentException
 * @throws IllegalMemoryException
 */
@When[os != "Windows"]
@Deprecated
public func linkat(fd: Int32, path: String, nfd: Int32, newPath: String, lflag: Int32): Int32 {
    checkPath(path)
    checkPath(newPath)
    unsafe {
        var r: Int32 = -1
        try (oldp = LibC.mallocCString(path).asResource(), newp = LibC.mallocCString(newPath).asResource()) {
            r = linkat(fd, oldp.value, nfd, newp.value, lflag)
        }
        return r
    }
}


@Deprecated
public const AT_REMOVEDIR: Int32 = 0x200
















/**
 * @throws IllegalArgumentException
 * @throws IllegalMemoryException
 */
@When[os != "Windows"]
@Deprecated
public func unlinkat(fd: Int32, path: String, ulflag: Int32): Int32 {
    checkPath(path)
    var p: CString = unsafe { LibC.mallocCString(path) }
    var r: Int32 = unsafe { unlinkat(fd, p, ulflag) }
    unsafe { LibC.free(p) }
    return r
}
















/**
 * @throws IllegalArgumentException
 * @throws IllegalMemoryException
 */
@When[os != "Windows"]
@Deprecated
public func symlink(path: String, symPath: String): Int32 {
    checkPath(path)
    checkPath(symPath)
    unsafe {
        var r: Int32 = -1
        try (p = LibC.mallocCString(path).asResource(), symp = LibC.mallocCString(symPath).asResource()) {
            r = symlink(p.value, symp.value)
        }
        return r
    }
}














/**
 * @throws IllegalArgumentException
 * @throws IllegalMemoryException
 */
@When[os != "Windows"]
@Deprecated
public func symlinkat(path: String, fd: Int32, symPath: String): Int32 {
    checkPath(path)
    checkPath(symPath)
    unsafe {
        var r: Int32 = -1
        try (p = LibC.mallocCString(path).asResource(), symP = LibC.mallocCString(symPath).asResource()) {
            r = symlinkat(p.value, fd, symP.value)
        }
        return r
    }
}










/**
 * @throws IllegalArgumentException
 * @throws IllegalMemoryException
 */
@Deprecated
public func remove(path: String): Int32 {
    checkPath(path)
    var p: CString = unsafe { LibC.mallocCString(path) }
    let r: Int32 = unsafe { remove(p) }
    unsafe { LibC.free(p) }
    return r
}


















/**
 * @throws IllegalArgumentException
 * @throws IllegalMemoryException
 */
@Deprecated
public func rename(oldName: String, newName: String): Int32 {
    checkPath(oldName)
    checkPath(newName)
    unsafe {
        var r: Int32 = -1
        try (oldN = LibC.mallocCString(oldName).asResource(), newN = LibC.mallocCString(newName).asResource()) {
            r = rename(oldN.value, newN.value)
        }
        return r
    }
}
















/**
 * @throws IllegalArgumentException
 * @throws IllegalMemoryException
 */
@When[os != "Windows"]
@Deprecated
public func renameat(oldfd: Int32, oldName: String, newfd: Int32, newName: String): Int32 {
    checkPath(oldName)
    checkPath(newName)
    unsafe {
        var r: Int32 = -1
        try (oldN = LibC.mallocCString(oldName).asResource(), newN = LibC.mallocCString(newName).asResource()) {
            r = renameat(oldfd, oldN.value, newfd, newN.value)
        }
        return r
    }
}

/**
 * @throws IllegalArgumentException
 */
func checkPath(path: String): Unit {
    if (path.contains(NULL_BYTE)) {
        throw IllegalArgumentException("The path cannot contain null character!")
    }
}
