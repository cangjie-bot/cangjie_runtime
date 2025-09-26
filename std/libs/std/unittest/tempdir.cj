






package std.unittest

import std.sync.ReentrantMutex
import std.random.Random
import std.fs.*
import std.env.getTempDirectory

class TempDirectory {
    private static const ID_SIZE: Int64 = 16
    private static const MAX_ATTEMPTS: Int64 = 100
    private static const BUFFER_SIZE: Int64 = 100
    private static let VOCAB = "abcdefghijklmnopqrstuvwxyz0123456789".toRuneArray()

    private let lock = ReentrantMutex()
    private let rnd = Random()
    private let buffer = Array<Rune>(ID_SIZE * BUFFER_SIZE, repeat: r'0')
    private var currentOffset = buffer.size
    private var tempDir: ?Path = None

        /**
         * @throws NoneValueException
         * @throws IllegalMemoryException
         * @throws IllegalArgumentException
         * @throws OutOfMemoryError
         * @throws IllegalSynchronizationStateException
         */
    prop path: Path {
        get() {
            synchronized(lock) {
                match (tempDir) {
                    case Some(dir) => return dir
                    case None =>
                        let dir = getDir()
                        tempDir = dir
                        return dir
                }
            }
        }
    }

    /**
     * @throws IllegalSynchronizationStateException
     * @throws NoneValueException
     * @throws IllegalMemoryException
     * @throws IllegalArgumentException
     * @throws OutOfMemoryError
     */
    private static func getDir(): Path {
        try {
            let dir = getTempDirectory()
            if (exists(dir)) {
                return dir
            }
        } catch (cause: Exception) {
            eprintln("Failed to find the temp directory: ${cause}")
        }

        return Path(".")
    }

    /**
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     * @throws IllegalSynchronizationStateException
     */
    private func nextId(): Array<Rune> {
        func fillBuffer() {
            for (index in 0..buffer.size) {
                buffer[index] = VOCAB[rnd.nextInt64(VOCAB.size)]
            }
            currentOffset = 0
        }

        synchronized(lock) {
            if (currentOffset >= buffer.size) {
                fillBuffer()
            }

            let startOffset = currentOffset
            currentOffset += ID_SIZE
            buffer[startOffset..startOffset + ID_SIZE].clone()
        }
    }

    /**
     * @throws IllegalSynchronizationStateException
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    private func nextId(prefix: String, suffix: String): String {
        let sb = StringBuilder()
        sb.append(prefix)
        sb.append(nextId())
        sb.append(suffix)
        return sb.toString()
    }

    /**
     * @throws OutOfMemoryError
     * @throws IllegalSynchronizationStateException
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     * @throws FSException
     * @throws NoneValueException
     * @throws IllegalMemoryException
     * @throws Exception
     */
    func createTempFile(dir!: Path = path, prefix!: String = "tempFile", suffix!: String = ".tmp"): File {
        for (_ in 0..MAX_ATTEMPTS) {
            let path = createTempPath(dir: dir, prefix: prefix, suffix: suffix)
            try {
                return File.create(path)
            } catch (_) {
            }
        }
        throw Exception("Too many attempts to create a temporary file")
    }

    /**
     * @throws OutOfMemoryError
     * @throws IllegalSynchronizationStateException
     * @throws IndexOutOfBoundsException
     * @throws FSException
     * @throws IllegalArgumentException
     * @throws NoneValueException
     * @throws IllegalMemoryException
     * @throws Exception
     */
    func createTempPath(dir!: Path = path, prefix!: String = "tempFile", suffix!: String = ".tmp"): Path {
        for (_ in 0..MAX_ATTEMPTS) {
            let path = dir.join(nextId(prefix, suffix))
            if (!exists(path)) {
                return path
            }
        }
        throw Exception("Too many attempts to create a temporary file")
    }
}
