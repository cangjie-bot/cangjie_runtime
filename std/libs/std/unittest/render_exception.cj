






package std.unittest

import std.unittest.common.PrettyText
import std.unittest.mock.PrettyException

/**
 * @throws IndexOutOfBoundsException
 * @throws IllegalArgumentException
 * @throws OutOfMemoryError
 */
func renderException(exception: Exception, preamble: ?PrettyText): PrettyText {
    let text = PrettyText()
    if (let Some(preamble) <- preamble) {
        text.append(preamble)
    }
    if (let Some(prettyError) <- (exception as PrettyException)) {
        text.append(prettyError)
    } else {
        text.append(exceptionToString(exception))
    }
    text
}

/**
 * @throws IndexOutOfBoundsException
 * @throws IllegalArgumentException
 * @throws OutOfMemoryError
 */
func exceptionToString(e: Exception): String {
    let traceElementArray: Array<StackTraceElement> = e.getStackTrace()
    var msg = StringBuilder("An exception has occurred:${e}\n")
    let indexAfterLast = indexOfFirstIrrelevantEntry(traceElementArray)
    for (index in 0..indexAfterLast) {
        let element = traceElementArray[index]
        let declaringClass = element.declaringClass
        let fileName = element.fileName
        let lineNumber = element.lineNumber.toString()
        msg.append("\tat ${declaringClass}.${methodName(element)}(${fileName}:${lineNumber})")
        if (index != indexAfterLast - 1) {
            msg.append("\n")
        }
    }
    return msg.toString()
}

/**
 * @throws IndexOutOfBoundsException
 */
func indexOfFirstIrrelevantEntry(elements: Array<StackTraceElement>): Int64 {
    var index = elements.size - 1
    while (index > 0) {
        let element = elements[index]
        if (index == elements.size - 1 && isEntryPoint(element)) {
            index--
            continue
        }
        let frameInsideUnittest = elements[index].declaringClass.startsWith("std.unittest")
        if (frameInsideUnittest) {
            index--
            continue
        }
        let hasAnyFramesInsideUnittest = index != (elements.size - 1)
        if (hasAnyFramesInsideUnittest) {
            if (isLambda(element)) {
                return index
            } else {
                return index + 1
            }
        } else {
            return elements.size
        }
    }
    return elements.size
}

@When[backend == "cjnative"]
func isEntryPoint(_: StackTraceElement): Bool {
    false
}

@When[backend == "cjnative"]
func isLambda(element: StackTraceElement): Bool {
    element.methodName.startsWith("lambda.")
}

/**
 * @throws IndexOutOfBoundsException
 * @throws IllegalArgumentException
 * @throws OutOfMemoryError
 */
@When[backend == "cjnative"]
func methodName(element: StackTraceElement): String {
    element.methodName.replace("::", ".")
}
