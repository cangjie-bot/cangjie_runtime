/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */
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
            if (let Some(params) <- _parameters) {
                return params
            }

            let nums: Int64 = Int64(getNumOfFunctionParameters(_info))
            let arr = getFunctionParameters(_info)

            let params = ArrayList<TypeInfo>(nums) {
                idx =>
                    let slot = unsafe { CPointer<Byte>(arr) + 8 * idx } /* TypeInfo pointer occupies 8 bytes */
                    let ti = unsafe { CPointer<CPointer<Unit>>(slot).read() }
                    TypeInfo.getOrCreate(ti)
            }
            _parameters = params
            params
        }
    }

    public prop returnType: TypeInfo {
        get() {
            return if (let Some(ti) <- _returnType) {
                ti
            } else {
                let pointer: CPointer<Unit> = getFunctionReturnType(_info)
                let info = TypeInfo.getOrCreate(pointer)
                _returnType = info
                info
            }
        }
    }

    public static func of(instance: Any): FunctionTypeInfo {
        match (TypeInfo.of(instance)) {
            case ti: FunctionTypeInfo => ti
            case _ => throw IllegalTypeException("The type of parameter `instance` is not a function type.")
        }
    }

    public static redef func of<T>(): FunctionTypeInfo {
        match (TypeInfo.of<T>()) {
            case ti: FunctionTypeInfo => ti
            case _ => throw IllegalTypeException("The type of generic type `T` is not a function type.")
        }
    }

    public func apply(instance: Any, args: Array<Any>): Any {
        if (args.size != parameters.size) {
            throw IllegalArgumentException(
                "The size of parameter `args` does not match the number of parameters of the function.")
        }

        applyCJStaticMethod(_info, args, CPointer<Unit>())
    }
}
