/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

/**
 * @file The file declares several util functions.
 */
package std.fs

private func checkCopy(sourcePath: Path, to: Path): Unit {
    if (sourcePath._rawPath.isEmpty() || to._rawPath.isEmpty()) {
        throw IllegalArgumentException("The path 'sourcePath' or 'to' cannot be empty!")
    }

    if (sourcePath._rawPath.contains(NULL_BYTE) || to._rawPath.contains(NULL_BYTE)) {
        throw IllegalArgumentException("The path 'sourcePath' or 'to' cannot contain null character!")
    }

    if (sourcePath == to) {
        throw FSException("'${sourcePath}' and '${to}' are the same path.")
    }
}

/**
 * @throws IllegalArgumentException if sourcePath or to is empty or contains null character
 * @throws FSException if paths are the same, destination exists without overwrite, or file type conflicts
 */
public func copy(sourcePath: Path, to!: Path, overwrite!: Bool = false): Unit {
    checkCopy(sourcePath, to)

    let fileInfo = FileInfo(sourcePath)
    let destInfo = if (exists(to)) {
        Some(FileInfo(to))
    } else {
        Option<FileInfo>.None
    }

    if (fileInfo.isRegular()) {
        if (let Some(info) <- destInfo) {
            if (!overwrite) {
                throw FSException("Destination path exists.")
            } else if (!info.isRegular()) {
                throw FSException("The target exists and the file type is different from the original file.")
            }
        }
        return File.copy(sourcePath._rawPath, to._rawPath, overwrite)
    } else if (fileInfo.isDirectory()) {
        if (let Some(info) <- destInfo) {
            if (!overwrite) {
                throw FSException("Destination path exists.")
            } else if (!info.isDirectory()) {
                throw FSException("The target exists and the file type is different from the original file.")
            }
        }
        return Directory.copy(sourcePath._rawPath, to._rawPath, overwrite)
    } else if (fileInfo.isSymbolicLink()) {
        if (let Some(info) <- destInfo) {
            if (!overwrite) {
                throw FSException("Destination path exists.")
            } else if (!info.isSymbolicLink()) {
                throw FSException("The target exists and the file type is different from the original file.")
            } else {
                remove(to)
            }
        }
        let target = SymbolicLink.readFrom(fileInfo._path)
        SymbolicLink.create(to, to: target)
        return
    }
    throw FSException("Unsupported file type.")
}

/**
 * @throws IllegalArgumentException if sourcePath or to is empty or contains null character
 * @throws FSException if paths are the same, destination exists without overwrite, or file type conflicts
 */
public func copy(sourcePath: String, to!: String, overwrite!: Bool = false): Unit {
    copy(Path(sourcePath), to: Path(to), overwrite: overwrite)
}

/**
 * @throws IllegalArgumentException if path is empty or contains null character
 * @throws FSException if failed to remove file or directory
 */
public func remove(path: Path, recursive!: Bool = false): Unit {
    remove(path._rawPath, recursive: recursive)
}

private func checkRemove(path: String): Unit {
    if (path.isEmpty()) {
        throw IllegalArgumentException("The path cannot be empty!")
    }
    if (path.contains(NULL_BYTE)) {
        throw IllegalArgumentException("The path cannot contain null character!")
    }
}

/**
 * @throws IllegalArgumentException if path is empty or contains null character
 * @throws FSException if failed to remove file or directory
 */
public func remove(path: String, recursive!: Bool = false): Unit {
    checkRemove(path)
    unsafe {
        try (cpath = LibC.mallocCString(path).asResource()) {
            let pret = CJ_FS_Remove(cpath.value, recursive)
            if (pret.isNull()) {
                throw FSException("Failed malloc in C code!")
            }
            let ret = pret.read()
            LibC.free(pret)
            if (ret.rtnCode == 0) {
                return
            }
            try {
                let errMessage = ret.msg.toString()
                throw FSException("Failed to remove file or directory: '${errMessage.trimAscii()}'.")
            } finally {
                LibC.free(ret.msg)
            }
        }
    }
}

/**
 * @throws IllegalArgumentException if path is empty or contains null character
 */
public func exists(path: Path): Bool {
    exists(path._rawPath)
}

/**
 * @throws IllegalArgumentException if path is empty or contains null character
 */
public func exists(path: String): Bool {
    if (path.isEmpty()) {
        throw IllegalArgumentException("The path cannot be empty!")
    }
    if (let Some(n) <- path.indexOf(NULL_BYTE)) {
        throw IllegalArgumentException("The path cannot contain null character!")
    }
    unsafe {
        let cPath = LibC.mallocCString(path)
        var ret: Int8 = CJ_FS_Exists(cPath)
        LibC.free(cPath)
        return ret == 0
    }
}

/**
 * @throws IllegalArgumentException if sourcePath or to is empty or contains null character
 * @throws FSException if paths are the same, destination exists without overwrite, or rename operation fails
 */
public func rename(sourcePath: String, to!: String, overwrite!: Bool = false): Unit {
    if (sourcePath.isEmpty() || to.isEmpty()) {
        throw IllegalArgumentException("The path cannot be empty!")
    }
    if (sourcePath.contains(NULL_BYTE) || to.contains(NULL_BYTE)) {
        throw IllegalArgumentException("The path cannot contain null character!")
    }

    if (Path(sourcePath) == Path(to)) {
        throw FSException("'${sourcePath}' and '${to}' are the same path.")
    }

    if (exists(to) && !overwrite) {
        throw FSException("Destination path exists.")
    }

    try (sourceCPath = unsafe { LibC.mallocCString(sourcePath).asResource() },
        destinationCPath = unsafe { LibC.mallocCString(to).asResource() }) {
        let resultptr = unsafe { CJ_FS_Rename(sourceCPath.value, destinationCPath.value) }
        if (resultptr.isNull()) {
            throw FSException("Failed malloc in C code!")
        }
        let result = unsafe { resultptr.read() }
        unsafe { LibC.free(resultptr) }
        if (result.rtnCode == 0) {
            return
        }
        try {
            let errMessage = result.msg.toString()
            throw FSException("${errMessage.trimAscii()}.")
        } finally {
            unsafe { LibC.free(result.msg) }
        }
    }
}

/**
 * @throws IllegalArgumentException if sourcePath or to is empty or contains null character
 * @throws FSException if paths are the same, destination exists without overwrite, or rename operation fails
 */
public func rename(sourcePath: Path, to!: Path, overwrite!: Bool = false): Unit {
    rename(sourcePath._rawPath, to: to._rawPath, overwrite: overwrite)
}

/**
 * @throws IllegalArgumentException if path is empty or contains null character
 * @throws FSException if failed to remove file or directory
 */
public func removeIfExists(path: Path, recursive!: Bool = false): Bool {
    if (exists(path)) {
        remove(path, recursive: recursive)
        return true
    }
    return false
}

/**
 * @throws IllegalArgumentException if path is empty or contains null character
 * @throws FSException if failed to remove file or directory
 */
public func removeIfExists(path: String, recursive!: Bool = false): Bool {
    removeIfExists(Path(path), recursive: recursive)
}
