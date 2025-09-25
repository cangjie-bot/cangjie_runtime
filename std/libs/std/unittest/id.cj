






package std.unittest

import std.unittest.common.*

struct TestSuiteId <: Serializable<TestSuiteId> & Hashable & Equatable<TestSuiteId> & ToString {
    /*
     * @noThrow
     */
    TestSuiteId(
        let groupName: String,
        let suiteName: String
    ) {}

    /*
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    public func serializeInternal(): DataModel {
        DataModelStruct()
            .add(field<String>("groupName", groupName))
            .add(field<String>("suiteName", suiteName))
    }

    /*
     * @throws Exception
     * @throws DataModelException
     */
    public static func deserialize(dm: DataModel): TestSuiteId {
        let dms = dm.asStruct()

        TestSuiteId(
            String.deserialize(dms.get("groupName")),
            String.deserialize(dms.get("suiteName"))
        )
    }

    /*
     * @noThrow
     */
    public operator func ==(other: TestSuiteId): Bool {
        this.groupName == other.groupName && this.suiteName == other.suiteName
    }

    /*
     * @noThrow
     */
    public operator func !=(other: TestSuiteId): Bool {
        !(this == other)
    }

    /*
     * @noThrow
     */
    public func hashCode(): Int64 {
        var hasher = DefaultHasher()
        hasher.write(groupName)
        hasher.write(suiteName)
        hasher.finish()
    }

    /*
     * @noThrow
     */
    public func toString(): String {
        "TestSuiteId(${groupName}, ${suiteName})"
    }

    /*
     * @noThrow
     */
    public static func fromTestSuite(groupName: String, testSuite: TestSuite): TestSuiteId {
        TestSuiteId(
            groupName,
            testSuite.name
        )
    }

    prop isFromTopLevelFunc: Bool {
        /*
         * @noThrow
         */
        get() { this.suiteName.startsWith("TestCase_") }
    }
}

struct TestCaseId <: Serializable<TestCaseId> & Hashable & Equatable<TestCaseId> & ToString {
    /*
     * @noThrow
     */
    TestCaseId(
        let suiteId: TestSuiteId,
        let caseName: String,
        let isBench!: Bool
    ) {}

    /*
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    public func serializeInternal(): DataModel {
        DataModelStruct()
            .add(field<TestSuiteId>("suiteId", suiteId))
            .add(field<String>("caseName", caseName))
            .add(field<Bool>("isBench", isBench))
    }

    /*
     * @throws Exception
     * @throws DataModelException
     */
    public static func deserialize(dm: DataModel): TestCaseId {
        let dms = dm.asStruct()
        TestCaseId(
            TestSuiteId.deserialize(dms.get("suiteId")),
            String.deserialize(dms.get("caseName")),
            isBench: Bool.deserialize(dms.get("isBench"))
        )
    }

    /*
     * @noThrow
     */
    public operator func ==(other: TestCaseId): Bool {
        this.caseName == other.caseName && this.suiteId == other.suiteId && this.isBench == other.isBench
    }

    /*
     * @noThrow
     */
    public operator func !=(other: TestCaseId): Bool {
        !(this == other)
    }

    /*
     * @noThrow
     */
    public func hashCode(): Int64 {
        var hasher = DefaultHasher()
        hasher.write(suiteId.hashCode())
        hasher.write(caseName)
        hasher.write(isBench)
        hasher.finish()
    }

    /*
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     * @throws OutOfMemoryError
     */
    public func fqName(): String {
        "${suiteId.groupName.toSafeFileName()}.${suiteId.suiteName.toSafeFileName()}.${caseName.toSafeFileName()}"
    }

    /*
     * @noThrow
     */
    public func toString(): String {
        "TestCaseId(${suiteId}, ${caseName})"
    }
}
