






package std.unittest.mock

import std.unittest.common.*

public abstract class PrettyException <: Exception & PrettyPrintable {
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
    MockFrameworkInternalError(
        text: PrettyText
    ) {
        super(text)
    }
}


public class MockFrameworkException <: PrettyException {
    MockFrameworkException(
        text: PrettyText
    ) {
        super(text)
    }
}


public open class ExpectationFailedException <: PrettyException {
    ExpectationFailedException(
        text: PrettyText
    ) {
        super(text)
    }
}


public class UnnecessaryStubbingException <: PrettyException {
    UnnecessaryStubbingException(
        text: PrettyText
    ) {
        super(text)
    }
}


public class UnstubbedInvocationException <: PrettyException {
    UnstubbedInvocationException(
        text: PrettyText
    ) {
        super(text)
    }
}


public class UnhandledCallException <: PrettyException {
    UnhandledCallException(
        text: PrettyText
    ) {
        super(text)
    }
}

public class VerificationFailedException <: PrettyException {
    VerificationFailedException(
        text: PrettyText
    ) {
        super(text)
    }
}
