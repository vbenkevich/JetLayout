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


@_functionBuilder
public class ViewBuilder {
    public typealias Element = View
    public typealias Result = Views
    
    // It doesn`t work :(
    public static func buildBlock() -> Result {
        return ViewArray([])
    }
    
//    // It doesn`t work :(
//    public static func buildExpression(_ element: Element) -> Result {
//        return ViewArray([element])
//    }
    
    public static func buildBlock(_ elements: Result...) -> Result {
        return ViewArray(elements.flatMap { $0.views })
    }
    
    public static func buildBlock(_ elements: Element...) -> Result {
        return ViewArray(elements)
    }
    
    public static func buildIf(_ elements: Result?) -> Result {
        return elements ?? ViewArray([])
    }
    
    public static func buildEither(first: Result) -> Result {
        return first
    }
    
    public static func buildEither(second: Result) -> Result {
        return second
    }
    
    public static func buildOptional(_ view: Result?) -> Result {
        if let view = view {
            return view
        } else {
            return ViewArray([])
        }
    }
    
    public struct ViewArray: Views {
        
        init(_ views: [View]) {
            self.views = views
        }
        
        public let views: [View]
    }
}

public func foreach<C: Sequence>(_ collection: C,
                                 @ViewBuilder elements: (C.Element) ->  Views) -> Views {
    ViewBuilder.ViewArray(collection.flatMap { elements($0).views })
}

