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

public protocol StringConverter {
    associatedtype Value
    
    func string(value: Value) -> String?
    
    func value(string: String) -> Value
}

public extension Text {
    
    convenience init<Source: ObservableType>(_ source: Source, color: UIColor? = nil, font: UIFont? = nil) where Source.Element == String {
        self.init(nil, color: color, font: font)
        _ = text(bind: source)
    }
    
    convenience init<Source: ObservableType>(_ source: Source, color: UIColor? = nil, font: UIFont? = nil) where Source.Element == String? {
        self.init(nil, color: color, font: font)
        _ = text(bind: source)
    }

    convenience init<Source: ObservableType>(_ source: Source, color: UIColor? = nil, font: UIFont.TextStyle) where Source.Element == String {
        self.init(nil, color: color, font: font)
        _ = text(bind: source)
    }

    convenience init<Source: ObservableType>(_ source: Source, color: UIColor? = nil, font: UIFont.TextStyle) where Source.Element == String? {
        self.init(nil, color: color, font: font)
        _ = text(bind: source)
    }
    
    convenience init<Source: ObservableType>(_ source: Source, color: UIColor? = nil, font: UIFont? = nil) where Source.Element == NSAttributedString {
        self.init(nil, color: color, font: font)
        _ = text(bind: source)
    }
    
    convenience init<Source: ObservableType>(_ source: Source, color: UIColor? = nil, font: UIFont? = nil) where Source.Element == NSAttributedString? {
        self.init(nil, color: color, font: font)
        _ = text(bind: source)
    }
}

public extension Widget where TView: UILabel {

    func text<Source: ObservableType>(bind observable: Source) -> Self where Source.Element == String {
        text(bind: observable.optional())
    }

    func text<Source: ObservableType>(bind observable: Source) -> Self where Source.Element == String? {
        bind(observable, to: \.text)
    }

    func text<Source: ObservableType>(bind observable: Source) -> Self where Source.Element == NSAttributedString {
        text(bind: observable.optional())
    }

    func text<Source: ObservableType>(bind observable: Source) -> Self where Source.Element == NSAttributedString? {
        bind(observable, to: \.attributedText)
    }

    func color<Source: ObservableType>(bind observable: Source) -> Self where Source.Element == UIColor {
        bind(observable) { view, color in view.textColor = color }
    }

    func font<Source: ObservableType>(bind observable: Source) -> Self where Source.Element == UIFont {
        bind(observable) { view, font in view.font = font }
    }

    func font<Source: ObservableType>(bind observable: Source) -> Self where Source.Element == UIFont.TextStyle {
        bind(observable) { view, style in view.font = .preferredFont(forTextStyle: style) }
    }
}

public extension Field {
    
    convenience init<Storage>(_ storage: Storage, borders: UITextField.BorderStyle = .roundedRect)
        where Storage: ObserverType, Storage: ObservableType, Storage.Element == String  {
        self.init(borders: borders)
        _ = text(bind: storage)
    }
    
    convenience init<Storage>(_ storage: Storage, borders: UITextField.BorderStyle = .roundedRect)
        where Storage: ObserverType, Storage: ObservableType, Storage.Element == String?  {
        self.init(borders: borders)
        _ = text(bind: storage)
    }
    
    convenience init<Storage>(_ storage: Storage, borders: UITextField.BorderStyle = .roundedRect)
        where Storage: ObserverType, Storage: ObservableType, Storage.Element == NSAttributedString  {
        self.init(borders: borders)
        _ = text(bind: storage)
    }
    
    convenience init<Storage>(_ storage: Storage, borders: UITextField.BorderStyle = .roundedRect)
        where Storage: ObserverType, Storage: ObservableType, Storage.Element == NSAttributedString?  {
        self.init(borders: borders)
        _ = text(bind: storage)
    }
}

public extension Widget where TView: UITextField {

    func text<Storage>(bind storage: Storage) -> Self where Storage: ObserverType, Storage: ObservableType, Storage.Element == String? {
        let fromView = view.rx.text.distinctUntilChanged()

        return bind(storage, to: view.rx.text).bind(fromView, to: storage)
    }

    func text<Storage>(bind storage: Storage) -> Self where Storage: ObserverType, Storage: ObservableType, Storage.Element == String {
        let fromView = view.rx.text.compactMap { $0 }.distinctUntilChanged()

        return bind(storage.optional(), to: view.rx.text)
            .bind(fromView, to: storage)
    }

    func text<Storage, Converter: StringConverter>(bind storage: Storage, converter: Converter, runtimeUpdate: Bool = false) -> Self
        where Storage: ObserverType, Storage: ObservableType, Storage.Element == Converter.Value
    {
        let fromView = runtimeUpdate
            ? view.rx.textChanged
            : view.rx.editingDidEnd
        
        return bind(storage.map(converter.string), to: view.rx.text)
            .bind(fromView.map(converter.value), to: storage)
    }
    
    func text<Storage>(bind storage: Storage) -> Self where Storage: ObserverType, Storage: ObservableType, Storage.Element == NSAttributedString? {
        let fromView = view.rx.attributedText.distinctUntilChanged()

        return bind(storage, to: view.rx.attributedText)
            .bind(fromView, to: storage)
    }

    func text<Storage>(bind storage: Storage) -> Self where Storage: ObserverType, Storage: ObservableType, Storage.Element == NSAttributedString {
        let fromView = view.rx.attributedText.compactMap { $0 }.distinctUntilChanged()

        return bind(storage.optional(), to: view.rx.attributedText)
            .bind(fromView, to: storage)
    }
}

private extension Reactive where Base: UITextField {
    
    var textChanged: ControlProperty<String> {
        return base.rx.controlProperty(
            editingEvents: [.editingChanged],
            getter: { [weak base] _    in base?.text ?? "" },
            setter: { [weak base] f, v in base?.text = v }
        )
    }
    
    var editingDidEnd: ControlProperty<String> {
        return base.rx.controlProperty(
            editingEvents: [.editingDidEnd],
            getter: { [weak base] _    in base?.text ?? "" },
            setter: { [weak base] f, v in base?.text = v }
        )
    }
}
