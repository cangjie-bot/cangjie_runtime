






package std.unittest.mock

import std.collection.ArrayList






public class Verify {




    /**
     * @throws NoneValueException
     * @throws IllegalSynchronizationStateException
     * @throws IndexOutOfBoundsException
     * @throws MockFrameworkException
     * @throws VerificationFailedException
     * @throws MockFrameworkInternalError
     * @throws IllegalArgumentException
     */
    public static func that(statement: VerifyStatement): Unit {
        unordered(Partial, [statement])
    }














    /**
     * @throws NoneValueException
     * @throws IllegalSynchronizationStateException
     * @throws IndexOutOfBoundsException
     * @throws MockFrameworkException
     * @throws VerificationFailedException
     * @throws MockFrameworkInternalError
     * @throws IllegalArgumentException
     */
    public static func unordered(
        exhaustive: Exhaustiveness,
        collectStatements: (UnorderedVerifier) -> Unit
    ): Unit {
        let verifier = UnorderedVerifier()
        collectStatements(verifier)
        unordered(exhaustive, verifier.statements.toArray())
    }





    /**
     * @throws NoneValueException
     * @throws IllegalSynchronizationStateException
     * @throws IndexOutOfBoundsException
     * @throws MockFrameworkException
     * @throws VerificationFailedException
     * @throws MockFrameworkInternalError
     * @throws IllegalArgumentException
     */
    public static func unordered(collectStatements: (UnorderedVerifier) -> Unit): Unit {
        unordered(Exhaustive, collectStatements)
    }






    /**
     * @throws NoneValueException
     * @throws IllegalSynchronizationStateException
     * @throws IndexOutOfBoundsException
     * @throws MockFrameworkException
     * @throws VerificationFailedException
     * @throws MockFrameworkInternalError
     * @throws IllegalArgumentException
     */
    public static func unordered(statements: Array<VerifyStatement>): Unit {
        unordered(Exhaustive, statements)
    }





    /**
     * @throws NoneValueException
     * @throws IllegalSynchronizationStateException
     * @throws IndexOutOfBoundsException
     * @throws MockFrameworkException
     * @throws VerificationFailedException
     * @throws MockFrameworkInternalError
     * @throws IllegalArgumentException
     */
    public static func unordered(
        exhaustive: Exhaustiveness,
        statements: Array<VerifyStatement>
    ): Unit {
        performVerification(statements, Unordered, exhaustive)
    }










    /**
     * @throws NoneValueException
     * @throws IllegalSynchronizationStateException
     * @throws IndexOutOfBoundsException
     * @throws MockFrameworkException
     * @throws VerificationFailedException
     * @throws MockFrameworkInternalError
     * @throws IllegalArgumentException
     */
    public static func ordered(collectStatements: (OrderedVerifier) -> Unit): Unit {
        let verifier = OrderedVerifier()
        collectStatements(verifier)
        ordered(verifier.statements.toArray())
    }





    /**
     * @throws NoneValueException
     * @throws IllegalSynchronizationStateException
     * @throws IndexOutOfBoundsException
     * @throws MockFrameworkException
     * @throws VerificationFailedException
     * @throws MockFrameworkInternalError
     * @throws IllegalArgumentException
     */
    public static func ordered(statements: Array<VerifyStatement>): Unit {
        performVerification(statements, Ordered, Exhaustive)
    }



    /**
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     * @throws MockFrameworkInternalError
     * @throws IllegalSynchronizationStateException
     */
    public static func clearInvocationLog(): Unit {
        MockFramework.session {
            session: MockSession => session.invocationLog.clear()
        }
    }









    /**
     * @throws IllegalSynchronizationStateException
     * @throws MockFrameworkException
     * @throws IndexOutOfBoundsException
     * @throws MockFrameworkInternalError
     * @throws IllegalArgumentException
     * @throws VerificationFailedException
     */
    public static func noInteractions(mockObjects: Array<Object>): Unit {
        verifyNoInteractions(mockObjects)
    }
}


