






macro package std.unittest.testmacro

import std.ast.*
import std.collection.*

func parseNamedCommaSeparatedExpressions(params: Tokens): Array<(Token, Expr)> {
    let paramSpec = parseExpr(quote(foo($params)))
    let callExpr = (paramSpec as CallExpr).getOrThrow()
    var callInfo: ArrayList<(Token, Expr)> = ArrayList<(Token, Expr)>()
    for (arg in callExpr.arguments) {
        callInfo.add((arg.identifier, arg.expr))
    }
    collectArray(callInfo)
}


func parseConfigurationMacro(params: Tokens): Array<(Token, Expr)> {
    try {
        parseNamedCommaSeparatedExpressions(params)
    } catch (_: Exception) {
        throw MacroException(
            "Illegal parameters for @Configure: ${params}," +
            "parameters should use the form @Configure[arg1: value1, arg2: value2, arg3: value3]"
        )
    }
}

func parseMeasurements(params: ArrayList<Tokens>): Array<Expr> {
    let measurements = ArrayList<Expr>()
    for (measureEntry in params) {
        var hasMeasurement = false
        try {
            for (measurement in parseCommaSeparatedExpressions(measureEntry)) {
                measurements.add(measurement)
                hasMeasurement = true
            }
        } catch (_: Exception) {
            throw MacroException("Illegal usage of @Measure: ${measureEntry}," +
            "parameters should use the form @Measure[Measurement1, Measurement2, Measurement3]," +
            "where Measurement<1,2,3> are instances of Measurement such as TimeNow()")
        }
        if (!hasMeasurement) {
            throw MacroException("Illegal usage of @Measure: expected minimum 1 argument")
        }
    }
    measurements.toArray()
}

func skipNl(tokens: Tokens, pos: Int64): Int64 {
    var next = pos
    while (next < tokens.size && tokens[next].kind == NL) {
        next += 1
    }
    next
}


func parseDSLMacro(params_: ?Tokens): Array<(String, Tokens)> {
    let params = params_ ?? return []
    try {
        parseDSL(params)
    } catch (ex: Exception) {
        throw MacroException(
            "Illegal parameters for @Test: ${params}," +
            "parameters should use the form @Test[arg1 in (0..12), arg2 in [1,2,3,4], arg3 in random<Int64>()], error details:" +
            ex.message
        )
    }
}

func parseDSL(params: Tokens): Array<(String, Tokens)> {
    var i = 0
    let result = ArrayList<(String, Tokens)>()
    var leftPart: Expr = Block()
    var rightPart: Expr = Block()
    while (i < params.size) {
        (leftPart, i) = parseExprFragment(params, startFrom: i)
        if (params.get(i).kind != IN) {
            throw Exception("Expected 'in' keyword.")
        }
        (rightPart, i) = parseExprFragment(params, startFrom: i + 1)
        if (i < params.size && params[i].kind != COMMA) {
            throw Exception("Expected comma.")
        }
        i = skipNl(params, i + 1)
        match (leftPart) {
            case left: MemberAccess where (left.baseExpr as RefExpr)?.identifier.value == Some("config") =>
                let paramName = Token(STRING_LITERAL, left.field.value)
                result.add(("_", quote(
                    DataStrategyProcessor.start($rightPart, $paramName)
                        .mapWithConfig<Unit>{ x, config: Configuration =>
                            $left (x)
                        }
                )))
            case left: RefExpr where left.typeArguments.isEmpty() => result.add((left.identifier.value, rightPart.toTokens()))
            case _ => throw Exception("Left part of the parameter must consist of a single identifier or expression in a form of `config.<identifier>` ")
        }
    }
    result.toArray()
}




private func createOptionFQName(identifier: Token): Tokens {
    let nameStr = identifier.value

    let structName = Token(TokenKind.IDENTIFIER, "Key" + nameStr[0..1].toAsciiUpper() + nameStr[1..])
    return quote($structName.$identifier)
}








func buildConfiguration(
    raw: Array<(Token, Expr)>,
    variableName: Token,
    builder: TokensBuilder
): TokensBuilder {
    builder.append(quote(let $variableName = Configuration())).append(NL)
    for ((identifier, value) in raw) {
        let keyFQName = createOptionFQName(identifier)
        builder.append(quote($variableName.set($keyFQName, $value))).append(NL)
    }
    return builder
}












func buildDataStrategy(
    raw: ArrayList<(String, Tokens)>,
    argNames: Array<String>,
    argTypes: Array<Tokens>,
    variableName: Token,
    resultingType!: Tokens = Tokens(),
    builder!: TokensBuilder = TokensBuilder()
): TokensBuilder {
    if (resultingType.size == 0) {
        builder.append(quote(let $variableName = ))
    } else {
        builder.append(quote(let $variableName : $resultingType =))
    }

    buildDataStrategyForArgs(
        raw,
        argNames,
        argTypes,
        builder: builder
    )
    for ((name, strat) in raw where name == "_") {
        builder.append(quote(
            .productWithUnit($strat)
        ))
    }

    builder
}

func buildDataStrategyForArgs(
    raw: ArrayList<(String, Tokens)>,
    argNames: Array<String>,
    argTypes: Array<Tokens>,
    builder!: TokensBuilder = TokensBuilder()
): TokensBuilder {
    if (argNames.size != argTypes.size) {
        throw MacroException("Argument names and argument types must have the same size")
    }
    let argMap = HashMap<String, Tokens>(raw)

    let strategies = Array(argNames.size) { ix: Int64 =>
        let strat = argMap.get(argNames[ix]) ??
            throw MacroException("No strategy provided for argument ${argNames[ix]}: ${argTypes[ix].toTokens()}")
        strat
    }

    if (strategies.size == 0) {
        builder.append(quote( DataStrategyProcessor<Unit>.start( { => [()] } ,"" ) )).append(NL)
        return builder
    }


    builder.append(
        quote( DataStrategyProcessor<$(argTypes[0])>.start( { => $(strategies[0]) } ,$(argNames[0]) ) )
    ).append(NL)
    for (i in 1..strategies.size) {
        builder.append(quote(.product(
                DataStrategyProcessor<$(argTypes[i])>.start( { => $(strategies[i]) } ,$(argNames[i]) )
            )) ).append(NL)
    }

    return builder
}
