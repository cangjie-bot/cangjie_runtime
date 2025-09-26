







package std.reflect

import std.collection.*
import std.sync.*


const constructorName = "init"

public class ClassTypeInfo <: TypeInfo {
    var _constructors: Option<Collection<ConstructorInfo>> = None
    var _instanceVariables: Option<Collection<InstanceVariableInfo>> = None
    var _staticVariables: Option<Collection<StaticVariableInfo>> = None
    var _superClass: Option<Option<ClassTypeInfo>> = None
    var _sealedSubclasses: Option<Collection<ClassTypeInfo>> = None

    init(cp: CPointer<Unit>) {
        super(cp)
    }

    /**
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
    public redef static func get(qualifiedName: String): ClassTypeInfo {
        match (TypeInfo.get(qualifiedName)) {
            case typ: ClassTypeInfo => return typ
            case _ => throw IllegalTypeException("The type of '${qualifiedName}' is not a Class Type.")
        }
    }

    /**
     * @throws OutOfMemoryError
     * @throws NoneValueException
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     * @throws ReflectException
     * @throws IllegalSynchronizationStateException
     * @throws InfoNotFoundException
     * @throws IllegalTypeException
     */
    public redef static func of(a: Any): ClassTypeInfo {
        match (TypeInfo.of(a)) {
            case typ: ClassTypeInfo => return typ
            case _ => throw IllegalTypeException("The type of parameter 'a' is not a Class Type.")
        }
    }

    /**
     * @throws OutOfMemoryError
     * @throws NoneValueException
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     * @throws ReflectException
     * @throws IllegalSynchronizationStateException
     * @throws InfoNotFoundException
     */
    public static func of(a: Object): ClassTypeInfo {
        return TypeInfo.of(a)
    }

    /**
     * @throws OutOfMemoryError
     * @throws NoneValueException
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     * @throws ReflectException
     * @throws IllegalSynchronizationStateException
     * @throws InfoNotFoundException
     * @throws IllegalTypeException
     */
    public redef static func of<T>(): ClassTypeInfo {
        match (TypeInfo.of<T>()) {
            case typ: ClassTypeInfo => return typ
            case _ => throw IllegalTypeException("The type of generic type 'T' is not a Class Type.")
        }
    }


        /**
         * @throws IllegalArgumentException
         * @throws IndexOutOfBoundsException
         * @throws ReflectException
         * @throws InfoNotFoundException
         * @throws NoneValueException
         */
    public prop constructors: Collection<ConstructorInfo> {
        get() {
            match (_constructors) {
                case Some(res) => res
                case None =>
                    getInstanceFunctions()
                    _constructors.getOrThrow()
            }
        }
    }


