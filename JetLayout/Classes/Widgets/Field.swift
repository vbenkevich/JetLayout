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
import UIKit

public protocol WithContentInsetsView: class {

    var insets: UIEdgeInsets? { get set }
}

open class Field: Widget<UITextField> {
     
    public init(_ view: UITextField? = nil, value text: String? = nil, borders: UITextField.BorderStyle = .roundedRect) {
        super.init(view ?? WidgetTextField())
         
        self.view.text = text
        self.view.borderStyle = borders
    }
    
    public func contentInsets(_ insets: UIEdgeInsets) -> Self {
        guard let view = view as? WithContentInsetsView else {
            assertionFailure("TView have to implement WithContentInsetsView")
            return self
        }
    
        view.insets = insets
    
        return self
    }
    
    private class WidgetTextField: UITextField, WithContentInsetsView {

        var insets: UIEdgeInsets?

        override func textRect(forBounds bounds: CGRect) -> CGRect {
            guard let insets = insets else {
                return super.textRect(forBounds: bounds)
            }

            return bounds.inset(by: insets)
        }

        override func editingRect(forBounds bounds: CGRect) -> CGRect {
            guard let insets = insets else {
                return super.textRect(forBounds: bounds)
            }

            return bounds.inset(by: insets)
        }
    }
}

public extension Widget where TView: UITextField {
    
    func text(_ text: String?) -> Self {
        view.text = text
        return self
    }
    
    func textAlignment(_ alignment: NSTextAlignment) -> Self {
        view.textAlignment = alignment
        return self
    }
    
    func color(_ color: UIColor) -> Self {
        view.textColor = color
        return self
    }
    
    func font(_ font: UIFont) -> Self {
        view.font = font
        return self
    }
    
    func font(_ style: UIFont.TextStyle) -> Self {
        view.font = .preferredFont(forTextStyle: style)
        return self
    }
    
    func placeholder(_ placeholder: String?) -> Self {
        view.placeholder = placeholder
        return self
    }
    
    func delegate(_ delegate: UITextFieldDelegate, retain: Bool = false) -> Self {
        view.delegate = delegate
        if retain {
            objc_setAssociatedObject(view, &retainDelegateFieldKey, delegate, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        return self
    }
    
    func keyboard(style: UIKeyboardAppearance, type: UIKeyboardType) -> Self {
        view.keyboardAppearance = style
        view.keyboardType = type
        return self
    }
    
    func contentType(_ type: UITextContentType) -> Self {
        view.textContentType =  type
        return self
    }
    
    func autocorrection(_ autocorrection: UITextAutocorrectionType) -> Self {
        view.autocorrectionType = autocorrection
        return self
    }
    
    func isSecureTextEntry(_ isSecureTextEntry: Bool) -> Self {
        view.isSecureTextEntry = isSecureTextEntry
        return self
    }
}

public extension Field {

    func contentInsets(left: CGFloat, top: CGFloat, right: CGFloat, bottom: CGFloat) -> Self {
        return contentInsets(UIEdgeInsets(top: top, left: left, bottom: bottom, right: right))
    }

    func contentInsets(horizontal: CGFloat, vertical: CGFloat) -> Self {
        return contentInsets(left: horizontal, top: vertical, right: horizontal, bottom: vertical)
    }
}

private var retainDelegateFieldKey = false
