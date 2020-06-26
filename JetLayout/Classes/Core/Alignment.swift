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

public struct Alignment {
    
    var leftAnchor = Anchor(priority: .required, constantSignMultiplier: 1, anchorKeyPath: \.leftAnchor)
    var rightAnchor = Anchor(priority: .required, constantSignMultiplier: -1, anchorKeyPath: \.rightAnchor)
    var centerXAnchor = Anchor(priority: .required, constantSignMultiplier: 1, anchorKeyPath: \.centerXAnchor)
    var topAnchor = Anchor(priority: .required, constantSignMultiplier: 1, anchorKeyPath: \.topAnchor)
    var bottomAnchor = Anchor(priority: .required, constantSignMultiplier: -1, anchorKeyPath: \.bottomAnchor)
    var centerYAnchor = Anchor(priority: .required, constantSignMultiplier: 1, anchorKeyPath: \.centerYAnchor)
    
    mutating func apply(superview: UILayoutGuide, padding: UILayoutGuide, child: UILayoutGuide) -> Alignment {
        let constraints = [
            leftAnchor.apply(superview: superview, padding: padding, child: child),
            rightAnchor.apply(superview: superview, padding: padding, child: child),
            centerXAnchor.apply(superview: superview, padding: padding, child: child),
            topAnchor.apply(superview: superview, padding: padding, child: child),
            bottomAnchor.apply(superview: superview, padding: padding, child: child),
            centerYAnchor.apply(superview: superview, padding: padding, child: child)
        ].compactMap { $0 }
        
        NSLayoutConstraint.activate(constraints)
        
        return self
    }
}

public extension Alignment {

    var isDefault: Bool {
        return anchors.allSatisfy { $0.disabled }
    }
    
    var isPaddingRelative: Bool {
        get { anchors.allSatisfy { $0.isPaddingRelative } }
        set {
            leftAnchor.isPaddingRelative = newValue
            rightAnchor.isPaddingRelative = newValue
            topAnchor.isPaddingRelative = newValue
            bottomAnchor.isPaddingRelative = newValue
            centerYAnchor.isPaddingRelative = newValue
            centerXAnchor.isPaddingRelative = newValue
        }
    }
    
    internal var anchors: [LayoutAnchor] {
        [leftAnchor, rightAnchor, centerXAnchor, topAnchor, bottomAnchor, centerYAnchor]
    }
    
    struct Anchor<T: NSLayoutAnchor<AnchorType>, AnchorType: AnyObject> {
        
        init(priority: UILayoutPriority,
             constantSignMultiplier: CGFloat,
             anchorKeyPath: Swift.KeyPath<UILayoutGuide, T>,
             relation: NSLayoutConstraint.Relation = .equal)
        {
            self.relation = relation
            self.priority = priority
            self.constantSignMultiplier = constantSignMultiplier
            self.anchorKeyPath = anchorKeyPath
        }
        
        private let relation: NSLayoutConstraint.Relation
        
        public var priority: UILayoutPriority {
            didSet {
                constraint?.priority = priority
            }
        }
        
        public var constant: CGFloat? = nil {
            didSet {
                guard let constraint = self.constraint else { return }
                
                if let constant = constant {
                    constraint.set(constant: constant, multiplier: constantSignMultiplier)
                    constraint.isActive = true
                } else {
                    constraint.isActive = false
                }
            }
        }
        
        public var isPaddingRelative = true {
            didSet {
                assert(constraint == nil, "Can't update guide after constraing is created")
            }
        }
        
        // we have a same guide order for each constraints so multiplier for constant has different sign (e.g. left = 1, right = -1)
        let constantSignMultiplier: CGFloat
        
        let anchorKeyPath: Swift.KeyPath<UILayoutGuide, T>
        
        fileprivate var constraint: NSLayoutConstraint? = nil {
            didSet {
                guard constraint != oldValue else { return }
                
                oldValue?.isActive = false
                constraint?.priority = priority
                constraint?.set(constant: constant, multiplier: constantSignMultiplier)
            }
        }
    }
}

protocol LayoutAnchor {
    
    var priority: UILayoutPriority { get set }
    
    var constant: CGFloat? { get set }
    
    var disabled: Bool { get }
    
    var isPaddingRelative: Bool { get }
    
    mutating func apply(superview: UILayoutGuide, padding: UILayoutGuide, child: UILayoutGuide) -> NSLayoutConstraint?
}


extension Alignment {
    
    mutating func apply(superview: UIView, view: UIView) -> Alignment {
        apply(superview: superview.viewGuide, padding: superview.layoutMarginsGuide, child: view.viewGuide)
    }
}

extension Alignment.Anchor: LayoutAnchor {
    
    var disabled: Bool {
        constant == nil
    }
    
    mutating func apply(superview: UILayoutGuide, padding: UILayoutGuide, child: UILayoutGuide) -> NSLayoutConstraint? {
        
        let parentGuide = selectLayoutGuide(superview: superview,
                                            padding: padding)
        
        switch relation {
        case .equal:
            constraint = child[keyPath: anchorKeyPath].constraint(equalTo: parentGuide[keyPath: anchorKeyPath])
        case .greaterThanOrEqual:
            constraint = child[keyPath: anchorKeyPath].constraint(greaterThanOrEqualTo: parentGuide[keyPath: anchorKeyPath])
        case .lessThanOrEqual:
            constraint = child[keyPath: anchorKeyPath].constraint(lessThanOrEqualTo: parentGuide[keyPath: anchorKeyPath])
        default:
            fatalError()
        }
        
        return constant != nil ? constraint! : nil
    }
    
    private func selectLayoutGuide(superview: UILayoutGuide, padding: UILayoutGuide) -> UILayoutGuide {
        isPaddingRelative ? padding : superview
    }
}

extension LayoutAnchor {
    
    mutating func apply(superview: UIView, view: UIView) -> NSLayoutConstraint? {
        apply(superview: superview.viewGuide, padding: superview.layoutMarginsGuide, child: view.viewGuide)
    }
}


private extension NSLayoutConstraint {
    
    func set(constant: CGFloat?, multiplier: CGFloat) {
        guard let constant = constant else {
            return
        }
        
        self.constant = constant * multiplier
    }
}
