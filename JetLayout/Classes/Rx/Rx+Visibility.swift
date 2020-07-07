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

import UIKit
import RxSwift
import RxCocoa

public extension Widget {

    func hidden<Source: ObservableType>(bind source: Source) -> Self where Source.Element == Bool {
        bind(source, to: \.isHidden)
    }

    func visible<Source: ObservableType>(bind source: Source) -> Self where Source.Element == Bool {
        bind(source.invert(), to: \.isHidden)
    }
}

public extension View {
    
    func animation<Source: ObservableType>(expanded: Source, axis: Stack.Axis) -> View where Source.Element == Bool {
        let container = CollapsibleContainerView()
        container.axis = axis
        container.heightConstraint = container.heightAnchor.constraint(equalToConstant: 1)
        container.widthConstraint = container.widthAnchor.constraint(equalToConstant: 1)
        
        return ZStack(container) {
            self
        }.bind(expanded) { view, visible in
            (view as? CollapsibleContainerView)?.animate(visible: visible, for: 0.250)
        }
    }
    
    func animation<Source: ObservableType>(collapsed: Source, axis: Stack.Axis) -> View where Source.Element == Bool {
        return animation(expanded: collapsed.invert(), axis: axis)
    }
}

private class CollapsibleContainerView: UIView {

    var axis: Stack.Axis!
    var heightConstraint: NSLayoutConstraint!
    var widthConstraint: NSLayoutConstraint!
    
    func animate(visible: Bool, for duration: TimeInterval) {
        heightConstraint.isActive = axis == .vertical && !visible
        widthConstraint.isActive = axis == .horizontal && !visible
        
        UIView.animate(withDuration: duration, animations: {
            self.superview?.layoutIfNeeded()
        })
    }
}
