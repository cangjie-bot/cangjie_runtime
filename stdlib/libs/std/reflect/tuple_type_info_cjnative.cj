/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */
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
            println(count)
            return ArrayList<TypeInfo>(count) {
                idx =>
                    println(arr.toUIntNative())
                    let info = unsafe { CPointer<Byte>(arr) + 8 * idx } /* Tuple element type occupies 8 bytes */
                    println(info.toUIntNative())
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
