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

public class Button: Widget<UIButton> {
    
    public init(_ view: UIButton, title: String? = nil, image: UIImage? = nil) {
        super.init(view)
        self.view.setTitle(title, for: .normal)
        self.view.setImage(image, for: .normal)
    }
         
    public convenience init(type: UIButton.ButtonType = .system, title: String? = nil, image: UIImage? = nil) {
        self.init(UIButton(type: type), title: title, image: image)
    }
}

public extension Widget where TView: UIButton {

    func color(_ color: UIColor?, for state: UIControl.State = .normal) -> Self {
        backImage(UIImage(color: color), for: state)
    }

    func image(_ image: UIImage?, for state: UIControl.State = .normal) -> Self {
        view.setImage(image, for: state)
        return self
    }

    func backImage(_ image: UIImage?, for state: UIControl.State = .normal) -> Self {
        view.setBackgroundImage(image, for: state)
        return self
    }

    func title(_ title: String?, for state: UIControl.State = .normal) -> Self {
        view.setTitle(title, for: state)
        return self
    }
    
    func titleColor(_ color: UIColor?, for state: UIControl.State = .normal) -> Self {
        view.setTitleColor(color, for: state)
        return self
    }
    
    func font(_ font: UIFont?) -> Self {
        if let font = font {
            view.titleLabel?.font = font
        }
        return self
    }
}

