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

open class ZStack: Widget<UIView> {
    public typealias Builder = ViewBuilder
    public typealias Content = () -> Builder.Result
    
    public init(_ view: UIView? = nil, @Builder content: @escaping Content) {
        super.init(view ?? ZStackContainerView())
        self.content = content
    }
    
    public init() {
        super.init(ZStackContainerView())
    }
    
    var contentAlignment = Alignment.fill(priority: .required)
    
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
            let view = child.body
            if view.alignment.isDefault {
                let paddingRelative = view.alignment.isPaddingRelative
                view.alignment = contentAlignment
                view.alignment.isPaddingRelative = paddingRelative
            }
            view.layout(container: self.view)
        }
        content = nil
        
        return view
    }
    
    private class ZStackContainerView: UIView {}
}

public extension ZStack {
    
    func contentAlignment(_ alignment: Alignment) -> Self {
        contentAlignment = alignment
        return self
    }
}

