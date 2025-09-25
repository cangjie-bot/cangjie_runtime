







package std.database.sql

public enum ConnectionState <: Equatable<ConnectionState> {






    | Broken




    | Closed




    | Connecting




    | Connected

    public operator func ==(rhs: ConnectionState): Bool {
        match ((this, rhs)) {
            case (Broken, Broken) => true
            case (Closed, Closed) => true
            case (Connecting, Connecting) => true
            case (Connected, Connected) => true
            case _ => false
        }
    }

    public operator func !=(rhs: ConnectionState): Bool {
        return !(this == rhs)
    }
}
