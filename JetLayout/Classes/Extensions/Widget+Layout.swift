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

public extension Widget where TView: UIView {
    
    func padding(_ offset: Offset) -> Self {
        layoutMargins.left = offset.left
        layoutMargins.right = offset.right
        layoutMargins.top = offset.top
        layoutMargins.bottom = offset.bottom
        
        return self
    }
    
    func padding(_ offsets: Offset...) -> Self {
        padding(offsets.reduce(.zero) { $0 + $1 })
    }
    
    func padding(_ padding: CGFloat) -> Self {
        return self.padding(top: padding, left: padding, bottom: padding, right: padding)
    }
    
    func padding(horizontal: CGFloat? = nil, vertical: CGFloat? = nil) -> Self {
        return self.padding(top: vertical, left: horizontal, bottom: vertical, right: horizontal)
    }
    
    func padding(top: CGFloat? = nil, left: CGFloat? = nil, bottom: CGFloat? = nil, right: CGFloat? = nil) -> Self {
        return self.padding(Offset(top: top ?? 0, left: left ?? 0, bottom: bottom ?? 0, right: right ?? 0))
    }

    func size(width: CGFloat? = nil, height: CGFloat? = nil, priority: UILayoutPriority = UILayoutPriority(999)) -> Self {
        if let width = width {
            widthConstraint.constant = width
            widthConstraint.priority = priority
            widthConstraint.isActive = true
        }
        
        if let height = height {
            heightConstraint.constant = height
            heightConstraint.priority = priority
            heightConstraint.isActive = true
        }
        
        return self
    }
    
    func alignment(_ alignment: Alignment) -> Self {
        self.alignment = alignment
        return self
    }
    
    func align(top: CGFloat? = nil,
               left: CGFloat? = nil,
               bottom: CGFloat? = nil,
               right: CGFloat? = nil,
               toPadding: Bool? = nil) -> Self {
        
        var alignment = self.alignment
        if let top = top {
            alignment = alignment.top(top, toPadding: toPadding)
        }
        
        if let left = left {
            alignment = alignment.left(left, toPadding: toPadding)
        }
        
        if let right = right {
            alignment = alignment.right(right, toPadding: toPadding)
        }
        
        if let bottom = bottom {
            alignment = alignment.bottom(bottom, toPadding: toPadding)
        }
        
        if let toPadding = toPadding, top == nil && bottom == nil && right == nil && left == nil {
            alignment.isPaddingRelative = toPadding
        }
        
        self.alignment = alignment
        
        return self
    }
    
    func align(topPadding: Bool? = nil,
               leftPadding: Bool? = nil,
               bottomPadding: Bool? = nil,
               rightPadding: Bool? = nil) -> Self {
        
        if let top = topPadding {
            alignment.topAnchor.isPaddingRelative = top
        }
        
        if let left = topPadding {
            alignment.leftAnchor.isPaddingRelative = left
        }
        
        if let right = topPadding {
            alignment.rightAnchor.isPaddingRelative = right
        }
        
        if let bottom = topPadding {
            alignment.bottomAnchor.isPaddingRelative = bottom
        }
        
        self.alignment = alignment
        
        return self
    }
    
    func pinToTop(_ offset: CGFloat = 0, toPadding: Bool = false) -> Self {
        return align(top: offset, left: offset, right: offset, toPadding: toPadding)
    }
    
    func pinToBottom(_ offset: CGFloat = 0, toPadding: Bool = false) -> Self {
        return align(left: offset, bottom: offset, right: offset, toPadding: toPadding)
    }
    
    func safeAreaRelativePadding(_ insetsLayoutMarginsFromSafeArea: Bool = true) -> Self {
        view.insetsLayoutMarginsFromSafeArea = insetsLayoutMarginsFromSafeArea
        return self
    }
    
    func preserveParentPadding(_ preservesSuperviewLayoutMargins: Bool = true) -> Self {
        view.preservesSuperviewLayoutMargins = preservesSuperviewLayoutMargins
        
        if preservesSuperviewLayoutMargins {
            alignment.isPaddingRelative = false
        }
        
        return self
    }
    
    func hugging(_ priority: UILayoutPriority, axis: NSLayoutConstraint.Axis) -> Self {
        view.setContentHuggingPriority(priority, for: axis)
        return self
    }

    func compression(_ priority: UILayoutPriority, axis: NSLayoutConstraint.Axis) -> Self {
        view.setContentCompressionResistancePriority(priority, for: axis)
        return self
    }
    
    func zIndex(_ index: CGFloat) -> Self {
        view.layer.zPosition = index
        return self
    }
}

public extension View {
    
    func root(of controller: UIViewController) {
        let container: UIView
        container = controller.view
        
        embed(in: container, alignment: .fill(toPadding: false))
        
        container.setNeedsLayout()
        container.layoutIfNeeded()
    }
}
