







package std.reflect


public class InstanceVariableInfo <: Equatable<InstanceVariableInfo> & Hashable & ToString {
    let _info: CPointer<Unit>
    let _isStruct: Bool
    var _mutable: Option<Bool> = None
    var _name: Option<String> = None
    var _typeInfo: Option<TypeInfo> = None
    var _modifiers: Option<Collection<ModifierInfo>> = None
    var _annotations: Option<Collection<Annotation>> = None
    var _declaringTypeInfo: CPointer<Unit>

    /*
     * @noThrow
     */
    init(cp: CPointer<Unit>, declaringTypeInfo: CPointer<Unit>, isStruct!: Bool = false) {
        _info = cp
        _declaringTypeInfo = declaringTypeInfo
        _isStruct = isStruct
    }


    public prop name: String {
        /*
         * @throws IllegalStateException
         */
        get() {
            match (_name) {
                case Some(res) => res
                case None =>
                    let pointer = getInstanceFieldName(_info, _declaringTypeInfo)
                    if (pointer.isNull()) {
                        throw IllegalStateException("getFieldName Null Pointer!")
                    }
                    let variableName = CString(pointer).toString()
                    _name = variableName
                    variableName
            }
        }
    }


    public prop typeInfo: TypeInfo {
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
            match (_typeInfo) {
                case Some(res) => res
                case None =>
                    let pointer = getInstanceFieldType(_info, _declaringTypeInfo)
                    let ti = TypeInfo.getOrCreate(pointer)
                    _typeInfo = ti
                    ti
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
                    let infos = ModifierInfo.byMask(getInstanceFieldModifier(_info))
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
                    let infos = match (getInstanceFieldAnnotations(_info, TypeInfo.of<Array<Object>>()._info)) {
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
        match (_mutable) {
            case Some(res) => res
            case None =>
                let mutable = ModifierInfo.isMutable(getInstanceFieldModifier(_info))
                _mutable = mutable
                mutable
        }
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
    public func getValue(instance: Any): Any {
        checkDeclaringClassType(instance)
        getInstanceFieldValue(_info, _declaringTypeInfo, instance)
    }









    /*
     * @throws IllegalSynchronizationStateException
     * @throws NoneValueException
     * @throws ReflectException
     * @throws IllegalStateException
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     * @throws OutOfMemoryError
     * @throws IllegalTypeException
     * @throws InfoNotFoundException
     * @throws IllegalSetException
     */
    public func setValue(instance: Any, newValue: Any): Unit {
        if (!this.isMutable()) {
            throw IllegalSetException("Attempt to modify immutable variable '${name}'.")
        }
        checkDeclaringClassType(instance)
        checkValueType(newValue, typeInfo)
        setInstanceFieldValue(_info, _declaringTypeInfo, instance, newValue)
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
    func checkDeclaringClassType(instance: Any): Unit {
        let declaringClassTypeInfo = getFieldDeclaringClassType(_declaringTypeInfo)
        let instanceTypeInfo = TypeInfo.of(instance)
        if (declaringClassTypeInfo != instanceTypeInfo) {
            throw IllegalTypeException(
                "The input instance should be \"${declaringClassTypeInfo}\", but now it`s \"${instanceTypeInfo}\"")
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
     * @noThrow
     */
    public operator func ==(that: InstanceVariableInfo): Bool {
        this._info == that._info
    }

    /*
     * @noThrow
     */
    public operator func !=(that: InstanceVariableInfo): Bool {
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
     * @throws IllegalStateException
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    public func toString(): String {
        let sb = StringBuilder()
        for (m in modifiers) {
            sb.append(m)
            sb.append(" ")
        }
        sb.append(name)
        sb.append(": ")
        sb.append(typeInfo)
        sb.toString()
    }
}


public class StaticVariableInfo <: Equatable<StaticVariableInfo> & Hashable & ToString {
    let _info: CPointer<Unit>
    let _isStruct: Bool
    var _mutable: Option<Bool> = None
    var _name: Option<String> = None
    var _typeInfo: Option<TypeInfo> = None
    var _modifiers: Option<Collection<ModifierInfo>> = None
    var _annotations: Option<Collection<Annotation>> = None
    var _declaringTypeInfo: CPointer<Unit>

    /*
     * @throws OutOfMemoryError
     * @throws IllegalSynchronizationStateException
     * @throws NoneValueException
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     * @throws ReflectException
     * @throws InfoNotFoundException
     */
    init(cp: CPointer<Unit>, declaringTypeInfo: CPointer<Unit>) {
        _info = cp
        _isStruct = getFieldDeclaringClassType(declaringTypeInfo) is StructTypeInfo
        _declaringTypeInfo = declaringTypeInfo
    }


    public prop name: String {
        /*
         * @throws IllegalStateException
         */
        get() {
            match (_name) {
                case Some(res) => res
                case None =>
                    let pointer = getStaticFieldName(_info)
                    if (pointer.isNull()) {
                        throw IllegalStateException("GetStaticFieldName failed: null pointer!")
                    }
                    let variableName = CString(pointer).toString()
                    _name = variableName
                    variableName
            }
        }
    }


    public prop typeInfo: TypeInfo {
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
            match (_typeInfo) {
                case Some(res) => res
                case None =>
                    let pointer = getStaticFieldType(_info)
                    let ti = TypeInfo.getOrCreate(pointer)
                    _typeInfo = ti
                    ti
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
                    let infos = ModifierInfo.byMask(getStaticFieldModifier(_info))
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
                    let infos = match (getStaticFieldAnnotations(_info, TypeInfo.of<Array<Object>>()._info)) {
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
        match (_mutable) {
            case Some(res) => res
            case None =>
                let mutable = ModifierInfo.isMutable(getStaticFieldModifier(_info))
                _mutable = mutable
                mutable
        }
    }


    /*
     * @noThrow
     */
    public func getValue(): Any {
        getStaticFieldValue(_info)
    }







    /*
     * @throws IllegalTypeException
     * @throws OutOfMemoryError
     * @throws IllegalSynchronizationStateException
     * @throws NoneValueException
     * @throws IllegalArgumentException
     * @throws IllegalStateException
     * @throws IndexOutOfBoundsException
     * @throws ReflectException
     * @throws InfoNotFoundException
     * @throws IllegalSetException
     */
    public func setValue(newValue: Any): Unit {
        if (!isMutable()) {
            throw IllegalSetException("Attempt to modify immutable variable '${name}'.")
        }
        checkValueType(newValue, typeInfo)
        setStaticFieldValue(_info, newValue)
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
    public operator func ==(that: StaticVariableInfo): Bool {
        this._info == that._info
    }

    /*
     * @noThrow
     */
    public operator func !=(that: StaticVariableInfo): Bool {
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
     * @throws IllegalStateException
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    public func toString(): String {
        let sb = StringBuilder()
        for (m in modifiers) {
            sb.append(m)
            sb.append(" ")
        }
        sb.append(name)
        sb.append(": ")
        sb.append(typeInfo)
        sb.toString()
    }
}


public class GlobalVariableInfo <: Equatable<GlobalVariableInfo> & Hashable & ToString {
    let _info: CPointer<Unit>
    var _mutable: Option<Bool> = None
    var _name: Option<String> = None
    var _typeInfo: Option<TypeInfo> = None
    var _annotations: Option<Collection<Annotation>> = None

    /*
     * @noThrow
     */
    init(cp: CPointer<Unit>) {
        _info = cp
    }


    public prop name: String {
        /*
         * @throws IllegalStateException
         */
        get() {
            match (_name) {
                case Some(res) => res
                case None =>
                    let pointer = getStaticFieldName(_info)
                    if (pointer.isNull()) {
                        throw IllegalStateException("GetFieldName Null Pointer!")
                    }
                    let variableName = CString(pointer).toString()
                    _name = variableName
                    variableName
            }
        }
    }
    public prop typeInfo: TypeInfo {
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
            match (_typeInfo) {
                case Some(res) => res
                case None =>
                    let pointer = getStaticFieldType(_info)
                    let ti = TypeInfo.getOrCreate(pointer)
                    _typeInfo = ti
                    ti
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
                    let infos = match (getStaticFieldAnnotations(_info, TypeInfo.of<Array<Object>>()._info)) {
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
        match (_mutable) {
            case Some(res) => res
            case None =>
                let mutable = ModifierInfo.isMutable(getStaticFieldModifier(_info))
                _mutable = mutable
                mutable
        }
    }
    /*
     * @noThrow
     */
    public func getValue(): Any {
        getStaticFieldValue(_info)
    }







    /*
     * @throws IllegalSynchronizationStateException
     * @throws NoneValueException
     * @throws ReflectException
     * @throws IllegalStateException
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     * @throws OutOfMemoryError
     * @throws IllegalTypeException
     * @throws InfoNotFoundException
     * @throws IllegalSetException
     */
    public func setValue(newValue: Any): Unit {
        if (!isMutable()) {
            throw IllegalSetException("Attempt to modify immutable variable '${name}'.")
        }
        checkValueType(newValue, typeInfo)
        setStaticFieldValue(_info, newValue)
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
    public operator func ==(that: GlobalVariableInfo): Bool {
        this._info == that._info
    }

    /*
     * @noThrow
     */
    public operator func !=(that: GlobalVariableInfo): Bool {
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
     * @throws IllegalStateException
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    public func toString(): String {
        let sb = StringBuilder()
        sb.append(name)
        sb.append(": ")
        sb.append(typeInfo)
        sb.toString()
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
func getFieldDeclaringClassType(declaringTypeInfo: CPointer<Unit>): TypeInfo {
    TypeInfo.getOrCreate(declaringTypeInfo)
}
