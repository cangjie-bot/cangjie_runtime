






package std.unittest.mock

import std.collection.*




public enum Exhaustiveness {
    Exhaustive | Partial
}

enum Orderedness {
    Ordered | Unordered
}

enum VerificationResult {
    Success | Failure(VerificationFailedReason)
}

func performVerification(statements: Array<VerifyStatement>, orderedness: Orderedness, exhaustiveness: Exhaustiveness) {
    if (statements.isEmpty()) {
        VerifyMisconfiguration().fail(EmptyVerifyBlock)
    }

    let objectIds = collectObjectsIds(statements)
    let logSnapshot = MockFramework.session { session: MockSession =>
        for (st in statements) {
            st.prepareForVerification(orderedness)
        }
        session.invocationLog.snapshotSinceLastClear(objectIds)
    }

    let verificationResult = match ((orderedness, exhaustiveness)) {
        case (Ordered, Exhaustive) => verifyExhaustiveOrdered(statements, logSnapshot)
        case (Unordered, exhaustiveness) => verifyUnordered(exhaustiveness, statements, logSnapshot)
        case _ => internalError("Unsupported modes")
    }

    match (verificationResult) {
        case Failure(reason) =>
            let nameRegistry = MockNameRegistry(
                statements |> map {st: VerifyStatement => st.invocationMatcher} |> collectArray)
            VerificationFailureReport(logSnapshot, nameRegistry).fail(reason)
        case Success => ()
    }
}

func verifyNoInteractions(objectRefs: Array<Object>) {
    ensureDistinctReferences(objectRefs)

    let objectIds = _FRAMEWORK.findObjectIdsByRefs(objectRefs)
    if (objectIds.size != objectRefs.size) {
        illegalInput(
            "Invalid input: arguments to Verify.noInteractions must be mock or spy objects"
        )
    }

    let logSnapshot = MockFramework.session { session: MockSession =>
        session.invocationLog.snapshotSinceLastClear(objectIds)
    }

    let invocations = logSnapshot.invocations()
    if (invocations.isEmpty()) {
        return
    }

    VerificationFailureReport(logSnapshot, MockNameRegistry.EMPTY).fail(
        UnwantedInteractions(invocations)
    )
}

func ensureDistinctReferences(refs: Array<Object>) {
    if (refs.isEmpty()) {
        illegalInput("Invalid input: empty object array")
    }

    for (i in 0..refs.size) {
        for (j in (i + 1)..refs.size) {
            if (refEq(refs[i], refs[j])) {
                illegalInput("Invalid input: several references to the same object")
            }
        }
    }
}

func collectObjectsIds(statements: Array<VerifyStatement>): HashSet<UInt64> {
    let objectIds = HashSet<UInt64>()
    for (statement in statements) {
        objectIds.add(statement.invocationMatcher.stubId.receiverId)
    }
    return objectIds
}

func checkMatchersConsistency(statement: VerifyStatement) {
    for (matcher in statement.invocationMatcher.positionalMatchers) {
        if (let Some(listeningMatcher) <- (matcher as ListeningMatcher)) {
            match (listeningMatcher.valueListener) {
                case None => ()
                case _ =>
                    VerifyMisconfiguration().fail(ArgumentCaptureNotAllowed(statement, matcher))
            }
        }
    }
}
