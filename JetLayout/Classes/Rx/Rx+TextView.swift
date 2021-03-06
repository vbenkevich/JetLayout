//
//  Pods
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
import RxSwift
import RxCocoa

public extension Widget where TView: UITextView {
    
    func color(_ color: UIColor) -> Self {
        view.textColor = color
        view.tintColor = color
        return self
    }

    func font(_ font: UIFont) -> Self {
        view.font = font
        return self
    }
    
    func text<Storage>(bind storage: Storage) -> Self where Storage: ObserverType, Storage: ObservableType, Storage.Element == String? {
        let fromView = view.rx.text.distinctUntilChanged()
        
        return bind(storage, to: view.rx.text).bind(fromView, to: storage)
    }
    
    func error<T: ObservableType>(_ error: T) -> Self where T.Element == Bool {
        
        return bind(error) { (view, error) in
            if error {
                view.layer.borderColor = UIColor.red.cgColor
            } else {
                view.layer.borderColor = UIColor.white.withAlphaComponent(0.2).cgColor
            }
        }
    }
}
