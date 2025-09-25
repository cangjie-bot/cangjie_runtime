







package std.net

import std.io.*
























public interface StreamingSocket <: IOStream & Resource & ToString {





    prop localAddress: SocketAddress




    prop remoteAddress: SocketAddress









    mut prop readTimeout: ?Duration









    mut prop writeTimeout: ?Duration
}











public interface DatagramSocket <: Resource & ToString {





    prop localAddress: SocketAddress




    prop remoteAddress: ?SocketAddress








    mut prop receiveTimeout: ?Duration









    mut prop sendTimeout: ?Duration












    /*
     * @noThrow
     */
    func receiveFrom(buffer: Array<Byte>): (SocketAddress, Int64)






    /*
     * @noThrow
     */
    func sendTo(address: SocketAddress, payload: Array<Byte>): Unit
}

public interface ServerSocket <: Resource & ToString {




    prop localAddress: SocketAddress





    /*
     * @noThrow
     */
    func bind(): Unit









    /*
     * @noThrow
     */
    func accept(timeout!: ?Duration): StreamingSocket






    /*
     * @noThrow
     */
    func accept(): StreamingSocket {
        accept(timeout: None)
    }
}
