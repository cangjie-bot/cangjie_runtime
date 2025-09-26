






package std.unittest.mock

import std.unittest.common.*

public abstract class PrettyException <: Exception & PrettyPrintable {
    /**
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    PrettyException(
        private let text: PrettyText
    ) {
        super(text.toString())
    }

    public func pprint(to: PrettyPrinter): PrettyPrinter {
        text.pprint(to)
    }
}


public class MockFrameworkInternalError <: PrettyException {
    /**
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    MockFrameworkInternalError(
        text: PrettyText
    ) {
        super(text)
    }
}


public class MockFrameworkException <: PrettyException {
    /**
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    MockFrameworkException(
        text: PrettyText
    ) {
        super(text)
    }
}


public open class ExpectationFailedException <: PrettyException {
    /**
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    ExpectationFailedException(
        text: PrettyText
    ) {
        super(text)
    }
}


public class UnnecessaryStubbingException <: PrettyException {
    /**
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    UnnecessaryStubbingException(
        text: PrettyText
    ) {
        super(text)
    }
}


public class UnstubbedInvocationException <: PrettyException {
    /**
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    UnstubbedInvocationException(
        text: PrettyText
    ) {
        super(text)
    }
}


public class UnhandledCallException <: PrettyException {
    /**
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    UnhandledCallException(
        text: PrettyText
    ) {
        super(text)
    }
}

public class VerificationFailedException <: PrettyException {
    /**
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    VerificationFailedException(
        text: PrettyText
    ) {
        super(text)
    }
}
