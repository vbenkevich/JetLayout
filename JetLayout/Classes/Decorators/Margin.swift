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

public struct Margin: ViewDecorator {
    
    let offset: Offset
    
    public func attach(to view: View) -> View {
        ZStack {
            view
        }
        .padding(offset)
    }
}

public extension Margin {

    init(_ offset: CGFloat) {
        self.offset = Offset(offset)
    }
    
    init(_ offsets: Offset...) {
        self.offset = offsets.reduce(.zero, { $0 + $1 })
    }
    
    init(offsets: [Offset]) {
        self.offset = offsets.reduce(.zero, { $0 + $1 })
    }
}


public extension View {
    
    @available(*, deprecated, renamed: "margin")
    func addMargin(_ offset: CGFloat) -> View {
        margin(offset)
    }
    
    @available(*, deprecated, renamed: "margin")
    func addMargin(horizontal: CGFloat? = nil, vertical: CGFloat? = nil) -> View {
        margin(horizontal: horizontal ?? 0, vertical: vertical ?? 0)
    }
    
    @available(*, deprecated, renamed: "margin")
    func addMargin(left: CGFloat? = nil, top: CGFloat? = nil, right: CGFloat? = nil, bottom: CGFloat? = nil) -> View {
        margin(top: top ?? 0, left: left ?? 0, bottom: bottom ?? 0, right: right ?? 0)
    }
    
    func margin(_ offset: CGFloat) -> View {
        add(Margin(offset))
    }
    
    func margin(_ offsets: Offset...) -> View {
        add(Margin(offsets: offsets))
    }
    
    func margin(horizontal: CGFloat = 0, vertical: CGFloat = 0) -> View {
        add(Margin(.horizontal(horizontal), .vertical(vertical)))
    }
    
    func margin(top: CGFloat = 0, left: CGFloat = 0, bottom: CGFloat = 0, right: CGFloat = 0) -> View {
        add(Margin(.left(left), .top(top), .right(right), .bottom(bottom)))
    }
    
    func shift(dx: CGFloat = 0, dy: CGFloat = 0) -> View {
        return add(Margin(Offset(top: dy, left: dx, bottom: -dy, right: -dx)))
    }
}
