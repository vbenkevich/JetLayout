//
//  JetLayout
//
//  Copyright © 2020 Vladimir Benkevich
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

import Foundation
import RxSwift
import RxCocoa

@propertyWrapper
public struct Observed<Element>: ObservableType, ObserverType {

    private let relay: BehaviorRelay<Element>

    public init(wrappedValue: Element) {
        self.relay = BehaviorRelay(value: wrappedValue)
    }

    public var projectedValue: Observed<Element> {
        self
    }

    public var wrappedValue: Element {
        get { relay.value }
        nonmutating set { relay.accept(newValue) }
    }

    public func subscribe<Observer: ObserverType>(_ observer: Observer) -> Disposable where Observer.Element == Element {
        relay.subscribe(observer)
    }

    public func on(_ event: Event<Element>) {
        if case let .next(value) = event {
            relay.accept(value)
        }
    }
}

public extension Observed {
    
    subscript<T>(_ path: WritableKeyPath<Element, T>) -> FieldProxy<Element, T> {
        FieldProxy(parent: self, path: path)
    }
    
    class FieldProxy<TParent, Element>: ObservableType, ObserverType {
        
        init(parent: Observed<TParent>, path: WritableKeyPath<TParent, Element>) {
            self.parent = parent
            self.path = path
        }
        
        private var parent: Observed<TParent>
        private let path: WritableKeyPath<TParent, Element>
        
        public func subscribe<Observer: ObserverType>(_ observer: Observer) -> Disposable where Element == Observer.Element {
            return parent.map { [path] in $0[keyPath: path] }.subscribe(observer)
        }
        
        public func on(_ event: Event<Element>) {
            if case let .next(element) = event {
                parent.wrappedValue[keyPath: path] = element
            }
        }
    }
}

public extension ObservableType {
    
    func store(in observerd: Observed<Element?>) -> Observable<Element> {
        return self.do(onNext: { element in observerd.wrappedValue = element })
    }
    
    func store(in observerd: Observed<Element>) -> Observable<Element> {
        return self.do(onNext: { element in observerd.wrappedValue = element })
    }
}

extension PrimitiveSequenceType where Self.Trait == RxSwift.SingleTrait {
    
    func store(in observerd: Observed<Element?>) -> Single<Element> {
        return self.do(onSuccess: { element in observerd.wrappedValue = element })
    }
    
    func store(in observerd: Observed<Element>) -> Single<Element> {
        return self.do(onSuccess: { element in observerd.wrappedValue = element })
    }
    
    func bind<Observer: ObserverType>(to observer: Observer) -> Disposable where Observer.Element == Element {
        return subscribe(onSuccess: { observer.onNext($0) }, onError: { _ in })
    }
}

extension SharedSequence {
    
    func store(in observerd: Observed<Element?>) -> Self {
        self.do(onNext: { element in observerd.wrappedValue = element })
    }
    
    func store(in observerd: Observed<Element>) -> Self {
        self.do(onNext: { element in observerd.wrappedValue = element })
    }
}
