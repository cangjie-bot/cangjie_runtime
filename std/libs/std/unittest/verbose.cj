






package std.unittest

import std.core.println as corePrintln
import std.core.print as corePrint

class ProgressOutput {
    private let isVerbose: Bool

    ProgressOutput(configuration: Configuration) {
        this.isVerbose = configuration.get(KeyVerbose.verbose) ?? false
    }

    func println(message: () -> String) {
        corePrintln(message())
    }

    func verboseLine(message: String) {
        if (isVerbose) {
            corePrintln(message)
        }
    }

    func verbose(message: String) {
        if (isVerbose) {
            corePrint(message)
        }
    }
}
