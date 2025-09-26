






package std.unittest.mock

import std.collection.*

class VerifyIterator {
    /**
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     * @throws NoneValueException
     */
    VerifyIterator(
        let statements: Iterable<VerifyStatement>,
        let invocations: Array<Invocation>
    ) {
        logIndex = 0
        invocation = invocations[0]
        statementIterator = statements.iterator()
        currentStatement = statementIterator.next().getOrThrow()
        nextStatement = statementIterator.next()
        currentStatementMatch = currentStatement.invocationMatcher.matches(invocation)
        nextStatementMatch = nextStatement?.invocationMatcher.matches(invocation) ?? false
    }

    let statementIterator: Iterator<VerifyStatement>
    var currentStatement: VerifyStatement
    var nextStatement: Option<VerifyStatement>
    var logIndex: Int64
    var invocation: Invocation
    var currentStatementMatch: Bool
    var nextStatementMatch: Bool

    /**
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    func goToNextStatement(): Bool {
        match (nextStatement) {
            case None => return false

            case Some(statement) =>
                currentStatement = statement
                nextStatement = statementIterator.next()
                currentStatementMatch = nextStatementMatch
                nextStatementMatch = nextStatement?.invocationMatcher.matches(invocation) ?? false
                return true
        }
    }

    func hasMoreStatements(): Bool {
        match (nextStatement) {
            case Some(_) => true
            case None => false
        }
    }

    /**
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    func goToNextInvocation(): Bool {
        logIndex++
        if (let Some(nextInv) <- invocations.get(logIndex)) {
            invocation = nextInv
            currentStatementMatch = currentStatement.invocationMatcher.matches(invocation)
            nextStatementMatch = nextStatement?.invocationMatcher.matches(invocation) ?? false
            return true
        } else {
            return false
        }
    }

    /**
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     * @throws MockFrameworkInternalError
     */
    func check(count: Int64): CardinalityCheck {
        return currentStatement.cardinality.check(count)
    }
}

/**
 * @throws IndexOutOfBoundsException
 * @throws MockFrameworkInternalError
 * @throws IllegalArgumentException
 */
func verifyExhaustiveOrderedIteration(iterator: VerifyIterator): ?VerificationResult {
    var count = 0
    while (true) {
        if (iterator.currentStatementMatch && iterator.nextStatementMatch) {
            match (
                (iterator.check(count),
                iterator.check(count + 1))
            ) {
                case (Ok, More) =>
                    if (!iterator.hasMoreStatements()) {
                        internalError("Must have more statements")
                    }
                    return None
                case (Ok, Ok) =>
                    return iterator.nonDisjointStatements()
                case _ => ()
            }
        }

        if (iterator.currentStatementMatch) {
            count++
            match (iterator.check(count)) {
                case More => return iterator.tooManyInvocations(count)
                case Less =>
                    if (!iterator.goToNextInvocation()) {
                        return iterator.tooFewInvocations(count)
                    }
                    continue
                case Ok =>
                    if (iterator.goToNextInvocation()) {
                        continue
                    }
                    if (iterator.hasMoreStatements()) {
                        return iterator.unmatchedStatements()
                    }
                    return None
            }
        }
        match (iterator.check(count)) {
            case Less =>
                return if (count > 0) {
                    iterator.tooFewInvocations(count)
                } else {
                    iterator.unexpectedInvocation()
                }
            case Ok =>
                if (!iterator.hasMoreStatements()) {
                    return iterator.unmatchedInvocations()
                }
                return None
            case More => internalError("Too many invocations was handled earlier")
        }
    }
    return None
}

/**
 * @throws NoneValueException
 * @throws IndexOutOfBoundsException
 * @throws MockFrameworkInternalError
 * @throws IllegalArgumentException
 */
func verifyExhaustiveOrdered(statements: Array<VerifyStatement>, log: LogSnapshot): VerificationResult {
    let invocations = log.invocations()
    if (invocations.isEmpty()) {
        return Failure(UnmatchedStatements(statements))
    }

    let iterator = VerifyIterator(statements, invocations)
    while (true) {
        if (let Some(result) <- verifyExhaustiveOrderedIteration(iterator)) {
            return result
        }
        if (!iterator.goToNextStatement()) {
            break
        }
    }
    return Success
}

extend VerifyIterator {
    /**
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     * @throws MockFrameworkInternalError
     */
    func tooFewInvocations(count: Int64): VerificationResult {
        Failure(TooFewInvocations(currentStatement, currentStatement.cardinality, count))
    }

    /**
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     * @throws MockFrameworkInternalError
     */
    func tooManyInvocations(count: Int64): VerificationResult {
        Failure(TooManyInvocations(currentStatement, currentStatement.cardinality, count))
    }

    /**
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     * @throws MockFrameworkInternalError
     */
    func nonDisjointStatements(): VerificationResult {
        match (nextStatement) {
            case None => internalError("Missing next statement")
            case Some(nextStatement) => Failure(NonDisjointStatements(currentStatement, nextStatement, invocation))
        }
    }

    /**
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    func unmatchedStatements(): VerificationResult {
        Failure(UnmatchedStatements(leftoverStatements()))
    }

    /**
     * @throws IndexOutOfBoundsException
     */
    func unmatchedInvocations(): VerificationResult {
        let leftoverInvocations = invocations.slice(logIndex, invocations.size - logIndex).toArray()
        return Failure(UnmatchedInvocations(leftoverInvocations))
    }

    func unexpectedInvocation(): VerificationResult {
        return Failure(UnexpectedInvocation(currentStatement, invocation))
    }

    /**
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    func leftoverStatements(): Array<VerifyStatement> {
        let result = ArrayList<VerifyStatement>()
        match (nextStatement) {
            case Some(statement) => result.add(statement)
            case None => ()
        }
        result.add(all: statementIterator |> collectArray)
        return result.toArray()
    }
}
