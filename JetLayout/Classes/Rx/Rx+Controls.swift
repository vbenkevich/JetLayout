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
import RxSwift
import RxCocoa

public extension Button {

    convenience init<Title: ObservableType>(type: UIButton.ButtonType = .system, _ title: Title) where Title.Element == String {
        self.init(type: type)
    }
}

public extension Widget where TView: UIButton {

    func title<Title: ObservableType>(_ title: Title, for state: UIControl.State = .normal) -> Self where Title.Element == String {
        bind(title) {
            $0.setTitle($1, for: state)
        }
    }
    
    func title(_ title: String, for state: UIControl.State = .normal) -> Self {
        view.setTitle(title, for: state)
        return self
    }
    
    func title(insets: UIEdgeInsets) -> Self {
        view.titleEdgeInsets = insets
        return self
    }

    func icon(_ image: UIImage?, for state: UIControl.State = .normal) -> Self {
        view.setImage(image, for: state)
        return self
    }
    
    func icon(insets: UIEdgeInsets) -> Self {
        view.imageEdgeInsets = insets
        return self
    }
    
    func tap(_ block: @escaping () -> Void) -> Self {
        view.rx.tap.bind(onNext: block).disposed(by: disposeBag)
        return self
    }

    func tap<Observer: ObserverType>(_ observer: Observer) -> Self where Observer.Element == Void {
        view.rx.tap.bind(to: observer).disposed(by: disposeBag)
        return self
    }
}
