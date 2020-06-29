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

public protocol OptionalType {
    associatedtype Wrapped
    var unwrapped: Wrapped? { get }
}

extension Optional: OptionalType {
    public var unwrapped: Wrapped? { self }
    public var hasValue: Bool { unwrapped != nil }
    public var isNil: Bool { unwrapped == nil }
}

public extension ObservableType {

    func optional() -> Observable<Element?> {
        map{$0}
    }
}

public extension ObservableType where Element == Bool {
    
    func invert() -> Observable<Bool> {
        self.map{!$0}
    }
}

public extension ObservableType where Element == String? {
    
    var isEmpty: Observable<Bool> {
        map { $0 == nil ? true : $0!.isEmpty }
    }
}

public extension ObservableType where Element: Equatable {
    
    func filter(only element: Element) -> Observable<Element> {
        filter { $0 == element }
    }
    
    func isEqual(to element: Element) -> Observable<Bool> {
        map { $0 == element }
    }
    
    func notEqual(to element: Element) -> Observable<Bool> {
        map { $0 != element }
    }
    
    func isEqual<TOther: ObservableType>(to other: TOther) -> Observable<Bool> where TOther.Element == Element {
        Observable.combineLatest(self, other) { $0 == $1 }
    }
    
    func notEqual<TOther: ObservableType>(to other: TOther) -> Observable<Bool> where TOther.Element == Element {
        Observable.combineLatest(self, other) { $0 != $1 }
    }
}

public extension ObservableType where Element: OptionalType {

    func isNil() -> Observable<Bool> {
        self.map( { $0.unwrapped == nil })
    }

    func notNil() -> Observable<Bool> {
        self.map { $0.unwrapped != nil }
    }
}

public extension ObservableType where Element == String? {

    func isNilOrEmpty() -> Observable<Bool> {
        self.map { $0?.isEmpty != false }
    }
}
