






package std.unittest.mock

import std.unittest.common.PrettyText

enum VerificationFailedReason {
      /*
       * @noThrow
       */
    | TooFewInvocations(VerifyStatement, Cardinality, Int64)
      /*
       * @noThrow
       */
    | TooManyInvocations(VerifyStatement, Cardinality, Int64)
      /*
       * @noThrow
       */
    | UnmatchedStatements(Array<VerifyStatement>)
      /*
       * @noThrow
       */
    | UnmatchedInvocations(Array<Invocation>)
      /*
       * @noThrow
       */
    | UnexpectedInvocation(VerifyStatement, Invocation)
      /*
       * @noThrow
       */
    | NonDisjointStatements(VerifyStatement, VerifyStatement, Invocation)
      /*
       * @noThrow
       */
    | UnwantedInteractions(Array<Invocation>)
}

class VerificationFailureReport <: FailureReport {
    /*
     * @noThrow
     */
    VerificationFailureReport(
        logSnapshot: LogSnapshot,
        nameRegistry: MockNameRegistry
    ) {
        super(logSnapshot, nameRegistry)
    }

    /*
     * @throws MockFrameworkException
     * @throws IndexOutOfBoundsException
     * @throws MockFrameworkInternalError
     * @throws IllegalArgumentException
     * @throws VerificationFailedException
     */
    func fail(reason: VerificationFailedReason): Nothing {
        throw VerificationFailedException(renderVerificationFailure(reason))
    }

    /*
     * @throws MockFrameworkException
     * @throws IndexOutOfBoundsException
     * @throws MockFrameworkInternalError
     * @throws IllegalArgumentException
     */
    private func renderVerificationFailure(reason: VerificationFailedReason): PrettyText {
        build {
            errorHeader("Verification failed")
            indent {
                renderReason(reason)
            }
        }
    }

    /*
     * @throws IndexOutOfBoundsException
     * @throws MockFrameworkInternalError
     * @throws IllegalArgumentException
     */
    private func renderTooManyInvocations(
        statement: VerifyStatement,
        requiredCardinality: Cardinality,
        actualInvocations: Int64
    ) {
        line {
            text("Too many invocations for")
            renderStatement(statement)
        }
        indent {
            renderRequiredActual(actualInvocations) {
                renderCardinalityMax(requiredCardinality)
            }
            renderMatchingInvocations(statement.invocationMatcher)
        }
    }

    /*
     * @throws IndexOutOfBoundsException
     * @throws MockFrameworkInternalError
     * @throws IllegalArgumentException
     */
    private func renderTooFewInvocations(
        statement: VerifyStatement,
        requiredCardinality: Cardinality,
        actualInvocations: Int64
    ) {
        line {
            text("Too few invocations for")
            renderStatement(statement)
        }
        indent {
            renderRequiredActual(actualInvocations) {
                renderCardinalityMin(requiredCardinality)
            }
            renderMatchingInvocations(statement.invocationMatcher)
        }
    }

    /*
     * @throws MockFrameworkException
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    private func renderUnexpectedInvocation(statement: VerifyStatement, invocation: Invocation) {
        line("Unexpected invocation.")
        line {
            text("Expected:")
            renderMatcher(statement.invocationMatcher, atString: "expected by statement at")
        }
        line {
            text("Actual:")
            renderInvocationWithLocation(invocation, atString: "invoked at")
        }
        match (statement.invocationMatcher.tryMatch(invocation)) {
            case Ok => illegalInput("Inconsistent argument matchers.")
            case ReceiverMismatch => ()
            case FuncMismatch =>
                if (let Some(methodName) <- sameName(invocation, statement)) {
                    line {
                        error("Wrong overloaded version")
                        text("of method")
                        userCode(methodName)
                        text("was invoked.")
                    }
                }
            case ArgumentMismatch(indices) =>
                errorLine("Argument mismatch:")
                indent {
                    reportArgumentMismatch(statement.invocationMatcher, indices)
                }
            case TypeArgMismatch(_) =>
                errorLine("Type arguments mismatch")
        }
    }

    /*
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    private func renderUnmatchedInvocations(invocations: Array<Invocation>) {
        line("The following invocations were not matched by any statement:")
        indent {
            for (invocation in invocations) {
                listEntry { renderInvocationWithLocation(invocation) }
            }
        }
    }

    /*
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    private func renderUnmatchedStatements(statements: Array<VerifyStatement>) {
        line("The following statements were not matched by any invocations:")
        indent {
            for (statement in statements) {
                listEntry { renderMatcher(statement.invocationMatcher, atString: "declared at") }
            }
        }
    }

    /*
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    private func renderNonDisjointStatements(
        statement1: VerifyStatement,
        statement2: VerifyStatement,
        invocation: Invocation
    ) {
        line("The following invocation:")
        indent {
            line { renderInvocationWithLocation(invocation) }
        }
        line("Was matched by several statements:")
        indent {
            line { renderMatcher(statement1.invocationMatcher, atString: "declared at") }
            line { renderMatcher(statement2.invocationMatcher, atString: "declared at") }
        }
        line("Provide disjoint statements to avoid ambiguous verification results.")
    }

    /*
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    private func renderUnwantedInteractions(invocations: Array<Invocation>) {
        line("Unwanted interactions:")
        indent {
            for (invocation in invocations) {
                listEntry { renderInvocationWithLocation(invocation) }
            }
        }
    }

    /*
     * @throws MockFrameworkException
     * @throws IndexOutOfBoundsException
     * @throws MockFrameworkInternalError
     * @throws IllegalArgumentException
     */
    private func renderReason(reason: VerificationFailedReason): Unit {
        match (reason) {
            case TooManyInvocations(statement, requiredCardinality, actualInvocations) =>
                renderTooManyInvocations(statement, requiredCardinality, actualInvocations)

            case TooFewInvocations(statement, requiredCardinality, actualInvocations) =>
                renderTooFewInvocations(statement, requiredCardinality, actualInvocations)

            case UnmatchedInvocations(invocations) =>
                renderUnmatchedInvocations(invocations)

            case UnmatchedStatements(statements) =>
                renderUnmatchedStatements(statements)

            case NonDisjointStatements(statement1, statement2, invocation) =>
                renderNonDisjointStatements(statement1, statement2, invocation)

            case UnexpectedInvocation(statement, invocation) =>
                renderUnexpectedInvocation(statement, invocation)

            case UnwantedInteractions(invocations) =>
                renderUnwantedInteractions(invocations)
        }
    }

    /*
     * @noThrow
     */
    private func sameName(invocation: Invocation, statement: VerifyStatement): ?String {
        match ((
            statement.invocationMatcher.stubId.funcInfo.kind,
            invocation.call.funcInfo.kind
        )) {
            case (Method(statementName), Method(invocationName))
                where statementName == invocationName => statementName
            case _ => None
        }
    }
}
