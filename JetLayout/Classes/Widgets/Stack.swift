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

public class HStack: Stack {

    public init(spacing: CGFloat = 0) {
        super.init()
        
        view.axis = .horizontal
        view.spacing = spacing
    }
    
    public init(spacing: CGFloat = 0, @Builder content: @escaping Content) {
        super.init()
        
        view.axis = .horizontal
        view.spacing = spacing
        _ = self.content(content)
    }
}

public class VStack: Stack {
    
    public init(spacing: CGFloat = 0) {
        super.init()
        
        view.axis = .vertical
        view.spacing = spacing
    }
    
    public init(spacing: CGFloat = 0, @Builder content: @escaping Content) {
        super.init()
        
        view.axis = .vertical
        view.spacing = spacing
        _ = self.content(content)
    }
}

public class Stack: Widget<StackView> {
    public typealias Builder = ViewBuilder
    public typealias Content = () -> Builder.Result
    public typealias Axis = NSLayoutConstraint.Axis
    
    init() {
        super.init(StackView())
    }
    
    private var content: Content?
    
    public func content(@Builder _ content: @escaping Content) -> Self {
        assert(self.content == nil, "Content has been added already")
        self.content = content
        return self
    }
    
    @discardableResult
    public final override func layout(container: UIView?) -> UIView {
        super.layout(container: container)
        
        content?().views.forEach { child in
            let body = child.body
            let subview = body.layout(container: view)
            view.addArranged(view: subview, alignment: body.alignment)
        }
        
        content = nil
        
        return view
    }
}

public extension Stack {
    
    enum AxisAlignment : Int {
        case fill
        case fillEqually
    }
    
    enum NormalAlignment {
        case start
        case finish
        case fill
        case center
    }

    func spacing(_ spacing: CGFloat) -> Self {
        view.spacing = spacing
        return self
    }
    
    func distribution(_ distribution: AxisAlignment) -> Self {
        view.axisAlignment = distribution
        return self
    }
    
    func alignment(_ alignment: NormalAlignment) -> Self {
        view.normalAlignment = alignment
        return self
    }
}
