/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */
package std.reflect

import std.collection.*

public class EnumTypeInfo <: TypeInfo {
    var _constructors: Option<Collection<EnumConstructorInfo>> = None

    init(cp: CPointer<Unit>) {
        super(cp)
    }

    public prop constructors: Collection<EnumConstructorInfo> {
        get() {
            match (_constructors) {
                case Some(res) => res
                case None =>
                    // Enum constructors are exposed as static functions which return the enum (or its case type).
                    let infoList = ArrayList<EnumConstructorInfo>()
                    for (fn in staticFunctions) {
                        if (fn.returnType.isSubtypeOf(this)) {
                            infoList.add(EnumConstructorInfo(fn._info, _info))
                        }
                    }
                    let infos = infoList.toArray()
                    _constructors = infos
                    infos
            }
        }
    }

    public static redef func get(qualifiedName: String): EnumTypeInfo {
        // Support both enum type names and enum constructor type names like:
        // - default.E
        // - default.E.M1
        // - default.E.M2<Int64>
        // - default.E.M5<default.E.M1>
        let enumQualifiedName = tryGetEnumQualifiedName(qualifiedName)
        match (TypeInfo.get(enumQualifiedName)) {
            case ti: EnumTypeInfo => return ti
            case _ => throw IllegalTypeException("The type of `${qualifiedName}` is not an Enum type.")
        }
    }

    public static func of(instance: Any): EnumTypeInfo {
        let ti = TypeInfo.of(instance)
        match (TypeInfo.get(tryGetEnumQualifiedName(ti.qualifiedName))) {
            case eti: EnumTypeInfo => return eti
            case _ => throw IllegalTypeException("The type of parameter `instance` is not an Enum type.")
        }
    }

    public static redef func of<T>(): EnumTypeInfo {
        let ti = TypeInfo.of<T>()
        match (TypeInfo.get(tryGetEnumQualifiedName(ti.qualifiedName))) {
            case eti: EnumTypeInfo => return eti
            case _ => throw IllegalTypeException("The type of generic type `T` is not an Enum type.")
        }
    }

    public func construct(constructor: String, args: Array<Any>): Any {
        let ctor = getConstructorBySignature(constructor)
        try {
            ctor.checkArgs(args)
            ctor.call(args)
        } catch (e: IllegalArgumentException) {
            throw InvocationTargetException("Invalid number of arguments")
        } catch (e: IllegalTypeException) {
            throw InvocationTargetException("Argument type mismatch")
        }
    }

    public func destruct(instance: Any): (EnumConstructorInfo, ReadOnlyList<Any>) {
        let ti = TypeInfo.of(instance)
        if (!ti.isSubtypeOf(this)) {
            throw InvocationTargetException("Argument type mismatch")
        }

        let instanceQualifiedName = ti.qualifiedName
        let expectedPrefix = qualifiedName + "."
        let signature = if (instanceQualifiedName.startsWith(expectedPrefix)) {
            instanceQualifiedName[expectedPrefix.size..]
        } else {
            // Fallback: try to use the simple suffix after last top-level dot.
            let lastDot = findLastTopLevelDot(instanceQualifiedName)
            if (lastDot < 0) {
                throw InvocationTargetException("Argument type mismatch")
            }
            instanceQualifiedName[lastDot + 1..]
        }
        let ctor = getConstructorBySignature(signature)

        let arrOpt = getAssociatedValues(instance, TypeInfo.of<Array<Any>>()._info) as Array<Any>
        let arr = arrOpt.getOrThrow()
        (ctor, ArrayList<Any>(arr))
    }

    public func getConstructor(constructor: String, argsCount!: Int64 = 0): EnumConstructorInfo {
        let name = constructor.trimAscii()
        for (ctor in constructors) {
            if (ctor.constructorName != name) {
                continue
            }
            if (argsCount == 0 || ctor.parameters.size == argsCount) {
                return ctor
            }
        }
        throw InfoNotFoundException("Enum constructor `${constructor}` not found.")
    }

    func getConstructorBySignature(signature: String): EnumConstructorInfo {
        let sig = signature.trimAscii()
        for (ctor in constructors) {
            if (ctor.signature == sig || ctor.qualifiedName.endsWith("." + sig) || ctor.name.endsWith("." + sig)) {
                return ctor
            }
        }
        throw InfoNotFoundException("Enum constructor `${signature}` not found.")
    }
}

public class EnumConstructorInfo <: Equatable<EnumConstructorInfo> & Hashable & ToString {
    let _info: CPointer<Unit>
    let _enumTypeInfoPointer: CPointer<Unit>
    var _name: Option<String> = None
    var _qualifiedName: Option<String> = None
    var _parameters: Option<ReadOnlyList<TypeInfo>> = None
    var _annotations: Option<Collection<Annotation>> = None
    var _constructorName: Option<String> = None

    init(cp: CPointer<Unit>, enumTypeInfoPointer: CPointer<Unit>) {
        _info = cp
        _enumTypeInfoPointer = enumTypeInfoPointer
    }

