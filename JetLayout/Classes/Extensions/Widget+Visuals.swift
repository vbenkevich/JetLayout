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

public extension Widget {
    
    func isHidden(_ hidden: Bool) -> Self {
        view.isHidden = hidden
        return self
    }
    
    func isVisible(_ visible: Bool) -> Self {
        view.isHidden = !visible
        return self
    }
    
    func background(_ color: UIColor) -> Self {
        view.backgroundColor = color
        return self
    }
    
    func corner(radius: CGFloat?) -> Self {
        view.layer.cornerRadius = radius ?? 0
        view.clipsToBounds = radius != nil
        return self
    }
    
    func corner(mask: CACornerMask) -> Self {
        view.layer.maskedCorners = mask
        return self
    }

    func border(color: UIColor?) -> Self {
        view.layer.borderColor = color?.cgColor
        return self
    }
    
    func border(width: CGFloat) -> Self {
        view.layer.borderWidth = width
        return self
    }
    
    func focus() -> Self {
        view.becomeFirstResponder()
        return self
    }
    
    func tint(_ color: UIColor) -> Self {
        view.tintColor = color
        return self
    }
    
    func contentMode(_ contentMode: UIView.ContentMode) -> Self {
        view.contentMode = contentMode
        return self
    }
}
