










package std.database.sql


public enum TransactionIsoLevel <: ToString & Hashable & Equatable<TransactionIsoLevel> {
    | Unspecified
    | ReadCommitted
    | ReadUncommitted
    | RepeatableRead
    | Snapshot
    | Serializable
    | Linearizable
    | Chaos

    public func toString(): String {
        match (this) {
            case Unspecified => "Unspecified"
            case ReadCommitted => "Read Committed"
            case ReadUncommitted => "Read Uncommitted"
            case RepeatableRead => "Repeatable Read"
            case Snapshot => "Snapshot"
            case Serializable => "Serializable"
            case Linearizable => "Linearizable"
            case Chaos => "Chaos"
        }
    }

    public operator func ==(rhs: TransactionIsoLevel): Bool {
        match ((this, rhs)) {
            case (Unspecified, Unspecified) => true
            case (ReadCommitted, ReadCommitted) => true
            case (ReadUncommitted, ReadUncommitted) => true
            case (RepeatableRead, RepeatableRead) => true
            case (Snapshot, Snapshot) => true
            case (Serializable, Serializable) => true
            case (Linearizable, Linearizable) => true
            case (Chaos, Chaos) => true
            case _ => false
        }
    }

    public operator func !=(rhs: TransactionIsoLevel): Bool {
        return !(this == rhs)
    }

    public func hashCode(): Int64 {
        return this.toString().hashCode()
    }
}


public enum TransactionAccessMode <: ToString & Hashable & Equatable<TransactionAccessMode> {
    | Unspecified
    | ReadWrite
    | ReadOnly

    public func toString(): String {
        match (this) {
            case Unspecified => "Unspecified"
            case ReadWrite => "Read Write"
            case ReadOnly => "Read Only"
        }
    }

    public operator func ==(rhs: TransactionAccessMode): Bool {
        match ((this, rhs)) {
            case (Unspecified, Unspecified) => true
            case (ReadWrite, ReadWrite) => true
            case (ReadOnly, ReadOnly) => true
            case _ => false
        }
    }

    public operator func !=(rhs: TransactionAccessMode): Bool {
        return !(this == rhs)
    }

    public func hashCode(): Int64 {
        return this.toString().hashCode()
    }
}


public enum TransactionDeferrableMode <: ToString & Hashable & Equatable<TransactionDeferrableMode> {
    | Unspecified
    | Deferrable
    | NotDeferrable

    public func toString(): String {
        match (this) {
            case Unspecified => "Unspecified"
            case Deferrable => "Deferrable"
            case NotDeferrable => "Not Deferrable"
        }
    }

    public operator func ==(rhs: TransactionDeferrableMode): Bool {
        match ((this, rhs)) {
            case (Unspecified, Unspecified) => true
            case (Deferrable, Deferrable) => true
            case (NotDeferrable, NotDeferrable) => true
            case _ => false
        }
    }

    public operator func !=(rhs: TransactionDeferrableMode): Bool {
        return !(this == rhs)
    }

    public func hashCode(): Int64 {
        return this.toString().hashCode()
    }
}


public interface Transaction {


    mut prop isoLevel: TransactionIsoLevel


    mut prop accessMode: TransactionAccessMode


    mut prop deferrableMode: TransactionDeferrableMode



    func begin(): Unit



    func commit(): Unit



    func rollback(): Unit



    func rollback(savePointName: String): Unit



    func save(savePointName: String): Unit



    func release(savePointName: String): Unit
}
