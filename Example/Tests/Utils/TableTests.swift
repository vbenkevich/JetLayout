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

import XCTest
import UIKit
import FBSnapshotTestCase
import RxSwift

@testable import JetLayout

class TableTests: LayoutTestCase {
    
    override func setUp() {
        super.setUp()
        self.recordMode = false
    }
    
    func testDynamicSection() {
        let numbers = Observable.just([1, 2])
        
        Table {
            NumberCell.register()
            
            TSection(source: numbers,
                     header: Text("Header").background(.yellow),
                     footer: Text("Footer").background(.blue))
        }
        .padding(10)
        .verify(self, size: CGSize(width: 60, height: 150))
    }
    
    func testSectionsMix() {
        let numbers = Observable.just([1, 2])
        let strings = Observable.just(["s1", "s2"])
        
        Table {
            NumberCell.register()
            StringCell.register()
            
            TSection {
                ZStack {
                    Text("1.0").background(.green)
                }
                .size(height: 44)
                .preserveParentPadding()
            }
            
            TSection(source: numbers)
            
            TSection(source: strings)
            
            TSection(source: numbers.map { n in n.map { $0 * 10 }})
        }
        .padding(10)
        .verify(self, size: CGSize(width: 60, height: 150))
    }
    
    func testDynamicSectionUpdate() {
        class Source {
            @Observed
            var numbers = [1]
        }
        
        let hostView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 100, height: 100)))
        hostView.layoutMargins = .zero
         
        let source = Source()
        Table {
            NumberCell.register()
            
            TSection(source: source.$numbers,
                     header: Text("Header").background(.yellow),
                     footer: Text("Footer").background(.blue))
        }
        .padding(10)
        .attach(to: hostView)
        
        hostView.setNeedsLayout()
        hostView.layoutIfNeeded()
        
        FBSnapshotVerifyView(hostView, identifier: "1")
        
        source.numbers.append(2)
        
        FBSnapshotVerifyView(hostView, identifier: "2")
    }
    
    func testTableBuilderOne() {
        Table {
            TSection {
                Text("1.0").background(.red).size(height: 44)
            }
        }
        .padding(15)
        .verify(self, size: CGSize(width: 50, height: 70))
    }
    
    func testTableBuilderIf() {
        Table {
            if true {
                TSection {
                    Text("1.1").background(.red)
                    Text("2.1").background(.green)
                    Text("3.1").background(.blue)
                }
            }
        }
        .padding(15)
        .verify(self, size: CGSize(width: 50, height: 70))
    }
    
    func testTableBuilderIfElse() {
        Table {
            if false {
                TSection {
                    Text("1.1").background(.red)
                }
            }
            else {
                TSection {
                    Text("1.2").background(.red)
                    Text("2.2").background(.green)
                    Text("3.3").background(.blue)
                }
            }
        }
        .padding(15)
        .verify(self, size: CGSize(width: 50, height: 70))
    }
    
    func testTableBuilderComplex() {
        Table {
            TSection {
                Text("1.0").background(.red)
                    .size(height: 44)
                
                ZStack {
                    Text("2.0").background(.green)
                }
                .size(height: 44)
                .preserveParentPadding()
            }
            
            if false {
                TSection {
                    Text("1.1").background(.red)
                    Text("2.1").background(.green)
                }
            }
            else {
                TSection {
                    Text("1.2").background(.red)
                    Text("2.2").background(.green)
                }
            }
        }
        .padding(10)
        .verify(self, size: CGSize(width: 60, height: 150))
    }
    
    func testHeaderFooter() {
        Table {
            TSection(header: Text("Header").background(.yellow),
                     footer: Text("Footer").background(.blue)) {
                Text("1.0").background(.red)
                    .size(height: 44)
                
                ZStack {
                    Text("2.0").background(.green)
                }
                .size(height: 44)
                .preserveParentPadding()
            }
        }
        .padding(10)
        .verify(self, size: CGSize(width: 60, height: 150))
    }
    
    
    class NumberCell: ViewBasedTableCell<Int> {
        
        override var view: View {
            Text($model.compactMap{ $0 }.map {"int \($0)"})
                .align(toPadding: true)
        }
    }
    
    class StringCell: ViewBasedTableCell<String> {
        
        override var view: View {
            Text($model)
        }
    }
}
