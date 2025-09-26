






package std.unittest.mock

import std.unittest.mock.internal.*



public enum StubMode {





    | ReturnsDefaults




    | SyntheticFields
}





/**
 * @throws MockFrameworkInternalError
 * @throws IllegalArgumentException
 * @throws IndexOutOfBoundsException
 * @throws IllegalSynchronizationStateException
 */
@Frozen
public func mock<T>(): T {
    return create<T>(Mock, []) { handler: CallHandlerImpl => unsafe { createMock<T>(handler) }}
}






/**
 * @throws MockFrameworkInternalError
 * @throws IllegalArgumentException
 * @throws IndexOutOfBoundsException
 * @throws IllegalSynchronizationStateException
 */
@Frozen
public func mock<T>(modes: Array<StubMode>): T {
    return create<T>(Mock, modes) { handler: CallHandlerImpl => unsafe { createMock<T>(handler) }}
}






/**
 * @throws MockFrameworkInternalError
 * @throws IllegalArgumentException
 * @throws IndexOutOfBoundsException
 * @throws IllegalSynchronizationStateException
 */
@Frozen
public func spy<T>(objectToSpyOn: T): T {
    return create<T>(Spy, []) { handler: CallHandlerImpl => unsafe { createSpy<T>(handler, objectToSpyOn) }}
}

/**
 * @throws MockFrameworkInternalError
 * @throws IllegalArgumentException
 * @throws IndexOutOfBoundsException
 * @throws IllegalSynchronizationStateException
 */
func create<T>(kind: MockKind, modes: Array<StubMode>, constructor: (CallHandlerImpl) -> T): T {
    MockFramework.session { session: MockSession =>
        let id = _FRAMEWORK.generateUniqueId()
        let createdAtSessionName = session.name
        let handler = CallHandlerImpl(id, createdAtSessionName)
        let objAsT = constructor(handler)
        let ref = (objAsT as Object) ?? internalError("Mock object does not inherit Object superclass")
        _FRAMEWORK.registerObject(MockObject(id, ref, kind, modes, createdAtSessionName))
        objAsT
    }
}