    public prop annotations: Collection<Annotation> {
        get() {
            match (_annotations) {
                case Some(res) => res
                case None =>
                    let infos = match (getMethodAnnotations(_info, TypeInfo.of<Array<Object>>()._info)) {
                        case arr: Array<Annotation> => arr
                        case _ => Array<Annotation>()
                    }
                    _annotations = infos
                    infos
            }
        }
    }

    public prop enumTypeInfo: EnumTypeInfo {
        get() {
            (TypeInfo.getOrCreate(_enumTypeInfoPointer) as EnumTypeInfo) ??
                throw MisMatchException("Declaring type is not an Enum type.")
        }
    }

    public prop name: String {
        get() {
            match (_name) {
                case Some(res) => res
                case None =>
                    let sb = StringBuilder()
                    sb.append(enumTypeInfo.name)
                    sb.append(".")
                    sb.append(signature)
                    let n = sb.toString()
                    _name = n
                    n
            }
        }
    }

    public prop qualifiedName: String {
        get() {
            match (_qualifiedName) {
                case Some(res) => res
                case None =>
                    let sb = StringBuilder()
                    sb.append(enumTypeInfo.qualifiedName)
                    sb.append(".")
                    sb.append(signature)
                    let n = sb.toString()
                    _qualifiedName = n
                    n
            }
        }
    }

    public prop parameters: ReadOnlyList<TypeInfo> {
        get() {
            match (_parameters) {
                case Some(res) => res
                case None =>
                    let params = getParameters(_info)
                    let types = ArrayList<TypeInfo>(params.size) { idx => params[idx].typeInfo }
                    _parameters = types
                    types
            }
        }
    }

    public static func get(qualifiedName: String): EnumConstructorInfo {
        let enumInfo = EnumTypeInfo.get(qualifiedName)
        let lastDot = findLastTopLevelDot(qualifiedName)
        if (lastDot < 0) {
            throw InfoNotFoundException("Enum constructor `${qualifiedName}` not found.")
        }
        let signature = qualifiedName[lastDot + 1..]
        enumInfo.getConstructorBySignature(signature)
    }

    public static func of(instance: Any): EnumConstructorInfo {
        let enumInfo = EnumTypeInfo.of(instance)
        let (ctor, _) = enumInfo.destruct(instance)
        ctor
    }

    public func call(args: Array<Any>): Any {
        applyCJStaticMethod(_info, args, _enumTypeInfoPointer)
    }

    public func getAssociatedvalues(instance: Any): ReadOnlyList<Any> {
        let (ctor, values) = enumTypeInfo.destruct(instance)
        if (ctor != this) {
            throw IllegalTypeException("Argument type mismatch")
        }
        values
    }

    public func findAllAnnotations<T>(): Array<T> where T <: Annotation {
        findAllAnnotations<T>(annotations)
    }

    public func findAllAnnotation<T>(): ?T where T <: Annotation {
        findAnnotation<T>(annotations)
    }

    public func getAllAnnotations(): Array<Annotation> {
        annotations.toArray()
    }

    public func hashCode(): Int64 {
        _info.toUIntNative().hashCode()
    }

    public operator func ==(other: EnumConstructorInfo): Bool {
        _info == other._info
    }

    public func toString(): String {
        qualifiedName
    }

    prop constructorName: String {
        get() {
            match (_constructorName) {
                case Some(res) => res
                case None =>
                    let res = parseConstructorName(getFuncName(_info))
                    _constructorName = res
                    res
            }
        }
    }

    prop signature: String {
        get() {
            if (parameters.size == 0) {
                return constructorName
            }
            let sb = StringBuilder()
            sb.append(constructorName)
            sb.append("<")
            for (idx in 0..parameters.size) {
                sb.append(parameters[idx].qualifiedName)
                if (idx < parameters.size - 1) {
                    sb.append(", ")
                }
            }
            sb.append(">")
            sb.toString()
        }
    }

    func checkArgs(args: Array<Any>): Unit {
        if (args.size != parameters.size) {
            throw IllegalArgumentException("Invalid number of arguments")
        }
        for (i in 0..args.size) {
            if (!TypeInfo.of(args[i]).isSubtypeOf(parameters[i])) {
                throw IllegalTypeException("Argument type mismatch")
            }
        }
    }
}

func parseConstructorName(raw: String): String {
    var name = raw
    if (let Some(idx) <- name.indexOf("<")) {
        name = name[..idx]
    }
    let dot = name.lastIndexOf(".") ?? -1
    name[dot + 1..]
}

func findLastTopLevelDot(name: String): Int64 {
    var angle = 0
    var idx: Int64 = name.size - 1
    while (idx >= 0) {
        match (name[idx]) {
            case '>' => angle++
            case '<' => angle--
            case '.' =>
                if (angle == 0) {
                    return idx
                }
            case _ => ()
        }
        idx -= 1
    }
    -1
}

func tryGetEnumQualifiedName(name: String): String {
    let lastDot = findLastTopLevelDot(name)
    if (lastDot < 0) {
        return name
    }
    // Prefer stripping the last segment first; if it doesn't resolve to an enum, fall back to original.
    let prefix = name[..lastDot]
    try {
        match (TypeInfo.get(prefix)) {
            case _: EnumTypeInfo => return prefix
            case _ => ()
        }
    } catch (_: ReflectException) {
    }
    name
}
