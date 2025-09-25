







package std.reflect

import std.collection.*


public class StructTypeInfo <: TypeInfo {
    var _constructors: Option<Collection<ConstructorInfo>> = None
    var _instanceVariables: Option<Collection<InstanceVariableInfo>> = None
    var _staticVariables: Option<Collection<StaticVariableInfo>> = None

    init(cp: CPointer<Unit>) {
        super(cp)
    }

    public static redef func get(qualifiedName: String): StructTypeInfo {
        match (TypeInfo.get(qualifiedName)) {
            case typ: StructTypeInfo => return typ
            case _ => throw IllegalTypeException("The type of '${qualifiedName}' is not a Struct Type.")
        }
    }

    public static redef func of(a: Any): StructTypeInfo {
        match (TypeInfo.of(a)) {
            case typ: StructTypeInfo => return typ
            case _ => throw IllegalTypeException("The type of parameter 'a' is not a Struct Type.")
        }
    }

    public static redef func of<T>(): StructTypeInfo {
        match (TypeInfo.of<T>()) {
            case typ: StructTypeInfo => return typ
            case _ => throw IllegalTypeException("The type of generic type 'T' is not a Struct Type.")
        }
    }


    public prop constructors: Collection<ConstructorInfo> {
        get() {
            if (_constructors.isNone()) {
                getInstanceFunctions()
            }
            _constructors.getOrThrow()
        }
    }


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







    public func construct(args: Array<Any>): Any {
        let parameterTypes = ArrayList<TypeInfo>()
        for (i in 0..args.size) {
            parameterTypes.add(TypeInfo.of(args[i]))
        }
        getConstructor(parameterTypes.toArray()).apply(args)
    }


    public func getConstructor(parameterTypes: Array<TypeInfo>): ConstructorInfo {
        getByNameAndParamTypes(constructors, constructorName, parameterTypes, "Constructor not found.") {
            constructor => (constructorName, constructor.parameters)
        }
    }


    public func getInstanceVariable(name: String): InstanceVariableInfo {
        getByName(instanceVariables, name, "Instance variable '${name}' in struct ${qualifiedName} not found.") {
            instanceVariable => instanceVariable.name
        }
    }


    public func getStaticVariable(name: String): StaticVariableInfo {
        getByName(staticVariables, name, "Static variable '${name}' in struct ${qualifiedName} not found.") {
            staticVariable => staticVariable.name
        }
    }
}
