






package std.unittest.mock

import std.collection.ArrayList

enum Action {
    | Return(() -> Any)
    | Throw(() -> Exception)
    | CallOriginal
    | Fail
    | GetField(SyntheticFieldDescription)
    | SetField(SyntheticFieldDescription)
}

struct ScenarioConfiguration {
    ScenarioConfiguration(
        let action: Action,
        let cardinality: Cardinality
    ) {}
}

enum ScenarioStatus {
    | Created(Option<Action>, Option<Cardinality>)
    | Active(ScenarioConfiguration, Box<Int64>)
}

class Scenario {
    private var status: ScenarioStatus

    Scenario(let parentChain: StubChain) {
        status = Created(None, None)
    }

    /**
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     * @throws MockFrameworkException
     */
    func setAction(selectedAction: Action) {
        match (status) {
            case Created(None, cardinality) =>
                status = Created(selectedAction, cardinality)
            case _ => StubMisconfiguration().fail(parentChain, ActionAlreadySet)
        }
    }

    /**
     * @throws IndexOutOfBoundsException
     * @throws MockFrameworkInternalError
     * @throws IllegalArgumentException
     * @throws MockFrameworkException
     */
    func setCardinality(cardinality: Cardinality) {
        match ((cardinality.min, cardinality.max)) {
            case (0, None) => ()
            case _ => requireVerifiableSession()
        }

        match (status) {
            case Created(None, _) =>
                internalError(InconsistentState("Choosing cardinality before selecting an action"))
            case Created(action, None) =>
                status = Created(action, cardinality)
            case _ => StubMisconfiguration().fail(parentChain, CardinalityAlreadySet)
        }
    }

    /**
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     * @throws MockFrameworkInternalError
     */
    func tryRegisterInvocation(): Bool {
        match (status) {
            case Active(config, count) =>
                let newCount = count.value + 1
                match (config.cardinality.check(newCount)) {
                    case More => false
                    case _ =>
                        count.value = newCount
                        true
                }
            case _ => mustBeActive()
        }
    }

    /**
     * @throws MockFrameworkException
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     * @throws MockFrameworkInternalError
     */
    func activate() {
        match (status) {
            case Created(None, _) =>
                StubMisconfiguration().fail(parentChain, ActionNotSpecified)
            case Created(Some(action), cardinality) =>
                status = Active(ScenarioConfiguration(action, cardinality ?? defaultCardinality(action)), Box(0))
            case _ => internalError(InconsistentState("Already active"))
        }
    }

        /**
         * @throws IndexOutOfBoundsException
         * @throws IllegalArgumentException
         * @throws MockFrameworkInternalError
         */
    prop invocationCount: Int64 {
        get() {
            match (status) {
                case Active(_, count) => count.value
                case _ => mustBeActive()
            }
        }
    }

        /**
         * @throws IndexOutOfBoundsException
         * @throws IllegalArgumentException
         * @throws MockFrameworkInternalError
         */
    prop action: Action {
        get() {
            match (status) {
                case Active(config, _) => config.action
                case _ => mustBeActive()
            }
        }
    }

        /**
         * @throws IndexOutOfBoundsException
         * @throws IllegalArgumentException
         * @throws MockFrameworkInternalError
         */
    prop cardinality: Cardinality {
        get() {
            match (status) {
                case Active(config, _) => config.cardinality
                case _ => mustBeActive()
            }
        }
    }

    /**
     * @throws IndexOutOfBoundsException
     * @throws MockFrameworkInternalError
     * @throws IllegalArgumentException
     */
    private func defaultCardinality(action: Action) {
        if (let Fail <- action) {
            return Cardinality.times(0)
        }

        if (parentChain.isVerifiable()) {
            Cardinality.atLeastOnce()
        } else {
            Cardinality.atLeastTimes(0)
        }
    }

    /**
     * @throws MockFrameworkInternalError
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     * @throws MockFrameworkException
     */
    private func requireVerifiableSession() {
        if (!parentChain.isVerifiable()) {
            StubModeViolation().cardinalitySpecifierNotAllowed(parentChain)
        }
    }

    /**
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     * @throws MockFrameworkInternalError
     */
    private func mustBeActive(): Nothing {
        internalError(InconsistentState("Scenario must be active"))
    }
}

class StubChain {
    private var wasActivated: Bool = false

    StubChain(
        let invocationMatcher: InvocationMatcher,
        let objectKind: MockKind,
        let parentSession: MockSession
    ) {}

    let scenarios: ArrayList<Scenario> = ArrayList()
    /**
     * @throws MockFrameworkException
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    func addScenario(_: MockSession): Scenario {
        if (wasActivated) {
            StubMisconfiguration().fail(this, CannotModifyActive)
        }

        let newScenario = Scenario(this)
        scenarios.add(newScenario)
        return newScenario
    }

    /**
     * @throws MockFrameworkException
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     * @throws MockFrameworkInternalError
     */
    func ensureActivated() {
        if (!wasActivated) {
            for (sc in scenarios) {
                sc.activate()
            }
            wasActivated = true
        }
    }

    /**
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     * @throws MockFrameworkInternalError
     */
    func isVerifiable(): Bool {
        match (parentSession.sessionKind) {
            case Verifiable => true
            case Stateless => false
            case Forbidden => internalError("Should not be able to create stub chain in this mode")
        }
    }
}
