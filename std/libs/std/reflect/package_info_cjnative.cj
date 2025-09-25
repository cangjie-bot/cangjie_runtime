







package std.reflect

import std.collection.*
import std.fs.*
import std.sync.*

const PACKAGE_LOAD_FAIL: UIntNative = 0
const MULTI_PACKAGE_INFO: UIntNative = 1
const REPEATED_PACKAGE_LOAD: UIntNative = 2
const REPEATED_FILENAME_LOAD: UIntNative = 3
@When[os == "Windows"]
const MODULE_SUFFIX = ".dll"
@When[os != "Windows"]
const MODULE_SUFFIX = ".so"


public class PackageInfo <: Equatable<PackageInfo> & Hashable & ToString {
    private static let filenameSet = HashSet<String>()
    private static let qualifiedNameMap = HashMap<String, PackageInfo>()
    private static let mutex = Mutex()

    let _packageInfo: CPointer<Unit>
    var _qualifiedName: ?String = None
    var _name: ?String = None

    var _typeInfos: ?Collection<TypeInfo> = None
    var _variables: ?Collection<GlobalVariableInfo> = None
    var _functions: ?Collection<GlobalFunctionInfo> = None
    var _version: ?String = None
    var _rootPackage: ?PackageInfo = None
    var _noPublicInfoList = ArrayList<TypeInfo>()

    /*
     * @noThrow
     */
    init(cp: CPointer<Unit>) {
        _packageInfo = cp
    }
    /*
     * @throws IllegalMemoryException
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     * @throws IllegalSynchronizationStateException
     * @throws InfoNotFoundException
     */
    public static func get(qualifiedName: String): PackageInfo {
        synchronized(mutex) {
            if (let Some(info) <- qualifiedNameMap.get(qualifiedName)) {
                return info
            }

            let cname = unsafe { LibC.mallocCString(qualifiedName) }
            var infoPointer = CPointer<Unit>()
            try {
                infoPointer = getPackageByQualifiedName(cname.getChars())
                if (infoPointer.isNull()) {
                    throw InfoNotFoundException("Cannot find specified package: `${qualifiedName}`.")
                }

                let info = PackageInfo(infoPointer)
                qualifiedNameMap.add(info.qualifiedName, info)
                info
            } finally {
                unsafe { LibC.free(cname) }
            }
        }
    }

    /*
     * @throws IllegalSynchronizationStateException
     * @throws IndexOutOfBoundsException
     * @throws FSException
     * @throws IllegalMemoryException
     * @throws ReflectException
     * @throws IllegalArgumentException
     */
    public static func load(path: String): PackageInfo {
        let realPath = try {
            canonicalize(if (!path.endsWith(MODULE_SUFFIX)) {
                path + MODULE_SUFFIX
            } else {
                path
            })
        } catch (e: FSException) {
            throw IllegalArgumentException("Failed to load `${path}` because of illegal path.")
        }

        synchronized(mutex) {
            if (filenameSet.contains(realPath.fileName)) {
                throw ReflectException("Try to load the same file twice, path: `${path}`.")
            }

            let cpath = unsafe { LibC.mallocCString(realPath.toString()) }
            try {
                let info: CPointer<Unit> = loadPackage(cpath.getChars())
                let result = info.toUIntNative()
                if (result == PACKAGE_LOAD_FAIL) {
                    throw ReflectException("Package `${path}` load failed.")
                } else if (result == MULTI_PACKAGE_INFO) {
                    throw ReflectException("Multiple package info has been found in `${path}`.")
                } else if (result == REPEATED_PACKAGE_LOAD) {
                    throw ReflectException("Try to load the same package twice, path: `${path}`.")
                } else if (result == REPEATED_FILENAME_LOAD) {
                    throw ReflectException("Try to load the same file twice, path: `${path}`.")
                } else {
                    filenameSet.add(realPath.fileName)
                    return PackageInfo(info)
                }
            } finally {
                unsafe { LibC.free(cpath) }
            }
        }
    }
    public prop qualifiedName: String {
        /*
         * @noThrow
         */
        get() {
            match (_qualifiedName) {
                case Some(res) => res
                case None =>
                    let name = CString(getPackageName(_packageInfo)).toString()
                    _qualifiedName = name
                    name
            }
        }
    }
    public prop name: String {
        /*
         * @throws IndexOutOfBoundsException
         * @throws IllegalArgumentException
         */
        get() {
            match (_name) {
                case Some(res) => res
                case None =>
                    let name = if (let Some(index) <- qualifiedName.lastIndexOf(".")) {
                        qualifiedName[index + 1..]
                    } else {
                        qualifiedName
                    }
                    _name = name
                    name
            }
        }
    }

