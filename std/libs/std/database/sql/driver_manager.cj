







package std.database.sql

import std.collection.HashMap
import std.sync.Mutex
import std.sort.sort




public class DriverManager {
    static let _regMut = Mutex()
    static let _drivers = HashMap<String, Driver>()
    init() {}





    public static func register(driverName: String, driver: Driver): Unit {
        synchronized(_regMut) {
            if (_drivers.contains(driverName)) {
                throw SqlException("Duplicate database driver (${driverName}).")
            }
            _drivers.add(driverName, driver)
        }
    }




    public static func deregister(driverName: String): Unit {
        synchronized(_regMut) {
            _drivers.remove(driverName)
        }
    }





    public static func getDriver(driverName: String): Option<Driver> {
        synchronized(_regMut) {
            _drivers.get(driverName)
        }
    }




    public static func drivers(): Array<String> {
        synchronized(_regMut) {
            let arr = _drivers.keys().toArray()
            sort(arr, stable: true)
            return arr
        }
    }
}
