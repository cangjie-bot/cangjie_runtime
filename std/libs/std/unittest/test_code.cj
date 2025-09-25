






package std.unittest

import std.unittest.common.*



enum TestCode <: ToString & PrettyPrintable & Equatable<TestCode> {
    | PASS
    | SKIP
    | TIMEOUT
    | FAIL
    | ERROR
    | NORUN

    public func toString(): String {
        match (this) {
            case PASS => "PASS"
            case SKIP => "SKIP"
            case TIMEOUT => "TIMEOUT"
            case FAIL => "FAIL"
            case ERROR => "ERROR"
            case NORUN => "NORUN"
        }
    }

    func mostSevereWith(other: TestCode): TestCode {
        if (this.severity() > other.severity()) {
            this
        } else {
            other
        }
    }

    private func severity(): Int64 {
        match (this) {
            case PASS => 0
            case SKIP => 1
            case TIMEOUT => 2
            case FAIL => 3
            case ERROR => 4
            case NORUN => 5
        }
    }

    func isFailure(): Bool {
        match (this) {
            case PASS | SKIP | NORUN => false
            case _ => true
        }
    }

    func toStringTense(): String {
        match (this) {
            case PASS => "PASSED"
            case SKIP => "SKIPPED"
            case TIMEOUT => "TIMEOUT"
            case FAIL => "FAILED"
            case ERROR => "ERROR"
            case NORUN => "NORUN"
        }
    }

    public operator func ==(right: TestCode): Bool {
        match ((this, right)) {
            case (PASS, PASS) => return true
            case (SKIP, SKIP) => return true
            case (TIMEOUT, TIMEOUT) => return true
            case (FAIL, FAIL) => return true
            case (ERROR, ERROR) => return true
            case (NORUN, NORUN) => return true
            case _ => return false
        }
    }

    public operator func !=(right: TestCode): Bool {
        !(this == right)
    }

    public func pprint(pp: PrettyPrinter): PrettyPrinter {
        let color = match (this) {
            case PASS | SKIP | NORUN => Color.GREEN
            case FAIL => Color.RED
            case TIMEOUT | ERROR => return pp.append(toStringTense())
        }
        pp.colored(color) { pp.append(toStringTense()) }
    }
}
