







package std.net

type sa_family_t = UInt16

type in_port_t = UInt16

type socklen_t = UInt32

type SockAddrByte = Byte

@C
struct AddrInfo {
    
    var ai_flags: Int32 = 0
    
    var ai_family: Int32 = 0
    
    var ai_socktype: Int32 = 0
    
    var ai_protocol: Int32 = 0
    
    var ai_addrlen: socklen_t = 0






    var ptr1 = CPointer<Unit>()
    var ptr2 = CPointer<Unit>()
    
    var ai_next = CPointer<AddrInfo>()
}

@C
struct SockAddrIn {
    var family: sa_family_t = 0 
    var port: in_port_t = 0 
    var addr: UInt32 = 0 
    let pad: Int64 = 0
}

@C
struct SockAddrIn6 {
    var family: sa_family_t = 0 
    var port: in_port_t = 0 
    var flowinfo: UInt32 = 0
    var addr: UInt32 = 0
    var pad1: UInt32 = 0
    var pad2: UInt32 = 0
    var pad3: UInt32 = 0
    var scope_id: UInt32 = 0 
}

type PAddrinfo = CPointer<AddrInfo>

foreign func getaddrinfo(node: CString, service: CPointer<Byte>, hints: PAddrinfo, res: CPointer<PAddrinfo>): Int32

foreign func freeaddrinfo(res: PAddrinfo): Unit

foreign func CJ_SOCKET_GetAddrFromAddrinfo(info: CPointer<AddrInfo>): CPointer<SockAddrByte>

struct SockAddrUn {
    var family: sa_family_t = 0 
    var sun_path = Array<Byte>(108, repeat: 0) 
}
