package std.reflect

import std.collection.{ReadOnlyList, ArrayList}

public class TupleTypeInfo <: TypeInfo {
    init(cp: CPointer<Unit>) {
        super(cp)
    }

    public prop elements: ReadOnlyList<TypeInfo> {
        get() {
            let count: Int64 = Int64(getNumOfTypeInfoFields(_info))
            let arr: CPointer<Unit> = getTypeInfoFields(_info)
            return ArrayList<TypeInfo>(count) {
                idx =>
                    let info = unsafe { CPointer<Byte>(arr) + 8 * idx } /* Tuple element type occupies 8 bytes */
                    return TypeInfo.getOrCreate(CPointer<Unit>(info))
            }
        }
    }

    public static func of(instance: Any): TupleTypeInfo {
        match (TypeInfo.of(instance)) {
            case ti: TupleTypeInfo => ti
            case _ => throw IllegalTypeException("The type of parameter `instance` is not an Enum type.")
        }
    }

    public static redef func of<T>(): TupleTypeInfo {
        match (TypeInfo.of<T>()) {
            case ti: TupleTypeInfo => ti
            case _ => throw IllegalTypeException("The type of generic type `T` is not an Enum type.")
        }
    }

    public func construct(args: Array<Any>): Any {
        newAndInitObject(_info, args)
    }

    public func destruct(instance: Any): ReadOnlyList<Any> {
        let arr = getAssociatedValues(_info) as Array<Any>
        return ArrayList<Any>(arr.getOrThrow())
    }
}
