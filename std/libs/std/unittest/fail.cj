






package std.unittest


public func failExpect(message: String): Unit {
    cancellationPoint()
    let checkResult = FailCheckResult(Expect, message)
    Framework.withCurrentContext{ ctx => ctx.checkFailed(checkResult) }
}


public func fail(message: String): Nothing {
    cancellationPoint()
    let checkResult = FailCheckResult(Assert, message)
    Framework.withCurrentContext{ ctx => ctx.checkFailed(checkResult) }
    throw AssertException(message, checkResult)
}


public func assertCaughtUnexpectedE(
    message: String,
    expectedExceptions: String,
    caughtException: String,
    optParentCtx!: ?AssertionCtx = None
): Nothing {
    let checkResult = AssertThrowsCheckResult(Assert, message, expectedExceptions, caughtException)
    if (let Some(parentCtx) <- optParentCtx) {
        parentCtx.fail(checkResult)
    } else {
        Framework.withCurrentContext{ ctx => ctx.checkFailed(checkResult) }
        throw AssertException(message, checkResult)
    }
}


public func expectCaughtUnexpectedE(
    message: String,
    expectedExceptions: String,
    caughtException: String,
    optParentCtx!: ?AssertionCtx = None
): Unit {
    let checkResult = AssertThrowsCheckResult(Expect, message, expectedExceptions, caughtException)
    if (let Some(parentCtx) <- optParentCtx) {
        parentCtx.failExpect(checkResult)
    } else {
        Framework.withCurrentContext{ ctx => ctx.checkFailed(checkResult) }
    }
}
