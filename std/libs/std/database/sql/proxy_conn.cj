







package std.database.sql

import std.collection.Map
import std.sync.AtomicBool

class ProxyConnection <: Connection {
    var delegate: Connection
    var poolEntry: Entry<Connection>
    var isReleased = AtomicBool(false)

    init(conn: Connection, poolEntry: Entry<Connection>) {
        this.delegate = conn
        this.poolEntry = poolEntry
    }

    public prop state: ConnectionState {
        get() {
            return delegate.state
        }
    }

    public func getMetaData(): Map<String, String> {
        return delegate.getMetaData()
    }

    public func isClosed(): Bool {
        return isReleased.load()
    }

    /**
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     * @throws ArithmeticException
     */
    public func close(): Unit {
        if (isReleased.load()) {
            return
        }
        isReleased.store(true)
        poolEntry.release()
    }

    /**
     * @throws SqlException
     */
    public func prepareStatement(sql: String): Statement {
        if (isClosed()) {
            throw SqlException("Connection closed")
        }
        return delegate.prepareStatement(sql)
    }

    /**
     * @throws SqlException
     */
    public func createTransaction(): Transaction {
        if (isClosed()) {
            throw SqlException("Connection closed")
        }
        return delegate.createTransaction()
    }
}
