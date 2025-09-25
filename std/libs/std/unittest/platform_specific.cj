






package std.unittest

import std.process.Process

@When[os == "Windows"]
extend Process {
    static prop currentArgs: Array<String> {
        get() { Process.current.arguments }
    }
}

@When[os != "Windows"]
extend Process {
    static prop currentArgs: Array<String> {
        /*
         * @throws OutOfMemoryError
         * @throws ProcessException
         * @throws IndexOutOfBoundsException
         * @throws IllegalArgumentException
         */
        get() {
            var cmdl = Process.current.commandLine
            cmdl[1..cmdl.size]
        }
    }
}
