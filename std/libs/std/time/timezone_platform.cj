












package std.time

import std.convert.*
import std.collection.ArrayList

@FastNative
foreign func CJ_TIME_GetLocalTimeOffset(): Int64

@When[os != "Windows"]
@FastNative
foreign func CJ_TIME_GetRealPath(path: CString): CString

@When[os == "Windows"]
func initLocal(): TimeZone {
    var timeZ = unsafe { LibC.mallocCString("TZ") }
    let ctz = unsafe { CJ_TIME_GetEnvVariable(timeZ) }
    unsafe { LibC.free(timeZ) }
    if (!ctz.isNull() && !ctz.isEmpty()) {
        let env = unsafe { LibC.mallocCString(TZPATH) }
        let envPath = unsafe { CJ_TIME_GetEnvVariable(env) }
        unsafe { LibC.free(env) }
        if (!envPath.isNull() && !envPath.isEmpty()) {
            var id = ctz.toString()
            let envPathArray = envPath.toString().split(SEPARATOR, removeEmpty: true)
            try {
                id = id.replace("\\", "/")
                let local = TimeZone.loadFromPaths(id, envPathArray)
                return local
            } catch (_) {
            }
        }
    }

    initLocalDefault()
}

@When[os != "Windows"]
/*
 * @throws ArithmeticException
 * @throws IllegalMemoryException
 * @throws IndexOutOfBoundsException
 * @throws OutOfMemoryError
 * @throws InvalidDataException
 * @throws IllegalArgumentException
 */
func initLocal(): TimeZone {
    var timeZ = unsafe { LibC.mallocCString("TZ") }
    let ctz = unsafe { CJ_TIME_GetEnvVariable(timeZ) }
    unsafe { LibC.free(timeZ) }

    if (!ctz.isNull() && !ctz.isEmpty()) {
        let id = ctz.toString()
        var envPathArray = ArrayList<String>(TZIF_SOURCE)
        let env = unsafe { LibC.mallocCString(TZPATH) }
        let envPath = unsafe { CJ_TIME_GetEnvVariable(env) }
        unsafe { LibC.free(env) }
        if (!envPath.isNull() && !envPath.isEmpty()) {
            envPathArray.add(all: envPath.toString().split(SEPARATOR, removeEmpty: true), at: 0)
        }
        try {
            let local = TimeZone.loadFromPaths(id, unsafe { envPathArray.getRawArray()[0..envPathArray.size] })
            return local
        } catch (_) {
        }
    }
    let clocalpath = unsafe { LibC.mallocCString(LOCALTIME_SRC) }
    let realpath = unsafe { CJ_TIME_GetRealPath(clocalpath) }
    unsafe { LibC.free(clocalpath) }
    if (!realpath.isNull()) {
        try {
            let path = realpath.toString()
            let name = getTimeZoneName(path)
            let tzdata = loadTZifData(path)
            return TimeZone.loadFromTZData(name, tzdata)
        } catch (_) {
        } finally {
            unsafe { LibC.free(realpath) }
        }
    }
    initLocalDefault()
}
/*
 * @throws ArithmeticException
 * @throws IllegalArgumentException
 */
func initLocalDefault(): TimeZone {
    let offset = unsafe { CJ_TIME_GetLocalTimeOffset() }
    if (offset == 0) {
        return TimeZone.UTC
    }
    let duration = Duration.minute * offset
    let hour = duration.toHours()
    let minute = duration.abs().toMinutes() % 60
    let name = "UTC${hour.format("+.2")}:${minute.format(".2")}"
    return TimeZone(name, duration)
}






@When[os != "Windows"]
/*
 * @throws IndexOutOfBoundsException
 * @throws IllegalArgumentException
 */
func getTimeZoneName(path: String): String {
    if (let Some(pos) <- path.lastIndexOf("zoneinfo")) {
        var substring = path[(pos + 8)..path.size]
        if (let Some(pos) <- substring.indexOf("/")) {
            return substring[pos + 1..]
        }
    }
    return "Local"
}
