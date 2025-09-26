






protected package std.deriving.impl

import std.deriving.api.*
import std.ast.*
import std.collection.*

/**
 * @throws ASTException
 * @throws NoneValueException
 * @throws IndexOutOfBoundsException
 * @throws IllegalArgumentException
 */
func settingsForEnum(
    inputOptions: InputOptions,
    enumDecl: EnumDecl,
    logger: Logger
): SettingsOutput {
    let allCases = enumDecl.allCases()
    let allProperties = enumDecl.allProperties()

    let includedSet = inputOptions.included |> collectHashSet

    let includedProperties = allProperties |> filter { p: PropDecl =>
        includedSet.contains(Identifier(p.identifier))
    } |> collectArray

    let namedAttributesMap = HashMap(includedProperties |>
        map { p: PropDecl =>
            let att = TargetNamedAttribute.PropertyAttribute(p)
            (att.identifier, att)
        } |> collectArray)

    let namedAttributes = if (inputOptions.ordering.isEmpty()) {
        includedProperties |> map { p: PropDecl => namedAttributesMap[Identifier(p.identifier)] } |> collectArray
    } else { inputOptions.ordering |> map { id: Identifier => namedAttributesMap[id] } |> collectArray }

    let settings = DerivingSettings(
        mapInterfaceSettings(enumDecl.generics(), inputOptions.origin, logger),
        [],
        allCases,
        inputOptions.ordering,
        includedProperties
    )

    let target = DerivingTarget(
        inputOptions.decl,
        namedAttributes,
        allCases,
        settings
    )

    return SettingsOutput(settings, target)
}
