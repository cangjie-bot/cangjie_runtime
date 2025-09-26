






package std.unittest.mock

import std.collection.*
import std.sync.*
import std.unittest.mock.internal.*

private const GLOBAL_SESSION_NAME = "Global"
let _FRAMEWORK = MockFramework()

type UnmatchedChains = ArrayList<(StubChain, MatchStatus)>

public class MockFramework {
    private let sessions: ArrayList<MockSession> = ArrayList.of(MockSession(GLOBAL_SESSION_NAME, Stateless))
    private var recording: Option<RecordingHandler> = None
    private let globalLock = ReentrantMutex()
    private let objCounter = AtomicUInt64(0)

    /**
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    init() {
        CallHandler.recordStatic(CallHandlerImpl(objCounter.fetchAdd(1), GLOBAL_SESSION_NAME))
    }









    /**
     * @throws MockFrameworkException
     * @throws IllegalSynchronizationStateException
     * @throws MockFrameworkInternalError
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    public static func openSession(name: String, sessionKind: MockSessionKind): Unit {
        return _FRAMEWORK.doOpen(name, sessionKind)
    }








    /**
     * @throws MockFrameworkException
     * @throws IndexOutOfBoundsException
     * @throws MockFrameworkInternalError
     * @throws IllegalArgumentException
     * @throws ExpectationFailedException
     * @throws IllegalSynchronizationStateException
     */
    public static func closeSession(): Unit {
        return _FRAMEWORK.doClose()
    }

    func generateUniqueId(): UInt64 {
        return objCounter.fetchAdd(1)
    }

    /**
     * @throws IllegalSynchronizationStateException
     */
    private func lock<T>(body: () -> T): T {
        try {
            globalLock.lock()
            body()
        } finally {
            globalLock.unlock()
        }
    }

    /**
     * @throws MockFrameworkException
     * @throws IllegalSynchronizationStateException
     * @throws MockFrameworkInternalError
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    private func doOpen(name: String, sessionKind: MockSessionKind): Unit {
        lock {
            match (currentSession().sessionKind) {
                case Stateless =>
                    sessions.add(MockSession(name, sessionKind))
                    CallHandler.recordStatic(CallHandlerImpl(0, name))
                case _ => illegalInput("Invalid session structure")
            }
        }
    }

    /**
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     * @throws MockFrameworkInternalError
     * @throws IllegalSynchronizationStateException
     */
    static func session<T>(body: (MockSession) -> T): T {
        return _FRAMEWORK.lock { body(_FRAMEWORK.currentSession()) }
    }

    /**
     * @throws MockFrameworkException
     * @throws IndexOutOfBoundsException
     * @throws MockFrameworkInternalError
     * @throws IllegalArgumentException
     * @throws ExpectationFailedException
     * @throws IllegalSynchronizationStateException
     */
    private func doClose(): Unit {
        lock {
            let lastSessionIndex = match (sessions.size) {
                case 0 => internalError("Should always have global session open")
                case 1 => illegalInput("Cannot close session: no sessions were opened")
                case size => size - 1
            }
            let sessionToClose = sessions[lastSessionIndex]
            sessions.remove(at: lastSessionIndex)
            CallHandler.clearStatic()
            sessionToClose.checkForMisconfigurationIssues()
            sessionToClose.invocationLog.validateLog()
            if (let Verifiable <- sessionToClose.sessionKind) {
                sessionToClose.verifyExpectations()
            }
        }
    }

    /**
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     * @throws MockFrameworkInternalError
     */
    private func currentSession(): MockSession {
        return sessions.get(sessions.size - 1) ?? internalError("Should always have global session open")
    }

    /**
     * @throws IndexOutOfBoundsException
     * @throws MockFrameworkInternalError
     * @throws IllegalArgumentException
     * @throws MockFrameworkException
     * @throws IllegalSynchronizationStateException
     */
    static func recordCall<R>(
        recordingInfo: RecordingInfo, dummyCall: () -> R
    ): RecordedCall {
        _FRAMEWORK.lock {
            let handler = RecordingHandler(recordingInfo)
            _FRAMEWORK.recording = Some(handler)
            dummyCall()
            _FRAMEWORK.recording = None
            handler.getRecorded()
        }
    }

