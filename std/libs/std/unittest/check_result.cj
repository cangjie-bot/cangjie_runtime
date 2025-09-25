






package std.unittest

import std.unittest.common.*

enum CheckResultKind <: Serializable<CheckResultKind> {
    Assert | Expect

    /*
     * @noThrow
     */
    public func serializeInternal(): DataModel {
        match (this) {
            case Assert => false.serializeInternal()
            case Expect => true.serializeInternal()
        }
    }

    /*
     * @noThrow
     */
    public static func deserialize(dm: DataModel): CheckResultKind {
        if (Bool.deserialize(dm)) {
            Expect
        } else {
            Assert
        }
    }
}


               /*
                * @noThrow
                */
abstract class CheckResult <: Serializable<CheckResult> {
    /*
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     * @throws DataModelException
     * @throws Exception
     */
    public static func deserialize(dm: DataModel): CheckResult {
        let dms = dm.asStruct()
        UnattachedCheckResult.tryToDeserialize(dms) ?? PlainCompareCheckResult.tryToDeserialize(dms) ??
            FailCheckResult.tryToDeserialize(dms) ?? AssertThrowsCheckResult.tryToDeserialize(dms) ??
            PowerAssertCheckResult.tryToDeserialize(dms) ?? PowerAssertExceptionCheckResult.tryToDeserialize(dms) ??
            DiffCheckResult.tryToDeserialize(dms) ?? CustomCheckResult.tryToDeserialize(dms) ??
            ExceptionThrownCheckResult.tryToDeserialize(dms) ?? MockFrameworkCheckResult.tryToDeserialize(dms) ??
            NoParametersProvidedResult.tryToDeserialize(dms) ?? CrashedCheckResult.tryToDeserialize(dms) ??
            TimeoutCheckResult.tryToDeserialize(dms) ?? PlainDeltaCompareCheckResult.tryToDeserialize(dms) ??
            throw Exception("Can not deserialize Invalid check result")
    }
}

class UnattachedCheckResult <: CheckResult {
    /*
     * @noThrow
     */
    UnattachedCheckResult(let inner: CheckResult) {}
    /*
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    public func serializeInternal(): DataModel {
        DataModelStruct().add(field<CheckResult>("unattached", inner))
    }

    /*
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     * @throws DataModelException
     * @throws Exception
     */
    public static func tryToDeserialize(dms: DataModelStruct): ?UnattachedCheckResult {
        UnattachedCheckResult(CheckResult.deserialize(dms.tryGet("unattached") ?? return None))
    }
}

abstract class AssertExpectCheckResult <: CheckResult {
    /*
     * @noThrow
     */
    AssertExpectCheckResult(let kind: CheckResultKind) {}
}

               /*
                * @noThrow
                */
abstract class ErrorCheckResult <: CheckResult {}

class PlainCompareCheckResult <: AssertExpectCheckResult {
    /*
     * @noThrow
     */
    PlainCompareCheckResult(
        kind: CheckResultKind,
        let leftExpr: String,
        let rightExpr: String,
        let leftValue: String,
        let rightValue: String
    ) {
        super(kind)
    }

    /*
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    public func serializeInternal(): DataModel {
        DataModelStruct()
            .add(field<CheckResultKind>("kind", kind))
            .add(field<String>("leftExpr", leftExpr))
            .add(field<String>("rightExpr", rightExpr))
            .add(field<String>("leftValue", leftValue))
            .add(field<String>("rightValue", rightValue))
    }

    /*
     * @throws DataModelException
     */
    public static func tryToDeserialize(dms: DataModelStruct): ?PlainCompareCheckResult {
        return PlainCompareCheckResult(
            CheckResultKind.deserialize(dms.tryGet("kind") ?? return None),
            String.deserialize(dms.tryGet("leftExpr") ?? return None),
            String.deserialize(dms.tryGet("rightExpr") ?? return None),
            String.deserialize(dms.tryGet("leftValue") ?? return None),
            String.deserialize(dms.tryGet("rightValue") ?? return None)
        )
    }
}

class PlainDeltaCompareCheckResult <: AssertExpectCheckResult {
    /*
     * @noThrow
     */
    PlainDeltaCompareCheckResult(kind: CheckResultKind, let expr: String) {
        super(kind)
    }