        /**
         * @throws InfoNotFoundException
         */
    public prop instanceVariables: Collection<InstanceVariableInfo> {
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
                                throw InfoNotFoundException("ClassTypeInfo find instanceVariables failed!")
                            }
                            InstanceVariableInfo(pointer, _info)
                        }
                    )
                    _instanceVariables = infos
                    infos
            }
        }
    }


        /**
         * @throws OutOfMemoryError
         * @throws NoneValueException
         * @throws IllegalArgumentException
         * @throws IndexOutOfBoundsException
         * @throws ReflectException
         * @throws IllegalSynchronizationStateException
         * @throws InfoNotFoundException
         */
    public prop staticVariables: Collection<StaticVariableInfo> {
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
                                throw InfoNotFoundException("ClassTypeInfo find staticVariables failed!")
                            }
                            StaticVariableInfo(pointer, _info)
                        }
                    )
                    _staticVariables = infos
                    infos
            }
        }
    }


        /**
         * @throws OutOfMemoryError
         * @throws NoneValueException
         * @throws IllegalArgumentException
         * @throws IndexOutOfBoundsException
         * @throws ReflectException
         * @throws IllegalSynchronizationStateException
         * @throws MisMatchException
         * @throws InfoNotFoundException
         */
    public prop superClass: Option<ClassTypeInfo> {
        get() {
            match (_superClass) {
                case Some(res) => res
                case None =>
                    let info = if (qualifiedName == "Object") {
                        None<ClassTypeInfo>
                    } else {
                        let pointer = getSuperTypeInfo(_info)
                        if (pointer.isNull()) {
                            throw InfoNotFoundException("ClassTypeInfo find superClass failed!")
                        }
                        (getOrCreate(pointer) as ClassTypeInfo) ?? throw MisMatchException(
                            "Super class info of '${qualifiedName}' can not cast to ClassTypeInfo.")
                    }
                    _superClass = info
                    info
            }
        }
    }


        /**
         * @throws IllegalSynchronizationStateException
         * @throws InfoNotFoundException
         * @throws IllegalMemoryException
         * @throws NoneValueException
         * @throws ReflectException
         * @throws OutOfMemoryError
         * @throws IndexOutOfBoundsException
         * @throws IllegalArgumentException
         */
    public prop sealedSubclasses: Collection<ClassTypeInfo> {
        get() {
            match (_sealedSubclasses) {
                case Some(res) => res
                case None =>
                    let res = if (!isSealed()) {
                        Array<ClassTypeInfo>()
                    } else {
                        findSubtypeFromPackage<ClassTypeInfo>(this)
                    }
                    _sealedSubclasses = res
                    res
            }
        }
    }








    /**
     * @throws IllegalTypeException
     * @throws OutOfMemoryError
     * @throws NoneValueException
     * @throws IllegalSynchronizationStateException
     * @throws InfoNotFoundException
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     * @throws ReflectException
     * @throws InvocationTargetException
     */
    public func construct(args: Array<Any>): Any {
        if (this.isAbstract()) {
            throw InvocationTargetException("Constructing abstract classes is not allowed.")
        }
        let parameterTypes = ArrayList<TypeInfo>()
        for (i in 0..args.size) {
            parameterTypes.add(TypeInfo.of(args[i]))
        }
        getConstructor(parameterTypes.toArray()).apply(args)
    }


    /**
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    public func isOpen(): Bool {
        containsModifier(modifiers, ModifierInfo.Open)
    }


    /**
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    public func isAbstract(): Bool {
        containsModifier(modifiers, ModifierInfo.Abstract)
    }


    /**
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    public func isSealed(): Bool {
        containsModifier(modifiers, ModifierInfo.Sealed)
    }


    /**
     * @throws NoneValueException
     * @throws IllegalSynchronizationStateException
     * @throws ReflectException
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     * @throws OutOfMemoryError
     * @throws InfoNotFoundException
     */
    public func getConstructor(parameterTypes: Array<TypeInfo>): ConstructorInfo {
        getByNameAndParamTypes(constructors, constructorName, parameterTypes, "Can not find the specified constructor") {
            constructor => (constructorName, constructor.parameters)
        }
    }


    /**
     * @throws ReflectException
     * @throws IllegalArgumentException
     * @throws OutOfMemoryError
     * @throws IndexOutOfBoundsException
     * @throws IllegalStateException
     * @throws InfoNotFoundException
     */
    public func getInstanceVariable(name: String): InstanceVariableInfo {
        getByName(instanceVariables, name, "instance variable '${name}' in class ${qualifiedName} not found") {
            instanceVariable => instanceVariable.name
        }
    }


    /**
     * @throws NoneValueException
     * @throws IllegalSynchronizationStateException
     * @throws ReflectException
     * @throws IllegalArgumentException
     * @throws OutOfMemoryError
     * @throws IndexOutOfBoundsException
     * @throws IllegalStateException
     * @throws InfoNotFoundException
     */
    public func getStaticVariable(name: String): StaticVariableInfo {
        getByName(staticVariables, name, "static variable '${name}' in class ${qualifiedName} not found") {
            staticVariable => staticVariable.name
        }
    }
}
