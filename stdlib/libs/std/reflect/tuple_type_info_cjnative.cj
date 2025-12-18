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
            let count: Int64 = Int64(getNumOfFieldTypes(_info))
            let arr: CPointer<Unit> = getFieldTypes(_info)
            return ArrayList<TypeInfo>(count) {
                idx =>
                    let info = unsafe { CPointer<Byte>(arr) + 8 * idx } /* Tuple element type occupies 8 bytes */
                    let ti = unsafe { CPointer<CPointer<Unit>>(info).read() }
                    return TypeInfo.getOrCreate(ti)
            }
        }
    }

    public static func of(instance: Any): TupleTypeInfo {
        let ti = TypeInfo.of(instance)
        match (ti) {
            case tupleInfo: TupleTypeInfo => tupleInfo
            case _ => throw IllegalTypeException("Expected `instance` to be a tuple type, but got ${ti.qualifiedName}.")
        }
    }

    public static redef func of<T>(): TupleTypeInfo {
        let ti = TypeInfo.of<T>()
        match (ti) {
            case tupleInfo: TupleTypeInfo => tupleInfo
            case _ => throw IllegalTypeException("Expected generic type `T` to be a tuple type, but got ${ti.qualifiedName}.")
        }
    }

    public func construct(args: Array<Any>): Any {
        let elementInfos = elements
        if (args.size != elementInfos.size) {
            throw IllegalArgumentException(
                "Tuple argument count mismatch for ${qualifiedName}: expected ${elementInfos.size}, got ${args.size}."
            )
        }
        for (i in 0..args.size) {
            let argType = TypeInfo.of(args[i])
            let expectedType = elementInfos[i]
            if (!argType.isSubtypeOf(expectedType)) {
                throw IllegalTypeException(
                    "Tuple argument type mismatch at index ${i}: expected ${expectedType.qualifiedName}, got ${argType.qualifiedName}."
                )
            }
        }
        newAndInitObject(_info, args)
    }

    public func destruct(instance: Any): ReadOnlyList<Any> {
        let instanceType = TypeInfo.of(instance)
        if (instanceType != this) {
            throw IllegalTypeException(
                "Tuple instance type mismatch: expected ${qualifiedName}, got ${instanceType.qualifiedName}."
            )
        }
        let arr = getAssociatedValues(instance, TypeInfo.of<Array<Any>>()._info) as Array<Any>
        return ArrayList<Any>(arr.getOrThrow())
    }
}
