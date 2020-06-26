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

public protocol Views {
    
    var views: [View] { get }
}

public protocol View: Views {
    
    var body: Layout { get }
}

public extension View {
    
    var views: [View] {
        return [self]
    }
}

public protocol Layout: class {
    
    var alignment: Alignment { get set }
    
    @discardableResult
    func layout(container: UIView?) -> UIView
}

public extension View {
    
    func toUIView() -> UIView {
        return ViewAdapter(view: self)
    }
    
    func setup(block: (Self) -> Void) -> Self {
        block(self)
        return self
    }
}

private class ViewAdapter: UIView {
    
    init(view: View) {
        super.init(frame: .zero)
        view.embed(in: self, alignment: .fill(toPadding: false))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


protocol UIViewProvider {
    
    var uiView: UIView? { get }
}

public extension View {
    
    func embed(in view: UIView, alignment: Alignment = .fill()) {
        let body = self.body
        body.alignment = alignment
        body.layout(container: view)
    }
    
    func accessibilityId(_ identifier: String) -> Self {
        guard let view = (body as? UIViewProvider)?.uiView else {
            assertionFailure("cant set accessibility id")
            return self
        }
        
        view.accessibilityIdentifier = identifier
        
        return self
    }
}

extension Widget: UIViewProvider {
    
    var uiView: UIView? { return view }
}

