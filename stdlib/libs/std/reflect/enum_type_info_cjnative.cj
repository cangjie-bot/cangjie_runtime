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
    var _constructorsByTypeInfo: Option<HashMap<UIntNative, EnumConstructorInfo>> = None

    init(cp: CPointer<Unit>) {
        super(cp)
    }

    public prop constructors: Collection<EnumConstructorInfo> {
        get() {
            match (_constructors) {
                case Some(res) => res
                case None =>
                    let infoList = ArrayList<EnumConstructorInfo>()
                    let num = getNumOfEnumConstructorInfos(_info)
                    for (index in 0..Int64(num)) {
                        let ctorInfo = getEnumConstructorInfo(_info, UInt32(index))
                        if (ctorInfo.isNull()) {
                            throw InfoNotFoundException(
                                "Failed to get enum constructors for type `${qualifiedName}`: constructor info at index ${index} is null."
                            )
                        }
                        let namePtr = getEnumConstructorName(ctorInfo)
                        infoList.add(EnumConstructorInfo(ctorInfo, _info, ctorNamePtr: namePtr))
                    }
                    let infos = infoList.toArray()
                    let infoMap = HashMap<UIntNative, EnumConstructorInfo>(infos.size) {
                        idx =>
                            let ctor = infos[idx]
                            (ctor._info.toUIntNative(), ctor)
                    }
                    _constructors = infos
                    _constructorsByTypeInfo = infoMap
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
            case other =>
                throw IllegalTypeException(
                    "`${qualifiedName}` resolves to `${enumQualifiedName}`, which is not an Enum type (actual: `${other.qualifiedName}`)."
                )
        }
    }

    public static redef func of(instance: Any): EnumTypeInfo {
        let ti = TypeInfo.of(instance)
        match (TypeInfo.get(tryGetEnumQualifiedName(ti.qualifiedName))) {
            case eti: EnumTypeInfo => return eti
            case other =>
                throw IllegalTypeException(
                    "Parameter `instance` must be an Enum type instance (expected enum or enum case type), but got `${ti.qualifiedName}` (resolved: `${other.qualifiedName}`)."
                )
        }
    }

    public static redef func of<T>(): EnumTypeInfo {
        let ti = TypeInfo.of<T>()
        match (TypeInfo.get(tryGetEnumQualifiedName(ti.qualifiedName))) {
            case eti: EnumTypeInfo => return eti
            case other =>
                throw IllegalTypeException(
                    "Generic type `T` must be an Enum type (or enum case type), but got `${ti.qualifiedName}` (resolved: `${other.qualifiedName}`)."
                )
        }
    }

    public func construct(constructor: String, args: Array<Any>): Any {
        let ctor = getConstructorBySignature(constructor)
        try {
            ctor.apply(args)
        } catch (e: IllegalArgumentException) {
            throw InvocationTargetException(
                "Failed to construct enum `${qualifiedName}` with constructor `${ctor.signature}`: ${e.message}"
            )
        } catch (e: IllegalTypeException) {
            throw InvocationTargetException(
                "Failed to construct enum `${qualifiedName}` with constructor `${ctor.signature}`: ${e.message}"
            )
        }
    }

    public func destruct(instance: Any): (EnumConstructorInfo, ReadOnlyList<Any>) {
        let ti = TypeInfo.of(instance)
        if (!ti.isSubtypeOf(this)) {
            throw InvocationTargetException(
                "Failed to destruct enum `${qualifiedName}`: expected an instance of `${qualifiedName}` (or its case type), but got `${ti.qualifiedName}`."
            )
        }

        let ctorInfo = getEnumConstructorInfoFromAny(instance)
        if (ctorInfo.isNull()) {
            throw InvocationTargetException(
                "Failed to destruct enum `${qualifiedName}`: enum constructor info is null."
            )
        }
        let ctor = getCachedConstructor(ctorInfo) ??
            EnumConstructorInfo(ctorInfo, _info, ctorNamePtr: getEnumConstructorName(ctorInfo))

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
        let sig = normalizeConstructorSignature(signature)
        for (ctor in constructors) {
            let ctorSignature = normalizeConstructorSignature(ctor.signature)
            let ctorQualifiedName = normalizeConstructorSignature(ctor.qualifiedName)
            if (ctorSignature == sig || ctorQualifiedName.endsWith("." + sig)) {
                return ctor
            }
        }
        throw InfoNotFoundException("Enum constructor `${signature}` not found.")
    }

    func getCachedConstructor(ctorTypeInfo: CPointer<Unit>): ?EnumConstructorInfo {
        match (_constructorsByTypeInfo) {
            case Some(map) => map.get(ctorTypeInfo.toUIntNative())
            case None => None
        }
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
    var _constructorNamePtr: CPointer<UInt8> = CPointer<UInt8>()

    init(cp: CPointer<Unit>, enumTypeInfoPointer: CPointer<Unit>) {
        _info = cp
        _enumTypeInfoPointer = enumTypeInfoPointer
    }

    init(cp: CPointer<Unit>, enumTypeInfoPointer: CPointer<Unit>, ctorNamePtr!: CPointer<UInt8>) {
        _info = cp
        _enumTypeInfoPointer = enumTypeInfoPointer
        if (!ctorNamePtr.isNull()) {
            _constructorNamePtr = ctorNamePtr
        }
    }

    public prop annotations: Collection<Annotation> {
        get() {
            match (_annotations) {
                case Some(res) => res
                case None =>
                    let infos = match (getTypeInfoAnnotations(_info, TypeInfo.of<Array<Object>>()._info)) {
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
                    let res = constructorName
                    _name = res
                    res
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
                    let types = computeParameters()
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
        let ctorInfo = getEnumConstructorInfoFromAny(instance)
        if (ctorInfo.isNull()) {
            throw InfoNotFoundException("Enum constructor info not found for instance.")
        }
        if (let Some(cached) <- enumInfo.getCachedConstructor(ctorInfo)) {
            return cached
        }
        let namePtr = getEnumConstructorName(ctorInfo)
        EnumConstructorInfo(ctorInfo, enumInfo._info, ctorNamePtr: namePtr)
    }

    public func apply(args: Array<Any>): Any {
        checkArgs(args)
        newAndInitObject(_info, args)
    }

    public func getAssociatedvalues(instance: Any): ReadOnlyList<Any> {
        let instanceType = TypeInfo.of(instance)
        if (!instanceType.isSubtypeOf(enumTypeInfo)) {
            throw IllegalTypeException(
                "The instance type `${instanceType.qualifiedName}` does not belong to enum `${enumTypeInfo.qualifiedName}`."
            )
        }
        let (ctor, values) = enumTypeInfo.destruct(instance)
        if (ctor != this) {
            throw IllegalTypeException("The constructor `${name}` does not match the instance.")
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
                    if (!_constructorNamePtr.isNull()) {
                        let res = parseConstructorName(CString(_constructorNamePtr).toString())
                        _constructorName = res
                        return res
                    }
                    let typeName = TypeInfo.getOrCreate(_info).qualifiedName
                    let res = parseConstructorName(typeName)
                    _constructorName = res
                    res
            }
        }
    }

    prop signature: String {
        get() {
            buildSignature(constructorName, parameters)
        }
    }

    func checkArgs(args: Array<Any>): Unit {
        if (args.size != parameters.size) {
            throw IllegalArgumentException("Invalid number of arguments, expected ${parameters.size} but got ${args.size}.")
        }
        for (i in 0..args.size) {
            if (!TypeInfo.of(args[i]).isSubtypeOf(parameters[i])) {
                throw IllegalTypeException("Argument index ${i} expected ${parameters[i].qualifiedName} but got ${TypeInfo.of(args[i]).qualifiedName}.")
            }
        }
    }

    func computeParameters(): ArrayList<TypeInfo> {
        let count: Int64 = Int64(getNumOfFieldTypes(_info))
        let arr: CPointer<Unit> = getFieldTypes(_info)
        ArrayList<TypeInfo>(count) {
            idx =>
                let info = unsafe { CPointer<Byte>(arr) + 8 * idx } /* TypeInfo pointer occupies 8 bytes */
                let ti = unsafe { CPointer<CPointer<Unit>>(info).read() }
                TypeInfo.getOrCreate(ti)
        }
    }

    func buildSignature(name: String, params: ReadOnlyList<TypeInfo>): String {
        if (params.size == 0) {
            return name
        }
        let sb = StringBuilder()
        sb.append(name)
        sb.append("<")
        for (idx in 0..params.size) {
            sb.append(params[idx].qualifiedName)
            if (idx < params.size - 1) {
                sb.append(", ")
            }
        }
        sb.append(">")
        sb.toString()
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

func normalizeConstructorSignature(raw: String): String {
    raw.trimAscii().replace(" ", "")
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
