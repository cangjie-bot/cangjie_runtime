







package std.reflect

import std.collection.*


public class StructTypeInfo <: TypeInfo {
    var _constructors: Option<Collection<ConstructorInfo>> = None
    var _instanceVariables: Option<Collection<InstanceVariableInfo>> = None
    var _staticVariables: Option<Collection<StaticVariableInfo>> = None

    /*
     * @noThrow
     */
    init(cp: CPointer<Unit>) {
        super(cp)
    }

    /*
     * @throws OutOfMemoryError
     * @throws IllegalMemoryException
     * @throws NoneValueException
     * @throws ReflectException
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     * @throws InfoNotFoundException
     * @throws IllegalSynchronizationStateException
     * @throws IllegalTypeException
     */
    public static redef func get(qualifiedName: String): StructTypeInfo {
        match (TypeInfo.get(qualifiedName)) {
            case typ: StructTypeInfo => return typ
            case _ => throw IllegalTypeException("The type of '${qualifiedName}' is not a Struct Type.")
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
     * @throws IllegalTypeException
     */
    public static redef func of(a: Any): StructTypeInfo {
        match (TypeInfo.of(a)) {
            case typ: StructTypeInfo => return typ
            case _ => throw IllegalTypeException("The type of parameter 'a' is not a Struct Type.")
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
     * @throws IllegalTypeException
     */
    public static redef func of<T>(): StructTypeInfo {
        match (TypeInfo.of<T>()) {
            case typ: StructTypeInfo => return typ
            case _ => throw IllegalTypeException("The type of generic type 'T' is not a Struct Type.")
        }
    }


    public prop constructors: Collection<ConstructorInfo> {
        /*
         * @throws IllegalArgumentException
         * @throws IndexOutOfBoundsException
         * @throws ReflectException
         * @throws InfoNotFoundException
         * @throws NoneValueException
         */
        get() {
            if (_constructors.isNone()) {
                getInstanceFunctions()
            }
            _constructors.getOrThrow()
        }
    }


    public prop instanceVariables: Collection<InstanceVariableInfo> {
        /*
         * @throws InfoNotFoundException
         */
        get() {
            match (_instanceVariables) {
                case Some(res) => res
                case None =>
                    let num = getNumOfInstanceFieldInfos(_info)
                    let infos = Array<InstanceVariableInfo>(
                        Int64(num),
                        {
                            index =>
                            let pointer = getInstanceFieldInfo(_info, UInt32(index))
                            if (pointer.isNull()) {
                                throw InfoNotFoundException("StructTypeInfo find instanceVariables failed!")
                            }
                            InstanceVariableInfo(pointer, _info, isStruct: true)
                        }
                    )
                    _instanceVariables = infos
                    infos
            }
        }
    }


    public prop staticVariables: Collection<StaticVariableInfo> {
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
            match (_staticVariables) {
                case Some(res) => res
                case None =>
                    let num = getNumOfStaticFieldInfos(_info)
                    let infos = Array<StaticVariableInfo>(
                        Int64(num),
                        {
                            index =>
                            let pointer = getStaticFieldInfo(_info, UInt32(index))
                            if (pointer.isNull()) {
                                throw InfoNotFoundException("StructTypeInfo find staticVariables failed!")
                            }
                            StaticVariableInfo(pointer, _info)
                        }
                    )
                    _staticVariables = infos
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
    public func construct(args: Array<Any>): Any {
        let parameterTypes = ArrayList<TypeInfo>()
        for (i in 0..args.size) {
            parameterTypes.add(TypeInfo.of(args[i]))
        }
        getConstructor(parameterTypes.toArray()).apply(args)
    }


    /*
     * @throws IllegalSynchronizationStateException
     * @throws NoneValueException
     * @throws ReflectException
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     * @throws OutOfMemoryError
     * @throws InfoNotFoundException
     */
    public func getConstructor(parameterTypes: Array<TypeInfo>): ConstructorInfo {
        getByNameAndParamTypes(constructors, constructorName, parameterTypes, "Constructor not found.") {
            constructor => (constructorName, constructor.parameters)
        }
    }


    /*
     * @throws ReflectException
     * @throws IllegalArgumentException
     * @throws OutOfMemoryError
     * @throws IndexOutOfBoundsException
     * @throws IllegalStateException
     * @throws InfoNotFoundException
     */
    public func getInstanceVariable(name: String): InstanceVariableInfo {
        getByName(instanceVariables, name, "Instance variable '${name}' in struct ${qualifiedName} not found.") {
            instanceVariable => instanceVariable.name
        }
    }


    /*
     * @throws IllegalSynchronizationStateException
     * @throws NoneValueException
     * @throws ReflectException
     * @throws IllegalArgumentException
     * @throws OutOfMemoryError
     * @throws IndexOutOfBoundsException
     * @throws IllegalStateException
     * @throws InfoNotFoundException
     */
    public func getStaticVariable(name: String): StaticVariableInfo {
        getByName(staticVariables, name, "Static variable '${name}' in struct ${qualifiedName} not found.") {
            staticVariable => staticVariable.name
        }
    }
}
