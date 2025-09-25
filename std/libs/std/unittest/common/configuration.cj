






package std.unittest.common

import std.collection.*

public interface KeyFor<T> {
    prop name: String
}

              /*
               * @noThrow
               */
public struct KeyTags <: KeyFor<Array<String>> {
    public static prop tags: KeyTags {
        /*
         * @noThrow
         */
        get() {
            KeyTags()
        }
    }

    public prop name: String {
        /*
         * @noThrow
         */
        get() {
            "tags"
        }
    }
}

sealed abstract class ConfigurationKey <: Equatable<ConfigurationKey> & Hashable {
    /*
     * @noThrow
     */
    protected ConfigurationKey(public let name: String) {}

    /*
     * @noThrow
     */
    public override func hashCode(): Int64 {
        name.hashCode()
    }

    /*
     * @noThrow
     */
    protected func equals(that: ConfigurationKey): Bool

    /*
     * @noThrow
     */
    public override operator func ==(that: ConfigurationKey) {
        equals(that)
    }

    /*
     * @noThrow
     */
    public override operator func !=(that: ConfigurationKey) {
        !equals(that)
    }
}

class TypedConfigurationKey<T> <: ConfigurationKey {
    /*
     * @noThrow
     */
    TypedConfigurationKey(name: String) {
        super(name)
    }

    /*
     * @noThrow
     */
    protected override func equals(that: ConfigurationKey): Bool {
        that is TypedConfigurationKey<T> && this.name == that.name
    }
}

extend ConfigurationKey {
    /*
     * @noThrow
     */
    public static func create<T>(name: String): ConfigurationKey {
        TypedConfigurationKey<T>(name)
    }
}




public class Configuration <: ToString {
    private static let TAGS_CONCAT_KEY: ConfigurationKey = ConfigurationKey.create<Array<String>>("tags")

    /*
     * @noThrow
     */
    private Configuration(
        private let storage: HashMap<ConfigurationKey, Any>
    ) {}


    /*
     * @noThrow
     */
    public init() {
        this(HashMap<ConfigurationKey, Any>())
    }










    /*
     * @throws IndexOutOfBoundsException
     */
    public func get<T>(key: KeyFor<T>): ?T {
        getByName<T>(key.name)
    }








    /*
     * @throws IndexOutOfBoundsException
     */
    public func getByName<T>(name: String): ?T {
        let configurationKey = ConfigurationKey.create<T>(name)
        match (storage.get(configurationKey)) {
            case Some(v) => v as T
            case None => None<T>
        }
    }









    /*
     * @throws IllegalArgumentException
     * @throws UnittestOptionValidationException
     * @throws IndexOutOfBoundsException
     */
    public func set<T>(key: KeyFor<T>, value: T): Unit {
        let configurationKey = checkOptionValueAndGetConfigurationKey(key, value)
        storage[configurationKey] = value
    }






    /*
     * @throws IllegalArgumentException
     * @throws UnittestOptionValidationException
     * @throws IndexOutOfBoundsException
     */
    public func setByName<T>(name: String, value: T): Unit {
        let configurationKey = checkOptionValueByNameAndGetConfigurationKey(name, value)
        storage[configurationKey] = value
    }










    /*
     * @throws IndexOutOfBoundsException
     */
    public func remove<T>(key: KeyFor<T>): ?T {
        removeByName(key.name)
    }







    /*
     * @throws IndexOutOfBoundsException
     */
    public func removeByName<T>(key: String): ?T {
        let configurationKey = ConfigurationKey.create<T>(key)
        match (storage.remove(configurationKey)) {
            case Some(any) => any as T
            case None => None<T>
        }
    }



    /*
     * @noThrow
     */
    public func clone(): Configuration {
        Configuration(storage.clone())
    }




    /*
     * @throws ConcurrentModificationException
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    public func toString(): String {
        func printEntry(sb: StringBuilder, entry: (ConfigurationKey, Any)) {
            let (k, v) = entry
            sb.append(k.name)
            sb.append(":")
            sb.append(toStringOrPlaceholder(v))
        }
        let sb = StringBuilder("Configuration(")
        let storageIterator = storage.iterator()
        match (storageIterator.next()) {
            case None => return "Configuration()"
            case Some(entry) => printEntry(sb, entry)
        }
        for (entry in storageIterator) {
            sb.append(",")
            printEntry(sb, entry)
        }
        sb.append(")")
        return sb.toString()
    }
    /*
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    public static func merge(parent: Configuration, child: Configuration): Configuration {
        let clone = parent.clone()
        for ((k, v) in child.storage) {
            if (k.equals(TAGS_CONCAT_KEY)) {
                let typedV = v as Array<String> ?? Array()
                let toPut = typedV |> concat(clone.get(KeyTags.tags) ?? Array()) |> collectHashSet
                clone.storage.add(k, toPut.toArray())
            } else {
                clone.storage.add(k, v)
            }
        }
        clone
    }
}
