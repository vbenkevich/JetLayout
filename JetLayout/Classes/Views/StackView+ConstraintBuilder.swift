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

protocol ConstraintBuilder {
    
    func build(first: UIView?, second: UIView?, alignment: Alignment) -> [NSLayoutConstraint?]
}

extension StackView {
    
    func viewsAlignmentBuilder() -> ConstraintBuilder {
        let axis = self.axis
        let normalAlignment = self.normalAlignment
        return ParentChild(priority: .required, anchors: {
            let eq = axis.normalEQAnchors(for: $0)
            let ge = axis.normalGEAnchors()
            
            switch normalAlignment {
            case .fill: return [eq.first, eq.last]
            case .finish: return [eq.last, ge.first]
            case .start: return [eq.first, ge.last]
            case .center: return [eq.mid, ge.first, ge.last]
            }
        })
    }
    
    func viewsSpacingBuilder() -> ConstraintBuilder {
        SpacingBuilder(axis: axis, spacing: spacing)
    }
    
    
    func viewsSizeBuilder() -> ConstraintBuilder {
        SizeBuilder(axis: axis, alignmet: axisAlignment)
    }
    
    func firstViewBuilder() -> ConstraintBuilder {
        let axis = self.axis
        return ParentChild(priority: .required, anchors: {
            [axis.axisEQAnchors(for: $0).first]
        })
    }
    
    func lastViewBuilder() -> ConstraintBuilder {
        let axis = self.axis
        return ParentChild(priority: .required, anchors: {
            [axis.axisEQAnchors(for: $0).last]
        })
    }
}

private struct Composite: ConstraintBuilder {
    
    var parts: [ConstraintBuilder]
    
    func build(first: UIView?, second: UIView?, alignment: Alignment) -> [NSLayoutConstraint?] {
        parts.flatMap { $0.build(first: first, second: second, alignment: alignment) }
            .compactMap { $0 }
    }
}

private struct ParentChild: ConstraintBuilder {
    
    let priority: UILayoutPriority
    let anchors: (Alignment) -> [LayoutAnchor]
    
    func build(first: UIView?, second: UIView?, alignment: Alignment) -> [NSLayoutConstraint?] {
        guard let views = findParent(first: first, second: second) else {
            return []
        }
        
        return anchors(alignment).map { anchor in
            guard anchor.disabled else {
                return nil
            }
            
            var mutable = anchor
            mutable.constant = 0
            mutable.priority = priority
        
            return mutable.apply(superview: views.parent, view: views.child)
        }
    }

    private func findParent(first: UIView?, second: UIView?) -> (parent: UIView, child: UIView)? {
        guard let first = first, let second = second else {
            return nil
        }
        
        if second.superview == first  {
            return (parent: first, child: second)
        } else {
            return (parent: second, child: first)
        }
    }
}

private struct SizeBuilder: ConstraintBuilder {
        
    let axis: Stack.Axis
    let alignmet: Stack.AxisAlignment
    
    func build(first: UIView?, second: UIView?, alignment: Alignment) -> [NSLayoutConstraint?] {
        guard alignmet == .fillEqually, let first = first, let second = second else {
            return []
        }
        
        return axis == .horizontal
            ? [first.widthAnchor.constraint(equalTo: second.widthAnchor)]
            : [first.heightAnchor.constraint(equalTo: second.heightAnchor)]
    }
}

private struct SpacingBuilder: ConstraintBuilder {

    init(axis: Stack.Axis, spacing: CGFloat) {
        self.spacing = -spacing
        
        switch axis {
        case .horizontal:
            firstAttr = .right
            secondAttr = .left
        case .vertical:
            firstAttr = .bottom
            secondAttr = .top
        @unknown default:
            firstAttr = .right
            secondAttr = .left
        }
    }
    
    let spacing: CGFloat
    let firstAttr: NSLayoutConstraint.Attribute
    let secondAttr: NSLayoutConstraint.Attribute
    
    func build(first: UIView?, second: UIView?, alignment: Alignment) -> [NSLayoutConstraint?] {
        guard let first = first, let second = second else {
            return []
        }
        
        return [NSLayoutConstraint(item: first,
                                   attribute: firstAttr,
                                   relatedBy: .equal,
                                   toItem: second,
                                   attribute: secondAttr,
                                   multiplier: 1,
                                   constant: spacing)]
    }
}

private extension Stack.Axis {
    
    func normalEQAnchors(for alignment: Alignment) -> (first: LayoutAnchor, mid: LayoutAnchor, last: LayoutAnchor) {
        if self == .horizontal {
            return (first: alignment.topAnchor, mid: alignment.centerYAnchor, last: alignment.bottomAnchor)
        } else {
            return (first: alignment.leftAnchor, mid: alignment.centerXAnchor, last: alignment.rightAnchor)
        }
    }
    
    func normalGEAnchors() -> (first: LayoutAnchor, last: LayoutAnchor) {
        if self == .horizontal {
            return (first: Alignment.Anchor(priority: .required, constantSignMultiplier: 1, anchorKeyPath: \.topAnchor, relation: .greaterThanOrEqual),
                    last: Alignment.Anchor(priority: .required, constantSignMultiplier: 1, anchorKeyPath: \.bottomAnchor, relation: .lessThanOrEqual))
        } else {
            return (first: Alignment.Anchor(priority: .required, constantSignMultiplier: 1, anchorKeyPath: \.leadingAnchor, relation: .greaterThanOrEqual),
                    last: Alignment.Anchor(priority: .required, constantSignMultiplier: 1, anchorKeyPath: \.trailingAnchor, relation: .lessThanOrEqual))
        }
    }
    
    func axisEQAnchors(for alignment: Alignment) -> (first: LayoutAnchor, mid: LayoutAnchor, last: LayoutAnchor) {
        if self == .horizontal {
            return (first: alignment.leftAnchor, mid: alignment.centerXAnchor, last: alignment.rightAnchor)
        } else {
            return (first: alignment.topAnchor, mid: alignment.centerYAnchor, last: alignment.bottomAnchor)
        }
    }
}

func + (left: ConstraintBuilder, right: ConstraintBuilder) -> ConstraintBuilder {
    Composite(parts: [left, right])
}
