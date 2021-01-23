//
//  JetLayout
//
//  Copyright © 2021 Vladimir Benkevich
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

import RxSwift

public extension Stack {

    func content<T: ObservableType>(_ source: T) -> Self where T.Element == [View] {
        bind(source) { view, views in
            view.clearArrangedSubviews()
            views.forEach { child in
                let body = child.body
                let subview = body.layout(container: view)
                view.addArranged(view: subview, alignment: body.alignment)
            }
            view.setNeedsUpdateConstraints()
            view.layoutIfNeeded()
        }
    }
}

public extension ZStack {

    convenience init<T: ObservableType>(_ source: T) where T.Element == [View] {
        self.init()
        _ = content(source)
    }

    func content<T: ObservableType>(_ source: T) -> Self where T.Element == [View] {
        bind(source) { view, views in
            view.subviews.forEach { $0.removeFromSuperview() }
            views.forEach { child in
                _ = child.body.layout(container: view)
            }
        }
    }
}

public extension HStack {

    convenience init<T: ObservableType>(spacing: CGFloat = 0, _ source: T) where T.Element == [View] {
        self.init(spacing: spacing)
        _ = content(source)
    }
}

public extension VStack {

    convenience init<T: ObservableType>(spacing: CGFloat = 0, _ source: T) where T.Element == [View] {
        self.init(spacing: spacing)
        _ = content(source)
    }
}

