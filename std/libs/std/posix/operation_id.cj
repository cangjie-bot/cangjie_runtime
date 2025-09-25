










package std.posix


@Deprecated
public const SIGHUP: Int32 = 0x1


@Deprecated
public const SIGINT: Int32 = 0x2


@Deprecated
public const SIGQUIT: Int32 = 0x3


@Deprecated
public const SIGILL: Int32 = 0x4


@Deprecated
public const SIGTRAP: Int32 = 0x5


@Deprecated
public const SIGABRT: Int32 = 0x6


@Deprecated
public const SIGIOT: Int32 = 0x6


@When[os != "macOS"]
@Deprecated
public const SIGBUS: Int32 = 0x7
@When[os == "macOS"]
@Deprecated
public const SIGBUS: Int32 = 0xA


@Deprecated
public const SIGFPE: Int32 = 0x8


@Deprecated
public const SIGKILL: Int32 = 0x9


@When[os != "macOS"]
@Deprecated
public const SIGUSR1: Int32 = 0xA
@When[os == "macOS"]
@Deprecated
public const SIGUSR1: Int32 = 0x1E


@Deprecated
public const SIGSEGV: Int32 = 0xB


@When[os != "macOS"]
@Deprecated
public const SIGUSR2: Int32 = 0xC
@When[os == "macOS"]
@Deprecated
public const SIGUSR2: Int32 = 0x1F


@Deprecated
public const SIGPIPE: Int32 = 0xD


@Deprecated
public const SIGALRM: Int32 = 0xE


@Deprecated
public const SIGTERM: Int32 = 0xF


@When[os != "macOS"]
@Deprecated
public const SIGSTKFLT: Int32 = 0x10


@When[os != "macOS"]
@Deprecated
public const SIGCHLD: Int32 = 0x11
@When[os == "macOS"]
@Deprecated
public const SIGCHLD: Int32 = 0x14


@When[os != "macOS"]
@Deprecated
public const SIGCONT: Int32 = 0x12
@When[os == "macOS"]
@Deprecated
public const SIGCONT: Int32 = 0x13


@When[os != "macOS"]
@Deprecated
public const SIGSTOP: Int32 = 0x13
@When[os == "macOS"]
@Deprecated
public const SIGSTOP: Int32 = 0x11


@When[os != "macOS"]
@Deprecated
public const SIGTSTP: Int32 = 0x14
@When[os == "macOS"]
@Deprecated
public const SIGTSTP: Int32 = 0x12


@Deprecated
public const SIGTTIN: Int32 = 0x15


@Deprecated
public const SIGTTOU: Int32 = 0x16


@When[os != "macOS"]
@Deprecated
public const SIGURG: Int32 = 0x17
@When[os == "macOS"]
@Deprecated
public const SIGURG: Int32 = 0x10


@Deprecated
public const SIGXCPU: Int32 = 0x18


@Deprecated
public const SIGXFSZ: Int32 = 0x19


@Deprecated
public const SIGVTALRM: Int32 = 0x1A


@Deprecated
public const SIGPROF: Int32 = 0x1B


@Deprecated
public const SIGWINCH: Int32 = 0x1C


@When[os != "macOS"]
@Deprecated
public const SIGIO: Int32 = 0x1D
@When[os == "macOS"]
@Deprecated
public const SIGIO: Int32 = 0x17


@When[os != "macOS"]
@Deprecated
public const SIGPWR: Int32 = 0x1E


@When[os != "macOS"]
@Deprecated
public const SIGSYS: Int32 = 0x1F
@When[os == "macOS"]
@Deprecated
public const SIGSYS: Int32 = 0xC







@When[os == "Linux" || os == "macOS"]
@Deprecated
public func getgid(): UInt32 {
    return unsafe { CJ_OS_Getgid() }
}







@When[os == "Linux" || os == "macOS"]
@Deprecated
public func getuid(): UInt32 {
    return unsafe { CJ_OS_Getuid() }
}








@When[os == "Linux" || os == "macOS"]
@Deprecated
public func setgid(id: UInt32): Int32 {
    return unsafe { CJ_OS_Setgid(id) }
}








@When[os == "Linux" || os == "macOS"]
@Deprecated
public func setuid(id: UInt32): Int32 {
    return unsafe { CJ_OS_Setuid(id) }
}








@When[os == "Linux" || os == "macOS"]
@Deprecated
public func getpgid(pid: Int32): Int32 {
    return unsafe { CJ_OS_Getpgid(pid) }
}











@When[os == "Linux" || os == "macOS"]
@Deprecated
public unsafe func getgroups(size: Int32, gidArray: CPointer<UInt32>): Int32 {
    return CJ_OS_Getgroups(size, gidArray)
}







@When[os == "Linux" || os == "Windows" || os == "macOS"]
@Deprecated
public func getpid(): Int32 {
    return unsafe { CJ_OS_Getpid() }
}







@When[os == "Linux" || os == "macOS"]
@Deprecated
public func getppid(): Int32 {
    return unsafe { CJ_OS_Getppid() }
}








@When[os == "Linux" || os == "macOS"]
@Deprecated
public func getpgrp(): Int32 {
    return unsafe { CJ_OS_Getpgrp() }
}








@When[os == "Linux" || os == "macOS"]
@Deprecated
public func setpgrp(): Int32 {
    return unsafe { CJ_OS_Setpgrp() }
}










@When[os == "Linux" || os == "macOS"]
@Deprecated
public func setpgid(pid: Int32, pgrp: Int32): Int32 {
    return unsafe { CJ_OS_Setpgid(pid, pgrp) }
}










@When[os == "Linux" || os == "macOS"]
@Deprecated
public func nice(inc: Int32): Int32 {
    return unsafe { CJ_OS_Nice(inc) }
}














@When[os == "Linux" || os == "macOS"]
@Deprecated
public func kill(pid: Int32, sig: Int32): Int32 {
    return unsafe { CJ_OS_Kill(pid, sig) }
}









@When[os == "Linux" || os == "macOS"]
@Deprecated
public func killpg(pgid: Int32, sig: Int32): Int32 {
    return unsafe { CJ_OS_Killpg(pgid, sig) }
}
