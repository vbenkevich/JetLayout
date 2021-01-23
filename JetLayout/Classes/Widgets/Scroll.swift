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

open class Scroll: Widget<UIScrollView> {
    public typealias Builder = ViewBuilder
    public typealias Content = () -> Builder.Result
    public typealias Axis = NSLayoutConstraint.Axis
    
    public init(_ view: UIScrollView? = nil, _ axis: Axis = .vertical) {
        contentContainer = ZStack()
        super.init(view ?? UIScrollView())
        setupContentContainer(axis: axis)
    }
    
    public init(_ view: UIScrollView? = nil, _ axis: Axis = .vertical, @Builder content: @escaping Content) {
        contentContainer = ZStack(content: content)
        super.init(view ?? UIScrollView())
        setupContentContainer(axis: axis)
    }
    
    public override var layoutMargins: UIEdgeInsets {
        get { return contentContainer.layoutMargins }
        set { contentContainer.layoutMargins = newValue }
    }
    
    fileprivate let contentContainer: ZStack
    
    fileprivate var axis: Axis! {
        didSet {
            guard oldValue != axis else {
                return
            }
            let bounce = view.alwaysBounceHorizontal
            view.alwaysBounceHorizontal = view.alwaysBounceVertical
            view.alwaysBounceVertical = bounce
            
            axisConstraint = axis == .vertical
                ? view.widthAnchor.constraint(equalTo: contentContainer.view.widthAnchor)
                : view.heightAnchor.constraint(equalTo: contentContainer.view.heightAnchor)
        }
    }
    
    private var axisConstraint: NSLayoutConstraint! {
        didSet {
            if let old = oldValue {
                old.isActive = false
                view.removeConstraint(old)
            }
            axisConstraint.isActive = true
        }
    }
    
    public final override func layout(container: UIView?) -> UIView {
        contentContainer.layout(container: view)
        return super.layout(container: container)
    }
    
    private func setupContentContainer(axis: Axis) {
        let container = contentContainer.view
        let content: UILayoutGuide
        
        content = view.contentLayoutGuide
        
        view.addSubview(container)
        container.translatesAutoresizingMaskIntoConstraints = false
        container.preservesSuperviewLayoutMargins = true
        
        container.leftAnchor.constraint(equalTo: content.leftAnchor).isActive = true
        container.topAnchor.constraint(equalTo: content.topAnchor).isActive = true
        container.rightAnchor.constraint(equalTo: content.rightAnchor).isActive = true
        container.bottomAnchor.constraint(equalTo: content.bottomAnchor).isActive = true
       
        self.axis = axis
    }
}

public extension Scroll {

    convenience init(axis: Axis = .vertical, @Builder content: @escaping Content) {
        self.init(nil, axis, content: content)
    }

    func axis(_ axis: Axis) -> Self {
        self.axis = axis
        return self
    }
    
    func content(@Builder _ content: @escaping Content) -> Self {
        _ = contentContainer.content(content)
        return self
    }
    
    func contentInsets(_ insets: UIEdgeInsets) -> Self {
        view.contentInset = insets
        return self
    }
    
    func contentOffset(_ offset: CGPoint) -> Self {
        view.contentOffset = offset
        return self
    }
    
    func delegate(_ delegate: UIScrollViewDelegate) -> Self {
        view.delegate = delegate
        return self
    }
    
    func bounce(_ enabled: Bool = true) -> Self {
        if self.axis == Axis.vertical {
            view.alwaysBounceVertical = enabled
        } else {
            view.alwaysBounceHorizontal = enabled
        }
        
        return self
    }
    
    func indicatorStyle(_ style: UIScrollView.IndicatorStyle) -> Self {
        view.indicatorStyle = style
        return self
    }

    func keyboardDismissMode(_ mode: UIScrollView.KeyboardDismissMode) -> Self {
        view.keyboardDismissMode = mode
        return self
    }
}

public extension View {
    
    func embedInScroll(axis: Scroll.Axis = .vertical) -> Scroll {
        Scroll(nil, axis) { self }
    }
}
