







package std.core



public enum Endian {
    Big | Little



    public static prop Platform: Endian {
        /*
         * @throws Exception
         */
        get() {
            let code = unsafe {
                CJ_PlatformEndian()
            }

            match (code) {
                case 1 => Big
                case 2 => Little
                case _ => throw Exception("Platform endian detection failed")
            }
        }
    }
}

foreign func CJ_PlatformEndian(): UInt8
