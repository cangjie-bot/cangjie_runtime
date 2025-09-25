






package std.unittest.mock

import std.collection.*

/*
 * @throws NoneValueException
 * @throws MockFrameworkInternalError
 * @throws IllegalArgumentException
 * @throws IndexOutOfBoundsException
 */
func verifyUnordered(
    exhastiveness: Exhaustiveness,
    statements: Array<VerifyStatement>,
    log: LogSnapshot
): VerificationResult {
    let invocations = log.invocations()
    let (invocationIndexToStatement, statementIndexToCount) = match (batchMatch(statements, invocations)) {
        case DisjointMatching(matched, count) => (matched, count)
        case Ambiguity(statement1, statement2, invocation) =>
            return Failure(NonDisjointStatements(statement1, statement2, invocation))
    }
    match (exhastiveness) {
        case Partial => ()
        case Exhaustive =>
            let unmatchedInvocations = ArrayList<Invocation>()
            for ((index, invocation) in invocations |> enumerate) {
                match (invocationIndexToStatement[index]) {
                    case Some(_) => ()
                    case None => unmatchedInvocations.add(invocation)
                }
            }
            if (!unmatchedInvocations.isEmpty()) {
                return Failure(
                    UnmatchedInvocations(unmatchedInvocations.toArray())
                )
            }
    }
    let unmatchedStatements = ArrayList<VerifyStatement>()
    let onlyHasOneStatement = statements.size == 1
    for ((index, statement) in statements |> enumerate) {
        let count = statementIndexToCount[index]
        let cardinality = statement.cardinality
        match (cardinality.check(count)) {
            case Ok => ()
            case More => return Failure(TooManyInvocations(statement, cardinality, count))
            case Less =>
                if (count == 0 && !onlyHasOneStatement) {
                    unmatchedStatements.add(statement)
                } else {
                    return Failure(TooFewInvocations(statement, cardinality, count))
                }
        }
    }
    if (!unmatchedStatements.isEmpty()) {
        return Failure(UnmatchedStatements(unmatchedStatements.toArray()))
    }
    return Success
}

/*
 * @throws NoneValueException
 * @throws IllegalArgumentException
 * @throws IndexOutOfBoundsException
 */
func batchMatch(
    statements: Array<VerifyStatement>, invocations: Array<Invocation>
): BatchMatchResult {
    let invocationsByStub = invocations.groupIndexedBy { inv: Invocation => inv.stubId }
    let statementsByStub = statements.groupIndexedBy { st: VerifyStatement => st.invocationMatcher.stubId }
    let invocationIndexToStatement = Array<Option<VerifyStatement>>(invocations.size, repeat: None)
    let statementIndexToCount = Array<Int64>(statements.size, repeat: 0)
    for (stubId in invocationsByStub.keys()) {
        let statementIndices = statementsByStub.get(stubId) ?? continue
        let invocationIndices = invocationsByStub[stubId]
        for (invocationIndex in invocationIndices) {
            for (statementIndex in statementIndices) {
                let statement = statements[statementIndex]
                let invocation = invocations[invocationIndex]
                if (statement.invocationMatcher.matches(invocation)) {
                    match (invocationIndexToStatement[invocationIndex]) {
                        case Some(otherStatement) => return Ambiguity(otherStatement, statement, invocation)
                        case None =>
                            statementIndexToCount[statementIndex] = statementIndexToCount[statementIndex] + 1
                            invocationIndexToStatement[invocationIndex] = Some(statement)
                    }
                }
            }
        }
    }
    return DisjointMatching(invocationIndexToStatement, statementIndexToCount)
}

enum BatchMatchResult {
    /*
     * @noThrow
     */
                                                                     /*
                                                                      * @noThrow
                                                                      */
    DisjointMatching(Array<Option<VerifyStatement>>, Array<Int64>) | Ambiguity(VerifyStatement, VerifyStatement,
        Invocation)
}

extend<T> Array<T> {
    /*
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     * @throws NoneValueException
     */
    func groupIndexedBy<K>(toKey: (T) -> K): HashMap<K, ArrayList<Int64>> where K <: Hashable & Equatable<K> {
        let result = HashMap<K, ArrayList<Int64>>()
        for ((index, value) in this |> enumerate) {
            let key = toKey(value)
            result.addIfAbsent(key, ArrayList<Int64>())
            result[key].add(index)
        }
        return result
    }
}
