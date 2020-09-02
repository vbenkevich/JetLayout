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

public struct Offset {
    
    public var top: CGFloat
    public var left: CGFloat
    public var bottom: CGFloat
    public var right: CGFloat
}

public extension Offset {
    
    init(_ insets: UIEdgeInsets) {
        top = insets.top
        left = insets.left
        bottom = insets.bottom
        right = insets.right
    }
    
    init(_ offset: CGFloat) {
        top = offset
        left = offset
        bottom = offset
        right = offset
    }
    
    init(vertical: CGFloat) {
        top = vertical
        left = 0
        bottom = vertical
        right = 0
    }
    
    init(horizontal: CGFloat) {
        top = 0
        left = horizontal
        bottom = 0
        right = horizontal
    }
    
    init(_ offsets: Offset...) {
        self = offsets.reduce(.zero) { $0 + $1 }
    }
}

public extension Offset {
    
    static func top(_ offset: CGFloat) -> Offset {
        Offset(top: offset, left: 0, bottom: 0, right: 0)
    }
    
    static func left(_ offset: CGFloat) -> Offset {
        Offset(top: 0, left: offset, bottom: 0, right: 0)
    }
    
    static func bottom(_ offset: CGFloat) -> Offset {
        Offset(top: 0, left: 0, bottom: offset, right: 0)
    }
    
    static func right(_ offset: CGFloat) -> Offset {
        Offset(top: 0, left: 0, bottom: 0, right: offset)
    }
    
    static func horizontal(_ offset: CGFloat) -> Offset {
        Offset(top: 0, left: offset, bottom: 0, right: offset)
    }
    
    static func vertical(_ offset: CGFloat) -> Offset {
        Offset(top: offset, left: 0, bottom: offset, right: 0)
    }
    
    func top(_ offset: CGFloat) -> Offset {
        var mutable = self
        mutable.top = offset
        return mutable
    }
    
    func left(_ offset: CGFloat) -> Offset {
        var mutable = self
        mutable.left = offset
        return mutable
    }
    
    func bottom(_ offset: CGFloat) -> Offset {
        var mutable = self
        mutable.bottom = offset
        return mutable
    }
    
    func right(_ offset: CGFloat) -> Offset {
        var mutable = self
        mutable.right = offset
        return mutable
    }
    
    func horizontal(_ offset: CGFloat) -> Offset {
        var mutable = self
        mutable.left = offset
        mutable.right = offset
        return mutable
    }
    
    func vertical(_ offset: CGFloat) -> Offset {
        var mutable = self
        mutable.top = offset
        mutable.bottom = offset
        return mutable
    }
}

extension Offset: AdditiveArithmetic {
    
    public static let zero = Offset(0)
    
    public static func + (lhs: Offset, rhs: Offset) -> Offset {
        Offset(top: lhs.top + rhs.top,
               left: lhs.left + rhs.right,
               bottom: lhs.bottom + rhs.bottom,
               right: lhs.right + rhs.right)
    }
    
    public static func - (lhs: Offset, rhs: Offset) -> Offset {
        Offset(top: lhs.top - rhs.top,
               left: lhs.left - rhs.right,
               bottom: lhs.bottom - rhs.bottom,
               right: lhs.right - rhs.right)
    }
}
