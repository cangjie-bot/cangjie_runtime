






package std.unittest.diff

import std.unittest.common.PrettyPrinter

public interface AssertPrintable<T> {
    prop hasNestedDiff: Bool
    /*
     * @noThrow
     */
    func pprintForAssertion(
        pp: PrettyPrinter, that: T, thisPrefix: String, thatPrefix: String, level: Int64
    ): PrettyPrinter
}
