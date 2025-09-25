






package std.unittest

import std.time.DateTime

class Details {
    var failedCount = 0
    var passedCount = 0
    var skippedCount = 0
    var errorCount = 0
    var executedSteps = 0
    var failedSteps = 0
    var startTimestamp: DateTime = DateTime.now()
    var duration = Duration.Zero

    /*
     * @noThrow
     */
    Details(var testcode: TestCode, var isAccountedStep: Bool) {
    }
    /*
     * @noThrow
     */
    init() {
        testcode = PASS
        isAccountedStep = false
    }

    /*
     * @throws IllegalArgumentException
     * @throws InvalidDataException
     * @throws IndexOutOfBoundsException
     * @throws ArithmeticException
     */
    func add(other: Details) {
        this.testcode = testcode.mostSevereWith(other.testcode)
        if (other.isAccountedStep) {
            failedCount = 0
            passedCount = 0
            skippedCount = 0
            errorCount = 0
            match (this.testcode) {
                case PASS => this.passedCount = 1
                case FAIL => this.failedCount = 1
                case ERROR | TIMEOUT => this.errorCount = 1
                case SKIP => this.skippedCount = 1
                case NORUN => this.passedCount = 1
            }
        }

        this.failedSteps += other.failedSteps
        this.executedSteps += other.executedSteps
        this.failedCount += other.failedCount
        this.passedCount += other.passedCount
        this.skippedCount += other.skippedCount
        this.errorCount += other.errorCount
        this.startTimestamp = min(this.startTimestamp, other.startTimestamp)
        let endTimestamp = max(startTimestamp + duration, other.startTimestamp + other.duration)
        this.duration = endTimestamp - startTimestamp
    }
    prop totalCount: Int64 {
        /*
         * @noThrow
         */
        get() {
            failedCount + passedCount + skippedCount + errorCount
        }
    }

    prop isSuccess: Bool {
        /*
         * @noThrow
         */
        get() {
            !testcode.isFailure()
        }
    }
}