    /**
     * @throws MockFrameworkException
     * @throws MockFrameworkInternalError
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    private func getAction(
        sc: Scenario, currentSession: MockSession, invocation: Invocation, call: Call
    ): OnCall {
        let invocationLog = currentSession.invocationLog
        return match (sc.action) {
            case Return(valueFactory) => OnCall.Return(valueFactory())
            case Throw(exceptionFactory) => OnCall.Throw(exceptionFactory())
            case CallOriginal => OnCall.CallBase
            case GetField(description) =>
                OnCall.Return(currentSession.fieldStorage.getExplicitFieldValue(description))
            case SetField(description) =>
                currentSession.fieldStorage.setExplicitFieldValue(description, getSingleArg(call))
                OnCall.Return(())
            case Fail =>
                logAndThrow(invocationLog, invocation,
                    runtimeUnwantedInteraction(invocation, sc, invocationLog.fullLog())
                )
        }
    }

    /**
     * @throws MockFrameworkException
     * @throws IndexOutOfBoundsException
     * @throws MockFrameworkInternalError
     * @throws IllegalArgumentException
     */
    private func handleCall(call: Call, objId: UInt64, objectCreatedAtSessionName: ?String): OnCall {
        let currentSession = currentSession()
        let obj = if (objId != 0) {
            findObjectById(objId) ??
                MockScopeViolation().reportInaccessible(objectCreatedAtSessionName, currentSession.name)
        } else {
            Option<MockObject>.None
        }
        if (let Some(recording) <- recording) {
            recording.record(call, obj)
            return OnCall.ReturnZero
        }
        let invocation = Invocation(obj, call, locationFromTrace())
        let unmatchedChains = UnmatchedChains()
        let invocationLog = currentSession.invocationLog
        for (i in (sessions.size - 1)..=0 : -1) {
            let handlingSession = sessions[i]
            match (handlingSession.handle(invocation, unmatchedChains)) {
                case Unhandled => ()
                case PerformScenario(sc) =>
                    invocationLog.newEntry(LogEntry(invocation, Stub(sc.parentChain)))
                    return getAction(sc, currentSession, invocation, call)

                case InvocationLimitExceeded(chain) =>
                    logAndThrow(invocationLog, invocation,
                        invocationLimitExceededReport(invocation, chain, invocationLog.fullLog())
                    )
            }
        }
        let defaultBehaviour = handleUnstubbed(invocation, invocationLog, unmatchedChains)
        invocationLog.newEntry(LogEntry(invocation, Default))
        return defaultBehaviour
    }

    /**
     * @throws MockFrameworkException
     * @throws IndexOutOfBoundsException
     * @throws MockFrameworkInternalError
     * @throws IllegalArgumentException
     */
    private func handleUnstubbed(invocation: Invocation, log: MutableLog, unmatchedChains: UnmatchedChains): OnCall {
        let mockObject = match (invocation.mockObject) {
            case Some(o) => o
            case _ => return OnCall.CallBase
        }
        if (let Spy <- mockObject.kind) {
            return OnCall.CallBase
        }
        let funcInfo = invocation.call.funcInfo
        if (mockObject.hasMode(SyntheticFields)) {
            match {
                case funcInfo.isSetter =>
                    currentSession().fieldStorage.setAutoFieldValue(
                        AutoFieldId(mockObject, funcInfo.presentableName), getSingleArg(invocation.call)
                    )
                    return OnCall.Return(())
                case funcInfo.isGetter =>
                    if (let Some(value) <- currentSession().fieldStorage.getAutoFieldValue(
                        AutoFieldId(mockObject, funcInfo.presentableName)
                    )) {
                        return OnCall.Return(value)
                    }
                    if (invocation.canReturnDefaultValue) {
                        return OnCall.ReturnDefault
                    }
                    logAndThrow(log, invocation,
                        FieldsErrorReport().errorReadingField(invocation)
                    )
                case _ => ()
            }
        }
        if (invocation.canReturnDefaultValue) {
            return OnCall.ReturnDefault
        }
        logAndThrow(log, invocation,
            unhandledInvocationReport(invocation, unmatchedChains, log.fullLog())
        )
    }

    /**
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    private func logAndThrow(log: MutableLog, invocation: Invocation, error: PrettyException): Nothing {
        log.newEntry(LogEntry(invocation, Failure(error)))
        throw error
    }

    /**
     * @throws MockFrameworkException
     * @throws IndexOutOfBoundsException
     * @throws MockFrameworkInternalError
     * @throws IllegalArgumentException
     * @throws IllegalSynchronizationStateException
     */
    func handleSync(call: Call, objId: UInt64, objectCreatedAtSessionName: ?String): OnCall {
        lock {
            handleCall(call, objId, objectCreatedAtSessionName)
        }
    }

