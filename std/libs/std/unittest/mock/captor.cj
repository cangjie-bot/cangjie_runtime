






package std.unittest.mock

import std.collection.ArrayList



public interface ValueListener<T> {


    func lastValue(): Option<T>


    func allValues(): Array<T>


    func addCallback(callback: (T) -> Unit): Unit


    static func new(): ValueListener<T> {
        ValueListenerImpl<T>()
    }



    static func onEach(callback: (T) -> Unit): ValueListener<T> {
        return ValueListenerImpl<T>(callback)
    }
}

interface ListenerInternal {
    func supplyValue(value: Any): Unit
}

class ValueListenerImpl<T> <: ValueListener<T> & ListenerInternal {
    private let callBacks = ArrayList<(T) -> Unit>()
    private let values = ArrayList<T>()

    ValueListenerImpl() {}

    init(callBack: (T) -> Unit) {
        addCallback(callBack)
    }

    public func lastValue(): Option<T> {
        return values.get(values.size - 1)
    }

    public func allValues(): Array<T> {
        return values.toArray()
    }

    public func addCallback(callBack: (T) -> Unit) {
        callBacks.add(callBack)
    }

    public override func supplyValue(value: Any) {
        if (let Some(valueAsT) <- unwrapValue<T>(value)) {
            for (callback in callBacks) {
                callback(valueAsT)
            }
            values.add(valueAsT)
        }
    }
}