    /*
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    public func serializeInternal(): DataModel {
        DataModelStruct().
            add(field<CheckResultKind>("kind", kind)).
            add(field<String>("expr", expr))
    }

    /*
     * @throws DataModelException
     */
    public static func tryToDeserialize(dms: DataModelStruct): ?PlainDeltaCompareCheckResult {
        return PlainDeltaCompareCheckResult(
            CheckResultKind.deserialize(dms.tryGet("kind") ?? return None),
            String.deserialize(dms.tryGet("expr") ?? return None)
        )
    }
}

class FailCheckResult <: AssertExpectCheckResult {
    /*
     * @noThrow
     */
    FailCheckResult(kind: CheckResultKind, let failMessage: String) {
        super(kind)
    }

    /*
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    public func serializeInternal(): DataModel {
        DataModelStruct().add(field<String>("failMessage", failMessage)).add(field<CheckResultKind>("kind", kind))
    }

    /*
     * @throws DataModelException
     */
    public static func tryToDeserialize(dms: DataModelStruct): ?FailCheckResult {
        return FailCheckResult(
            CheckResultKind.deserialize(dms.tryGet("kind") ?? return None),
            String.deserialize(dms.tryGet("failMessage") ?? return None)
        )
    }
}

class AssertThrowsCheckResult <: AssertExpectCheckResult {
    /*
     * @noThrow
     */
    AssertThrowsCheckResult(
        kind: CheckResultKind,
        let message: String,
        let expectedExceptions: String,
        let caughtException: String
    ) {
        super(kind)
    }

    /*
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    public func serializeInternal(): DataModel {
        DataModelStruct()
            .add(field<CheckResultKind>("kind", kind))
            .add(field<String>("expectedExceptions", expectedExceptions))
            .add(field<String>("message", message))
            .add(field<String>("caughtException", caughtException))
    }

    /*
     * @throws DataModelException
     */
    public static func tryToDeserialize(dms: DataModelStruct): Option<AssertThrowsCheckResult> {
        return AssertThrowsCheckResult(
            CheckResultKind.deserialize(dms.tryGet("kind") ?? return None),
            String.deserialize(dms.tryGet("message") ?? return None),
            String.deserialize(dms.tryGet("expectedExceptions") ?? return None),
            String.deserialize(dms.tryGet("caughtException") ?? return None)
        )
    }
}

class PowerAssertCheckResult <: AssertExpectCheckResult {
    /*
     * @noThrow
     */
    PowerAssertCheckResult(
        let expr: String,
        let diagram: PowerAssertDiagram
    ) {
        super(Assert)
    }

    /*
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    public func serializeInternal(): DataModel {
        DataModelStruct().add(field<String>("expr", expr)).add(field<PowerAssertDiagram>("diagram", diagram))
    }

    /*
     * @throws DataModelException
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    public static func tryToDeserialize(dms: DataModelStruct): ?PowerAssertCheckResult {
        return PowerAssertCheckResult(
            String.deserialize(dms.tryGet("expr") ?? return None),
            PowerAssertDiagram.deserialize(dms.tryGet("diagram") ?? return None)
        )
    }
}

class PowerAssertExceptionCheckResult <: AssertExpectCheckResult {
    /*
     * @noThrow
     */
    PowerAssertExceptionCheckResult(
        let expression: String,
        let exception: String,
        let diagram: PowerAssertDiagram
    ) {
        super(Assert)
    }

    /*
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    public func serializeInternal(): DataModel {
        DataModelStruct()
            .add(field<String>("expression", expression))
            .add(field<String>("exception", exception))
            .add(field<PowerAssertDiagram>("diagram", diagram))
    }

    /*
     * @throws DataModelException
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    public static func tryToDeserialize(dms: DataModelStruct): ?PowerAssertExceptionCheckResult {
        return PowerAssertExceptionCheckResult(
            String.deserialize(dms.tryGet("expression") ?? return None),
            String.deserialize(dms.tryGet("exception") ?? return None),
            PowerAssertDiagram.deserialize(dms.tryGet("diagram") ?? return None)
        )
    }
}

class DiffCheckResult <: AssertExpectCheckResult {
    /*
     * @noThrow
     */
    DiffCheckResult(
        kind: CheckResultKind,
        let diffMessage: PrettyText
    ) {
        super(kind)
    }

