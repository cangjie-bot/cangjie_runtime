







package std.unittest

import std.unittest.common.optionsInfo
import std.process.Process
import std.collection.ArrayList
import std.unittest.common.*




/**
 * @throws ProcessException
 * @throws IndexOutOfBoundsException
 * @throws OutOfMemoryError
 * @throws IllegalArgumentException
 */
func printUnittestHelpPageIfRequested(): Bool {
    if (!needToPrintHelpPage()) {
        return false
    }

    let printer = ConsoleOptionsPrinter()

    let userDefinedOptions = ArrayList<OptionInfo>()
    let internalOptions = ArrayList<OptionInfo>()
    for ((_, info) in optionsInfo) {
        if (info.userDefined) {
            userDefinedOptions.add(info)
        } else {
            internalOptions.add(info)
        }
    }

    if (userDefinedOptions.size != 0) {
        printer.header("User defined options")
        for (info in userDefinedOptions) {
            printer.option(info)
        }
    }

    printer.header("Unittest options")
    for (info in internalOptions) {
        printer.option(info)
    }

    return true
}

/**
 * @throws OutOfMemoryError
 * @throws ProcessException
 * @throws IllegalArgumentException
 * @throws IndexOutOfBoundsException
 */
private func needToPrintHelpPage(): Bool {
    let args = Process.current.arguments
    if (args.size == 0) {
        return false
    }
    let firstArg = args[0]

    return firstArg == "help" || firstArg == "--help" || firstArg == "-h" || firstArg == "-help"
}

private class ConsoleOptionsPrinter {
    let pp: PrettyPrinter = TerminalPrettyPrinter.fromDefaultConfiguration()

    /**
     * @throws IllegalArgumentException
     */
    func header(str: String): Unit {
        pp.appendLine(str + ":")
    }

    /**
     * @throws IndexOutOfBoundsException
     * @throws OutOfMemoryError
     * @throws IllegalArgumentException
     */
    func option(info: OptionInfo): Unit {
        pp.colored(GREEN, "--${camelCaseToKebabCase(info.name)} ")

        if (let Some(description) <- info.description) {
            pp.colored((MAGENTA), description)
            pp.newLine()
        }

        var needNewLine = false
        for ((ty, typeDescription) in info.types) {
            if (needNewLine) {
                pp.newLine()
            }

            optionType(ty)
            if (let Some(description) <- typeDescription) {
                optionDesription(description)
                needNewLine = true
            }
        }

        pp.newLine()
    }

    /**
     * @throws IllegalArgumentException
     */
    private func optionType(ty: String): Unit {
        pp.indent {
            pp.append("[").colored(RED, "${ty}").append("]")
        }
    }

    /**
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     * @throws OutOfMemoryError
     */
    private func optionDesription(description: String): Unit {
        pp.append(" - ")
        var quoted = false
        for (str in description.split("'")) {
            if (quoted) {
                pp.append("'").colored(YELLOW, str).append("'")
            } else {
                pp.colored(GRAY, str)
            }
            quoted = !quoted
        }
    }
}
