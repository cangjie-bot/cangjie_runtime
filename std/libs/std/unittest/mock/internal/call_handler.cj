






protected package std.unittest.mock.internal

import std.collection.ArrayList

private var staticCallHandlers = ArrayList<CallHandler>()

public interface CallHandler {
    func onCall(call: Call): OnCall
    @When[backend == "cjnative"]
    func requireMockObject<T>(obj: T): T

    /**
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    static func recordStatic(callHandler: CallHandler) {
        staticCallHandlers.add(callHandler)
    }

    /**
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    static func clearStatic() {
        staticCallHandlers.remove(at: staticCallHandlers.size - 1)
    }

    /**
     * @throws UninitializedStaticCallHandler
     */
    static func currentStatic() {
        return staticCallHandlers.get(staticCallHandlers.size - 1) ??
            throw UninitializedStaticCallHandler()
    }
}

public enum OnCall {
    ReturnZero | Return(Any) | Throw(Exception) | CallBase | ReturnDefault
}

/**
 * @throws UninitializedStaticCallHandler
 */
@When[backend == "cjnative"]
protected func requireMockObject<T>(obj: T): T {
    CallHandler.currentStatic().requireMockObject(obj)
}
