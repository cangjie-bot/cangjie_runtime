






package std.unittest

import std.unittest.diff.AssertPrintable
import std.unittest.common.*










/**
 * @throws Error
 * @throws UnittestTimeoutException
 * @throws IllegalSynchronizationStateException
 * @throws IllegalArgumentException
 * @throws IndexOutOfBoundsException
 * @throws AssertException
 */
public func assertEqual<T>(
    leftStr: String,
    rightStr: String,
    expected: T,
    actual: T,
    optParentCtx!: ?AssertionCtx = None
): Unit where T <: Equatable<T> {
    assertEqual(leftStr, rightStr, expected, actual, isDelta: false, optParentCtx: optParentCtx)
}











/**
 * @throws Error
 * @throws UnittestTimeoutException
 * @throws IllegalSynchronizationStateException
 * @throws IllegalArgumentException
 * @throws IndexOutOfBoundsException
 * @throws AssertException
 */
public func assertEqual<T>(
    leftStr: String,
    rightStr: String,
    expected: T,
    actual: T,
    isDelta!: Bool,
    optParentCtx!: ?AssertionCtx = None
): Unit where T <: Equatable<T> {
    cancellationPoint()
    if (let Some(parentCtx) <- optParentCtx) {
        if (expected != actual) {
            let cr = buildCheckResult(leftStr, rightStr, expected, actual, Assert, isDelta: isDelta)
            parentCtx._errors.add(Leaf(cr))
            throw AssertException("", cr)
        }
    } else {
        if (expected != actual) {
            let cr = buildCheckResult(leftStr, rightStr, expected, actual, Assert, isDelta: isDelta)
            Framework.withCurrentContext{ ctx => ctx.checkFailed(cr) }
            throw AssertException("", cr)
        } else {
            Framework.withCurrentContext{ ctx => ctx.checkPassed() }
        }
    }
}








/**
 * @throws Error
 * @throws UnittestTimeoutException
 * @throws IllegalSynchronizationStateException
 * @throws IllegalArgumentException
 * @throws IndexOutOfBoundsException
 */
public func expectEqual<T>(
    leftStr: String,
    rightStr: String,
    expected: T,
    actual: T,
    optParentCtx!: ?AssertionCtx = None
): Unit where T <: Equatable<T> {
    expectEqual(leftStr, rightStr, expected, actual, isDelta: false, optParentCtx: optParentCtx)
}









/**
 * @throws Error
 * @throws UnittestTimeoutException
 * @throws IllegalSynchronizationStateException
 * @throws IllegalArgumentException
 * @throws IndexOutOfBoundsException
 */
public func expectEqual<T>(
    leftStr: String,
    rightStr: String,
    expected: T,
    actual: T,
    isDelta!: Bool,
    optParentCtx!: ?AssertionCtx = None
): Unit where T <: Equatable<T> {
    cancellationPoint()
    if (let Some(parentCtx) <- optParentCtx) {
        if (expected != actual) {
            let cr = buildCheckResult(leftStr, rightStr, expected, actual, Expect, isDelta: isDelta)
            parentCtx._errors.add(Leaf(cr))
        }
    } else {
        if (expected != actual) {
            let cr = buildCheckResult(leftStr, rightStr, expected, actual, Expect, isDelta: isDelta)
            Framework.withCurrentContext{ ctx => ctx.checkFailed(cr) }
        } else {
            Framework.withCurrentContext{ ctx => ctx.checkPassed() }
        }
    }
}

/**
 * @throws IllegalArgumentException
 */
func buildCheckResult<T>(
    leftStr: String,
    rightStr: String,
    expected: T,
    actual: T,
    checkResultKind: CheckResultKind,
    isDelta!: Bool = false 
): AssertExpectCheckResult {
    match (expected) {
        case te: AssertPrintable<T> =>
            let message = PrettyText()
            te.pprintForAssertion(message, actual, leftStr, rightStr, 1)
            DiffCheckResult(checkResultKind, message)
        case _ =>
            if (isDelta) {
                PlainDeltaCompareCheckResult(checkResultKind, leftStr)
            } else {
                PlainCompareCheckResult(
                    checkResultKind, leftStr, rightStr, toStringOrPlaceholder(expected), toStringOrPlaceholder(actual)
                )
            }
    }
}
