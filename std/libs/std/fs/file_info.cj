









package std.fs

import std.time.*

public struct FileInfo <: Equatable<FileInfo> {
    var _path: Path

    public init(path: Path) {
        this(path, true)
    }

    public init(path: String) {
        this(Path(path), true)
    }


    init(path: Path, isCheckPath: Bool) {
        if (isCheckPath && !exists(path)) {
            throw FSException("The path `${path}` does not exist.")
        }
        _path = toAbsolutePath(path)
    }

    public prop name: String {
        get() {
            _path.fileName
        }
    }

    public prop parentDirectory: Option<FileInfo> {
        get() {
            let parent = _path.parent
            if (!parent.toString().isEmpty() && !isRootPath(_path.toString())) {
                return FileInfo(parent)
            }
            return None
        }
    }

    public prop path: Path {
        get() {
            _path
        }
    }


    public prop creationTime: DateTime {
        get() {
            let time = callNativeFunc(CJ_FS_GetCreationTime, "Failed to get creation time.")
            return DateTime.ofEpoch(second: time, nanosecond: 0)
        }
    }


    public prop lastAccessTime: DateTime {
        get() {
            let time = callNativeFunc(CJ_FS_GetLastAccessTime, "Failed to get last access time.")
            return DateTime.ofEpoch(second: time, nanosecond: 0)
        }
    }


    public prop lastModificationTime: DateTime {
        get() {
            let time = callNativeFunc(CJ_FS_GetLastModificationTime, "Failed to get last modification time.")
            return DateTime.ofEpoch(second: time, nanosecond: 0)
        }
    }


    public prop size: Int64 {
        get() {
            return callNativeFunc(CJ_FS_PathSize, "Failed to get file size.")
        }
    }


    public func isSymbolicLink(): Bool {
        return callNativeFunc(CJ_FS_IsLink)
    }


    public func isRegular(): Bool {
        return callNativeFunc(CJ_FS_IsFile)
    }


    public func isDirectory(): Bool {
        return callNativeFunc(CJ_FS_IsDir)
    }


    public func isReadOnly(): Bool {
        return callNativeFunc(CJ_FS_IsReadOnly)
    }

    public func isHidden(): Bool {
        let fileName = canonicalize(_path).fileName
        if (fileName.isEmpty()) {
            throw FSException("FileName is empty.")
        }
        return fileName[0] == b'.'
    }


    public func canExecute(): Bool {
        return callNativeFunc(CJ_FS_CanExecute, shouldFixLongPath: false)
    }


    public func canRead(): Bool {
        return callNativeFunc(CJ_FS_CanRead)
    }


    public func canWrite(): Bool {
        return callNativeFunc(CJ_FS_CanWrite)
    }



    public func setExecutable(executable: Bool): Bool {
        return callNativeFunc(CJ_FS_SetExecutable, executable)
    }



    public func setReadable(readable: Bool): Bool {
        return callNativeFunc(CJ_FS_SetReadable, readable)
    }



    public func setWritable(writable: Bool): Bool {
        return callNativeFunc(CJ_FS_SetWritable, writable, shouldFixLongPath: false)
    }


    private func callNativeFunc(nativeFunction: CFunc<(CString) -> Int8>, shouldFixLongPath!: Bool = true): Bool {
        unsafe {
            let pathStr = if (shouldFixLongPath) {
                fixLongPath(_path.toString())
            } else {
                _path.toString()
            }
            let cPath = LibC.mallocCString(pathStr)
            var ret: Int8 = nativeFunction(cPath)
            LibC.free(cPath)
            if (ret < 0) {
                throw FSException("Native function error.")
            }
            return ret > 0
        }
    }



    private func callNativeFunc(nativeFunction: CFunc<(CString, Bool) -> Int8>, flag: Bool,
        shouldFixLongPath!: Bool = true): Bool {
        unsafe {
            let pathStr = if (shouldFixLongPath) {
                fixLongPath(_path.toString())
            } else {
                _path.toString()
            }
            let cPath = LibC.mallocCString(pathStr)
            let ret: Int8 = nativeFunction(cPath, flag)
            LibC.free(cPath)
            if (ret == -1) {
                throw FSException("Native function error.")
            } else if (ret == -2) {
                throw FSException("Operation not permitted!")
            }
            return ret > 0
        }
    }


    private func callNativeFunc(nativeFunction: CFunc<(CString) -> Int64>, msg: String, shouldFixLongPath!: Bool = true): Int64 {
        unsafe {
            let pathStr = if (shouldFixLongPath) {
                fixLongPath(_path.toString())
            } else {
                _path.toString()
            }
            let cPath: CString = LibC.mallocCString(pathStr)
            let ret: Int64 = nativeFunction(cPath)
            LibC.free(cPath)
            if (ret < 0) {
                throw FSException(msg)
            }
            return ret
        }
    }

    public operator func ==(that: FileInfo): Bool {
        return _path == that.path
    }
}
