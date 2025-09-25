







package std.core

@When[backend == "cjnative"]
func getCommandLineArgsFromRuntime(): CPointer<CPointer<UInt8>> {
    unsafe {
        let argv = CJ_MRT_GetCommandLineArgs()
        if (argv.isNull()) {
            return argv
        } else {
            return argv + 1
        }
    }
}

func getCommandLineArgs(): Array<String> {
    let argv = getCommandLineArgsFromRuntime()
    if (argv.isNull()) {
        return Array<String>()
    }

    var argc: Int64 = 0
    while (true) {
        let cstr: CPointer<UInt8> = unsafe { argv.read(argc) }
        if (cstr.isNull()) {
            break
        }
        argc++
    }

    let args: Array<String> = Array<String>(argc, repeat: String())
    for (argIndex in 0..argc) {
        let cstr: CPointer<UInt8> = unsafe { argv.read(argIndex) }

        let cstrLen: Int64 = unsafe { Int64(strlen(cstr)) }
        let arg: Array<UInt8> = Array<UInt8>(cstrLen, repeat: 0)
        for (charIndex in 0..cstrLen) {
            arg[charIndex] = unsafe { UInt8(cstr.read(charIndex)) }
        }
        args[argIndex] = String.fromUtf8(arg)
    }
    return args
}