    /*
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    public func serializeInternal(): DataModel {
        DataModelStruct().add(field<PrettyText>("diffMessage", diffMessage)).add(field<CheckResultKind>("kind", kind))
    }

    /*
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     * @throws DataModelException
     */
    public static func tryToDeserialize(dms: DataModelStruct): ?DiffCheckResult {
        DiffCheckResult(
            CheckResultKind.deserialize(dms.tryGet("kind") ?? return None),
            PrettyText.deserialize(dms.tryGet("diffMessage") ?? return None)
        )
    }
}

class CustomCheckResult <: AssertExpectCheckResult {
    /*
     * @noThrow
     */
    CustomCheckResult(
        kind: CheckResultKind,
        let custom: PrettyText
    ) {
        super(kind)
    }

    /*
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    public func serializeInternal(): DataModel {
        DataModelStruct().add(field<PrettyText>("custom", custom)).add(field<CheckResultKind>("kind", kind))
    }

    /*
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     * @throws DataModelException
     */
    public static func tryToDeserialize(dms: DataModelStruct): ?DiffCheckResult {
        DiffCheckResult(
            CheckResultKind.deserialize(dms.tryGet("kind") ?? return None),
            PrettyText.deserialize(dms.tryGet("custom") ?? return None)
        )
    }
}

class ExceptionThrownCheckResult <: ErrorCheckResult {
    /*
     * @noThrow
     */
    ExceptionThrownCheckResult(
        let errorMessage: PrettyText,
        let stackTrace: PrettyText
    ) {}

    /*
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    public func serializeInternal(): DataModel {
        DataModelStruct()
            .add(field<PrettyText>("errorMessage", errorMessage))
            .add(field<PrettyText>("stackTrace", stackTrace))
    }

    /*
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     * @throws DataModelException
     */
    public static func tryToDeserialize(dms: DataModelStruct): ?ExceptionThrownCheckResult {
        ExceptionThrownCheckResult(
            PrettyText.deserialize(dms.tryGet("errorMessage") ?? return None),
            PrettyText.deserialize(dms.tryGet("stackTrace") ?? return None)
        )
    }
}

class MockFrameworkCheckResult <: CheckResult {
    /*
     * @noThrow
     */
    MockFrameworkCheckResult(
        let mockFrameworkMessage: PrettyText
    ) {}

    /*
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    public func serializeInternal(): DataModel {
        DataModelStruct().add(field<PrettyText>("mockFrameworkMessage", mockFrameworkMessage))
    }

    /*
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     * @throws DataModelException
     */
    public static func tryToDeserialize(dms: DataModelStruct): ?MockFrameworkCheckResult {
        MockFrameworkCheckResult(
            PrettyText.deserialize(dms.tryGet("mockFrameworkMessage") ?? return None),
        )
    }
}

class NoParametersProvidedResult <: CheckResult {
    /*
     * @noThrow
     */
    NoParametersProvidedResult() {}
    /*
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    public func serializeInternal(): DataModel {
        DataModelStruct().add(field<Int64>("noParameters", 0))
    }

    /*
     * @noThrow
     */
    static func tryToDeserialize(dms: DataModelStruct): ?NoParametersProvidedResult {
        dms.tryGet("noParameters") ?? return None
        NoParametersProvidedResult()
    }
}

class CrashedCheckResult <: CheckResult {
    /*
     * @noThrow
     */
    CrashedCheckResult(
        let exitCode: Int64
    ) {}

    /*
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    public func serializeInternal(): DataModel {
        DataModelStruct().add(
            field<Int64>("exitCode", exitCode)
        )
    }

    /*
     * @noThrow
     */
    static func tryToDeserialize(dms: DataModelStruct): ?CrashedCheckResult {
        CrashedCheckResult(
            Int64.deserialize(dms.tryGet("exitCode") ?? return None),
        )
    }
}

class TimeoutCheckResult <: CheckResult {
    /*
     * @noThrow
     */
    TimeoutCheckResult(let msg: PrettyText) {}

    /*
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    public func serializeInternal(): DataModel {
        DataModelStruct().add(field<PrettyText>("timeout", this.msg))
    }

    /*
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     * @throws DataModelException
     */
    static func tryToDeserialize(dms: DataModelStruct): ?TimeoutCheckResult {
        TimeoutCheckResult(PrettyText.deserialize(dms.tryGet("timeout") ?? return None))
    }
}
