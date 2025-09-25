










package std.fs

foreign {
    func CJ_FS_NormalizePath(path: CString, realPath: CPointer<UInt8>): CPointer<FsError>
    func CJ_FS_PathSize(path: CString): Int64
    func CJ_FS_GetCreationTime(path: CString): Int64
    func CJ_FS_GetLastAccessTime(path: CString): Int64
    func CJ_FS_GetLastModificationTime(path: CString): Int64

    func CJ_FS_IsReadOnly(path: CString): Int8

    func CJ_FS_CanRead(path: CString): Int8
    func CJ_FS_CanWrite(path: CString): Int8
    func CJ_FS_CanExecute(path: CString): Int8

    func CJ_FS_SetExecutable(path: CString, executable: Bool): Int8
    func CJ_FS_SetReadable(path: CString, readable: Bool): Int8
    func CJ_FS_SetWritable(path: CString, writable: Bool): Int8
    func CJ_FS_DirGetNumber(path: CString): Int64
    func CJ_FS_ISDirEmpty(path: CString): Int8
    func CJ_FS_DirGetData(path: CString, buffer: CPointer<Byte>, bufferLen: Int64): Int64
    func CJ_FS_DirCreate(path: CString): CPointer<FsError>
    func CJ_FS_DirCreateRecursive(path: CString): CPointer<FsError>
    func CJ_FS_CreateTempDir(path: CPointer<Byte>): Bool
    func CJ_FS_CopyREF(srcPath: CString, destPath: CString): Int8
    func CJ_FS_CopyLink(srcPath: CString, destPath: CString): Int8
    func CJ_FS_OpenFile(path: CString, openMode: Int32): CPointer<FsInfo>
    func CJ_FS_Seek(fd: FileHandle, whence: Int32, offset: Int64): Int64
    func CJ_FS_CloseFile(fd: FileHandle): Int64
    func CJ_FS_GetFileSize(fd: FileHandle): Int64
    func CJ_FS_FileRead(fd: FileHandle, buffer: CPointer<Byte>, maxLen: UIntNative): Int64
    func CJ_FS_FileWrite(fd: FileHandle, buffer: CPointer<Byte>, maxLen: UIntNative): Bool
    func CJ_FS_Truncate(fd: FileHandle, length: Int64): CPointer<FsError>

    func CJ_FS_CreateTempFile(path: CPointer<Byte>): FileHandle
    func CJ_FS_IsLink(path: CString): Int8
    func CJ_FS_IsFile(path: CString): Int8
    func CJ_FS_IsDir(path: CString): Int8

    func CJ_FS_IsFileORLinkToFile(path: CString): Int8
    func CJ_FS_IsDirORLinkToFDir(path: CString): Int8

    func CJ_FS_Exists(path: CString): Int8
    func CJ_FS_Remove(path: CString, recursive: Bool): CPointer<FsError>
    func CJ_FS_Rename(sourcePath: CString, destinationPath: CString): CPointer<FsError>

    func CJ_FS_ErrnoGet(): Int32
    func CJ_FS_FormatMessage(errnoValue: Int32): CString
    func CJ_FS_ErrmesGet(errnoValue: Int32): CString

    func CJ_FS_Link(linkPath: CString, originPath: CString): CPointer<FsError>
    func CJ_FS_SymLink(linkPath: CString, originPath: CString): CPointer<FsError>
    func CJ_FS_ReadLink(path: CString): CPointer<FsError>
}



@C
struct FsError {
    let rtnCode: Int64 = -1
    let msg: CString = CString(CPointer<UInt8>())
}

@C
struct FsInfo {
    let fd: FileHandle = InvalidHandle
    let msg: CString = CString(CPointer<UInt8>())
}
