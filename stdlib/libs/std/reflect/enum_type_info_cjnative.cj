/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
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
                                "Failed to get enum constructors for type `${qualifiedName}`: constructor info at index ${index} is null.")
                        }
                        let name: CString = CString(getEnumConstructorName(ctorInfo))
                        infoList.add(EnumConstructorInfo(ctorInfo, _info, ctorName: name))
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
        try {
            match (TypeInfo.get(qualifiedName)) {
                case ti: EnumTypeInfo => return ti
                case other => throw IllegalTypeException(
                    "The type of `${qualifiedName}` is not an Enum type (actual: `${other.qualifiedName}`).")
            }
        } catch (e: InfoNotFoundException) {
            throw IllegalTypeException(
                "EnumTypeInfo.get expects an enum type name (e.g. `default.E`), but got `${qualifiedName}`. Use EnumConstructorInfo.get for constructor names.")
        }
    }

    public static redef func of(instance: Any): EnumTypeInfo {
        let ti = TypeInfo.of(instance)
        return match (ti) {
            case eti: EnumTypeInfo =>
                let sti = EnumTypeInfo(getSuperTypeInfo(eti._info))
                return sti
            case other => throw IllegalTypeException(
                "Parameter `instance` must be an Enum type instance (expected enum or enum case type), but got `${ti.qualifiedName}` (resolved: `${other.qualifiedName}`).")
        }
    }

    public static redef func of<T>(): EnumTypeInfo {
        let ti = TypeInfo.of<T>()
        match (TypeInfo.get(tryGetEnumQualifiedName(ti.qualifiedName))) {
            case eti: EnumTypeInfo => return eti
            case other => throw IllegalTypeException(
                "Generic type `T` must be an Enum type (or enum case type), but got `${ti.qualifiedName}` (resolved: `${other.qualifiedName}`).")
        }
    }

    public func construct(constructor: String, args: Array<Any>): Any {
        let ctor = getConstructorBySignature(constructor)
        try {
            ctor.apply(args)
        } catch (e: IllegalArgumentException) {
            throw InvocationTargetException(
                "Failed to construct enum `${qualifiedName}` with constructor `${ctor.signature}`: ${e.message}")
        } catch (e: IllegalTypeException) {
            throw InvocationTargetException(
                "Failed to construct enum `${qualifiedName}` with constructor `${ctor.signature}`: ${e.message}")
        }
    }

    public func destruct(instance: Any): (EnumConstructorInfo, ReadOnlyList<Any>) {
        let ti = TypeInfo.of(instance)
        if (!ti.isSubtypeOf(this)) {
            throw InvocationTargetException(
                "Failed to destruct enum `${qualifiedName}`: expected an instance of `${qualifiedName}` (or its case type), but got `${ti.qualifiedName}`.")
        }

        let ctorInfo = getEnumConstructorInfoFromAny(instance)
        if (ctorInfo.isNull()) {
            throw InvocationTargetException(
                "Failed to destruct enum `${qualifiedName}`: enum constructor info is null.")
        }
        let ctor = getCachedConstructor(ctorInfo) ?? EnumConstructorInfo(ctorInfo, _info,
            ctorName: CString(getEnumConstructorName(ctorInfo)))

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
        let sig = normalizeConstructorSignature(signature) // M1<String>
        for (ctor in constructors) {
            let ctorSignature = normalizeConstructorSignature(ctor.signature) // M1<String>
            let ctorQualifiedName = normalizeConstructorSignature(ctor.qualifiedName) // default.E.M1<String>
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
    var _constructorName: ?String = None

    init(cp: CPointer<Unit>, enumTypeInfoPointer: CPointer<Unit>, ctorName!: ?CString = None) {
        _info = unsafe { CPointer<CPointer<Unit>>(CPointer<Byte>(cp) + 8).read() }
        _enumTypeInfoPointer = enumTypeInfoPointer
        if (let Some(name) <- ctorName) {
            _constructorName = name.toString()
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
            (TypeInfo.getOrCreate(_enumTypeInfoPointer) as EnumTypeInfo) ?? throw MisMatchException(
                "Declaring type is not an Enum type.")
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
                    let types = computeParameters(stripFirst: true)
                    _parameters = types
                    types
            }
        }
    }

    public static func get(qualifiedName: String): EnumConstructorInfo {
        let lastDot = findLastTopLevelDot(qualifiedName)
        if (lastDot < 0) {
            throw InfoNotFoundException("Enum constructor `${qualifiedName}` not found.")
        }
        let enumQualifiedName = qualifiedName[..lastDot]
        let signature = qualifiedName[lastDot + 1..]
        let enumInfo = EnumTypeInfo.get(enumQualifiedName)
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
        let name: CString = CString(getEnumConstructorName(ctorInfo))
        EnumConstructorInfo(ctorInfo, enumInfo._info, ctorName: name)
    }

    public func apply(args: Array<Any>): Any {
        checkArgs(args)
        newAndInitObject(_info, args)
    }

    public func getAssociatedvalues(instance: Any): ReadOnlyList<Any> {
        let instanceType = TypeInfo.of(instance)
        if (!instanceType.isSubtypeOf(enumTypeInfo)) {
            throw IllegalTypeException(
                "The instance type `${instanceType.qualifiedName}` does not belong to enum `${enumTypeInfo.qualifiedName}`.")
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
                    let res = CString(getEnumConstructorName(_info)).toString()
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
            throw IllegalArgumentException(
                "Invalid number of arguments, expected ${parameters.size} but got ${args.size}.")
        }
        for (i in 0..args.size) {
            if (!TypeInfo.of(args[i]).isSubtypeOf(parameters[i])) {
                throw IllegalTypeException(
                    "Argument index ${i} expected ${parameters[i].qualifiedName} but got ${TypeInfo.of(args[i]).qualifiedName}.")
            }
        }
    }

    func computeParameters(stripFirst!: Bool = true): ArrayList<TypeInfo> {
        let skip = if (stripFirst) {
            1
        } else {
            0
        }
        let count: Int64 = Int64(getNumOfFieldTypes(_info)) - skip
        let arr: CPointer<Unit> = getFieldTypes(_info)
        ArrayList<TypeInfo>(count) {
            idx =>
                let rawIdx = idx + skip
                let info = unsafe { CPointer<Byte>(arr) + 8 * rawIdx } /* TypeInfo pointer occupies 8 bytes */
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

func resolveEnumQualifiedName(name: String): ?String {
    try {
        match (TypeInfo.get(name)) {
            case _: EnumTypeInfo => return name
            case _ => return None
        }
    } catch (_: ReflectException) {
        None
    }
}

func isDigits(name: String): Bool {
    if (name.isEmpty()) {
        return false
    }
    for (idx in 0..name.size) {
        let ch = name[idx]
        if (ch < b'0' || ch > b'9') {
            return false
        }
    }
    true
}

func stripNumericSuffixSegment(name: String): ?String {
    let lastDot = findLastTopLevelDot(name)
    if (lastDot < 0) {
        return None
    }
    let suffix = name[lastDot + 1..]
    if (!isDigits(suffix)) {
        return None
    }
    Some(name[..lastDot])
}

/**
 * Tries to resolve the enum qualified name from the given name, which may be:
 * - enum type name: default.E
 * - enum constructor name: default.E.M1
 * - enum constructor name with generic args: default.E.M2<Int64>, default.E.M5<default.E.M1>
 *
 * This function will iteratively strip the last segment (after the last dot) and
 * try to resolve the remaining prefix as an enum type name. If the last segment
 * is numeric, it will also try stripping it as a numeric suffix.
 *
 * @param name the input name to resolve.
 * @return the resolved enum qualified name, or the original name if not found.
 */
func tryGetEnumQualifiedName(name: String): String {
    var current = name
    while (true) {
        let lastDot = findLastTopLevelDot(current)
        if (lastDot < 0) {
            break
        }
        let prefix = current[..lastDot]
        if (let Some(res) <- resolveEnumQualifiedName(prefix)) {
            return res
        }
        match (stripNumericSuffixSegment(prefix)) {
            case Some(next) =>
                if (let Some(res) <- resolveEnumQualifiedName(next)) {
                    return res
                }
                current = next
                continue
            case None => ()
        }
        current = prefix
    }
    if (let Some(res) <- resolveEnumQualifiedName(name)) {
        return res
    }
    return name
}