public class UnorderedVerifier {
    let statements = ArrayList<VerifyStatement>()
    UnorderedVerifier() {}





    /**
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    public func checkThat(statement: VerifyStatement): UnorderedVerifier {
        statements.add(statement)
        return this
    }
}


public class OrderedVerifier {
    let statements = ArrayList<VerifyStatement>()
    OrderedVerifier() {}





    /**
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    public func checkThat(statement: VerifyStatement): OrderedVerifier {
        statements.add(statement)
        return this
    }
}







public class VerifyStatement {
    private var _cardinality = Option<Cardinality>.None
    var isUsed = false

        /**
         * @throws IndexOutOfBoundsException
         * @throws IllegalArgumentException
         * @throws MockFrameworkInternalError
         */
    prop cardinality: Cardinality {
        get() {
            _cardinality ?? internalError(InconsistentState("Cardinality not set before using verify statement"))
        }
    }

    VerifyStatement(
        let invocationMatcher: InvocationMatcher
    ) {}




    /**
     * @throws MockFrameworkException
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     * @throws MockFrameworkInternalError
     * @throws IllegalSynchronizationStateException
     */
    public static func fromStub<R>(
        stubCall: () -> R,
        matchers: Array<ArgumentMatcher>,
        objName: Option<String>,
        declarationName: String,
        callDescription: String,
        lineNumber: Int64
    ): VerifyStatement {
        let recordingInfo = RecordingInfo(VerifyStatementStub, objName, declarationName)
        let recordedCall = MockFramework.recordCall(recordingInfo, stubCall)
        let invocationMatcher = InvocationMatcher(
            matchers,
            recordedCall.typeArgs,
            recordedCall.stubId,
            StubDescription(
                callDescription,
                objName,
                recordedCall.location.forceLineNumber(lineNumber)
            )
        )
        let statement = VerifyStatement(invocationMatcher)
        checkMatchersConsistency(statement)
        MockFramework.session { session: MockSession =>
            session.statements.add(statement)
        }
        statement
    }

    /**
     * @throws IndexOutOfBoundsException
     * @throws MockFrameworkException
     * @throws IllegalArgumentException
     */
    func prepareForVerification(orderedness: Orderedness) {
        match (isUsed) {
            case true => VerifyMisconfiguration().fail(StatementUsedTwice(this))
            case false => isUsed = true
        }
        match ((_cardinality, orderedness)) {
            case (None, Unordered) => _cardinality = Some(Cardinality.atLeastOnce())
            case (None, Ordered) => _cardinality = Some(Cardinality.once())
            case _ => ()
        }
    }

    /**
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     * @throws MockFrameworkException
     */
    func setCardinality(newCardinality: Cardinality): VerifyStatement {
        match (_cardinality) {
            case None => _cardinality = Some(newCardinality)
            case Some(_) => VerifyMisconfiguration().fail(CardinalityCannotBeReassigned(this))
        }
        this
    }





    /**
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     * @throws MockFrameworkException
     */
    public func once(): VerifyStatement { setCardinality(Cardinality.once()) }





    /**
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     * @throws MockFrameworkException
     */
    public func atLeastOnce(): VerifyStatement { setCardinality(Cardinality.atLeastOnce()) }






    /**
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     * @throws MockFrameworkException
     */
    public func times(expectedTimes: Int64): VerifyStatement { setCardinality(Cardinality.times(expectedTimes)) }







    /**
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     * @throws MockFrameworkException
     */
    public func times(min!: Int64, max!: Int64): VerifyStatement {
        setCardinality(Cardinality.times(min: min, max: max))
    }






    /**
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     * @throws MockFrameworkException
     */
    public func atLeastTimes(minTimesExpected: Int64): VerifyStatement {
        setCardinality(Cardinality.atLeastTimes(minTimesExpected))
    }





    /**
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     * @throws MockFrameworkException
     */
    public func never(): VerifyStatement { setCardinality(Cardinality.never()) }
}
