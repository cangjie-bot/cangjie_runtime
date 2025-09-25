







package std.reflect


public class ParameterInfo <: Equatable<ParameterInfo> & Hashable & ToString {
    let _info: CPointer<Unit>
    var _index: Option<Int64> = None
    var _name: Option<String> = None
    var _typeInfo: Option<TypeInfo> = None
    var _annotations: Option<Collection<Annotation>> = None

    /*
     * @noThrow
     */
    init(cp: CPointer<Unit>) {
        _info = cp
    }


    public prop index: Int64 {
        /*
         * @noThrow
         */
        get() {
            match (_index) {
                case Some(res) => res
                case None =>
                    var parameterIndex = Int64(getParameterIndex(_info))
                    _index = parameterIndex
                    parameterIndex
            }
        }
    }


    public prop name: String {
        /*
         * @throws InfoNotFoundException
         */
        get() {
            match (_name) {
                case Some(res) => res
                case None =>
                    let pointer = getParameterName(_info)
                    if (pointer.isNull()) {
                        throw InfoNotFoundException("Get parameter name failed!")
                    }
                    let parameterName = CString(pointer).toString()
                    _name = parameterName
                    parameterName
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
                    let pointer = getParameterType(_info)
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
                    let infos = match (getParameterAnnotations(_info, TypeInfo.of<Array<Object>>()._info)) {
                        case arr: Array<Annotation> => arr
                        case _ => Array<Annotation>()
                    }
                    _annotations = infos
                    infos
            }
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
    public operator func ==(that: ParameterInfo): Bool {
        this._info == that._info
    }

    /*
     * @noThrow
     */
    public operator func !=(that: ParameterInfo): Bool {
        !(this == that)
    }

    /*
     * @noThrow
     */
    public func hashCode(): Int64 {
        this._info.toUIntNative().hashCode()
    }

    /*
     * @throws IllegalSynchronizationStateException
     * @throws NoneValueException
     * @throws InfoNotFoundException
     * @throws ReflectException
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     * @throws OutOfMemoryError
     */
    public func toString(): String {
        typeInfo.toString()
    }
}
