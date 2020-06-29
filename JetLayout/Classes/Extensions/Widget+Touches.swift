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
import RxCocoa

public extension Widget {
    
    func tap(exclude: [UIView] = [], block: @escaping (TView, UITapGestureRecognizer) -> Void) -> Self {
        let gesture = Gesture()
        gesture.exclude = exclude
        gesture.delegate = gesture
        
        view.addGestureRecognizer(gesture)
        
        return bind(gesture.rx.event) { view, gesture in
            block(view, gesture)
        }
    }
    
    func touch(enabled: Bool) -> Self {
        view.isUserInteractionEnabled = enabled
        return self
    }
    
    private class Gesture: UITapGestureRecognizer, UIGestureRecognizerDelegate {
        
        var exclude = [] as [UIView]
        
        func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
            for view in exclude {
                if view.bounds.contains(gestureRecognizer.location(in: view)) {
                    return false
                }
            }
            
            return true
        }
        
        override func shouldBeRequiredToFail(by otherGestureRecognizer: UIGestureRecognizer) -> Bool {
            return true
        }
    }
}