    prop noPublicInfos: ArrayList<TypeInfo> {
        /*
         * @noThrow
         */
        get() {
            _noPublicInfoList
        }
    }
    public prop typeInfos: Collection<TypeInfo> {
        /*
         * @throws OutOfMemoryError
         * @throws IllegalSynchronizationStateException
         * @throws NoneValueException
         * @throws ReflectException
         * @throws IllegalArgumentException
         * @throws IndexOutOfBoundsException
         * @throws InfoNotFoundException
         */
        get() {
            match (_typeInfos) {
                case Some(res) => res
                case None =>
                    let infoList = ArrayList<TypeInfo>()
                    var subPackageInfo = _packageInfo
                    do {
                        let num = getPackageNumOfTypeInfos(subPackageInfo)
                        getTypeInfos(num, subPackageInfo, infoList)
                        subPackageInfo = getRelatedPackageInfo(subPackageInfo)
                    } while (!subPackageInfo.isNull())
                    _typeInfos = infoList
                    infoList
            }
        }
    }

    public prop version: String {
        /*
         * @noThrow
         */
        get() {
            match (_version) {
                case Some(version) => version
                case _ => CString(getPackageVersion(_packageInfo)).toString()
            }
        }
    }

    public prop subPackages: Collection<PackageInfo> {
        /*
         * @throws OutOfMemoryError
         * @throws NoneValueException
         * @throws ReflectException
         * @throws InfoNotFoundException
         * @throws IllegalArgumentException
         * @throws IndexOutOfBoundsException
         * @throws IllegalSynchronizationStateException
         */
        get() {
            synchronized(mutex) {
                getSubPackagesMap().values()
            }
        }
    }

    public prop parentPackage: PackageInfo {
        /*
         * @throws IllegalMemoryException
         * @throws IllegalArgumentException
         * @throws IndexOutOfBoundsException
         * @throws IllegalSynchronizationStateException
         * @throws InfoNotFoundException
         */
        get() {
            match (this.qualifiedName.lastIndexOf(b'.')) {
                case Some(idx) => PackageInfo.get(this.qualifiedName[..idx])
                case None => PackageInfo.get(this.qualifiedName)
            }
        }
    }

    public prop rootPackage: PackageInfo {
        /*
         * @throws IllegalMemoryException
         * @throws IllegalArgumentException
         * @throws IndexOutOfBoundsException
         * @throws IllegalSynchronizationStateException
         * @throws InfoNotFoundException
         */
        get() {
            match (this.qualifiedName.indexOf(b'.')) {
                case Some(idx) => PackageInfo.get(this.qualifiedName[..idx])
                case None => PackageInfo.get(this.qualifiedName)
            }
        }
    }

    /*
     * @throws OutOfMemoryError
     * @throws NoneValueException
     * @throws ReflectException
     * @throws IllegalSynchronizationStateException
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     * @throws InfoNotFoundException
     */
    public func getSubPackage(qualifiedName: String): PackageInfo {
        getSubPackagesMap().get(qualifiedName) ?? throw InfoNotFoundException(
            "Can not find subpackage: `${qualifiedName}`.")
    }

    /*
     * @throws OutOfMemoryError
     * @throws NoneValueException
     * @throws ReflectException
     * @throws InfoNotFoundException
     * @throws IllegalSynchronizationStateException
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    private func getSubPackagesMap(): HashMap<String, PackageInfo> {
        synchronized(mutex) {
            let infos = match (getSubPackages(_packageInfo, TypeInfo.of<Array<CPointer<Unit>>>()._info)) {
                case arr: Array<CPointer<Unit>> => arr
                case _ => Array<CPointer<Unit>>()
            }

            HashMap<String, PackageInfo>(infos.size) {
                idx =>
                let info = PackageInfo(infos[idx])
                qualifiedNameMap.add(info.qualifiedName, info)
                (info.qualifiedName, info)
            }
        }
    }

    /*
     * @throws OutOfMemoryError
     * @throws IllegalSynchronizationStateException
     * @throws NoneValueException
     * @throws ReflectException
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     * @throws InfoNotFoundException
     */
    func getTypeInfos(num: UInt32, subPackageInfo: CPointer<Unit>, infoList: ArrayList<TypeInfo>) {
        for (i in 0..num) {
            let pointer = getPackageTypeInfo(subPackageInfo, i)
            if (pointer.isNull()) {
                throw InfoNotFoundException("PackageInfo find typeInfo failed!")
            }

            if (isReflectUnsupportedType(pointer)) {
                continue
            }

            let info = TypeInfo.getOrCreate(pointer)
            if (!ModifierInfo.isPublic(getTypeInfoModifier(pointer))) {
                _noPublicInfoList.add(info)
            } else {
                infoList.add(info)
            }
        }
    }
    public prop variables: Collection<GlobalVariableInfo> {
        /*
         * @throws IllegalArgumentException
         * @throws IndexOutOfBoundsException
         * @throws InfoNotFoundException
         */
        get() {
            match (_variables) {
                case Some(res) => res
                case None =>
                    let infoList = ArrayList<GlobalVariableInfo>()
                    var subPackageInfo = _packageInfo
                    do {
                        let num = getPackageNumOfGlobalFieldInfos(subPackageInfo)
                        getGlobalVariableInfos(num, subPackageInfo, infoList)
                        subPackageInfo = getRelatedPackageInfo(subPackageInfo)
                    } while (!subPackageInfo.isNull())
                    _variables = infoList
                    infoList
            }
        }
    }

