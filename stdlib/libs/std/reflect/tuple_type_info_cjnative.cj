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
            return ArrayList<TypeInfo>(count) {
                idx =>
                    let info = unsafe { CPointer<Byte>(arr) + 8 * idx } /* Tuple element type occupies 8 bytes */
                    let ti = unsafe { CPointer<CPointer<Unit>>(info).read() }
                    return TypeInfo.getOrCreate(ti)
            }
        }
    }

    public static func of(instance: Any): TupleTypeInfo {
        match (TypeInfo.of(instance)) {
            case ti: TupleTypeInfo => ti
            case _ => throw IllegalTypeException("The type of parameter `instance` is not a tuple type.")
        }
    }

    public static redef func of<T>(): TupleTypeInfo {
        match (TypeInfo.of<T>()) {
            case ti: TupleTypeInfo => ti
            case _ => throw IllegalTypeException("The type of generic type `T` is not a tuple type.")
        }
    }

    public func construct(args: Array<Any>): Any {
        if (args.size != elements.size) {
            throw IllegalArgumentException("The number of arguments does not match the number of tuple elements.")
        }
        for (i in 0..args.size) {
            if (!TypeInfo.of(args[i]).isSubtypeOf(elements[i])) {
                throw IllegalTypeException("The type of argument at index ${i} does not match the type of the corresponding tuple element.")
            }
        }
        newAndInitObject(_info, args)
    }

    public func destruct(instance: Any): ReadOnlyList<Any> {
        if (TypeInfo.of(instance) != this) {
            throw IllegalTypeException("The type of parameter `instance` does not match this tuple type.")
        }
        let arr = getAssociatedValues(instance, TypeInfo.of<Array<Any>>()._info) as Array<Any>
        return ArrayList<Any>(arr.getOrThrow())
    }
}
