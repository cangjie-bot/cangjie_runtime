






package std.unittest

import std.regex.Regex
import std.convert.Parsable

let OP_TIMEOUT_EACH_NAME = camelCaseToKebabCase(KeyTimeoutEach().name)
let OP_TIMEOUT_EACH = "--${OP_TIMEOUT_EACH_NAME}"
let TIMEOUT_EACH_KEY = kebabCaseToCamelCase(OP_TIMEOUT_EACH_NAME)
let VALUE_TIMEOUT_PATTERN: Regex = Regex("(\\d+(\\.\\d+)?)(millis|s|m|h)")

extend Configuration {
        /**
         * @throws IndexOutOfBoundsException
         */
    prop timeout: ?Duration {
        get() {
            get(KeyTimeout.timeout)
        }
    }

        /**
         * @throws IndexOutOfBoundsException
         */
    prop timeoutHandler: (TestCaseInfo) -> Unit {
        get() {
            get(KeyTimeoutHandler.timeoutHandler) ?? { _: TestCaseInfo => () }
        }
    }
}

/**
 * @throws Error
 * @throws UnittestTimeoutException
 */
func cancellationPoint() {
    if (Thread.currentThread.hasPendingCancellation) {
        throw UnittestTimeoutException()
    }
}

/**
 * @throws UnittestOptionValidationException
 * @throws RegexException
 * @throws IndexOutOfBoundsException
 * @throws ArithmeticException
 * @throws getOrThrow
 * @throws IllegalArgumentException
 * @throws IllegalMemoryException
 * @throws Exception
 * @throws UnittestCliOptionsFormatException
 */
func fillTimeoutKey(configuration: Configuration): Unit {
    if (let Some(timeout) <- configuration.get(KeyTimeoutEach.timeoutEach)) {
        if (let Some(parsed) <- parseTimeout(timeout)) {
            configuration.set(KeyTimeout.timeout, parsed)
        } else {
            throw UnittestCliOptionsFormatException(
                OP_TIMEOUT_EACH,
                actual: timeout,
                expected: "NUMBER(millis|s|m|h) format is expected. Example: 3s."
            )
        }
    }
}

/**
 * @throws RegexException
 * @throws IndexOutOfBoundsException
 * @throws ArithmeticException
 * @throws getOrThrow
 * @throws IllegalArgumentException
 * @throws IllegalMemoryException
 * @throws Exception
 */
private func parseTimeout(raw: String): ?Duration {
    if (let Some(data) <- VALUE_TIMEOUT_PATTERN.matcher(raw).fullMatch()) {
        let value = Float64.parse(data.matchString(1))
        let duration = match (data.matchString(3)) {
            case "millis" => Duration.millisecond
            case "s" => Duration.second
            case "m" => Duration.minute
            case "h" => Duration.hour
            case _ => throw Exception("unreachable")
        }
        duration * value
    } else {
        None
    }
}
