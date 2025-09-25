






package std.unittest.mock

import std.unittest.mock.internal.*

class Invocation {
    let stubId: StubId

    /*
     * @noThrow
     */
    Invocation(
        let mockObject: Option<MockObject>,
        let call: Call,
        let location: Location
    ) {
        stubId = StubId(call.funcInfo, mockObject?.id ?? 0)
    }
}

class StubId <: Hashable & Equatable<StubId> {
    /*
     * @noThrow
     */
    StubId(
        let funcInfo: FuncInfo,
        let receiverId: UInt64
    ) {}

    @OverflowWrapping
    /*
     * @noThrow
     */
    public func hashCode(): Int64 {
        return Int64(receiverId) + 31 * funcInfo.id.hashCode()
    }

    /*
     * @noThrow
     */
    public operator func ==(that: StubId): Bool {
        return this.receiverId == that.receiverId && this.funcInfo.id == that.funcInfo.id
    }

    /*
     * @noThrow
     */
    public operator func !=(that: StubId): Bool {
        return this.receiverId != that.receiverId || this.funcInfo.id != that.funcInfo.id
    }
}
