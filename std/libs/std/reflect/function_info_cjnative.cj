







package std.reflect

import std.collection.*

public class GenericTypeInfo <: TypeInfo & Equatable<GenericTypeInfo> {
    /*
     * @throws ReflectException
     * @throws OutOfMemoryError
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    public operator func ==(that: GenericTypeInfo): Bool {
        return this.name == that.name
    }
    /*
     * @noThrow
     */
    init(cp: CPointer<Unit>) {
        super(cp)
    }
}


public class InstanceFunctionInfo <: Equatable<InstanceFunctionInfo> & Hashable & ToString {
    let _info: CPointer<Unit>
    var _name: Option<String> = None
    var _parameters: Option<ArrayList<ParameterInfo>> = None
    var _returnType: Option<TypeInfo> = None
    var _modifiers: Option<Collection<ModifierInfo>> = None
    var _annotations: Option<Collection<Annotation>> = None
    var _genericParams: Option<Collection<GenericTypeInfo>> = None
    var _declaringTypeInfo: CPointer<Unit>
    /*
     * @noThrow
     */
    init(cp: CPointer<Unit>, info: CPointer<Unit>) {
        _info = cp
        _declaringTypeInfo = info
    }

    public prop genericParams: Collection<GenericTypeInfo> {
        /*
         * @throws IllegalArgumentException
         * @throws InfoNotFoundException
         */
        get() {
            match (_genericParams) {
                case Some(params) => params
                case None =>
                    let genericParametersNum = getNumOfGenericParameters(_info)
                    if (genericParametersNum == 0) {
                        _genericParams = Option<Collection<GenericTypeInfo>>.None
                        return ArrayList<GenericTypeInfo>()
                    }

                    let params = ArrayList<GenericTypeInfo>(
                        Int64(genericParametersNum),
                        {
                            index =>
                            let pointer = getGenericParameterInfo(_info, UInt32(index))
                            if (pointer.isNull()) {
                                throw InfoNotFoundException("Get parameters failed!")
                            }

                            GenericTypeInfo(pointer)
                        }
                    )

                    _genericParams = Some(params)
                    params
            }
        }
    }


    public prop name: String {
        /*
         * @throws NoneValueException
         */
        get() {
            _name.getOrThrow()
        }
    }


    public prop parameters: ReadOnlyList<ParameterInfo> {
        /*
         * @throws IllegalArgumentException
         * @throws InfoNotFoundException
         */
        get() {
            match (_parameters) {
                case Some(res) => res
                case None =>
                    let infos = getParameters(_info)
                    _parameters = infos
                    infos
            }
        }
    }


    public prop returnType: TypeInfo {
        /*
         * @throws OutOfMemoryError
         * @throws IllegalSynchronizationStateException
         * @throws NoneValueException
         * @throws IllegalArgumentException
         * @throws IndexOutOfBoundsException
         * @throws ReflectException
         * @throws InfoNotFoundException
         */
        get() {
            match (_returnType) {
                case Some(res) => res
                case None =>
                    let pointer = getMethodReturnType(_info)
                    let info = TypeInfo.getOrCreate(pointer)
                    _returnType = info
                    info
            }
        }
    }


    public prop modifiers: Collection<ModifierInfo> {
        /*
         * @throws IndexOutOfBoundsException
         * @throws IllegalArgumentException
         */
        get() {
            match (_modifiers) {
                case Some(res) => res
                case None =>
                    let infos = ModifierInfo.byMask(getMethodModifier(_info))
                    _modifiers = infos
                    infos
            }
        }
    }


