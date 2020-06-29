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

public protocol GenericCell {
    associatedtype Model
    
    var model: Model? { get set }
}

public extension GenericCell where Self: UITableViewCell {
    
    static func register() -> TableBuilderItem {
        Table.CellRegistration(model: Model.self, cell: self)
    }
}

open class ViewBasedTableCell<Model>: UITableViewCell, GenericCell {
    
    @Observed
    public var model: Model?
    
    open var view: View {
        fatalError("Abstract")
    }
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLayout()
    }
    
    private func setupLayout() {
        preservesSuperviewLayoutMargins = true
        contentView.preservesSuperviewLayoutMargins = true
        backgroundColor = .clear
        
        view.embed(in: contentView, alignment: .fill(toPadding: false))
    }
}

extension Table {

    class CellRegistration: TableBuilderItem {
        
        init<Model, Cell: UITableViewCell & GenericCell>(model: Model.Type, cell: Cell.Type) where Cell.Model == Model {
            canRepresent = { model in
                type(of: model) == Model.self
            }
            
            dequeueCell = { table, index, model in
                var cell = table.dequeueReusableCell(withIdentifier: Cell.identifier, for: index) as! Cell
                cell.model = model as? Model
                return cell
            }
            
            registerCell = { table in
                table.register(Cell.self, forCellReuseIdentifier: Cell.identifier)
            }
        }
        
        let registerCell: (UITableView) -> Void
        
        let canRepresent: (Any) -> Bool
        
        let dequeueCell: (UITableView, IndexPath, Any) -> UITableViewCell
        
        func append(to builder: TableBuilder) {
            builder.cells.append(self)
        }
    }
}

extension UITableViewCell {
    
    static var identifier: String {
        String(describing: self)
    }
}
