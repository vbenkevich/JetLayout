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

open class Table: Widget<UITableView> {
    
    public convenience init(_ tableView: UITableView, dataSource: UITableViewDataSource? = nil, delegate: UITableViewDelegate? = nil) {
        self.init(tableView)
        
        _ = self.preserveParentPadding()
            .table(delegate: delegate)
            .table(dataSource: dataSource)
    }
    
    public convenience init(dataSource: UITableViewDataSource? = nil, delegate: UITableViewDelegate? = nil) {
        
        self.init(UITableView(),
                  dataSource: dataSource,
                  delegate: delegate)
    }
}

public extension Widget where TView: UITableView {
    
    func table(dataSource: UITableViewDataSource?) -> Self {
        view.dataSource = dataSource
        return self
    }
    
    func table(delegate: UITableViewDelegate?) -> Self {
        view.delegate = delegate
        return self
    }

    func separator(style: UITableViewCell.SeparatorStyle? = nil, insets: UIEdgeInsets? = nil, color: UIColor? = nil) -> Self {
        if let style = style {
            view.separatorStyle = style
        }
        if let insets = insets {
            view.separatorInset = insets
        }
        if let color = color {
            view.separatorColor = color
        }
        return self
    }

    func selection(allow: Bool, multiple: Bool = false) -> Self {
        view.allowsSelection = allow
        view.allowsMultipleSelection = multiple
        return self
    }

    func selectionDuringEditing(allow: Bool, multiple: Bool = false) -> Self {
        view.allowsSelectionDuringEditing = allow
        view.allowsMultipleSelectionDuringEditing = multiple
        return self
    }
}
