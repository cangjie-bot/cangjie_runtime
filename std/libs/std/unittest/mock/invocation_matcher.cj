






package std.unittest.mock

import std.collection.*
import std.unittest.mock.internal.ParameterInfo

enum MatchStatus {
    Ok
    | FuncMismatch
    | ReceiverMismatch
      /*
       * @noThrow
       */
    | ArgumentMismatch(  Array<Int64>)
      /*
       * @noThrow
       */
    | TypeArgMismatch(  Array<Int64>)
}

struct StubDescription {
    /*
     * @noThrow
     */
    StubDescription(
        let fullCall: String,
        let prefixRefName: Option<String>,
        let location: Location
    ) {}
}
class InvocationMatcher {
    let positionalMatchers = ArrayList<ArgumentMatcher>()

    /*
     * @throws MockFrameworkException
     * @throws IndexOutOfBoundsException
     * @throws MockFrameworkInternalError
     * @throws IllegalArgumentException
     */
    InvocationMatcher(
        argumentMatchers: Array<ArgumentMatcher>,
        let typeParameters: Array<String>,
        let stubId: StubId,
        let description: StubDescription
    ) {
        let positionalParams = ArrayList<ParameterInfo>()
        let namedParams = ArrayList<ParameterInfo>()
        for (param in stubId.funcInfo.params) {
            if (!param.isNamed) {
                positionalParams.add(param)
            } else {
                namedParams.add(param)
            }
        }
        for ((index, param) in positionalParams |> enumerate) {
            if (param.position - 1 != index) {
                internalError("Inconsistent information for ${stubId.funcInfo.id.shortName}")
            }
            let matcherByPosition = argumentMatchers.get(index) ?? internalError(
                InconsistentState(
                    "Wrong number of matchers provided: ${argumentMatchers.size}" +
                        ", declaration has ${stubId.funcInfo.params.size} parameters"))
            positionalMatchers.add(matcherByPosition)
        }
        for (param in namedParams) {
            if (param.position - 1 != positionalMatchers.size) {
                internalError("Inconsistent information for ${stubId.funcInfo.id.shortName}")
            }
            let matchersWithThisName = argumentMatchers |>
                filter {
                matcher: ArgumentMatcher => matcher.getParameterName() == Some(param.name)
            } |> collectArray
            match (matchersWithThisName.size) {
                case 1 => positionalMatchers.add(matchersWithThisName[0])
                case 0 => positionalMatchers.add(Matchers.any())
                case _ => illegalInput("Several matchers with the same parameter name: ${param.name}")
            }
        }
    }

    /*
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    func tryMatch(invocation: Invocation): MatchStatus {
        if (invocation.stubId.funcInfo.id != stubId.funcInfo.id) {
            return MatchStatus.FuncMismatch
        }
        if (invocation.stubId.receiverId != stubId.receiverId) {
            return MatchStatus.ReceiverMismatch
        }

        let typeArgsMismatchedPositions = ArrayList<Int64>()
        for (typeArgPosition in 0..invocation.call.typeArgs.size) {
            if (invocation.call.typeArgs[typeArgPosition] != typeParameters[typeArgPosition]) {
                typeArgsMismatchedPositions.add(typeArgPosition)
            }
        }
        if (!typeArgsMismatchedPositions.isEmpty()) {
            return MatchStatus.TypeArgMismatch(typeArgsMismatchedPositions.toArray())
        }

        let mismatchedPositions = ArrayList<Int64>()
        for (argumentPosition in 0..invocation.call.args.size) {
            if (!positionalMatchers[argumentPosition].matchesAny(invocation.call.args[argumentPosition])) {
                mismatchedPositions.add(argumentPosition)
            }
        }
        if (!mismatchedPositions.isEmpty()) {
            return MatchStatus.ArgumentMismatch(mismatchedPositions.toArray())
        }
        return MatchStatus.Ok
    }

    /*
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    func matches(invocation: Invocation): Bool {
        match (tryMatch(invocation)) {
            case Ok => true
            case _ => false
        }
    }
}
