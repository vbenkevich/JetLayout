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

import JetLayout

class DynamicTableViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Dynamic table view"
        body.root(of: self)
    }
    
    @Observed
    var items: [String] = []
    
    var body: View {
        VStack(spacing: 24) {
            AddItemView { [weak self] in self?.items.append($0) }
            
            ItemsTable(items: self.$items)
        }
        .background(.white)
    }
}

struct AddItemView: View {
    
    let onAddClicked: (String) -> Void
    
    @Observed
    private var itemName: String? = "Add new item"

    var body: Layout {
        HStack(spacing: 16) {
            Field(self.$itemName).placeholder("Item mame")
            
            Button(type: .contactAdd)
                .disabled(source: self.$itemName.isEmpty)
                .tap {
                    self.onAddClicked(self.itemName ?? "")
                    self.itemName = ""
                }
        }
        .padding(16)
        .preserveParentPadding()
    }
}

struct ItemsTable: View {
    
    let items: Observed<[String]>
    
    var body: Layout {
        Table {
            // Cells registration
            ItemCell.register()
            
            // Static section at top
            TSection {
                Image(#imageLiteral(resourceName: "Logo"))
                    .alignment(.fill())
                    .size(height: 80)
                    .contentMode(.scaleAspectFit)
            }
            
            // Dynamic section
            TSection(source: self.items)
        }
        .preserveParentPadding()
    }
}


class ItemCell: ViewBasedTableCell<String> {
    
    override var view: View {
        HStack {
            Text(self.$model)
        }.preserveParentPadding()
    }
}
