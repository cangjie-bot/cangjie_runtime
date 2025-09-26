






package std.unittest.mock

import std.collection.*
import std.unittest.mock.internal.FuncInfo
import std.unittest.common.PrettyText
enum RuntimeFailureReason {
    | UnstubbedDeclaration(FuncInfo)
    | NoneMatchedArguments(Array<(StubChain, Array<Int64>)>)
    | TooManyInvocationsForStubChain(StubChain)
    | UnwantedInteraction(StubChain)
}

/**
 * @throws IndexOutOfBoundsException
 * @throws MockFrameworkInternalError
 * @throws IllegalArgumentException
 */
func unhandledInvocationReport(
    invocation: Invocation,
    unmatchedChains: UnmatchedChains,
    invocationLog: LogSnapshot
): PrettyException {
    let mismatchedArguments = ArrayList<(StubChain, Array<Int64>)>()
    let nameRegistry = MockNameRegistry()
    for ((chain, status) in unmatchedChains) {
        match (status) {
            case ArgumentMismatch(indices) =>
                nameRegistry.submit(chain.invocationMatcher)
                mismatchedArguments.add((chain, indices))
            case _ => ()
        }
    }
    let failureReport = RuntimeFailureReport(invocationLog, nameRegistry)
    if (!mismatchedArguments.isEmpty()) {
        return UnhandledCallException(
            failureReport.render(invocation, NoneMatchedArguments(mismatchedArguments.toArray()))
        )
    }
    return UnstubbedInvocationException(
        failureReport.render(invocation, UnstubbedDeclaration(invocation.call.funcInfo))
    )
}

/**
 * @throws IndexOutOfBoundsException
 * @throws MockFrameworkInternalError
 * @throws IllegalArgumentException
 */
func invocationLimitExceededReport(currentInvocation: Invocation, chain: StubChain, invocationLog: LogSnapshot): PrettyException {
    let message = RuntimeFailureReport(
        invocationLog,
        MockNameRegistry(chain.invocationMatcher)
    ).render(currentInvocation, TooManyInvocationsForStubChain(chain))
    return ExpectationFailedException(message)
}

/**
 * @throws IndexOutOfBoundsException
 * @throws MockFrameworkInternalError
 * @throws IllegalArgumentException
 */
func runtimeUnwantedInteraction(currentInvocation: Invocation, sc: Scenario, invocationLog: LogSnapshot): PrettyException {
    let message = RuntimeFailureReport(
        invocationLog,
        MockNameRegistry(sc.parentChain.invocationMatcher)
    ).render(currentInvocation, UnwantedInteraction(sc.parentChain))
    return ExpectationFailedException(message)
}

class RuntimeFailureReport <: FailureReport {
    RuntimeFailureReport(
        invocationLog: LogSnapshot,
        nameRegistry: MockNameRegistry
    ) {
        super(invocationLog, nameRegistry)
    }

    /**
     * @throws IndexOutOfBoundsException
     * @throws MockFrameworkInternalError
     * @throws IllegalArgumentException
     */
    func render(invocation: Invocation, reason: RuntimeFailureReason): PrettyText {
        build {
            match (reason) {
                case TooManyInvocationsForStubChain(_) => errorLine("Expectation failed")
                case UnwantedInteraction(_) => line {
                    error("Unwanted interaction")
                    renderInvocationWithLocation(invocation)
                }
                case _ => line {
                    error("Unhandled invocation")
                    renderInvocationWithLocation(invocation)
                }
            }
            indent {
                renderReason(invocation, reason)
            }
        }
    }

    /**
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     * @throws MockFrameworkInternalError
     */
    private func renderReason(invocation: Invocation, reason: RuntimeFailureReason): Unit {
        match (reason) {
            case UnstubbedDeclaration(funcInfo) =>
                line {
                    text("No stubs were specified for")
                    renderDeclarationNameAndKind(funcInfo, getterSetterPrefix: true)
                    if (invocation.isDefaultEnabled) {
                        text("and it does not have a default value. Use stubs to define the value.")
                    }
                }

            case NoneMatchedArguments(chainToMismatchedIndices) =>
                line("None of the following stubs matched the arguments:")
                indent {
                    for ((chain, unmatchedArgumentIndices) in chainToMismatchedIndices) {
                        listEntry { renderMatcher(chain.invocationMatcher, atString: "declared at") }
                        indent {
                            reportArgumentMismatch(chain.invocationMatcher, unmatchedArgumentIndices)
                        }
                    }
                }

            case TooManyInvocationsForStubChain(thisChain) =>
                let requiredCardinality = thisChain.getTotalCardinality()
                let previousInvocations = thisChain.getTotalInvocationCount()
                line {
                    text("Too many invocations for")
                    renderStub(thisChain)
                }
                indent {
                    renderRequiredActual(previousInvocations + 1) {
                        renderCardinalityMax(requiredCardinality)
                    }
                    let handledByThisChain = findInvocationsHandledByChain(thisChain)
                    if (!handledByThisChain.isEmpty()) {
                        line("Invocations handled by this stub occured at:")
                        indent {
                            renderInvocationList(handledByThisChain)
                        }
                    }
                }

            case UnwantedInteraction(stubChain) =>
                let totalCardinality = stubChain.getTotalCardinality()
                match (totalCardinality.max) {
                    case None => internalError("Invalid cardinality")
                    case Some(0) =>
                        line {
                            text("Explicitly prohibited by ")
                            renderStub(stubChain)
                        }
                    case Some(timesAllowed) =>
                        line {
                            text("Only ")
                            userCode(timesAllowed)
                            text("invocations allowed by ")
                            renderStub(stubChain)
                        }
                        line("Previous invocations handled by this stub occured at:")
                        indent {
                            renderInvocationList(findInvocationsHandledByChain(stubChain))
                        }
                }
        }
    }

    /**
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    func findInvocationsHandledByChain(stubChain: StubChain): Array<Invocation> {
        invocationLog.entries |>
            filter { entry: LogEntry => entry.wasHandledBy(stubChain) } |>
            map { entry: LogEntry => entry.invocation } |>
            collectArray
    }
}
