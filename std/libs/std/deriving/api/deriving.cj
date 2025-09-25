






protected package std.deriving.api

import std.ast.*

public interface Deriving {
    prop name: String
    prop description: String

    prop supportedInterfaces: Array<QualifiedName>


    func queryInterfaceInfo(interfaceName: QualifiedName): DerivingInterfaceInfo









    func derive(input: Tokens, target: DerivingTarget, logger: Logger): Tokens
}
