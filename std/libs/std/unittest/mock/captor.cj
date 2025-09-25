






package std.unittest.mock

import std.collection.ArrayList



public interface ValueListener<T> {


    /*
     * @noThrow
     */
    func lastValue(): Option<T>


    /*
     * @noThrow
     */
    func allValues(): Array<T>


    /*
     * @noThrow
     */
    func addCallback(callback: (T) -> Unit): Unit


    /*
     * @noThrow
     */
    static func new(): ValueListener<T> {
        ValueListenerImpl<T>()
    }



    /*
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    static func onEach(callback: (T) -> Unit): ValueListener<T> {
        return ValueListenerImpl<T>(callback)
    }
}

interface ListenerInternal {
    /*
     * @noThrow
     */
    func supplyValue(value: Any): Unit
}

class ValueListenerImpl<T> <: ValueListener<T> & ListenerInternal {
    private let callBacks = ArrayList<(T) -> Unit>()
    private let values = ArrayList<T>()

    /*
     * @noThrow
     */
    ValueListenerImpl() {}

    /*
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    init(callBack: (T) -> Unit) {
        addCallback(callBack)
    }

    /*
     * @noThrow
     */
    public func lastValue(): Option<T> {
        return values.get(values.size - 1)
    }

    /*
     * @throws IndexOutOfBoundsException
     * @throws IllegalArgumentException
     */
    public func allValues(): Array<T> {
        return values.toArray()
    }

    /*
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    public func addCallback(callBack: (T) -> Unit) {
        callBacks.add(callBack)
    }

    /*
     * @throws IllegalArgumentException
     * @throws IndexOutOfBoundsException
     */
    public override func supplyValue(value: Any) {
        if (let Some(valueAsT) <- unwrapValue<T>(value)) {
            for (callback in callBacks) {
                callback(valueAsT)
            }
            values.add(valueAsT)
        }
    }
}
