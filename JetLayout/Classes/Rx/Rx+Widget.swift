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

public extension Widget {
    
    func alpha<Source: ObservableType>(bind source: Source) -> Self where Source.Element == CGFloat {
        bind(source, to: \.alpha)
    }
    
    func touchDisabled<Source: ObservableType>(source: Source) -> Self where Source.Element == Bool {
        bind(source.invert()) {
            $0.isUserInteractionEnabled = $1
        }
    }

    func touchEnabled<Source: ObservableType>(source: Source) -> Self where Source.Element == Bool {
        bind(source) {
            $0.isUserInteractionEnabled = $1
        }
    }
    
    func background<Source: ObservableType>(bind source: Source) -> Self where Source.Element == UIColor? {
        bind(source, to: \.backgroundColor)
    }
    
    func background<Source: ObservableType>(bind source: Source) -> Self where Source.Element == UIColor {
        background(bind: source.optional())
    }
}

public extension Widget where TView: UIControl {

    func enabled<Source: ObservableType>(source: Source) -> Self where Source.Element == Bool {
        bind(source, to: \.isEnabled)
    }

    func disabled<Source: ObservableType>(source: Source) -> Self where Source.Element == Bool {
        bind(source.invert(), to: \.isEnabled)
    }

    func selected<Source: ObservableType>(source: Source) -> Self where Source.Element == Bool {
        bind(source, to: \.isSelected)
    }
}


public extension Widget where TView: UIView {
    
    func blinkBackground<Source: ObservableType>(bind source: Source, delay: TimeInterval) -> Self where Source.Element == UIColor? {
        
        source
            .subscribe(onNext: { color in
                self.blink(with: color, delay: delay)
            })
            .disposed(by: disposeBag)
        
        return self
    }
    
    private func blink(with color: UIColor?, delay: TimeInterval) {
        
        let oldColor = view.backgroundColor
        UIView.animate(withDuration: 0.3, delay: delay, options: [.autoreverse, .beginFromCurrentState], animations: {
            self.view.backgroundColor = color
        }, completion: { _ in
            self.view.backgroundColor = oldColor
        })
    }
}

public extension Widget {

    var disposeBag: DisposeBag {
        view.disposeBag
    }

    func subscribe(block: (Reactive<TView>) -> Disposable) -> Self {
        block(view.rx).disposed(by: disposeBag)
        return self
    }

    func bind<Observable: ObservableType>(_ observable: Observable, onNext: @escaping (TView, Observable.Element) -> Void) -> Self {
        let binding = observable.bind { [weak view] element in
            if let view = view {
                onNext(view, element)
            }
        }

        binding.disposed(by: disposeBag)
        return self
    }

    func bind<Observable: ObservableType, Observer: ObserverType>(_ observable: Observable, to observer: Observer) -> Self where Observable.Element == Observer.Element {
        let binding = observable.bind(to: observer)
        binding.disposed(by: disposeBag)
        return self
    }

    func bind<Observable: ObservableType, Observer: ObserverType>(_ observable: Observable, to path: Swift.KeyPath<TView, Observer>) -> Self where Observable.Element == Observer.Element {
        let observer = view[keyPath: path]
        return bind(observable, to: observer)
    }

    func bind<Observable: ObservableType, Observer: ObserverType>(_ observable: Observable, to path: Swift.KeyPath<Reactive<TView>, Observer>) -> Self where Observable.Element == Observer.Element {
        let observer = view.rx[keyPath: path]
        return bind(observable, to: observer)
    }
    
    func compressionResistance(priority: UILayoutPriority,
                               for axis: NSLayoutConstraint.Axis) -> Self {
        
        view.setContentCompressionResistancePriority(priority,
                                                     for: axis)
        return self
    }
    
    func contentHugging(priority: UILayoutPriority,
                        for axis: NSLayoutConstraint.Axis) -> Self {
        
        view.setContentHuggingPriority(priority, for: axis)
        return self
    }

    func disposeBindings() -> Self {
        view.disposeBag = DisposeBag()
        return self
    }
}

// Workaround
// it's impossible to get the Self type in Widget<TView> extension, only a TView type is available
public extension View {
    
    func bind<Observable: ObservableType, Observer: ObserverType, TView: UIView>(widget observable: (Self) -> Observable, to observer: Observer) -> Self
        where Observable.Element == Observer.Element, Self: Widget<TView>
    {
        bind(observable(self), to: observer)
    }
    
    func bind<Observable: ObservableType, Observer: ObserverType, TView: UIView>(_ observable: Observable, widget observer: (Self) -> Observer) -> Self
        where Observable.Element == Observer.Element, Self: Widget<TView>
    {
        bind(observable, to: observer(self))
    }
    
    func bind<Observable: ObservableType, Observer: ObserverType, TView: UIView>(view observable: (TView) -> Observable, to observer: Observer) -> Self
        where Observable.Element == Observer.Element, Self: Widget<TView>
    {
        bind(observable(self.view), to: observer)
    }
}

private var disposeBagKey = false

extension UIView {

    var disposeBag: DisposeBag {
        get {
            if let bag = objc_getAssociatedObject(self, &disposeBagKey) as? DisposeBag {
                return bag
            } else {
                let bag = DisposeBag()
                objc_setAssociatedObject(self, &disposeBagKey, bag, .OBJC_ASSOCIATION_RETAIN)
                return bag
            }
        }
        set {
            objc_setAssociatedObject(self, &disposeBagKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
}
