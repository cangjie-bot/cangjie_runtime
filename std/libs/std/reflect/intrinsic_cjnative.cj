







package std.reflect
@Intrinsic
/*
 * @noThrow
 */
func isInterface(ti: CPointer<Unit>): Bool

@Intrinsic
/*
 * @noThrow
 */
func isStruct(ti: CPointer<Unit>): Bool

@Intrinsic
/*
 * @noThrow
 */
func isPrimitive(ti: CPointer<Unit>): Bool

@Intrinsic
/*
 * @noThrow
 */
func isClass(ti: CPointer<Unit>): Bool

@Intrinsic
/*
 * @noThrow
 */
func isGeneric(ti: CPointer<Unit>): Bool

@Intrinsic
/*
 * @noThrow
 */
func getOrCreateTypeInfoForReflect(typeTemplate: CPointer<Unit>, typeArgs: Array<CPointer<Unit>>): CPointer<Unit>

@Intrinsic
/*
 * @noThrow
 */
func getTypeTemplate(name: CPointer<UInt8>): CPointer<Unit>

@Intrinsic
/*
 * @noThrow
 */
func checkMethodActualArgs(methodInfo: CPointer<Unit>, genericTypeArgs: Array<CPointer<Unit>>, args: Array<Any>): Bool

@Intrinsic
/*
 * @noThrow
 */
func methodEntryPointIsNull(methodInfo: CPointer<Unit>): Bool

@Intrinsic
/*
 * @noThrow
 */
func isReflectUnsupportedType(ti: CPointer<Unit>): Bool

@Intrinsic
/*
 * @noThrow
 */
func getTypeForAny(obj: Any): CPointer<Unit>

@Intrinsic
/*
 * @noThrow
 */
func getTypeByMangledName<T>(): CPointer<Unit>

@Intrinsic
/*
 * @noThrow
 */
func getTypeName(obj: CPointer<Unit>): CPointer<UInt8>

@Intrinsic
/*
 * @noThrow
 */
func getTypeByQualifiedName(qualifiedName: CPointer<UInt8>): CPointer<Unit>

@Intrinsic
/*
 * @noThrow
 */
func getTypeQualifiedNameLength(ti: CPointer<Unit>): UInt32

@Intrinsic
/*
 * @noThrow
 */
func getTypeQualifiedName(ti: CPointer<Unit>, name: CPointer<UInt8>): Unit

@Intrinsic
/*
 * @noThrow
 */
func getNumOfInterface(ti: CPointer<Unit>): UInt32

@Intrinsic
/*
 * @noThrow
 */
func getInterface(ti: CPointer<Unit>, index: UInt32): CPointer<Unit>

@Intrinsic
/*
 * @noThrow
 */
func isSubType(ti: CPointer<Unit>, superTypeclassInfo: CPointer<Unit>): Bool
@Intrinsic
/*
 * @noThrow
 */
func getTypeInfoModifier(ti: CPointer<Unit>): UInt32

@Intrinsic
/*
 * @noThrow
 */
func getTypeInfoAnnotations(ti: CPointer<Unit>, arrayTi: CPointer<Unit>): Any
@Intrinsic
/*
 * @noThrow
 */
func getObjClass(obj: Object): CPointer<Unit>

@Intrinsic
/*
 * @noThrow
 */
func getSuperTypeInfo(ti: CPointer<Unit>): CPointer<Unit>
@Intrinsic
/*
 * @noThrow
 */
func getNumOfInstanceMethodInfos(ti: CPointer<Unit>): UInt32

@Intrinsic
/*
 * @noThrow
 */
func getInstanceMethodInfo(ti: CPointer<Unit>, index: UInt32): CPointer<Unit>

@Intrinsic
/*
 * @noThrow
 */
func getNumOfStaticMethodInfos(ti: CPointer<Unit>): UInt32

@Intrinsic
/*
 * @noThrow
 */
func getStaticMethodInfo(ti: CPointer<Unit>, index: UInt32): CPointer<Unit>

@Intrinsic
/*
 * @noThrow
 */
func getMethodName(methodInfo: CPointer<Unit>): CPointer<UInt8>

@Intrinsic
/*
 * @noThrow
 */
func getParameterInfo(methodInfo: CPointer<Unit>, index: UInt32): CPointer<Unit>

@Intrinsic
/*
 * @noThrow
 */
func getMethodReturnType(methodInfo: CPointer<Unit>): CPointer<Unit>

@Intrinsic
/*
 * @noThrow
 */
func getMethodModifier(methodInfo: CPointer<Unit>): UInt32

@Intrinsic
/*
 * @noThrow
 */
func getMethodAnnotations(methodInfo: CPointer<Unit>, arrayTi: CPointer<Unit>): Any

@Intrinsic
/*
 * @noThrow
 */
func getNumOfActualParameters(methodInfo: CPointer<Unit>): UInt32

@Intrinsic
/*
 * @noThrow
 */
func getNumOfGenericParameters(methodInfo: CPointer<Unit>): UInt32

@Intrinsic
/*
 * @noThrow
 */
func getActualParameterInfo(methodInfo: CPointer<Unit>, idx: UInt32): CPointer<Unit>

@Intrinsic
/*
 * @noThrow
 */
func getGenericParameterInfo(methodInfo: CPointer<Unit>, idx: UInt32): CPointer<Unit>
@Intrinsic
/*
 * @noThrow
 */
func getNumOfInstanceFieldInfos(ti: CPointer<Unit>): UInt32

@Intrinsic
/*
 * @noThrow
 */
func getInstanceFieldInfo(ti: CPointer<Unit>, index: UInt32): CPointer<Unit>

