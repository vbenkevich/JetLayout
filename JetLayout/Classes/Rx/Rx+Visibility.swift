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
import RxSwift
import RxCocoa

public extension Widget {

    func hidden<Source: ObservableType>(bind source: Source) -> Self where Source.Element == Bool {
        bind(source, to: \.isHidden)
    }

    func visible<Source: ObservableType>(bind source: Source) -> Self where Source.Element == Bool {
        bind(source.invert(), to: \.isHidden)
    }
    
    func hidden<Source: ObservableType>(animated source: Source) -> Self where Source.Element == Bool {
        visible(animated: source.invert())
    }
    
    func visible<Source: ObservableType>(animated source: Source) -> Self where Source.Element == Bool {
        bind(source) { view, visible in
            view.getVisibilityAnimationProvider()
                .animate(view: view, visible: visible, for: 0.250)
        }
    }
}

protocol VisibilityAnimationProvider {
    
    func animate(view: UIView, visible: Bool, for duration: TimeInterval)
}

private extension UIView {
    
    func getVisibilityAnimationProvider() -> VisibilityAnimationProvider {
        if let provider = superview as? VisibilityAnimationProvider {
            return provider
        } else {
            return DefaultVisibilityAnimationProvider()
        }
    }
}
 
private struct DefaultVisibilityAnimationProvider: VisibilityAnimationProvider {
    
    func animate(view: UIView, visible: Bool, for duration: TimeInterval) {
        view.alpha = view.isHidden ? 0.01 : 1
        view.isHidden = false
        view.window?.layoutIfNeeded()
        
        UIView.animate(withDuration: duration, animations: {
            view.alpha = visible ? 1 : 0
            view.window?.layoutIfNeeded()
        }, completion: { _ in
            view.isHidden = !visible
        })
    }
}
