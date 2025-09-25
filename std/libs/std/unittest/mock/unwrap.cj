






package std.unittest.mock

interface UntypedOption {
    /*
     * @noThrow
     */
    func value(): ?Any
}

extend<T> Option<T> <: UntypedOption {
    /*
     * @noThrow
     */
    public func value(): ?Any {
        match (this) {
            case Some(v) => Some(v)
            case None => None
        }
    }
}




/*
 * @noThrow
 */
func unwrapValue<T>(value: Any): ?T {
    match (value) {
        case ofRequiredType: T => ofRequiredType
        case optional: UntypedOption =>
            match (optional.value()) {
                case Some(innerValue) => unwrapValue<T>(innerValue)
                case None => None
            }
        case _ => None
    }
}