@Intrinsic
/*
 * @noThrow
 */
func getNumOfStaticFieldInfos(ti: CPointer<Unit>): UInt32

@Intrinsic
/*
 * @noThrow
 */
func getStaticFieldInfo(ti: CPointer<Unit>, index: UInt32): CPointer<Unit>

@Intrinsic
/*
 * @noThrow
 */
func getStaticFieldName(fieldInfo: CPointer<Unit>): CPointer<UInt8>

@Intrinsic
/*
 * @noThrow
 */
func getStaticFieldType(fieldInfo: CPointer<Unit>): CPointer<Unit>

@Intrinsic
/*
 * @noThrow
 */
func getStaticFieldAnnotations(fieldInfo: CPointer<Unit>, arrayTi: CPointer<Unit>): Any

@Intrinsic
/*
 * @noThrow
 */
func getInstanceFieldName(fieldInfo: CPointer<Unit>, declaringTypeInfo: CPointer<Unit>): CPointer<UInt8>

@Intrinsic
/*
 * @noThrow
 */
func getInstanceFieldType(fieldInfo: CPointer<Unit>, declaringTypeInfo: CPointer<Unit>): CPointer<Unit>

@Intrinsic
/*
 * @noThrow
 */
func getInstanceFieldModifier(fieldInfo: CPointer<Unit>): UInt32

@Intrinsic
/*
 * @noThrow
 */
func getStaticFieldModifier(fieldInfo: CPointer<Unit>): UInt32

@Intrinsic
/*
 * @noThrow
 */
func getInstanceFieldAnnotations(fieldInfo: CPointer<Unit>, arrayTi: CPointer<Unit>): Any

@Intrinsic
/*
 * @noThrow
 */
func getInstanceFieldValue(fieldInfo: CPointer<Unit>, declaringTypeInfo: CPointer<Unit>, instance: Any): Any

@Intrinsic
/*
 * @noThrow
 */
func setInstanceFieldValue(fieldInfo: CPointer<Unit>, declaringTypeInfo: CPointer<Unit>, instance: Any, value: Any): Unit

@Intrinsic
/*
 * @noThrow
 */
func getStaticFieldValue(fieldInfo: CPointer<Unit>): Any

@Intrinsic
/*
 * @noThrow
 */
func setStaticFieldValue(fieldInfo: CPointer<Unit>, value: Any): Unit
@Intrinsic
/*
 * @noThrow
 */
func getParameterIndex(parameterInfo: CPointer<Unit>): UInt32

@Intrinsic
/*
 * @noThrow
 */
func getParameterName(parameterInfo: CPointer<Unit>): CPointer<UInt8>

@Intrinsic
/*
 * @noThrow
 */
func getParameterType(parameterInfo: CPointer<Unit>): CPointer<Unit>

@Intrinsic
/*
 * @noThrow
 */
func getParameterAnnotations(parameterInfo: CPointer<Unit>, arrayTi: CPointer<Unit>): Any
@Intrinsic
/*
 * @noThrow
 */
func applyCJInstanceMethod(methodInfo: CPointer<Unit>, instance: Any, args: Array<Any>): Any

@Intrinsic
/*
 * @noThrow
 */
func applyCJStaticMethod(methodInfo: CPointer<Unit>, args: Array<Any>, thisType: CPointer<Unit>): Any

@Intrinsic
/*
 * @noThrow
 */
func applyCJGenericInstanceMethod(methodInfo: CPointer<Unit>, instance: Any, genericTypeArgs: Array<CPointer<Unit>>,
    args: Array<Any>): Any

@Intrinsic
/*
 * @noThrow
 */
func applyCJGenericStaticMethod(methodInfo: CPointer<Unit>, genericTypeArgs: Array<CPointer<Unit>>, args: Array<Any>,
    thisType: CPointer<Unit>): Any

@Intrinsic
/*
 * @noThrow
 */
func getRelatedPackageInfo(packageInfo: CPointer<Unit>): CPointer<Unit>

@Intrinsic
/*
 * @noThrow
 */
func getPackageName(packageInfo: CPointer<Unit>): CPointer<UInt8>

@Intrinsic
/*
 * @noThrow
 */
func getPackageNumOfTypeInfos(packageInfo: CPointer<Unit>): UInt32

@Intrinsic
/*
 * @noThrow
 */
func getPackageTypeInfo(packageInfo: CPointer<Unit>, index: UInt32): CPointer<Unit>

@Intrinsic
/*
 * @noThrow
 */
func getPackageNumOfGlobalMethodInfos(packageInfo: CPointer<Unit>): UInt32

@Intrinsic
/*
 * @noThrow
 */
func getPackageGlobalMethodInfo(packageInfo: CPointer<Unit>, index: UInt32): CPointer<Unit>

@Intrinsic
/*
 * @noThrow
 */
func getPackageNumOfGlobalFieldInfos(packageInfo: CPointer<Unit>): UInt32

@Intrinsic
/*
 * @noThrow
 */
func getPackageGlobalFieldInfo(packageInfo: CPointer<Unit>, index: UInt32): CPointer<Unit>

@Intrinsic
/*
 * @noThrow
 */
func loadPackage(path: CPointer<UInt8>): CPointer<Unit>

@Intrinsic
/*
 * @noThrow
 */
func getPackageByQualifiedName(qualifiedName: CPointer<UInt8>): CPointer<Unit>

@Intrinsic
/*
 * @noThrow
 */
func getPackageVersion(packageInfo: CPointer<Unit>): CPointer<UInt8>

@Intrinsic
/*
 * @noThrow
 */
func getSubPackages(packageInfo: CPointer<Unit>, arrayTi: CPointer<Unit>): Any
