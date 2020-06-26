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

open class Text: Widget<UILabel> {
    
    public init() {
        super.init(UILabel())
    }
    
    public convenience init(_ text: String?, color: UIColor? = nil, font: UIFont? = nil) {
        self.init()
        
        view.text = text
        
        if let color = color {
            view.textColor = color
        }
        
        if let font = font {
            view.font = font
        }
    }
    
    public convenience init(_ text: String?, color: UIColor? = nil, font: UIFont.TextStyle) {
        self.init()
        
        view.text = text
        
        if let color = color {
            view.textColor = color
        }
        
        _ = self.font(font)
    }
}

public extension Widget where TView: UILabel {
    
    func text(_ text: String?) -> Self {
        view.text = text
        return self
    }

    func text(_ attributed: NSAttributedString?) -> Self {
        view.attributedText = attributed
        return self
    }

    func textAlignment(_ alignment: NSTextAlignment) -> Self {
        view.textAlignment = alignment
        return self
    }
    
    func color(_ color: UIColor) -> Self {
        view.textColor = color
        return self
    }

    func font(_ font: UIFont?) -> Self {
        view.font = font
        return self
    }
    
    func font(_ style: UIFont.TextStyle) -> Self {
        view.font = .preferredFont(forTextStyle: style)
        return self
    }
    
    func lineBreakMode(_ lineBreakMode: NSLineBreakMode) -> Self {
        view.lineBreakMode = lineBreakMode
        return self
    }
    
    func numberOfLines(_ numberOfLines: Int) -> Self {
        view.numberOfLines = numberOfLines
        return self
    }
}
