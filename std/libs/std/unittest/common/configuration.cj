






package std.unittest.common

import std.collection.*

public interface KeyFor<T> {
    prop name: String
}

public struct KeyTags <: KeyFor<Array<String>> {
    public static prop tags: KeyTags {
        get() {
            KeyTags()
        }
    }

    public prop name: String {
        get() {
            "tags"
        }
    }
}

sealed abstract class ConfigurationKey <: Equatable<ConfigurationKey> & Hashable {
    protected ConfigurationKey(public let name: String) {}

    public override func hashCode(): Int64 {
        name.hashCode()
    }

    protected func equals(that: ConfigurationKey): Bool

    public override operator func ==(that: ConfigurationKey) {
        equals(that)
    }

    public override operator func !=(that: ConfigurationKey) {
        !equals(that)
    }
}

class TypedConfigurationKey<T> <: ConfigurationKey {
    TypedConfigurationKey(name: String) {
        super(name)
    }

    protected override func equals(that: ConfigurationKey): Bool {
        that is TypedConfigurationKey<T> && this.name == that.name
    }
}

extend ConfigurationKey {
    public static func create<T>(name: String): ConfigurationKey {
        TypedConfigurationKey<T>(name)
    }
}




public class Configuration <: ToString {
    private static let TAGS_CONCAT_KEY: ConfigurationKey = ConfigurationKey.create<Array<String>>("tags")

    private Configuration(
        private let storage: HashMap<ConfigurationKey, Any>
    ) {}


    public init() {
        this(HashMap<ConfigurationKey, Any>())
    }










    public func get<T>(key: KeyFor<T>): ?T {
        getByName<T>(key.name)
    }








    public func getByName<T>(name: String): ?T {
        let configurationKey = ConfigurationKey.create<T>(name)
        match (storage.get(configurationKey)) {
            case Some(v) => v as T
            case None => None<T>
        }
    }









    public func set<T>(key: KeyFor<T>, value: T): Unit {
        let configurationKey = checkOptionValueAndGetConfigurationKey(key, value)
        storage[configurationKey] = value
    }






    public func setByName<T>(name: String, value: T): Unit {
        let configurationKey = checkOptionValueByNameAndGetConfigurationKey(name, value)
        storage[configurationKey] = value
    }










    public func remove<T>(key: KeyFor<T>): ?T {
        removeByName(key.name)
    }







    public func removeByName<T>(key: String): ?T {
        let configurationKey = ConfigurationKey.create<T>(key)
        match (storage.remove(configurationKey)) {
            case Some(any) => any as T
            case None => None<T>
        }
    }



    public func clone(): Configuration {
        Configuration(storage.clone())
    }




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
