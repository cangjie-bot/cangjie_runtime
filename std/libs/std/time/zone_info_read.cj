










package std.time
foreign func CJ_TIME_GetFileSize(path: CPointer<Byte>, pathLen: Int64): Int64
foreign func CJ_TIME_ReadAllBytesFromFile(path: CPointer<Byte>, pathLen: Int64, buf: CPointer<Byte>, bufLen: Int64): Int64





func loadTimeZone(name: String, source: String): TimeZone {
    return TimeZone.loadFromTZData(name, loadTZifData(name, source))
}




func loadTZifData(name: String, source: String): Array<UInt8> {
    let srcLen = source.size
    if (srcLen <= 0) {
        throw InvalidDataException("invalid timezone source")
    }
    let path = source + SLASH_CHAR + name
    return loadTZifData(path)
}

func loadTZifData(path: String): Array<UInt8> {
    unsafe {
        let cPath: CPointerHandle<UInt8> = acquireArrayRawData(path.rawData())
        let pathLen: Int64 = path.size
        let fileSize = CJ_TIME_GetFileSize(cPath.pointer, pathLen)
        releaseArrayRawData(cPath)
        if (fileSize < 0) {
            throw InvalidDataException("An error occurred when accessing file `${path}`!")
        }
        let bufLen: Int64 = fileSize + 1
        var arr: Array<UInt8> = Array<UInt8>(fileSize + 1, repeat: 0)

        let cPath2: CPointerHandle<UInt8> = acquireArrayRawData(path.rawData())
        var arrPtr: CPointerHandle<UInt8> = acquireArrayRawData(arr)
        var readNum = CJ_TIME_ReadAllBytesFromFile(cPath2.pointer, pathLen, arrPtr.pointer, bufLen)
        releaseArrayRawData(arrPtr)
        releaseArrayRawData(cPath2)
        if (readNum != fileSize) {
            throw InvalidDataException("An error occurred when reading data from file `${path}`!")
        }
        arr.slice(0, fileSize)
    }
}









func parseTZinfoData(data: Array<UInt8>): (Array<LocalTime>, Array<TransTime>, String) {
    var arrReader = ArrReader(data)












    let (isUTCnt, isStdCnt, leapCnt, timeCnt, typeCnt, charCnt) = (0, 1, 2, 3, 4, 5)
    var (version, fields) = parseHeader(arrReader)



















    var timeSize = 4
    if (version > 1) {
        arrReader.skip(fields[timeCnt] * timeSize + fields[timeCnt] + fields[typeCnt] * 6 + fields[charCnt] +
                       fields[leapCnt] * (4 + timeSize) + fields[isStdCnt] + fields[isUTCnt])



        timeSize = 8




        (version, fields) = parseHeader(arrReader)
    }

    var transTimes = arrReader.getNext(fields[timeCnt] * timeSize)
    var transTypes = arrReader.getNext(fields[timeCnt])
    var typeRecords = arrReader.getNext(fields[typeCnt] * 6)
    var zoneDes = arrReader.getNext(fields[charCnt])
    arrReader.getNext(fields[leapCnt] * (timeSize + 4))
    arrReader.getNext(fields[isStdCnt])
    arrReader.getNext(fields[isUTCnt])

    let zoneNum = fields[typeCnt]
    var zones: Array<LocalTime> = parseZones(zoneNum, typeRecords, zoneDes)
    if (zones.size <= 0) {
        throw InvalidDataException("Failed to parse the timezone file.")
    }
    let timeNum = fields[timeCnt]
    var TransTime: Array<TransTime> = parseZoneTrans(timeNum, zoneNum, transTimes, transTypes, timeSize)





    var footer = ""
    let last = arrReader.getLast()
    let asciiCodeOfLn: UInt8 = b'\n'
    if (version == 1) {
        if (last.size == 0) {
            return (zones, TransTime, footer)
        }
        throw InvalidDataException("Failed to parse the timezone file.")
    }
    if (last.size > 2 && last[0] == asciiCodeOfLn && last[last.size - 1] == asciiCodeOfLn) {
        footer = itos(last[1..last.size - 1], false)
        if (footer == "") {
            throw InvalidDataException("Failed to parse the timezone file.")
        }
    }
    return (zones, TransTime, footer)
}

func parseHeader(arrReader: ArrReader): (Int64, Array<Int64>) {
    let magic = arrReader.getNext(4)
    if (magic != [b'T', b'Z', b'i', b'f']) {
        throw InvalidDataException("Failed to parse the timezone file.")
    }

    var version: Int64
    match (arrReader.getNext(1)[0]) {
        case b'\0' => version = 1
        case b'2' => version = 2
        case b'3' => version = 3
        case _ => throw InvalidDataException("Failed to parse the timezone file.")
    }
    arrReader.getNext(15) 
    return (version, parseFields(arrReader))
}










