







package std.net

enum Result<T> {
    /*
     * @noThrow
     */
            /*
             * @noThrow
             */
    Ok(T) | Err(Exception)

    /*
     * @noThrow
     */
    func isOk(): Bool {
        match (this) {
            case Ok(v) => true
            case Err(v) => false
        }
    }

    /*
     * @noThrow
     */
    func isErr(): Bool {
        return !isOk()
    }

    /*
     * @noThrow
     */
    func unwrap(): T {
        match (this) {
            case Ok(v) => return v
            case Err(v) => throw v
        }
    }

    /*
     * @throws Exception
     */
    func unwrapErr(): Exception {
        match (this) {
            case Ok(v) => throw Exception("called `Result.unwrapErr()` on an `Ok` value")
            case Err(v) => v
        }
    }

    /*
     * @noThrow
     */
    func toOption(): Option<T> {
        match (this) {
            case Ok(v) => v
            case Err(v) => None
        }
    }
}

extend<T> Result<T> <: ToString where T <: ToString {
    /*
     * @noThrow
     */
    public func toString(): String {
        match (this) {
            case Ok(v) => return v.toString()
            case Err(v) => return v.message
        }
    }
}
