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

protocol TableSection {
    
    func attach(to tableView: UITableView, cells: [Table.CellRegistration])
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView?
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath?
}

extension TableSection {
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    public func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}

private var tableSectionsSourceKey = false

extension Table {
    
    class SectionsSource: NSObject, UITableViewDataSource, UITableViewDelegate {
        
        init(table: UITableView) {
            super.init()
            
            objc_setAssociatedObject(table, &tableSectionsSourceKey, self, .OBJC_ASSOCIATION_RETAIN)
            
            $sections
                .bind { [weak table] _ in table?.reloadData() }
                .disposed(by: table.disposeBag)
        }
        
        @Observed
        var sections: [TableSection] = []
        
        public func numberOfSections(in tableView: UITableView) -> Int {
            return sections.count
        }
        
        public func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
            return UITableView.automaticDimension
        }
        
        public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return sections[section].tableView(tableView, numberOfRowsInSection: section)
        }
        
        public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            return sections[indexPath.section].tableView(tableView, cellForRowAt: indexPath)
        }
        
        public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return sections[indexPath.section].tableView(tableView, heightForRowAt: indexPath)
        }
        
        public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
            return sections[section].tableView(tableView, viewForHeaderInSection: section)
        }
        
        public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            return sections[section].tableView(tableView, heightForHeaderInSection: section)
        }
        
        public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
            return sections[section].tableView(tableView, viewForFooterInSection: section)
        }
        
        public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
            return sections[section].tableView(tableView, heightForFooterInSection: section)
        }
        
        public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            sections[indexPath.section].tableView(tableView, didSelectRowAt: indexPath)
        }
        
        public func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
            return sections[indexPath.section].tableView(tableView, willSelectRowAt: indexPath)
        }
    }
}