@OverflowWrapping
func parseFields(arrReader: ArrReader): Array<Int64> {
    let fields = Array<Int64>(6, repeat: 0)
    let fieldCnt = 6
    for (i in 0..fieldCnt) {
        fields[i] = Int64(Int32((UInt32(arrReader.arr[arrReader.index + 3]) | 
                                (UInt32(arrReader.arr[arrReader.index + 2]) << 8) | 
                                (UInt32(arrReader.arr[arrReader.index + 1]) << 16) | 
                                (UInt32(arrReader.arr[arrReader.index]) << 24))))
        arrReader.skip(4)
    }
    return fields
}














@OverflowWrapping
func parseZones(zoneNum: Int64, typeRecords: Array<UInt8>, zoneDes: Array<UInt8>): Array<LocalTime> {
    if (zoneNum <= 0) {
        throw InvalidDataException("Failed to parse the timezone file.")
    }
    var zonedata = ArrReader(typeRecords)
    var zone = Array<LocalTime>(zoneNum, {_ => LocalTime()})
    let minUTOff = -89999
    let maxUTOff = 93599
    for (i in 0..zoneNum) {
        let utoffArr = zonedata.getNext(4)
        let utoff = Int32((UInt32(utoffArr[3])) |
                          (UInt32(utoffArr[2]) << 8) |
                          (UInt32(utoffArr[1]) << 16) |
                          (UInt32(utoffArr[0]) << 24))
        if (Int64(utoff) < minUTOff || Int64(utoff) > maxUTOff) {
            throw InvalidDataException("Failed to parse the timezone file.")
        }
        zone[i].offset = utoff
        let dst = (zonedata.getNext(1))[0]
        zone[i].isDST = dst != 0
        let idx = (zonedata.getNext(1))[0]
        if (Int64(idx) >= zoneDes.size) {
            throw InvalidDataException("Failed to parse the timezone file.")
        }
        zone[i].des = itos(zoneDes[Int64(idx)..zoneDes.size], true)
    }
    return zone
}




func itos(arr: Array<UInt8>, canNul: Bool): String {
    for (i in 0..arr.size) {
        if (arr[i] == 0x00) {
            if (!canNul) {
                return ""
            }
            return unsafe { String.fromUtf8Unchecked(arr[..i]) }
        }
        if (!arr[i].isAsciiWhiteSpace() && !arr[i].isAsciiGraphic()) {
            throw InvalidDataException(
                "Failed to parse the timezone file, since ${arr[i]} is not a supported ASCII code.")
        }
    }
    return unsafe { String.fromUtf8Unchecked(arr) }
}

















@OverflowWrapping
func parseZoneTrans(
    timeNum: Int64,
    zoneNum: Int64,
    transTimes: Array<UInt8>,
    transTypes: Array<UInt8>,
    timeSize: Int64
): Array<TransTime> {
    var transArr = Array<TransTime>(timeNum, {_ => TransTime()})
    let ttReader = ArrReader(transTimes)
    if (timeNum == 0) {
        return Array<TransTime>(1, repeat: TransTime(Int64.Min, 0))
    }

    for (i in 0..timeNum) {
        if (timeSize == 4) {
            let when = ttReader.getNext(4)
            transArr[i].trans = Int64(Int32((UInt32(when[3])) |
                                            (UInt32(when[2]) << 8) |
                                            (UInt32(when[1]) << 16) |
                                            (UInt32(when[0]) << 24)))
        } else if (timeSize == 8) {
            let when = ttReader.getNext(8)
            transArr[i].trans = Int64((UInt64(when[7])) |
            (UInt64(when[6]) << 8) |
            (UInt64(when[5]) << 16) |
            (UInt64(when[4]) << 24) |
            (UInt64(when[3]) << 32) |
            (UInt64(when[2]) << 40) |
            (UInt64(when[1]) << 48) |
            (UInt64(when[0]) << 56))
        } else {
            throw InvalidDataException("Failed to parse the timezone file.")
        }
        if (Int64(transTypes[i]) >= zoneNum) {
            InvalidDataException("Failed to parse the timezone file.")
        }
        transArr[i].index = transTypes[i]
    }
    return transArr
}

class ArrReader {
    var arr: Array<UInt8>
    var index: Int64 = 0

    init(arr: Array<UInt8>) {
        this.arr = arr
    }

    func skip(len: Int64): Unit {
        index += len
        if (index >= arr.size) {
            throw InvalidDataException("Failed to parse the timezone file.")
        }
    }

    func getNext(len: Int64): Array<UInt8> {
        var subArr = Array<UInt8>()
        try {
            subArr = arr.slice(index, len)
            index += len
        } catch (_) {
            throw InvalidDataException("Failed to parse the timezone file.")
        }
        return subArr
    }

    func getLast(): Array<UInt8> {
        var subArr = Array<UInt8>()
        try {
            subArr = arr.slice(index, arr.size - index)
            index = arr.size
        } catch (_) {
            throw InvalidDataException("Failed to parse the timezone file.")
        }
        return subArr
    }
}
