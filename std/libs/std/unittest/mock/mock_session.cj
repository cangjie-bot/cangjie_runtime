






package std.unittest.mock

import std.collection.*







public enum MockSessionKind {
    | Forbidden
    | Stateless
    | Verifiable
}




class MockSession {
    /*
     * @noThrow
     */
    MockSession(
        let name: String,
        let sessionKind: MockSessionKind
    ) {}

    let invocationLog = MutableLog()
    let chainsByStubId = HashMap<StubId, ArrayList<StubChain>>()
    let statements = ArrayList<VerifyStatement>()
    let objectRegistry = HashMap<UInt64, MockObject>()
    let fieldStorage = FieldStorage()
}

class MockObject {
    /*
     * @noThrow
     */
    MockObject(
        let id: UInt64,
        let ref: Object,
        let kind: MockKind,
        let modes: Array<StubMode>,
        let sessionName: ?String
    ) {}
}

enum MockKind {
    Mock | Spy
}
