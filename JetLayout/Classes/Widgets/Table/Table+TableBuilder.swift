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

public extension Table {

    convenience init(_ tableView: UITableView? = nil, @TableBuilder builderBlock: @escaping () -> TableBuilderItem) {
        self.init(tableView ?? UITableView())
        let source = Table.SectionsSource(table: view)
        let builder = builderBlock().asBuilder()

        builder.allItems.forEach {
            $0.attach(to: view)
        }

        Observable.combineLatest(builder.sections)
            .compactMap { sections in sections.flatMap { $0 }}
            .do(onNext: { [unowned view] sections in
                sections.forEach { $0.attach(to: view, cells: builder.cells) }
            })
            .bind(to: source.$sections)
            .disposed(by: view.disposeBag)

        view.delegate = source
        view.dataSource = source
    }
}

@_functionBuilder
public class TableBuilder {

    init() { }

    convenience init(_ item: TableBuilderItem) {
        self.init()
        item.append(to: self)
    }

    var sections: [Observable<[TableSection]>] = []
    var cells: [Table.CellRegistration] = []
    var allItems: [TableBuilderItem] = []

    public static func buildBlock(_ elements: TableBuilderItem...) -> TableBuilderItem {
        let builder = TableBuilder()

        for element in elements {
            element.append(to: builder)
            builder.allItems.append(element)
        }

        return builder
    }

    public static func buildIf(_ elements: TableBuilderItem?) -> TableBuilderItem {
        return elements ?? TableBuilder()
    }

    public static func buildEither(first: TableBuilderItem) -> TableBuilderItem {
        return first
    }

    public static func buildEither(second: TableBuilderItem) -> TableBuilderItem {
        return second
    }
}

public protocol TableBuilderItem {

    func append(to builder: TableBuilder)

    func attach(to tableView: UITableView)

    func asBuilder() -> TableBuilder
}

public extension TableBuilderItem {

    func attach(to tableView: UITableView) { }

    func append(to builder: TableBuilder) { }

    func asBuilder() -> TableBuilder {
        TableBuilder(self)
    }
}

extension TableBuilder: TableBuilderItem {

    public func asBuilder() -> TableBuilder {
        self
    }

    public func append(to builder: TableBuilder) {
        builder.sections.append(contentsOf: sections)
        builder.allItems.append(contentsOf: allItems)
    }
}

extension Table.StaticSection: TableBuilderItem {

    public func append(to builder: TableBuilder) {
        builder.sections.append(.just([self]))
    }
}

extension Table.DynamicSection: TableBuilderItem {

    public func append(to builder: TableBuilder) {
        builder.sections.append(.just([self]))
    }
}
