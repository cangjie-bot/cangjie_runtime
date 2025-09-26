






package std.unittest.diff

import std.unittest.common.PrettyPrinter

extend<T> Option<T> <: AssertPrintable<Option<T>> where T <: Equatable<T> {
    public prop hasNestedDiff: Bool {
        get() { false }
    }

    /**
     * @throws IllegalArgumentException
     */
    public func pprintForAssertion(pp: PrettyPrinter, right: Option<T>, leftPrefix: String, rightPrefix: String,
        level: Int64): PrettyPrinter {
        return pp.pprintOptionDiff(this, right, leftPrefix, rightPrefix, level)
    }
}

extend PrettyPrinter {
    /**
     * @throws IllegalArgumentException
     */
    func pprintOptionDiff<T>(left: Option<T>, right: Option<T>, leftPrefix: String, rightPrefix: String, level: Int64) {
        match (left) {
            case Some(l) =>
                match (right) {
                    case Some(r) => pprintForAssertionOrSimple(l, r, leftPrefix, rightPrefix, level)
                    case None => pprintLeftRight(l, right, leftPrefix, rightPrefix)
                }
            case None =>
                match (right) {
                    case Some(r) => pprintLeftRight(left, r, leftPrefix, rightPrefix)
                    case None => ()
                }
        }
        return this
    }
}