    /**
     * @throws MockFrameworkInternalError
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     * @throws IllegalSynchronizationStateException
     */
    func registerObject(mockObject: MockObject) {
        lock {
            currentSession().objectRegistry[mockObject.id] = mockObject
        }
    }

    /**
     * @throws IndexOutOfBoundsException
     */
    private func findObjectById(id: UInt64): Option<MockObject> {
        for (session in sessions) {
            if (let Some(obj) <- session.objectRegistry.get(id)) {
                return obj
            }
        }
        return None
    }

    /**
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     * @throws IllegalSynchronizationStateException
     */
    func findObjectIdsByRefs(referencesToFind: Array<Object>): Set<UInt64> {
        lock {
            doFindObjectIdsByRefs(referencesToFind)
        }
    }

    /**
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    private func doFindObjectIdsByRefs(referencesToFind: Array<Object>) {
        let ids = HashSet<UInt64>()
        for (session in sessions) {
            for ((id, mockObject) in session.objectRegistry) {
                if (referencesToFind |> any { targetRef: Object => refEq(mockObject.ref, targetRef) }) {
                    ids.add(id)
                }
            }
        }
        return ids
    }

    /**
     * @throws IllegalArgumentException
     * @throws MockFrameworkInternalError
     * @throws IndexOutOfBoundsException
     */
    private func getSingleArg(call: Call): Any {
        if (call.args.size != 1) {
            internalError(InconsistentState("Setters must have a single argument."))
        }
        return call.args[0]
    }

    /**
     * @throws IndexOutOfBoundsException
     * @throws MockFrameworkInternalError
     * @throws IllegalArgumentException
     * @throws MockFrameworkException
     */
    protected func throwNotAMockObject() {
        let recordingInfo = recording?.info ??
            internalError(InternalError.InconsistentState("There is no recording call info before actual calling"))
        RecordingFailureReport().fail(recordingInfo, NotAMock, UnmockableCallable)
    }
}

extend MockObject {
    func hasMode(mode: StubMode) {
        for (m in modes) {
            match ((m, mode)) {
                case (SyntheticFields, SyntheticFields) => return true
                case (ReturnsDefaults, ReturnsDefaults) => return true
                case _ => ()
            }
        }
        return false
    }
}

extend Invocation {
    prop isDefaultEnabled: Bool {
        get() {
            (mockObject?.hasMode(ReturnsDefaults) ?? false) && !call.funcInfo.isSetter
        }
    }

    prop canReturnDefaultValue: Bool {
        get() {
            isDefaultEnabled && call.funcInfo.hasDefaultValue
        }
    }
}

class CallHandlerImpl <: CallHandler {
    CallHandlerImpl(
        private let objId: UInt64,
        private let objectCreatedAtSessionName: ?String
    ) {}

    /**
     * @throws MockFrameworkException
     * @throws IndexOutOfBoundsException
     * @throws MockFrameworkInternalError
     * @throws IllegalArgumentException
     * @throws IllegalSynchronizationStateException
     */
    public func onCall(call: Call): OnCall {
        _FRAMEWORK.handleSync(call, objId, objectCreatedAtSessionName)
    }

    /**
     * @throws IndexOutOfBoundsException
     * @throws MockFrameworkInternalError
     * @throws IllegalArgumentException
     * @throws MockFrameworkException
     */
    @When[backend == "cjnative"]
    public func requireMockObject<T>(obj: T): T {
        if (obj is Mocked) {
            return obj
        } else {
            _FRAMEWORK.throwNotAMockObject()
        }
    }
}

class MockScopeViolation <: FailureReport {
    static let HINT = "Hint: accessing mock objects outside its intended use scope can lead to unstable tests"

    /**
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     * @throws MockFrameworkException
     */
    func reportInaccessible(createdAtSessionName: ?String, whereSessionName: ?String) {
        let message = build {
            errorHeader("Illegal mock object access")
            line {
                text("Mock object")
                match (createdAtSessionName) {
                    case None => ()
                    case Some(name) =>
                        text("created in")
                        userCode(name)
                }
                text("is no longer accessible")
                match (whereSessionName) {
                    case None => ()
                    case Some(name) =>
                        text("in")
                        userCode(name)
                }
            }
            line {
                text(HINT)
            }
        }
        throw MockFrameworkException(message)
    }
}
