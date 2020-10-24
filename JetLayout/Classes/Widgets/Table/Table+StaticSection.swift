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

public func TSection(header: View? = nil, footer: View? = nil, @ViewBuilder builder: () -> Views) -> TableBuilderItem {
    Table.StaticSection(header: header, cells: builder().views, footer: footer)
}

public extension View {

    func cell() -> Table.TableCellConfigurationView {
        Table.TableCellConfigurationView(origin: self)
    }
}

public extension Table.TableCellConfigurationView {

    func accessory(_ type: UITableViewCell.AccessoryType) -> Table.TableCellConfigurationView {
        var copy = self
        copy.accessoryType = type
        return copy
    }

    func selectionColor(_ color: UIColor) -> Table.TableCellConfigurationView {
        var copy = self
        copy.selectionColor = color
        return copy
    }

    func canSelect(_ action: @escaping () -> Bool) -> Table.TableCellConfigurationView {
        var copy = self
        copy.canSelectAction = action
        return copy
    }

    func didSelect(_ action: @escaping () -> Void) -> Table.TableCellConfigurationView {
        var copy = self
        copy.didSelectAction = action
        return copy
    }
}

extension Table {

    class StaticSection: NSObject, TableSection {

        init(header: View? = nil, cells: [View] = [], footer: View? = nil) {
            self.cells = cells
                .map { $0 as? TableCellConfigurationView ?? TableCellConfigurationView(origin: $0) }
                .map { $0.createCell() }

            self.header = header?.toUIView()
            self.footer = footer?.toUIView()
        }

        private var sizes: [IndexPath: CGFloat] = [:]

        let header: UIView?

        let cells: [TableCell]

        let footer: UIView?

        func attach(to tableView: UITableView, cells: [Table.CellRegistration]) {
        }

        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            cells.count
        }

        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            cells[indexPath.row]
        }

        func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
            sizes[indexPath] = cell.frame.height
        }

        func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
            sizes[indexPath] ?? UITableView.automaticDimension
        }

        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            sizes[indexPath] ?? UITableView.automaticDimension
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
            cells[indexPath.row].didSelect()
        }

        func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
            cells[indexPath.row].canSelect() ? indexPath : nil
        }

        private func estimatingSize(for view: UIView?, in parentView: UIView) -> CGSize {
            guard let view = view else { return .zero }

            let targetSize = CGSize(width: parentView.bounds.width,
                                    height: CGFloat.greatestFiniteMagnitude)

            return view.systemLayoutSizeFitting(targetSize,
                                                withHorizontalFittingPriority: .required,
                                                verticalFittingPriority: .fittingSizeLevel)
        }
    }
}

extension Table {

    class TableCell: UITableViewCell {

        init(_ view: View) {
            super.init(style: .default, reuseIdentifier: nil)
            backgroundColor = .clear
            contentView.preservesSuperviewLayoutMargins = true
            view.embed(in: contentView, alignment: Alignment.fill(toPadding: false))
        }

        var canSelectAction: (() -> Bool)?
        var selectionColor: UIColor?
        var didSelectAction: (() -> Void)?

        required public init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        func canSelect() -> Bool {
            return canSelectAction?() ?? (didSelectAction != nil)
        }

        func didSelect() {
            didSelectAction?()
        }

        override func setHighlighted(_ highlighted: Bool, animated: Bool) {
            guard let color = selectionColor else {
                super.setHighlighted(highlighted, animated: animated)
                return
            }
            backgroundColor = highlighted ? color : UIColor.clear
        }

        override func setSelected(_ selected: Bool, animated: Bool) {
            guard let color = selectionColor else {
                super.setSelected(selected, animated: animated)
                return
            }

            backgroundColor = selected ? color : UIColor.clear
        }
    }
}

extension Table {

    public struct TableCellConfigurationView: View {

        let origin: View

        var canSelectAction: (() -> Bool)? = nil
        var selectionColor: UIColor? = nil
        var didSelectAction: (() -> Void)? = nil
        var accessoryType: UITableViewCell.AccessoryType = .none

        public var body: Layout { origin.body }

        func createCell() -> TableCell {
            let cell = TableCell(origin)
            cell.accessoryType = accessoryType
            cell.selectionColor = selectionColor
            cell.didSelectAction = didSelectAction
            cell.canSelectAction = canSelectAction

            return cell
        }
    }
}
