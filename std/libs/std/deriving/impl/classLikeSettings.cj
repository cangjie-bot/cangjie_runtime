






protected package std.deriving.impl

import std.deriving.api.*
import std.ast.*
import std.collection.*

/**
 * @throws Exception
 * @throws IndexOutOfBoundsException
 * @throws IllegalArgumentException
 */
func settingsForClassLike(
    inputOptions: InputOptions,
    clazz: ClassLikeDecl,
    logger: Logger
): SettingsOutput {
    let allFields = clazz.allFields()
    let allProperties = clazz.allProperties()

    let includedSet = inputOptions.included |> collectHashSet
    let excludedSet = inputOptions.excluded |> collectHashSet

    let allFieldsMap = allFields |> associateBy<TargetNamedAttribute> { f => f.identifier }

    let excludedFields = excludedSet |>
        mapNotNone { id: Identifier => allFieldsMap.get(id) } |>
        collectArray

    let includedProperties = allProperties |> filter<PropDecl> { p =>
        includedSet.contains(Identifier(p.identifier))
    } |> collectArray

    let orderedFields = if (inputOptions.ordering.isEmpty()) {
        allFields |> filterFields(includedSet, excludedSet) |> collectArray
    } else {
        applyFieldsOrder(allFieldsMap, inputOptions.ordering, includedSet, excludedSet)
    }

    let interfaceSettings = mapInterfaceSettings(clazz.allGenerics(), inputOptions.origin, logger)

    let settings = DerivingSettings(
        interfaceSettings,
        excludedFields,
        [],
        inputOptions.ordering,
        includedProperties
    )

    let target = DerivingTarget(
        inputOptions.decl,
        orderedFields,
        [],
        settings
    )

    return SettingsOutput(settings, target)
}

/**
 * @throws IndexOutOfBoundsException
 * @throws IllegalArgumentException
 */
func applyFieldsOrder(
    allFieldsMap: HashMap<Identifier, TargetNamedAttribute>,
    userDefinedOrder: Array<Identifier>,
    includedSet: HashSet<Identifier>,
    excludedSet: HashSet<Identifier>
): Array<TargetNamedAttribute> {
    let ordered = userDefinedOrder |> mapNotNone<Identifier, TargetNamedAttribute> { id =>
        allFieldsMap.get(id)
    } |> filterFields(includedSet, excludedSet) |> collectArrayList

    let missing = allFieldsMap.values() |>
        filterFields(includedSet, excludedSet) |>
        filter<TargetNamedAttribute> { field =>
            !userDefinedOrder.contains(field.identifier)
        } |> collectArrayList

    ordered.add(all: missing)

    return ordered.toArray()
}

/**
 * @throws IndexOutOfBoundsException
 */
func filterFields(
    includedSet: HashSet<Identifier>,
    excludedSet: HashSet<Identifier>
): (it: Iterable<TargetNamedAttribute>) -> Iterator<TargetNamedAttribute> {{ iter =>
    iter |> filter<TargetNamedAttribute> { it =>
        match (it) {
            case PropertyAttribute(_) => includedSet.contains(it.identifier)
            case ConstructorFieldAttribute(_) => !excludedSet.contains(it.identifier)
            case FieldAttribute(_) => !excludedSet.contains(it.identifier)
        }
    }
}}