    public prop annotations: Collection<Annotation> {
        /*
         * @throws OutOfMemoryError
         * @throws IllegalSynchronizationStateException
         * @throws NoneValueException
         * @throws IllegalArgumentException
         * @throws IndexOutOfBoundsException
         * @throws ReflectException
         * @throws InfoNotFoundException
         */
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


    /*
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    public func isOpen(): Bool {
        containsModifier(modifiers, ModifierInfo.Open)
    }


    /*
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    public func isAbstract(): Bool {
        containsModifier(modifiers, ModifierInfo.Abstract)
    }








    /*
     * @throws IllegalSynchronizationStateException
     * @throws NoneValueException
     * @throws InfoNotFoundException
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     * @throws OutOfMemoryError
     * @throws IllegalTypeException
     * @throws ReflectException
     * @throws InvocationTargetException
     */
    public func apply(instance: Any, args: Array<Any>): Any {
        let nullEntryPointer = methodEntryPointIsNull(_info)
        if (isAbstract() && nullEntryPointer) {
            throw InvocationTargetException("The abstract function cannot be applied.")
        }

        try {
            if (genericParams.size > 0) {
                throw InvocationTargetException("The generic function cannot be applied without `genericTypeArgs`.")
            }
        } catch (_: InfoNotFoundException) {
            throw InvocationTargetException("The generic function cannot be applied without `genericTypeArgs`.")
        }

        checkArgsSizeAndType(parameters, args)
        checkMethodDeclaringClassType(instance, _declaringTypeInfo)

        applyCJInstanceMethod(_info, instance, args)
    }

    /*
     * @throws IllegalSynchronizationStateException
     * @throws NoneValueException
     * @throws InfoNotFoundException
     * @throws IndexOutOfBoundsException
     * @throws OutOfMemoryError
     * @throws IllegalArgumentException
     * @throws IllegalTypeException
     * @throws ReflectException
     * @throws InvocationTargetException
     */
    public func apply(instance: Any, genericTypeArgs: Array<TypeInfo>, args: Array<Any>): Any {
        if (genericParams.size == 0) {
            throw InvocationTargetException("The function cannot be applied with `genericTypeArgs`.")
        }

        let nullEntryPointer = methodEntryPointIsNull(_info)
        if (isAbstract() && nullEntryPointer) {
            throw InvocationTargetException("The abstract function cannot be applied.")
        }

        checkParamaterSize(genericParams, parameters.size, genericTypeArgs, args)
        checkMethodDeclaringClassType(instance, _declaringTypeInfo)

        let gArgs = ArrayList<CPointer<Unit>>(Int64(genericTypeArgs.size)) {index => genericTypeArgs[index]._info}
        if (!checkMethodActualArgs(_info, gArgs.toArray(), args)) {
            throw IllegalTypeException(
                "The input parameter does not match the type of the input parameter required by the function.")
        }

        applyCJGenericInstanceMethod(_info, instance, gArgs.toArray(), args)
    }


    /*
     * @throws OutOfMemoryError
     * @throws IllegalSynchronizationStateException
     * @throws NoneValueException
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     * @throws ReflectException
     * @throws InfoNotFoundException
     */
    public func findAnnotation<T>(): ?T where T <: Annotation {
        findAnnotation<T>(annotations)
   }

    /*
     * @throws OutOfMemoryError
     * @throws IllegalSynchronizationStateException
     * @throws ReflectException
     * @throws InfoNotFoundException
     * @throws NoneValueException
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    public func findAllAnnotations<T>(): Array<T> where T <: Annotation {
        findAllAnnotations<T>(annotations)
    }

    /*
     * @throws OutOfMemoryError
     * @throws IllegalSynchronizationStateException
     * @throws NoneValueException
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     * @throws ReflectException
     * @throws InfoNotFoundException
     */
    public func getAllAnnotations(): Array<Annotation> {
        annotations.toArray()
    }

    /*
     * @noThrow
     */
    public operator func ==(that: InstanceFunctionInfo): Bool {
        this._info == that._info
    }

    /*
     * @noThrow
     */
    public operator func !=(that: InstanceFunctionInfo): Bool {
        !(this == that)
    }

    /*
     * @noThrow
     */
    public func hashCode(): Int64 {
        this._info.toUIntNative().hashCode()
    }

    /*
     * @throws OutOfMemoryError
     * @throws IllegalSynchronizationStateException
     * @throws ReflectException
     * @throws NoneValueException
     * @throws InfoNotFoundException
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    public func toString(): String {
        let sb = StringBuilder()
        for (m in modifiers) {
            sb.append(m)
            sb.append(" ")
        }
        sb.append("func ")
        sb.append(name)
        sb.append("(")
        for (index in 0..parameters.size) {
            sb.append(parameters[index])
            if (index < parameters.size - 1) {
                sb.append(", ")
            }
        }
        sb.append("): ")
        sb.append(returnType)
        sb.toString()
    }
}


public class StaticFunctionInfo <: Equatable<StaticFunctionInfo> & Hashable & ToString {
    let _info: CPointer<Unit>
    var _name: Option<String> = None
    var _parameters: Option<ArrayList<ParameterInfo>> = None
    var _genericParams: Option<Collection<GenericTypeInfo>> = None
    var _returnType: Option<TypeInfo> = None
    var _modifiers: Option<Collection<ModifierInfo>> = None
    var _annotations: Option<Collection<Annotation>> = None
    var _declaringTypeInfo: CPointer<Unit>
    /*
     * @noThrow
     */
    init(cp: CPointer<Unit>, declaringTypeInfo: CPointer<Unit>) {
        _info = cp
        _declaringTypeInfo = declaringTypeInfo
    }

    public prop genericParams: Collection<GenericTypeInfo> {
        /*
         * @throws IllegalArgumentException
         * @throws InfoNotFoundException
         */
        get() {
            match (_genericParams) {
                case Some(params) => params
                case None =>
                    let genericParametersNum = getNumOfGenericParameters(_info)
                    if (genericParametersNum == 0) {
                        _genericParams = Option<Collection<GenericTypeInfo>>.None
                        return ArrayList<GenericTypeInfo>()
                    }

                    let params = ArrayList<GenericTypeInfo>(
                        Int64(genericParametersNum),
                        {
                            index =>
                            let pointer = getGenericParameterInfo(_info, UInt32(index))
                            if (pointer.isNull()) {
                                throw InfoNotFoundException("Get parameters failed!")
                            }

                            GenericTypeInfo(pointer)
                        }
                    )

                    _genericParams = Some(params)
                    params
            }
        }
    }


    public prop name: String {
        /*
         * @throws NoneValueException
         */
        get() {
            _name.getOrThrow()
        }
    }


    public prop parameters: ReadOnlyList<ParameterInfo> {
        /*
         * @throws IllegalArgumentException
         * @throws InfoNotFoundException
         */
        get() {
            match (_parameters) {
                case Some(res) => res
                case None =>
                    let infos = getParameters(_info)
                    _parameters = infos
                    infos
            }
        }
    }


    public prop returnType: TypeInfo {
        /*
         * @throws OutOfMemoryError
         * @throws IllegalSynchronizationStateException
         * @throws NoneValueException
         * @throws IllegalArgumentException
         * @throws IndexOutOfBoundsException
         * @throws ReflectException
         * @throws InfoNotFoundException
         */
        get() {
            match (_returnType) {
                case Some(res) => res
                case None =>
                    let pointer = getMethodReturnType(_info)
                    let info = TypeInfo.getOrCreate(pointer)
                    _returnType = info
                    info
            }
        }
    }


    public prop modifiers: Collection<ModifierInfo> {
        /*
         * @throws IndexOutOfBoundsException
         * @throws IllegalArgumentException
         */
        get() {
            match (_modifiers) {
                case Some(res) => res
                case None =>
                    let infos = ModifierInfo.byMask(getMethodModifier(_info))
                    _modifiers = infos
                    infos
            }
        }
    }


    public prop annotations: Collection<Annotation> {
        /*
         * @throws OutOfMemoryError
         * @throws IllegalSynchronizationStateException
         * @throws NoneValueException
         * @throws IllegalArgumentException
         * @throws IndexOutOfBoundsException
         * @throws ReflectException
         * @throws InfoNotFoundException
         */
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







    /*
     * @throws IllegalSynchronizationStateException
     * @throws NoneValueException
     * @throws IllegalTypeException
     * @throws IndexOutOfBoundsException
     * @throws OutOfMemoryError
     * @throws IllegalArgumentException
     * @throws InfoNotFoundException
     * @throws ReflectException
     * @throws InvocationTargetException
     */
    public func apply(thisType: TypeInfo, args: Array<Any>): Any {
        try {
            if (genericParams.size > 0) {
                throw InvocationTargetException("The generic function cannot be applied without `genericTypeArgs`.")
            }
        } catch (_: InfoNotFoundException) {
            throw InvocationTargetException("The generic function cannot be applied without `genericTypeArgs`.")
        }

        if (methodEntryPointIsNull(_info)) {
            throw InfoNotFoundException("Failed to find the method entry.")
        }

        let name = TypeInfo.getOrCreate(_declaringTypeInfo).qualifiedName
        if (thisType.qualifiedName != name) {
            throw IllegalArgumentException("Wrong typeInfo, excepted ${thisType.qualifiedName} but ${name} got.")
        }

        checkArgsSizeAndType(parameters, args)
        applyCJStaticMethod(_info, args, thisType._info)
    }

    /*
     * @throws OutOfMemoryError
     * @throws IllegalSynchronizationStateException
     * @throws NoneValueException
     * @throws IndexOutOfBoundsException
     * @throws IllegalTypeException
     * @throws IllegalArgumentException
     * @throws InfoNotFoundException
     * @throws ReflectException
     * @throws InvocationTargetException
     */
    public func apply(thisType: TypeInfo, genericTypeArgs: Array<TypeInfo>, args: Array<Any>): Any {
        if (genericParams.size == 0) {
            throw InvocationTargetException("The function cannot be applied with `genericTypeArgs`.")
        }

        if (methodEntryPointIsNull(_info)) {
            throw InfoNotFoundException("Failed to find the method entry.")
        }

        let name = TypeInfo.getOrCreate(_declaringTypeInfo).qualifiedName
        if (thisType.qualifiedName != name) {
            throw IllegalArgumentException("Wrong typeInfo, excepted ${thisType.qualifiedName} but ${name} got.")
        }

        checkParamaterSize(genericParams, parameters.size, genericTypeArgs, args)

        let gArgs = ArrayList<CPointer<Unit>>(Int64(genericTypeArgs.size)) {index => genericTypeArgs[index]._info}
        if (!checkMethodActualArgs(_info, gArgs.toArray(), args)) {
            throw IllegalTypeException(
                "The input parameter does not match the type of the input parameter required by the function.")
        }

        applyCJGenericStaticMethod(_info, gArgs.toArray(), args, thisType._info)
    }


    /*
     * @throws OutOfMemoryError
     * @throws IllegalSynchronizationStateException
     * @throws NoneValueException
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     * @throws ReflectException
     * @throws InfoNotFoundException
     */
    public func findAnnotation<T>(): ?T where T <: Annotation {
        findAnnotation<T>(annotations)
   }

    /*
     * @throws OutOfMemoryError
     * @throws IllegalSynchronizationStateException
     * @throws ReflectException
     * @throws InfoNotFoundException
     * @throws NoneValueException
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    public func findAllAnnotations<T>(): Array<T> where T <: Annotation {
        findAllAnnotations<T>(annotations)
    }

    /*
     * @throws OutOfMemoryError
     * @throws IllegalSynchronizationStateException
     * @throws NoneValueException
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     * @throws ReflectException
     * @throws InfoNotFoundException
     */
    public func getAllAnnotations(): Array<Annotation> {
        annotations.toArray()
    }

    /*
     * @noThrow
     */
    public operator func ==(that: StaticFunctionInfo): Bool {
        this._info == that._info
    }

    /*
     * @noThrow
     */
    public operator func !=(that: StaticFunctionInfo): Bool {
        !(this == that)
    }

    /*
     * @noThrow
     */
    public func hashCode(): Int64 {
        this._info.toUIntNative().hashCode()
    }

    /*
     * @throws OutOfMemoryError
     * @throws IllegalSynchronizationStateException
     * @throws NoneValueException
     * @throws ReflectException
     * @throws InfoNotFoundException
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    public func toString(): String {
        let sb = StringBuilder()
        for (m in modifiers) {
            sb.append(m)
            sb.append(" ")
        }
        sb.append("func ")
        sb.append(name)
        sb.append("(")
        for (index in 0..parameters.size) {
            sb.append(parameters[index])
            if (index < parameters.size - 1) {
                sb.append(", ")
            }
        }
        sb.append("): ")
        sb.append(returnType)
        sb.toString()
    }
}


public class InstancePropertyInfo <: Equatable<InstancePropertyInfo> & Hashable & ToString {
    let _name: String
    var _getterInfo: Option<InstanceFunctionInfo> = None
    var _setterInfo: Option<InstanceFunctionInfo> = None
    var _typeInfo: Option<TypeInfo> = None
    var _modifiers: Option<Collection<ModifierInfo>> = None
    var _annotations: Option<Collection<Annotation>> = None
    var _declaringTypeInfo: CPointer<Unit>

    /*
     * @noThrow
     */
    init(name: String, declaringTypeInfo: CPointer<Unit>) {
        _name = name
        _declaringTypeInfo = declaringTypeInfo
    }


    public prop name: String {
        /*
         * @noThrow
         */
        get() {
            _name
        }
    }


    public prop typeInfo: TypeInfo {
        /*
         * @throws OutOfMemoryError
         * @throws IllegalSynchronizationStateException
         * @throws IllegalArgumentException
         * @throws IndexOutOfBoundsException
         * @throws ReflectException
         * @throws InfoNotFoundException
         * @throws NoneValueException
         */
        get() {
            match (_typeInfo) {
                case Some(res) => res
                case None =>
                    _typeInfo = _getterInfo?.returnType
                    _typeInfo.getOrThrow()
            }
        }
    }


    public prop modifiers: Collection<ModifierInfo> {
        /*
         * @throws NoneValueException
         * @throws IndexOutOfBoundsException
         * @throws IllegalArgumentException
         */
        get() {
            match (_modifiers) {
                case Some(res) => res
                case None =>
                    let infos = if (isMutable()) {
                        let array = ArrayList<ModifierInfo>((_getterInfo?.modifiers).getOrThrow())
                        array.add(ModifierInfo.Mut)
                        array.toArray()
                    } else {
                        (_getterInfo?.modifiers).getOrThrow()
                    }
                    _modifiers = infos
                    infos
            }
        }
    }


    public prop annotations: Collection<Annotation> {
        /*
         * @throws OutOfMemoryError
         * @throws IllegalSynchronizationStateException
         * @throws NoneValueException
         * @throws IllegalArgumentException
         * @throws IndexOutOfBoundsException
         * @throws ReflectException
         * @throws InfoNotFoundException
         */
        get() {
            match (_annotations) {
                case Some(res) => res
                case None =>
                    let infos = match (getMethodAnnotations(_getterInfo.getOrThrow()._info,
                        TypeInfo.of<Array<Object>>()._info)) {
                        case arr: Array<Annotation> => arr
                        case _ => Array<Annotation>()
                    }
                    _annotations = infos
                    infos
            }
        }
    }


    /*
     * @throws NoneValueException
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    public func isOpen(): Bool {
        containsModifier(modifiers, ModifierInfo.Open)
    }


    /*
     * @throws NoneValueException
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    public func isAbstract(): Bool {
        containsModifier(modifiers, ModifierInfo.Abstract)
    }


    /*
     * @noThrow
     */
    public func isMutable(): Bool {
        _setterInfo.isSome()
    }


    /*
     * @throws IllegalSynchronizationStateException
     * @throws NoneValueException
     * @throws InfoNotFoundException
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     * @throws OutOfMemoryError
     * @throws IllegalTypeException
     * @throws ReflectException
     * @throws InvocationTargetException
     * @throws UnsupportedException
     */
    public func getValue(instance: Any): Any {
        if (isAbstract()) {
            throw UnsupportedException("Abstract prop cannot get value.")
        }
        if (let Some(v) <- _getterInfo) {
            return v.apply(instance, Array<Any>())
        }
    }


    /*
     * @throws IllegalSynchronizationStateException
     * @throws NoneValueException
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     * @throws OutOfMemoryError
     * @throws IllegalTypeException
     * @throws ReflectException
     * @throws InvocationTargetException
     * @throws InfoNotFoundException
     * @throws IllegalSetException
     */
    public func setValue(instance: Any, newValue: Any): Unit {
        if (isAbstract()) {
            throw IllegalSetException("Attempt to modify abstract variable '${name}'")
        }
        if (!isMutable()) {
            throw IllegalSetException("Attempt to modify immutable property '${name}'")
        }
        match (_setterInfo) {
            case Some(v) => v.apply(instance, Array<Any>(1, repeat: newValue))
            case None => throw IllegalSetException("Attempt to modify immutable property '${name}'")
        }
    }


    /*
     * @throws OutOfMemoryError
     * @throws IllegalSynchronizationStateException
     * @throws NoneValueException
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     * @throws ReflectException
     * @throws InfoNotFoundException
     */
    public func findAnnotation<T>(): ?T where T <: Annotation {
        findAnnotation<T>(annotations)
   }

    /*
     * @throws OutOfMemoryError
     * @throws IllegalSynchronizationStateException
     * @throws ReflectException
     * @throws InfoNotFoundException
     * @throws NoneValueException
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    public func findAllAnnotations<T>(): Array<T> where T <: Annotation {
        findAllAnnotations<T>(annotations)
    }

    /*
     * @throws OutOfMemoryError
     * @throws IllegalSynchronizationStateException
     * @throws NoneValueException
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     * @throws ReflectException
     * @throws InfoNotFoundException
     */
    public func getAllAnnotations(): Array<Annotation> {
        annotations.toArray()
    }

    /*
     * @throws NoneValueException
     */
    public operator func ==(that: InstancePropertyInfo): Bool {
        this._getterInfo.getOrThrow()._info == that._getterInfo.getOrThrow()._info
    }

    /*
     * @throws NoneValueException
     */
    public operator func !=(that: InstancePropertyInfo): Bool {
        !(this == that)
    }

    /*
     * @throws NoneValueException
     */
    public func hashCode(): Int64 {
        this._getterInfo.getOrThrow()._info.toUIntNative().hashCode()
    }

    /*
     * @throws OutOfMemoryError
     * @throws IllegalSynchronizationStateException
     * @throws ReflectException
     * @throws InfoNotFoundException
     * @throws NoneValueException
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    public func toString(): String {
        let sb = StringBuilder()
        for (m in modifiers) {
            sb.append(m)
            sb.append(" ")
        }
        sb.append("prop ")
        sb.append(name)
        sb.append(": ")
        sb.append(typeInfo)
        sb.toString()
    }

    /*
     * @noThrow
     */
    func setFunc(isGetter: Bool, pointer: CPointer<Unit>) {
        if (isGetter) {
            _getterInfo = InstanceFunctionInfo(pointer, _declaringTypeInfo)
        } else {
            _setterInfo = InstanceFunctionInfo(pointer, _declaringTypeInfo)
        }
    }
}


public class StaticPropertyInfo <: Equatable<StaticPropertyInfo> & Hashable & ToString {
    let _name: String
    var _getterInfo: Option<StaticFunctionInfo> = None
    var _setterInfo: Option<StaticFunctionInfo> = None
    var _typeInfo: Option<TypeInfo> = None
    var _modifiers: Option<Collection<ModifierInfo>> = None
    var _annotations: Option<Collection<Annotation>> = None
    var _declaringTypeInfo: CPointer<Unit>
    /*
     * @noThrow
     */
    init(name: String, declaringTypeInfo: CPointer<Unit>) {
        _name = name
        _declaringTypeInfo = declaringTypeInfo
    }


    public prop name: String {
        /*
         * @noThrow
         */
        get() {
            _name
        }
    }


    public prop typeInfo: TypeInfo {
        /*
         * @throws OutOfMemoryError
         * @throws IllegalSynchronizationStateException
         * @throws IllegalArgumentException
         * @throws IndexOutOfBoundsException
         * @throws ReflectException
         * @throws InfoNotFoundException
         * @throws NoneValueException
         */
        get() {
            match (_typeInfo) {
                case Some(res) => res
                case None =>
                    _typeInfo = _getterInfo?.returnType
                    _typeInfo.getOrThrow()
            }
        }
    }


    public prop modifiers: Collection<ModifierInfo> {
        /*
         * @throws NoneValueException
         * @throws IndexOutOfBoundsException
         * @throws IllegalArgumentException
         */
        get() {
            match (_modifiers) {
                case Some(res) => res
                case None =>
                    let infos = if (isMutable()) {
                        let array = ArrayList<ModifierInfo>((_getterInfo?.modifiers).getOrThrow())
                        array.add(ModifierInfo.Mut)
                        array.toArray()
                    } else {
                        (_getterInfo?.modifiers).getOrThrow()
                    }
                    _modifiers = infos
                    infos
            }
        }
    }


    public prop annotations: Collection<Annotation> {
        /*
         * @throws OutOfMemoryError
         * @throws IllegalSynchronizationStateException
         * @throws NoneValueException
         * @throws IllegalArgumentException
         * @throws IndexOutOfBoundsException
         * @throws ReflectException
         * @throws InfoNotFoundException
         */
        get() {
            match (_annotations) {
                case Some(res) => res
                case None =>
                    let infos = match (getMethodAnnotations(_getterInfo.getOrThrow()._info,
                        TypeInfo.of<Array<Object>>()._info)) {
                        case arr: Array<Annotation> => arr
                        case _ => Array<Annotation>()
                    }
                    _annotations = infos
                    infos
            }
        }
    }


    /*
     * @noThrow
     */
    public func isMutable(): Bool {
        _setterInfo.isSome()
    }


    /*
     * @throws IllegalSynchronizationStateException
     * @throws NoneValueException
     * @throws IllegalTypeException
     * @throws IndexOutOfBoundsException
     * @throws OutOfMemoryError
     * @throws IllegalArgumentException
     * @throws InfoNotFoundException
     * @throws ReflectException
     * @throws InvocationTargetException
     */
    public func getValue(): Any {
        if (let Some(v) <- _getterInfo) {
            return v.apply(TypeInfo.getOrCreate(_declaringTypeInfo), Array<Any>())
        }
    }


    /*
     * @throws IllegalSynchronizationStateException
     * @throws NoneValueException
     * @throws IllegalTypeException
     * @throws IndexOutOfBoundsException
     * @throws OutOfMemoryError
     * @throws IllegalArgumentException
     * @throws ReflectException
     * @throws InvocationTargetException
     * @throws InfoNotFoundException
     * @throws IllegalSetException
     */
    public func setValue(newValue: Any): Unit {
        if (!isMutable()) {
            throw IllegalSetException("Attempt to modify immutable property '${name}'")
        }
        match (_setterInfo) {
            case Some(v) => v.apply(TypeInfo.getOrCreate(_declaringTypeInfo), Array<Any>(1, repeat: newValue))
            case None => throw IllegalSetException("Attempt to modify immutable property '${name}'")
        }
    }


    /*
     * @throws OutOfMemoryError
     * @throws IllegalSynchronizationStateException
     * @throws NoneValueException
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     * @throws ReflectException
     * @throws InfoNotFoundException
     */
    public func findAnnotation<T>(): ?T where T <: Annotation {
        findAnnotation<T>(annotations)
   }

    /*
     * @throws OutOfMemoryError
     * @throws IllegalSynchronizationStateException
     * @throws ReflectException
     * @throws InfoNotFoundException
     * @throws NoneValueException
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    public func findAllAnnotations<T>(): Array<T> where T <: Annotation {
        findAllAnnotations<T>(annotations)
    }

    /*
     * @throws OutOfMemoryError
     * @throws IllegalSynchronizationStateException
     * @throws NoneValueException
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     * @throws ReflectException
     * @throws InfoNotFoundException
     */
    public func getAllAnnotations(): Array<Annotation> {
        annotations.toArray()
    }
    /*
     * @throws NoneValueException
     */
    public operator func ==(that: StaticPropertyInfo): Bool {
        this._getterInfo.getOrThrow()._info == that._getterInfo.getOrThrow()._info
    }

    /*
     * @throws NoneValueException
     */
    public operator func !=(that: StaticPropertyInfo): Bool {
        !(this == that)
    }

    /*
     * @throws NoneValueException
     */
    public func hashCode(): Int64 {
        this._getterInfo.getOrThrow()._info.toUIntNative().hashCode()
    }

    /*
     * @throws OutOfMemoryError
     * @throws IllegalSynchronizationStateException
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     * @throws ReflectException
     * @throws InfoNotFoundException
     * @throws NoneValueException
     */
    public func toString(): String {
        let sb = StringBuilder()
        for (m in modifiers) {
            sb.append(m)
            sb.append(" ")
        }
        sb.append("prop ")
        sb.append(name)
        sb.append(": ")
        sb.append(typeInfo)
        sb.toString()
    }

    /*
     * @noThrow
     */
    func setFunc(isGetter: Bool, pointer: CPointer<Unit>) {
        if (isGetter) {
            _getterInfo = StaticFunctionInfo(pointer, _declaringTypeInfo)
        } else {
            _setterInfo = StaticFunctionInfo(pointer, _declaringTypeInfo)
        }
    }
}


public class ConstructorInfo <: Equatable<ConstructorInfo> & Hashable & ToString {
    let _info: CPointer<Unit>
    var _parameters: Option<ArrayList<ParameterInfo>> = None
    var _annotations: Option<Collection<Annotation>> = None
    private var _isAbstract: Option<Bool> = None
    var _declaringTypeInfo: CPointer<Unit>
    /*
     * @noThrow
     */
    init(infoPointer: CPointer<Unit>, declaringTypeInfo: CPointer<Unit>) {
        _info = infoPointer
        _declaringTypeInfo = declaringTypeInfo
    }


    public prop parameters: ReadOnlyList<ParameterInfo> {
        /*
         * @throws IllegalArgumentException
         * @throws InfoNotFoundException
         */
        get() {
            match (_parameters) {
                case Some(res) => res
                case None =>
                    let infos = getParameters(_info)
                    _parameters = infos
                    infos
            }
        }
    }


    public prop annotations: Collection<Annotation> {
        /*
         * @throws OutOfMemoryError
         * @throws IllegalSynchronizationStateException
         * @throws NoneValueException
         * @throws IllegalArgumentException
         * @throws IndexOutOfBoundsException
         * @throws ReflectException
         * @throws InfoNotFoundException
         */
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

    private prop isAbstract: Bool {
        /*
         * @noThrow
         */
        get() {
            match (_isAbstract) {
                case Some(res) => res
                case None =>
                    let isDeclaringClassAbstract = ModifierInfo.isAbstract(getMethodModifier(_info)) ||
                        ModifierInfo.isAbstract(getTypeInfoModifier(_declaringTypeInfo))

                    _isAbstract = isDeclaringClassAbstract
                    isDeclaringClassAbstract
            }
        }
    }








    /*
     * @throws IllegalSynchronizationStateException
     * @throws NoneValueException
     * @throws InfoNotFoundException
     * @throws IndexOutOfBoundsException
     * @throws OutOfMemoryError
     * @throws IllegalTypeException
     * @throws IllegalArgumentException
     * @throws ReflectException
     * @throws InvocationTargetException
     */
    public func apply(args: Array<Any>): Any {
        let nullEntryPointer = methodEntryPointIsNull(_info)
        if (isAbstract || nullEntryPointer) {
            throw InvocationTargetException("Abstract constructor cannot apply.")
        }

        checkArgsSizeAndType(parameters, args)
        applyCJStaticMethod(_info, args, CPointer<Unit>())
    }


    /*
     * @throws OutOfMemoryError
     * @throws IllegalSynchronizationStateException
     * @throws NoneValueException
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     * @throws ReflectException
     * @throws InfoNotFoundException
     */
    public func findAnnotation<T>(): ?T where T <: Annotation {
        findAnnotation<T>(annotations)
   }

    /*
     * @throws OutOfMemoryError
     * @throws IllegalSynchronizationStateException
     * @throws ReflectException
     * @throws InfoNotFoundException
     * @throws NoneValueException
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    public func findAllAnnotations<T>(): Array<T> where T <: Annotation {
        findAllAnnotations<T>(annotations)
    }

    /*
     * @throws OutOfMemoryError
     * @throws IllegalSynchronizationStateException
     * @throws NoneValueException
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     * @throws ReflectException
     * @throws InfoNotFoundException
     */
    public func getAllAnnotations(): Array<Annotation> {
        annotations.toArray()
    }

    /*
     * @noThrow
     */
    public operator func ==(that: ConstructorInfo): Bool {
        this._info == that._info
    }

    /*
     * @noThrow
     */
    public operator func !=(that: ConstructorInfo): Bool {
        !(this == that)
    }

    /*
     * @noThrow
     */
    public func hashCode(): Int64 {
        this._info.toUIntNative().hashCode()
    }

    /*
     * @throws InfoNotFoundException
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    public func toString(): String {
        let sb = StringBuilder(constructorName)
        sb.append("(")
        for (index in 0..parameters.size) {
            sb.append(parameters[index])
            if (index < parameters.size - 1) {
                sb.append(", ")
            }
        }
        sb.append(")")
        sb.toString()
    }
}


public class GlobalFunctionInfo <: Equatable<GlobalFunctionInfo> & Hashable & ToString {
    let _info: CPointer<Unit>
    var _name: ?String = None
    var _parameters: Option<ArrayList<ParameterInfo>> = None
    var _genericParams = Option<Collection<GenericTypeInfo>>.None
    var _returnType: Option<TypeInfo> = None
    var _annotations: Option<Collection<Annotation>> = None

    /*
     * @noThrow
     */
    init(cp: CPointer<Unit>) {
        _info = cp
    }

    public prop genericParams: Collection<GenericTypeInfo> {
        /*
         * @throws IllegalArgumentException
         * @throws InfoNotFoundException
         */
        get() {
            match (_genericParams) {
                case Some(params) => params
                case None =>
                    let genericParametersNum = getNumOfGenericParameters(_info)
                    if (genericParametersNum == 0) {
                        _genericParams = Option<Collection<GenericTypeInfo>>.None
                        return ArrayList<GenericTypeInfo>()
                    }
                    let params = ArrayList<GenericTypeInfo>(
                        Int64(genericParametersNum),
                        {
                            index =>
                            let pointer = getGenericParameterInfo(_info, UInt32(index))
                            if (pointer.isNull()) {
                                throw InfoNotFoundException("Get parameters failed!")
                            }
                            GenericTypeInfo(pointer)
                        }
                    )
                    _genericParams = Some(params)
                    params
            }
        }
    }
    public prop name: String {
        /*
         * @throws NoneValueException
         */
        get() {
            _name.getOrThrow()
        }
    }


    public prop parameters: ReadOnlyList<ParameterInfo> {
        /*
         * @throws IllegalArgumentException
         * @throws InfoNotFoundException
         */
        get() {
            match (_parameters) {
                case Some(res) => res
                case None =>
                    let infos = getParameters(_info)
                    _parameters = infos
                    infos
            }
        }
    }


    public prop returnType: TypeInfo {
        /*
         * @throws OutOfMemoryError
         * @throws IllegalSynchronizationStateException
         * @throws NoneValueException
         * @throws IllegalArgumentException
         * @throws IndexOutOfBoundsException
         * @throws ReflectException
         * @throws InfoNotFoundException
         */
        get() {
            match (_returnType) {
                case Some(res) => res
                case None =>
                    let pointer = getMethodReturnType(_info)
                    let info = TypeInfo.getOrCreate(pointer)
                    _returnType = info
                    info
            }
        }
    }
    public prop annotations: Collection<Annotation> {
        /*
         * @throws OutOfMemoryError
         * @throws IllegalSynchronizationStateException
         * @throws NoneValueException
         * @throws IllegalArgumentException
         * @throws IndexOutOfBoundsException
         * @throws ReflectException
         * @throws InfoNotFoundException
         */
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








    /*
     * @throws IllegalSynchronizationStateException
     * @throws NoneValueException
     * @throws InfoNotFoundException
     * @throws IndexOutOfBoundsException
     * @throws OutOfMemoryError
     * @throws IllegalTypeException
     * @throws IllegalArgumentException
     * @throws ReflectException
     * @throws InvocationTargetException
     */
    public func apply(args: Array<Any>): Any {
        try {
            if (genericParams.size > 0) {
                throw InvocationTargetException("The generic function cannot be applied without `genericTypeArgs`.")
            }
        } catch (_: InfoNotFoundException) {
            throw InvocationTargetException("The generic function cannot be applied without `genericTypeArgs`.")
        }

        checkArgsSizeAndType(parameters, args)
        applyCJStaticMethod(_info, args, CPointer<Unit>())
    }

    /*
     * @throws InfoNotFoundException
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     * @throws IllegalTypeException
     * @throws InvocationTargetException
     */
    public func apply(genericTypeArgs: Array<TypeInfo>, args: Array<Any>): Any {
        if (genericParams.size == 0) {
            throw InvocationTargetException("The function cannot be applied with `genericTypeArgs`.")
        }

        checkParamaterSize(genericParams, parameters.size, genericTypeArgs, args)

        let gArgs = ArrayList<CPointer<Unit>>(Int64(genericTypeArgs.size)) {index => genericTypeArgs[index]._info}
        if (!checkMethodActualArgs(_info, gArgs.toArray(), args)) {
            throw IllegalTypeException(
                "The input parameter does not match the type of the input parameter required by the function.")
        }

        applyCJGenericStaticMethod(_info, gArgs.toArray(), args, CPointer<Unit>())
    }
    /*
     * @throws OutOfMemoryError
     * @throws IllegalSynchronizationStateException
     * @throws NoneValueException
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     * @throws ReflectException
     * @throws InfoNotFoundException
     */
    public func findAnnotation<T>(): ?T where T <: Annotation {
        findAnnotation<T>(annotations)
   }

    /*
     * @throws OutOfMemoryError
     * @throws IllegalSynchronizationStateException
     * @throws ReflectException
     * @throws InfoNotFoundException
     * @throws NoneValueException
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    public func findAllAnnotations<T>(): Array<T> where T <: Annotation {
        findAllAnnotations<T>(annotations)
    }

    /*
     * @throws OutOfMemoryError
     * @throws IllegalSynchronizationStateException
     * @throws NoneValueException
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     * @throws ReflectException
     * @throws InfoNotFoundException
     */
    public func getAllAnnotations(): Array<Annotation> {
        annotations.toArray()
    }

    /*
     * @noThrow
     */
    public operator func ==(that: GlobalFunctionInfo): Bool {
        this._info == that._info
    }

    /*
     * @noThrow
     */
    public operator func !=(that: GlobalFunctionInfo): Bool {
        !(this == that)
    }

    /*
     * @noThrow
     */
    public func hashCode(): Int64 {
        this._info.toUIntNative().hashCode()
    }

    /*
     * @throws OutOfMemoryError
     * @throws IllegalSynchronizationStateException
     * @throws NoneValueException
     * @throws ReflectException
     * @throws InfoNotFoundException
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    public func toString(): String {
        let sb = StringBuilder()
        sb.append("func ")
        sb.append(name)
        sb.append("(")
        for (index in 0..parameters.size) {
            sb.append(parameters[index])
            if (index < parameters.size - 1) {
                sb.append(", ")
            }
        }
        sb.append("): ")
        sb.append(returnType)
        sb.toString()
    }
}

/*
 * @throws InfoNotFoundException
 */
func getFuncName(parentPointer: CPointer<Unit>): String {
    let pointer = getMethodName(parentPointer)
    if (pointer.isNull()) {
        throw InfoNotFoundException("Get function name failed!")
    }
    CString(pointer).toString()
}

/*
 * @throws IllegalArgumentException
 * @throws InfoNotFoundException
 */
func getParameters(cp: CPointer<Unit>): ArrayList<ParameterInfo> {
    let actualParametersNum = getNumOfActualParameters(cp)
    ArrayList<ParameterInfo>(
        Int64(actualParametersNum),
        {
            index =>
            let pointer = getActualParameterInfo(cp, UInt32(index))
            if (pointer.isNull()) {
                throw InfoNotFoundException("Get parameters failed!")
            }
            ParameterInfo(pointer)
        }
    )
}

/*
 * @throws IllegalSynchronizationStateException
 * @throws NoneValueException
 * @throws InfoNotFoundException
 * @throws ReflectException
 * @throws IndexOutOfBoundsException
 * @throws IllegalArgumentException
 * @throws OutOfMemoryError
 * @throws IllegalTypeException
 */
func checkMethodDeclaringClassType(instance: Any, declaringTypeInfo: CPointer<Unit>): Unit {
    let declaringClassTypeInfo = TypeInfo.getOrCreate(declaringTypeInfo)
    let instanceTypeInfo = TypeInfo.of(instance)
    if (declaringClassTypeInfo != instanceTypeInfo) {
        throw IllegalTypeException(
            "The input instance should be \"${declaringClassTypeInfo}\", but now it`s \"${instanceTypeInfo}\"")
    }
}

/*
 * @throws IllegalArgumentException
 */
func checkParamaterSize(genericParams: Collection<GenericTypeInfo>, actualParamSize: Int64,
    genericTypeParameters: Collection<TypeInfo>, args: Array<Any>): Unit {
    if (genericTypeParameters.size != genericParams.size) {
        throw IllegalArgumentException("The input generic parameter item does not comply with the required quantity.")
    }

    if (args.size != actualParamSize) {
        throw IllegalArgumentException("The input parameter item does not comply with the required quantity.")
    }
}