    /*
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     * @throws InfoNotFoundException
     */
    func getGlobalVariableInfos(num: UInt32, subPackageInfo: CPointer<Unit>, infoList: ArrayList<GlobalVariableInfo>) {
        for (i in 0..num) {
            let pointer = getPackageGlobalFieldInfo(subPackageInfo, i)
            if (pointer.isNull()) {
                throw InfoNotFoundException("PackageInfo find variableInfo failed!")
            }
            let varInfo = GlobalVariableInfo(pointer)
            infoList.add(varInfo)
        }
    }
    public prop functions: Collection<GlobalFunctionInfo> {
        /*
         * @throws InfoNotFoundException
         * @throws IndexOutOfBoundsException
         * @throws IllegalArgumentException
         */
        get() {
            match (_functions) {
                case Some(res) => res
                case None =>
                    let infoList = ArrayList<GlobalFunctionInfo>()
                    var subPackageInfo = _packageInfo
                    do {
                        let num = getPackageNumOfGlobalMethodInfos(subPackageInfo)
                        getGlobalFunctionInfos(num, subPackageInfo, infoList)
                        subPackageInfo = getRelatedPackageInfo(subPackageInfo)
                    } while (!subPackageInfo.isNull())
                    let infos = infoList.toArray()
                    _functions = infos
                    infos
            }
        }
    }

    /*
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     * @throws InfoNotFoundException
     */
    func getGlobalFunctionInfos(num: UInt32, subPackageInfo: CPointer<Unit>, infoList: ArrayList<GlobalFunctionInfo>) {
        for (i in 0..num) {
            let pointer = getPackageGlobalMethodInfo(subPackageInfo, i)
            if (pointer.isNull()) {
                throw InfoNotFoundException("PackageInfo find globalFunctionInfo failed!")
            }
            let funcName = getFuncName(pointer)
            if (funcName == constructorName) {
                continue
            }
            let funcInfo = GlobalFunctionInfo(pointer)
            funcInfo._name = funcName
            infoList.add(funcInfo)
        }
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
    public func getTypeInfo(qualifiedTypeName: String): TypeInfo {
        getByName(typeInfos, qualifiedTypeName,
            "type info `${qualifiedTypeName}` not found from package ${qualifiedName}") {
            typeInfo => typeInfo.qualifiedName
        }
    }
    /*
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     * @throws IllegalStateException
     * @throws InfoNotFoundException
     */
    public func getVariable(name: String): GlobalVariableInfo {
        getByName(variables, name, "variable info `${name}` not found from package `${qualifiedName}`") {
            variable => variable.name
        }
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
    public func getFunction(name: String, parameterTypes: Array<TypeInfo>): GlobalFunctionInfo {
        getByNameAndParamTypes(functions, name, parameterTypes,
            "func info `${name}` not found from package `${qualifiedName}`") {
            function => (function.name, function.parameters)
        }
    }

    /*
     * @throws InfoNotFoundException
     * @throws NoneValueException
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    public func getFunctions(name: String): Array<GlobalFunctionInfo> {
        var fns: ArrayList<GlobalFunctionInfo> = ArrayList<GlobalFunctionInfo>()
        for (fn in functions where fn.name == name) {
            fns.add(fn)
        }
        fns.toArray()
    }

    /*
     * @noThrow
     */
    public operator func ==(that: PackageInfo): Bool {
        this.hashCode() == that.hashCode()
    }

    /*
     * @noThrow
     */
    public operator func !=(that: PackageInfo): Bool {
        this.hashCode() != that.hashCode()
    }

    /*
     * @noThrow
     */
    public func hashCode(): Int64 {
        this._packageInfo.toUIntNative().hashCode()
    }

    /*
     * @noThrow
     */
    public func toString(): String {
        qualifiedName
    }
}
