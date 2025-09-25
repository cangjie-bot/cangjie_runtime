







package std.database.sql

import std.collection.HashMap
import std.sync.Mutex
import std.sort.sort




public class DriverManager {
    static let _regMut = Mutex()
    static let _drivers = HashMap<String, Driver>()
    /*
     * @noThrow
     */
    init() {}





    /*
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     * @throws IllegalSynchronizationStateException
     * @throws SqlException
     */
    public static func register(driverName: String, driver: Driver): Unit {
        synchronized(_regMut) {
            if (_drivers.contains(driverName)) {
                throw SqlException("Duplicate database driver (${driverName}).")
            }
            _drivers.add(driverName, driver)
        }
    }




    /*
     * @throws IndexOutOfBoundsException
     * @throws IllegalSynchronizationStateException
     */
    public static func deregister(driverName: String): Unit {
        synchronized(_regMut) {
            _drivers.remove(driverName)
        }
    }





    /*
     * @throws IndexOutOfBoundsException
     * @throws IllegalSynchronizationStateException
     */
    public static func getDriver(driverName: String): Option<Driver> {
        synchronized(_regMut) {
            _drivers.get(driverName)
        }
    }




    /*
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     * @throws IllegalSynchronizationStateException
     */
    public static func drivers(): Array<String> {
        synchronized(_regMut) {
            let arr = _drivers.keys().toArray()
            sort(arr, stable: true)
            return arr
        }
    }
}
