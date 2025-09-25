






macro package std.unittest.testmacro

import std.ast.*
import std.collection.*
import std.collection.concurrent.ConcurrentHashMap
import std.sync.AtomicUInt64

type MacroAttrs = HashMap<MacroKey, ArrayList<Tokens>>
      /*
       * @noThrow
       */
class MacroStorage {
    private static let globalMutableState = ConcurrentHashMap<String, Tokens>()
    private static let globalCounter = AtomicUInt64(0)

    private static let testGeneratedPrefix = quote(@Attribute[TEST_GENERATED])
    private static let attrPrefix = quote(@Attribute[)

    /*
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     * @throws IllegalSynchronizationStateException
     */
    private static func store(key: MacroKey, args: Tokens): String {
        let index = globalCounter.fetchAdd(1)
        let uniqueId = "${key.attrPrefix}${index}"
        globalMutableState[uniqueId] = args
        return uniqueId
    }

    /*
     * @throws IllegalSynchronizationStateException
     * @throws Error
     * @throws NoneValueException
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    static func saveAsAttribute(key: MacroKey, declTokens: Tokens, args: Tokens): Tokens {
        let uniqueId = Token(IDENTIFIER, store(key, args))
        let tb = TokensBuilder()
        match {
            case declTokens.startsWith(attrPrefix) =>
                let newCode = Tokens(collectArray(declTokens)[attrPrefix.size..])
                tb.append(attrPrefix).append(uniqueId).append(TokenKind.COMMA).append(newCode).toTokens()
            case _ => tb
                .append(attrPrefix)
                .append(uniqueId)
                .append(quote(]))
                .append(TokenKind.NL)
                .append(declTokens)
                .toTokens()
        }
    }

    /*
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    static func loadAttrsByKey(key: MacroKey, decl: Decl): ArrayList<Tokens> {
        let result = ArrayList<Tokens>()
        for (anno in decl.annotations) {
            for (attr in anno.attributes) {
                if (attr.value.startsWith(key.attrPrefix)) {
                    let loaded = globalMutableState.get(attr.value) ?? continue
                    result.add(loaded)
                }
            }
        }
        return result
    }

    /*
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    static func loadAllAttrs(decl: Decl): MacroAttrs {
        let result = MacroAttrs()
        for (key in SUPPORTED_MACROS) {
            let attributesByKey = loadAttrsByKey(key, decl)
            if (!attributesByKey.isEmpty()) {
                result[key] = attributesByKey
            }
        }
        result
    }

    /*
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    static func markTestGenerated(tb: TokensBuilder) {
        tb.append(testGeneratedPrefix)
    }

    /*
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     * @throws MacroException
     */
    static func verifyNotYetGenerated(generating: MacroKey, originalTokens: Tokens): Unit {
        if (let Some(alreadyGenerated) <- findAlreadyGenerated(originalTokens)) {
            if (alreadyGenerated == generating) {
                MacroErrors.doThrow("${generating} macro is not repeatable.")
            } else {
                MacroErrors.doThrow("${generating} cannot be used with ${alreadyGenerated}.")
            }
        }
    }

    /*
     * @throws IndexOutOfBoundsException
     */
    static func findAlreadyGenerated(tokens: Tokens): ?MacroKey {
        if (tokens.startsWith(testGeneratedPrefix)) {
            return TEST_MACRO
        }
        let isTestBuilderGenerated = tokens.startsWith(attrPrefix) &&
            tokens.size >= 4 && tokens[3].value.startsWith(TEST_BUILDER_MACRO.attrPrefix)
        if (isTestBuilderGenerated) {
            return TEST_BUILDER_MACRO
        }
        return None
    }
}

extend Decl {
    /*
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    func loadSingle(key: MacroKey): ?Tokens {
        MacroStorage.loadAttrsByKey(key, this).get(0)
    }

    /*
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    func loadRepeatable(key: MacroKey): ArrayList<Tokens> {
        MacroStorage.loadAttrsByKey(key, this)
    }

    /*
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    func has(key: MacroKey): Bool {
        loadSingle(key).isSome()
    }
}
