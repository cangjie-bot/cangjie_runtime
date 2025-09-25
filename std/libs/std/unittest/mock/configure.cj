






package std.unittest.mock

import std.collection.ArrayList

public class ConfigureMock {
    private static const STATIC_DECLARATIONS_MOCK_KIND = MockKind.Spy

    /*
     * @noThrow
     */
    private ConfigureMock() {}

    /*
     * @throws IllegalSynchronizationStateException
     * @throws MockFrameworkException
     * @throws MockFrameworkInternalError
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    public static func stubFunction<TRet>(
        stubCall: () -> TRet,
        matchers: Array<ArgumentMatcher>,
        prefixRefName: Option<String>,
        methodName: String,
        callDescription: String,
        lineNumber: Int64
    ): MethodActionSelector<TRet> {
        return MethodActionSelector<TRet>(
            createScenario(stubCall, matchers, prefixRefName, methodName, callDescription, lineNumber)
        )
    }

    /*
     * @throws IllegalSynchronizationStateException
     * @throws MockFrameworkException
     * @throws MockFrameworkInternalError
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    public static func stubGetter<TRet>(
        stubCall: () -> TRet,
        prefixRefName: Option<String>,
        fieldOrPropertyName: String,
        callDescription: String,
        lineNumber: Int64
    ): GetterActionSelector<TRet> {
        return GetterActionSelector<TRet>(
            createScenario(stubCall, [], prefixRefName, fieldOrPropertyName, callDescription, lineNumber)
        )
    }

    /*
     * @throws IllegalSynchronizationStateException
     * @throws MockFrameworkException
     * @throws MockFrameworkInternalError
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    public static func stubSetter<TArg>(
        stubCall: () -> Unit,
        _: () -> TArg,
        matcher: ArgumentMatcher,
        prefixRefName: Option<String>,
        fieldOrPropertyName: String,
        callDescription: String,
        lineNumber: Int64
    ): SetterActionSelector<TArg> {
        return SetterActionSelector<TArg>(
            createScenario(stubCall, [matcher], prefixRefName, fieldOrPropertyName, callDescription, lineNumber)
        )
    }

    /*
     * @throws IllegalSynchronizationStateException
     * @throws MockFrameworkException
     * @throws MockFrameworkInternalError
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    static func createScenario<TRet>(
        stubCall: () -> TRet,
        matchers: Array<ArgumentMatcher>,
        prefixRefName: Option<String>,
        declarationName: String,
        callDescription: String,
        lineNumber: Int64
    ): Scenario {
        let recordingInfo = RecordingInfo(MethodStub, prefixRefName, declarationName)
        let recordedCall = MockFramework.recordCall(recordingInfo, stubCall)
        let description = StubDescription(
            callDescription,
            prefixRefName,
            recordedCall.location.forceLineNumber(lineNumber)
        )

        let invocationMatcher = InvocationMatcher(
            matchers,
            recordedCall.typeArgs,
            recordedCall.stubId,
            description
        )

        MockFramework.session { session: MockSession =>
            if (let Forbidden <- session.sessionKind) {
                StubModeViolation().stubForbidden(description, session.name)
            }

            let chain = StubChain(invocationMatcher, recordedCall.object?.kind ?? STATIC_DECLARATIONS_MOCK_KIND, session)
            match (session.chainsByStubId.get(chain.invocationMatcher.stubId)) {
                case Some(chains) => chains.add(chain)
                case None =>
                    let chains = ArrayList<StubChain>.of(chain)
                    session.chainsByStubId.add(chain.invocationMatcher.stubId, chains)
            }
            chain.addScenario(session)
        }
    }
}

/*
 * @throws IndexOutOfBoundsException
 * @throws IllegalArgumentException
 * @throws MockFrameworkException
 */
func requireObject(ref: Any, name: String): Object {
    (ref as Object) ?? illegalInput("${name} must be an Object")
}
