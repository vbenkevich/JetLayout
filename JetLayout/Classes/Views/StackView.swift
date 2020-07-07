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

public class StackView: UIView {
    
    // MARK: - public
    
    public var axis: Stack.Axis = .vertical {
        didSet { setNeedsUpdateConstraints() }
    }
    
    public var spacing: CGFloat = 0 {
        didSet { setNeedsUpdateConstraints() }
    }
    
    public var axisAlignment: Stack.AxisAlignment = .fill {
        didSet { setNeedsUpdateConstraints() }
    }
    
    public var normalAlignment: Stack.NormalAlignment = .fill {
        didSet { setNeedsUpdateConstraints() }
    }
    
    public func addArranged(view: UIView, alignment: Alignment) {
        let arranged = ArrangedView(view: view,
                                    alignment: alignment,
                                    parent: self)
        
        allArrangedViews.append(arranged)
    }
    
    public override func updateConstraints() {
        super.updateConstraints()
        
        var previous = nil as UIView?
        var constraints = [NSLayoutConstraint?]()
        
        let arrangedViews = allArrangedViews.filter { $0.shouldDisplay }
        
        if !arrangedViews.isEmpty {
            constraints += firstViewBuilder().build(first: self, second: arrangedViews.first!.view, alignment: arrangedViews.first!.alignment)
            constraints += lastViewBuilder().build(first: self, second: arrangedViews.last!.view, alignment: arrangedViews.last!.alignment)
        }
        
        let normal = viewsAlignmentBuilder()
        let axis = viewsSpacingBuilder() + viewsSizeBuilder()
        
        for arranged in arrangedViews {
            constraints += axis.build(first: previous, second: arranged.view, alignment: arranged.alignment)
            constraints += normal.build(first: self, second: arranged.view, alignment: arranged.alignment)
            previous = arranged.view
        }
        
        alignmentConstraints = constraints.compactMap { $0 }
    }

    // MARK: - private
    
    private var allArrangedViews: [ArrangedView] = []
    
    private var alignmentConstraints: [NSLayoutConstraint] = [] {
        didSet {
            NSLayoutConstraint.deactivate(oldValue)
            NSLayoutConstraint.activate(alignmentConstraints)
        }
    }
    
    fileprivate class ArrangedView {
        
        init(view: UIView, alignment: Alignment, parent: StackView) {
            self.view = view
            self.alignment = alignment

            zeroHeight = view.heightAnchor.constraint(equalToConstant: 0)
            zeroWidth = view.widthAnchor.constraint(equalToConstant: 0)

            observation = view.observe(\.isHidden) { [weak parent] view,_ in
                parent?.setNeedsUpdateConstraints()
            }
        }
        
        let view: UIView
        let alignment: Alignment
        
        var shouldDisplay: Bool {
            return !view.isHidden
        }
        
        private var visible: Bool?
        private var observation: Any
        private var zeroHeight: NSLayoutConstraint
        private var zeroWidth: NSLayoutConstraint
    }
}
