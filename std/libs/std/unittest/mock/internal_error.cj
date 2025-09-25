






package std.unittest.mock

import std.unittest.common.PrettyText

enum InternalError {
    InconsistentState(String)
    | AssertionFailed(String)
    | Unimplemented(String)
}

func internalError(e: InternalError): Nothing {
    let report = FailureReport()
    let message = report.build {
        report.errorLine("Mock framework internal error")
        match (e) {
            case InconsistentState(info) => report.line(info)
            case AssertionFailed(info) => report.line(info)
            case Unimplemented(featureName) => report.line("Feature '${featureName}' is not yet implemented")
        }
    }
    throw MockFrameworkInternalError(message)
}

func internalError(assertion: String): Nothing {
    internalError(AssertionFailed(assertion))
}

func illegalInput(text: String): Nothing {
    throw MockFrameworkException(PrettyText(text))
}
