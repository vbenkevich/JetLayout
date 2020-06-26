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

open class Widget<TView: UIView>: Layout {
    
    public init(_ view: TView) {
        self.view = view
        
        view.layoutMargins = .zero
        
        widthConstraint = view.widthAnchor.constraint(equalToConstant: .zero)
        heightConstraint = view.heightAnchor.constraint(equalToConstant: .zero)
        
        alignment = Alignment()
    }
    
    public let view: TView
    
    public let widthConstraint: NSLayoutConstraint
    public let heightConstraint: NSLayoutConstraint
    
    public var alignment: Alignment
    
    public var layoutMargins: UIEdgeInsets {
        get { return view.layoutMargins }
        set { view.layoutMargins = newValue }
    }
    
    @discardableResult
    open func layout(container: UIView?) -> UIView {
        guard let container = container else {
            return view
        }
        
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        
        alignment = alignment.apply(superview: container.viewGuide,
                                    padding: container.layoutMarginsGuide,
                                    child: view.viewGuide)
    
        return view
    }
}

extension Widget: View {
   
    public var body: Layout {
        return self
    }
}

public extension Widget {
    
    func setup(block: (TView) -> Void) -> Self {
        block(view)
        return self
    }
}

public extension NSObjectProtocol where Self: UIView {
    
    func widget() -> Widget<Self> {
        return Widget(self)
    }
}

private var viewGuideKey = false

extension UIView {
    
    var viewGuide: UILayoutGuide {
        if let guide = objc_getAssociatedObject(self, &viewGuideKey) as? UILayoutGuide {
            return guide
        }
        
        let guide = ViewGuide()
        guide.identifier = "Widget.ViewGuide"
        addLayoutGuide(guide)
        
        objc_setAssociatedObject(self, &viewGuideKey, guide, .OBJC_ASSOCIATION_ASSIGN)
        
        return guide
    }
}

private class ViewGuide: UILayoutGuide {
    
    private var view: UIView { owningView! }
    
    override var layoutFrame: CGRect { view.frame }
    override var leadingAnchor: NSLayoutXAxisAnchor { view.leadingAnchor }
    override var trailingAnchor: NSLayoutXAxisAnchor { view.trailingAnchor }
    override var leftAnchor: NSLayoutXAxisAnchor { view.leftAnchor }
    override var rightAnchor: NSLayoutXAxisAnchor { view.rightAnchor }
    override var topAnchor: NSLayoutYAxisAnchor { view.topAnchor }
    override var bottomAnchor: NSLayoutYAxisAnchor { view.bottomAnchor }
    override var widthAnchor: NSLayoutDimension { view.widthAnchor }
    override var heightAnchor: NSLayoutDimension { view.heightAnchor }
    override var centerXAnchor: NSLayoutXAxisAnchor { view.centerXAnchor }
    override var centerYAnchor: NSLayoutYAxisAnchor { view.centerYAnchor }
}
