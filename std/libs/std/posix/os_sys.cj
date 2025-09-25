










package std.posix


@Deprecated
public const R_OK: Int32 = 0x4


@Deprecated
public const W_OK: Int32 = 0x2


@Deprecated
public const X_OK: Int32 = 0x1


@Deprecated
public const F_OK: Int32 = 0x0











@When[os == "Linux" || os == "Windows" || os == "macOS"]
@Deprecated
public func access(path: String, mode: Int32): Int32 {
    checkPath(path)
    unsafe {
        var p: CString = LibC.mallocCString(path)
        let r: Int32 = access(p, mode)
        LibC.free(p)
        return r
    }
}












@When[os == "Linux" || os == "macOS"]
@Deprecated
public func faccessat(fd: Int32, path: String, mode: Int32, flag: Int32): Int32 {
    checkPath(path)
    unsafe {
        var p: CString = LibC.mallocCString(path)
        let r: Int32 = faccessat(fd, p, mode, flag)
        LibC.free(p)
        return r
    }
}








@When[os == "Linux" || os == "Windows" || os == "macOS"]
@Deprecated
public func umask(cmask: UInt32): UInt32 {
    return unsafe { CJ_OS_Umask(cmask) }
}











@When[os == "Linux" || os == "macOS"]
@Deprecated
public func chown(path: String, owner: UInt32, group: UInt32): Int32 {
    checkPath(path)
    unsafe {
        var p: CString = LibC.mallocCString(path)
        let r: Int32 = chown(p, owner, group)
        LibC.free(p)
        return r
    }
}











@When[os == "Linux" || os == "macOS"]
@Deprecated
public func fchown(fd: Int32, owner: UInt32, group: UInt32): Int32 {
    return unsafe { CJ_OS_Fchown(fd, owner, group) }
}












@When[os == "Linux" || os == "macOS"]
@Deprecated
public func lchown(path: String, owner: UInt32, group: UInt32): Int32 {
    checkPath(path)
    unsafe {
        var p: CString = LibC.mallocCString(path)
        let r: Int32 = lchown(p, owner, group)
        LibC.free(p)
        return r
    }
}













@When[os == "Linux" || os == "macOS"]
@Deprecated
public func fchownat(fd: Int32, path: String, owner: UInt32, group: UInt32, flag: Int32): Int32 {
    checkPath(path)
    unsafe {
        var p: CString = LibC.mallocCString(path)
        let r: Int32 = fchownat(fd, p, owner, group, flag)
        LibC.free(p)
        return r
    }
}










@When[os == "Linux" || os == "Windows" || os == "macOS"]
@Deprecated
public func chmod(path: String, mode: UInt32): Int32 {
    checkPath(path)
    unsafe {
        var p: CString = LibC.mallocCString(path)
        let r: Int32 = chmod(p, mode)
        LibC.free(p)
        return r
    }
}









@When[os == "Linux" || os == "macOS"]
@Deprecated
public func fchmod(fd: Int32, mode: UInt32): Int32 {
    return unsafe { CJ_OS_Fchmod(fd, mode) }
}












@When[os == "Linux" || os == "macOS"]
@Deprecated
public func fchmodat(fd: Int32, path: String, mode: UInt32, flag: Int32): Int32 {
    checkPath(path)
    unsafe {
        var p: CString = LibC.mallocCString(path)
        let r: Int32 = fchmodat(fd, p, mode, flag)
        LibC.free(p)
        return r
    }
}








@When[os == "Linux" || os == "Windows" || os == "macOS"]
@Deprecated
public func isatty(fd: Int32): Bool {
    return unsafe { CJ_OS_Isatty(fd) }
}








@When[os == "Linux" || os == "macOS"]
@Deprecated
public func ttyname(fd: Int32): String {
    unsafe {
        var cstr: CString = CJ_OS_TtynameR(fd)
        if (cstr.isNull()) {
            return String()
        }
        try {
            return cstr.toString()
        } finally {
            LibC.free(cstr)
        }
    }
}
