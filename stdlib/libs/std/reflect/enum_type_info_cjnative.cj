/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */
package std.reflect

import std.collection.{ReadOnlyList, ArrayList}

public class EnumTypeInfo <: TypeInfo {
    var _constructors: ?Array<EnumConstructorInfo> = Array<EnumConstructorInfo>()

    init(cp: CPointer<Unit>) {
        super(cp)
    }

    public prop constructors: Collection<EnumConstructorInfo> {
        get() {
            return if (let Some(constructors) <- _constructors) {
                constructors
            } else {
                let constructors = Array<EnumConstructorInfo>()
                _constructors = constructors
                constructors
            }
        }
    }

    public static redef func get(qualifiedName: String): EnumTypeInfo {
        match (TypeInfo.get(qualifiedName)) {
            case ti: EnumTypeInfo => ti
            case _ => throw IllegalTypeException("The type of `${qualifiedName}` is not an Enum type.")
        }
    }

    public static func of(instance: Any): EnumTypeInfo {
        match (TypeInfo.of(instance)) {
            case ti: EnumTypeInfo => ti
            case _ => throw IllegalTypeException("The type of parameter `instance` is not an Enum type.")
        }
    }

    public static redef func of<T>(): EnumTypeInfo {
        match (TypeInfo.of<T>()) {
            case ti: EnumTypeInfo => ti
            case _ => throw IllegalTypeException("The type of generic type `T` is not an Enum type.")
        }
    }

    public func construct(constructor: String, args: Array<Any>): Any {
        EnumTypeInfo(CPointer<Unit>())
    }

    public func destruct(instance: Any): (EnumConstructorInfo, ReadOnlyList<Any>) {
        (EnumConstructorInfo(), ArrayList<Any>())
    }

    public func getConstructor(constructor: String, argsCount!: Int64 = 0): EnumConstructorInfo {
        EnumConstructorInfo()
    }
}

public class EnumConstructorInfo <: Equatable<EnumConstructorInfo> & Hashable & ToString {
    init() {}
    public prop annotations: Collection<Annotation> {
        get() {
            []
        }
    }

    public prop enumTypeInfo: EnumTypeInfo {
        get() {
            EnumTypeInfo(CPointer<Unit>())
        }
    }

    public prop name: String {
        get() {
            ""
        }
    }

    public prop qualifiedName: String {
        get() {
            ""
        }
    }

    public prop parameters: ReadOnlyList<TypeInfo> {
        get() {
            ArrayList<TypeInfo>()
        }
    }

    public static func get(qualifiedName: String): EnumConstructorInfo {
        EnumConstructorInfo()
    }

    public static func of(instance: Any): EnumConstructorInfo {
        EnumConstructorInfo()
    }

    public func call(args: Array<Any>): Any {
        EnumConstructorInfo()
    }

    public func getAssociatedvalues(instance: Any): ReadOnlyList<Any> {
        ArrayList<Any>()
    }

    public func findAllAnnotations<T>(): Array<T> where T <: Annotation {
        []
    }

    public func findAllAnnotation<T>(): ?T where T <: Annotation {
        None<T>
    }

    public func getAllAnnotations(): Array<Annotation> {
        []
    }

    public func hashCode(): Int64 {
        0
    }

    public operator func ==(other: EnumConstructorInfo): Bool {
        false
    }

    public func toString() {
        ""
    }
}
