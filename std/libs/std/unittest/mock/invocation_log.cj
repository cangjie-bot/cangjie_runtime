






package std.unittest.mock

import std.collection.*
import std.unittest.common.PrettyPrintable

class LogSnapshot {
    LogSnapshot(
        let entries: Array<LogEntry>
    ) {}

    /**
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    func invocations(): Array<Invocation> {
        entries |> map { entry: LogEntry => entry.invocation } |> collectArray
    }

    static let EMPTY = LogSnapshot([])
}

struct LogEntry {
    LogEntry(
        let invocation: Invocation,
        let origin: BehaviourSource
    ) {}

    func wasHandledBy(thatChain: StubChain): Bool {
        match (origin) {
            case Stub(thisChain) => refEq(thisChain, thatChain)
            case _ => false
        }
    }
}

enum BehaviourSource {
    | Stub(StubChain)
    | Default
    | Failure(PrettyException)
}

class MutableLog {
    private let entries = ArrayList<LogEntry>()
    private var lastClearIndex: Int64 = 0

    /**
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    func newEntry(entry: LogEntry): Unit {
        entries.add(entry)
    }

    func clear(): Unit {
        lastClearIndex = entries.size
    }

    /**
     * @throws MockFrameworkException
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    func snapshotSinceLastClear(scope: Set<UInt64>): LogSnapshot {
        validateLog()
        let snapshotEntries = ArrayList<LogEntry>()
        let untilIndex = entries.size

        for (i in lastClearIndex..untilIndex) {
            let entry = entries[i]
            if (scope.contains(entry.invocation.stubId.receiverId)) {
                snapshotEntries.add(entry)
            }
        }
        LogSnapshot(
            snapshotEntries.toArray()
        )
    }

    /**
     * @throws MockFrameworkException
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    func fullLog(): LogSnapshot {
        validateLog()
        return LogSnapshot(entries.toArray())
    }

    /**
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     * @throws MockFrameworkException
     */
    func validateLog() {
        for (entry in entries) {
            match (entry.origin) {
                case Failure(originalException) =>
                    LogCorruptedReport().fail(originalException)
                case _ => ()
            }
        }
    }
}

class LogCorruptedReport <: FailureReport {
    /**
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     * @throws MockFrameworkException
     */
    func fail(originalMessage: PrettyPrintable): Nothing {
        let message = build {
            errorHeader("Invocation log contains errors")
            line {
                text("Probable reason: original exception was suppressed by")
                userCode("catch")
                text("block")
            }
            line("Original error:")
            indent {
                includeContent(originalMessage)
            }
        }
        throw MockFrameworkException(message)
    }
}
