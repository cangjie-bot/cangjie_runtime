







package std.posix












@FastNative
foreign func open(pathname: CString, flags: Int32, ...): Int32

@FastNative
@When[os != "Windows" && os != "macOS"]
foreign func open64(pathname: CString, flags: Int32, ...): Int32













@FastNative
@When[os != "Windows"]
foreign func openat(dirfd: Int32, pathname: CString, flags: Int32, ...): Int32

@FastNative
@When[os != "Windows" && os != "macOS"]
foreign func openat64(dirfd: Int32, pathname: CString, flags: Int32, ...): Int32











@FastNative
foreign func creat(pathname: CString, flags: UInt32): Int32











@FastNative
foreign func CJ_OS_Close(fd: Int32): Int32













@FastNative
foreign func CJ_OS_Lseek(fd: Int32, offset: Int64, whence: Int32): Int64










@FastNative
foreign func CJ_OS_Dup(oldfd: Int32): Int32











@FastNative
foreign func CJ_OS_Dup2(oldfd: Int32, newfd: Int32): Int32












foreign func CJ_OS_Read(fd: Int32, buf: CPointer<UInt8>, count: UIntNative): IntNative













@When[os != "Windows"]
foreign func CJ_OS_Pread(fd: Int32, buf: CPointer<UInt8>, count: UIntNative, offset: Int32): IntNative













foreign func CJ_OS_Write(fd: Int32, buf: CPointer<UInt8>, count: UIntNative): IntNative













@When[os != "Windows"]
foreign func CJ_OS_Pwrite(fd: Int32, buf: CPointer<UInt8>, count: UIntNative, offset: Int32): IntNative

@FastNative
@When[os != "Windows"]
foreign func CJ_OS_IsType(pathname: CString, mode: UInt32): Bool

@FastNative
foreign func CJ_OS_IsTypeFunc(fileName: CString, typeNum: Int32): Bool












@FastNative
foreign func access(pathname: CString, mode: Int32): Int32
















@FastNative
foreign func faccessat(dirfd: Int32, pathname: CString, mode: Int32, flags: Int32): Int32










@FastNative
foreign func CJ_OS_Umask(mask: UInt32): UInt32












@FastNative
foreign func chown(pathname: CString, owner: UInt32, group: UInt32): Int32













@FastNative
foreign func CJ_OS_Fchown(fd: Int32, owner: UInt32, group: UInt32): Int32













@FastNative
foreign func lchown(pathname: CString, owner: UInt32, group: UInt32): Int32














@FastNative
foreign func fchownat(dirfd: Int32, pathname: CString, owner: UInt32, group: UInt32, flags: Int32): Int32











@FastNative
foreign func chmod(pathname: CString, mode: UInt32): Int32











@FastNative
foreign func CJ_OS_Fchmod(fd: Int32, mode: UInt32): Int32













@FastNative
foreign func fchmodat(dirfd: Int32, pathname: CString, mode: UInt32, flags: Int32): Int32









@FastNative
foreign func CJ_OS_Getgid(): UInt32









@FastNative
foreign func CJ_OS_Getuid(): UInt32










@FastNative
foreign func CJ_OS_Setgid(gid: UInt32): Int32










@FastNative
foreign func CJ_OS_Setuid(uid: UInt32): Int32










@FastNative
foreign func CJ_OS_Getpgid(pid: Int32): Int32













@FastNative
foreign func CJ_OS_Getgroups(size: Int32, gidArray: CPointer<UInt32>): Int32









@FastNative
foreign func CJ_OS_Getpid(): Int32








@FastNative
foreign func CJ_OS_Getppid(): Int32










@FastNative
foreign func CJ_OS_Getpgrp(): Int32










@FastNative
foreign func CJ_OS_Setpgrp(): Int32












@FastNative
foreign func CJ_OS_Setpgid(pid: Int32, pgid: Int32): Int32












@FastNative
foreign func CJ_OS_Nice(inc: Int32): Int32
















@FastNative
foreign func CJ_OS_Kill(pid: Int32, sig: Int32): Int32











@FastNative
foreign func CJ_OS_Killpg(pgrp: Int32, sig: Int32): Int32












@FastNative
@When[os != "Windows"]
foreign func gethostname(name: CString, len: UIntNative): Int32











@FastNative
@When[os != "Windows"]
foreign func sethostname(name: CString, len: UIntNative): Int32










@FastNative
foreign func CJ_OS_Getlogin(): CString











@FastNative
foreign func chdir(path: CString): Int32











@FastNative
foreign func CJ_OS_Fchdir(fd: Int32): Int32

@FastNative
foreign func CJ_OS_GetCwd(): CString












@FastNative
foreign func link(oldpath: CString, newpath: CString): Int32
















@FastNative
@When[os != "Windows"]
foreign func unlink(pathname: CString): Int32















@FastNative
@When[os != "Windows"]
foreign func linkat(olddirfd: Int32, oldpath: CString, newdirfd: Int32, newpath: CString, flags: Int32): Int32

















@FastNative
foreign func unlinkat(dirfd: Int32, pathname: CString, flags: Int32): Int32

















@FastNative
foreign func symlink(target: CString, linkpath: CString): Int32















@FastNative
foreign func symlinkat(target: CString, newdirfd: Int32, linkpath: CString): Int32











@FastNative
foreign func remove(pathname: CString): Int32



















@FastNative
foreign func rename(oldpath: CString, newpath: CString): Int32


















@FastNative
foreign func renameat(olddirfd: Int32, oldpath: CString, newdirfd: Int32, newpath: CString): Int32










@FastNative
foreign func CJ_OS_Isatty(fd: Int32): Bool

foreign func CJ_OS_TtynameR(fd: Int32): CString
