






package std.unittest

import std.core.println as corePrintln
import std.core.print as corePrint

class ProgressOutput {
    private let isVerbose: Bool

    /**
     * @throws IndexOutOfBoundsException
     */
    ProgressOutput(configuration: Configuration) {
        this.isVerbose = configuration.get(KeyVerbose.verbose) ?? false
    }

    /**
     * @throws OutOfMemoryError
     */
    func println(message: () -> String) {
        corePrintln(message())
    }

    /**
     * @throws OutOfMemoryError
     */
    func verboseLine(message: String) {
        if (isVerbose) {
            corePrintln(message)
        }
    }

    /**
     * @throws OutOfMemoryError
     */
    func verbose(message: String) {
        if (isVerbose) {
            corePrint(message)
        }
    }
}
