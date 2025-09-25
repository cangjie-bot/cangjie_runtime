






package std.unittest.mock

enum SessionHandleResult {
    PerformScenario(Scenario) | Unhandled | InvocationLimitExceeded(StubChain)
}

extend MockSession {
    func handle(invocation: Invocation, unmatchedChains: UnmatchedChains): SessionHandleResult {
        let chains = chainsByStubId.get(invocation.stubId) ?? return Unhandled

        for (chain in chains) {
            chain.ensureActivated()
        }
        for (index in (chains.size - 1)..=0 : -1) {
            let chain = chains[index]
            let matchStatus = chain.invocationMatcher.tryMatch(invocation)
            match (matchStatus) {
                case Ok => ()
                case _ =>
                    unmatchedChains.add((chain, matchStatus))
                    continue
            }
            for (sc in chain.scenarios) {
                match (sc.action) {
                    case Fail => return PerformScenario(sc)
                    case _ => ()
                }

                if (sc.tryRegisterInvocation()) {
                    chain.runListeners(invocation)
                    return PerformScenario(sc)
                }
            }
            return InvocationLimitExceeded(chain)
        }
        return Unhandled
    }
}

extend StubChain {
    func runListeners(invocation: Invocation) {
        for (i in 0..invocation.call.args.size) {
            if (let Some(listeningMatcher) <- (invocationMatcher.positionalMatchers[i] as ListeningMatcher)) {
                listeningMatcher.valueListener?.supplyValue(invocation.call.args[i])
            }
        }
    }
}
