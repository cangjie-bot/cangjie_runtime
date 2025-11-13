package std.reflect

import std.collection.ReadOnlyList
import std.collection.ArrayList

public class FunctionTypeInfo <: TypeInfo {
    var _parameters: ?ReadOnlyList<TypeInfo> = None<ReadOnlyList<TypeInfo>>
    var _returnType: ?TypeInfo = None<TypeInfo>

    init(cp: CPointer<Unit>) {
        super(cp)
    }

    public prop parameters: ReadOnlyList<TypeInfo> {
        get() {
            ArrayList<TypeInfo>()
        }
    }

    public prop returnType: TypeInfo {
        get() {
            if (let Some(ti) <- _returnType) {
                return ti
            } else {
                let pointer: CPointer<Unit> = getMethodReturnType(CPointer<Unit>())
                let info = TypeInfo.getOrCreate(pointer)
                _returnType = info
                info
            }
        }
    }

    public static func of(instance: Any): FunctionTypeInfo {
        match (TypeInfo.of(instance)) {
            case ti: FunctionTypeInfo => ti
            case _ => throw IllegalTypeException("The type of parameter `instance` is not an Enum type.")
        }
    }

    public static redef func of<T>(): FunctionTypeInfo {
        match (TypeInfo.of<T>()) {
            case ti: FunctionTypeInfo => ti
            case _ => throw IllegalTypeException("The type of generic type `T` is not an Enum type.")
        }
    }

    public static func apply(instance: Any, args: Array<Any>): Any {
    }
}
