







package std.database.sql

import std.time.DateTime
import std.sync.AtomicBool


public class PooledDatasource <: Datasource {
    private static let defaultIdleTimeout = Duration.minute * 10
    private static let defaultMaxLifetime = Duration.minute * 30
    private static let defaultConnTimeout = Duration.second * 30
    private static let defaultHealthCheckPeriod = Duration.minute * 1
    private static const DEFAULT_MAX_CONNS = 10i32
    private static const DEFAULT_MAX_IDLE_CONNS = 0i32
    private let datasource: Datasource
    private var pool: ResourcePool<Connection>
    private let isclosed = AtomicBool(false)






    /*
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     * @throws ArithmeticException
     * @throws IllegalSynchronizationStateException
     */
    public init(datasource: Datasource) {
        this.datasource = datasource
        func newConn(): Option<Connection> {
            var conn = datasource.connect()
            return conn
        }
        func closeConn(conn: Connection): Option<Unit> {
            conn.close()
        }
        let opt = Options<Connection>(
            DEFAULT_MAX_IDLE_CONNS,
            DEFAULT_MAX_CONNS,
            defaultIdleTimeout,
            defaultMaxLifetime,
            defaultHealthCheckPeriod,
            newConn,
            closeConn
        )
        pool = ResourcePool<Connection>(opt)
    }




    public mut prop idleTimeout: Duration {
        /*
         * @noThrow
         */
        get() {
            pool.options.idleTimeout
        }
        /*
         * @noThrow
         */
        set(value) {
            pool.options.idleTimeout = value
        }
    }




    public mut prop maxLifeTime: Duration {
        /*
         * @noThrow
         */
        get() {
            pool.options.maxLifeTime
        }
        /*
         * @noThrow
         */
        set(value) {
            pool.options.maxLifeTime = value
        }
    }




    public mut prop keepaliveTime: Duration {
        /*
         * @noThrow
         */
        get() {
            pool.options.keepaliveTime
        }
        /*
         * @noThrow
         */
        set(value) {
            pool.options.keepaliveTime = value
        }
    }





    public mut prop maxSize: Int32 {
        /*
         * @noThrow
         */
        get() {
            pool.maxSize
        }
        /*
         * @noThrow
         */
        set(value) {
            pool.maxSize = value
        }
    }




    public mut prop maxIdleSize: Int32 {
        /*
         * @noThrow
         */
        get() {
            pool.maxIdleSize
        }
        /*
         * @noThrow
         */
        set(value) {
            pool.maxIdleSize = value
        }
    }

    var _connTimeout: Duration = defaultConnTimeout




    public mut prop connectionTimeout: Duration {
        /*
         * @noThrow
         */
        get() {
            _connTimeout
        }
        /*
         * @throws ArithmeticException
         */
        set(value) {
            _connTimeout = value
            datasource.setOption(SqlOption.ConnectionTimeout, _connTimeout.toMilliseconds().toString())
        }
    }




    /*
     * @noThrow
     */
    public func setOption(key: String, value: String): Unit {
        datasource.setOption(key, value)
    }






    /*
     * @throws getOrThrow
     * @throws IndexOutOfBoundsException
     * @throws ArithmeticException
     * @throws IllegalArgumentException
     * @throws IllegalSynchronizationStateException
     * @throws Exception
     * @throws SqlException
     */
    public func connect(): Connection {
        var item = pool.acquire(_connTimeout)
        match (item) {
            case Some(entry) => return ProxyConnection(entry.value, entry)
            case None => throw SqlException("Can not acquire connection.")
        }
    }






    /*
     * @noThrow
     */
    public func isClosed(): Bool {
        return isclosed.load()
    }




    /*
     * @throws IndexOutOfBoundsException
     * @throws IllegalSynchronizationStateException
     * @throws SqlException
     * @throws OutOfMemoryError
     */
    public func close(): Unit {
        if (isclosed.load()) {
            return
        }
        isclosed.store(true)
        pool.close()
        datasource.close()
    }
}
