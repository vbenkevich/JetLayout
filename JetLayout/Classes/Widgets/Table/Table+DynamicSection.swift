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
import RxSwift
import RxCocoa

public func TSection<Source: ObservableType>(source: Source, header: View? = nil, footer: View? = nil) -> TableBuilderItem & TableBuilderSectionItem
    where Source.Element: Collection, Source.Element.Index == Int
{
    return Table.DynamicSection<Source.Element>(header: header, items: source, footer: footer)
}

public func TSection<Source: Collection>(source: Source, header: View? = nil, footer: View? = nil) -> TableBuilderItem & TableBuilderSectionItem
    where Source.Index == Int
{
    return Table.DynamicSection<Source>(header: header, items: source, footer: footer)
}

public protocol TableBuilderSectionItem {

    func itemSelected(_ block: @escaping (_ item: Any, _ tableView: UITableView, _ path: IndexPath) -> Void) -> TableBuilderItem & TableBuilderSectionItem

    func canSelect(_ block: @escaping (_ item: Any, _ indexPath: IndexPath) -> Bool) -> TableBuilderItem & TableBuilderSectionItem
}

extension Table {

    class DynamicSection<T: Collection>: NSObject, TableSection where T.Index == Int {
        init(header: View? = nil, items: T, footer: View? = nil) {
            self.header = header?.toUIView()
            self.footer = footer?.toUIView()
            self.items = items
        }

        init<Itmes: ObservableType>(header: View? = nil, items: Itmes, footer: View? = nil) where Itmes.Element == T {
            self.header = header?.toUIView()
            self.footer = footer?.toUIView()

            super.init()

            items.bind { [unowned self] in
                self.items = $0
                self.table?.reloadData()
            }
            .disposed(by: disposeBag)
        }

        private let disposeBag = DisposeBag()
        private var canSelectItemAt: ((IndexPath) -> Bool) = { _ in true }
        private var handleItemSelected: ((_ item: Any, _ tableView: UITableView, _ path: IndexPath) -> Void)?

        private weak var table: UITableView?

        let header: UIView?
        let footer: UIView?

        var items: T?

        var cells: [Table.CellRegistration] = []


        func attach(to tableView: UITableView, cells: [Table.CellRegistration]) {
            self.table = tableView
            self.cells = cells
        }

        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            items?.count ?? 0
        }

        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let item = items![indexPath.row]

            return cells
                .first { $0.canRepresent(item) }!
                .dequeueCell(tableView, indexPath, item)
        }

        func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
            header
        }

        func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            estimatingSize(for: header, in: tableView).height
        }

        func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
            footer
        }

        func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
            estimatingSize(for: footer, in: tableView).height
        }

        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            handleItemSelected?(items![indexPath.row], tableView, indexPath)
        }

        func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
            canSelectItemAt(indexPath) ? indexPath : nil
        }

        private func estimatingSize(for view: UIView?, in parentView: UIView) -> CGSize {
            guard let view = view else { return .zero }

            let targetSize = CGSize(width: parentView.bounds.width,
                                    height: CGFloat.greatestFiniteMagnitude)

            return view.systemLayoutSizeFitting(targetSize,
                                                withHorizontalFittingPriority: .required,
                                                verticalFittingPriority: .defaultLow)
        }
    }
}

extension Table.DynamicSection: TableBuilderSectionItem {

    func itemSelected(_ block: @escaping (Any, UITableView, IndexPath) -> Void) ->  TableBuilderItem & TableBuilderSectionItem {
        handleItemSelected = block
        return self
    }

    func canSelect(_ block: @escaping (Any, IndexPath) -> Bool) ->  TableBuilderItem & TableBuilderSectionItem {
        canSelectItemAt = { [unowned self] path in block(self.items![path.row], path) }
        return self
    }
}
