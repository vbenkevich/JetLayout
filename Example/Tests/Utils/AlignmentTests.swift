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

@testable import JetLayout

class AlignmentTests: LayoutTestCase {

    override func setUp() {
        super.setUp()
        self.recordMode = false
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testWithoutOffsets() {
        [
            Empty(color: .white),
            
            Empty(color: .green, width: 10, height: 10)
                .alignment(Alignment.top().left()),

            Empty(color: .blue, width: 10, height: 10)
                .alignment(Alignment.top().right()),

            Empty(color: .yellow, width: 10, height: 10)
                .alignment(Alignment.bottom().left()),

            Empty(color: .magenta, width: 10, height: 10)
                .alignment(Alignment.bottom().right()),

            Empty(color: .black, width: 10, height: 10)
                .alignment(Alignment.center()),

            Empty(color: .red, width: 10, height: 10)
                .alignment(Alignment.centerY().left()),

            Empty(color: .brown, width: 10, height: 10)
                .alignment(Alignment.centerY().right()),

            Empty(color: .gray, width: 10, height: 10)
                .alignment(Alignment.centerX().top()),

            Empty(color: .orange, width: 10, height: 10)
                .alignment(Alignment.centerX().bottom()),
        ]
        .verify(self, size: CGSize(width: 40, height: 40))
    }
    
    func testWithOffsets() {
        [
            Empty(color: .white),
            
            Empty(color: .green, width: 10, height: 10)
                .alignment(Alignment.top(-2).left(2)),
            
            Empty(color: .blue, width: 10, height: 10)
                .alignment(Alignment.top(2).right(2)),
            
            Empty(color: .yellow, width: 10, height: 10)
                .alignment(Alignment.bottom(2).left(2)),
            
            Empty(color: .magenta, width: 10, height: 10)
                .alignment(Alignment.bottom(2).right(2)),
            
            Empty(color: .red, width: 10, height: 10)
                .alignment(Alignment.centerY(2).left(-2)),
            
            Empty(color: .brown, width: 10, height: 10)
                .alignment(Alignment.centerY(-2).right(-2)),
            
            Empty(color: .gray, width: 10, height: 10)
                .alignment(Alignment.centerX(-2).top(8)),
            
            Empty(color: .orange, width: 10, height: 10)
                .alignment(Alignment.centerX(2).bottom(-2)),
        ]
        .verify(self, size: CGSize(width: 30, height: 30))
    }
    
    func testAnchorToPadding() {
        ZStack() {
            Empty(color: .black)
                .alignment(.fill(0, toPadding: false))
            
            Empty(color: .green)
                .alignment(Alignment
                    .top(1, toPadding: false)
                    .left(2, toPadding: false)
                    .bottom(3, toPadding: false)
                    .right(4, toPadding: false))

            Empty(color: .red)
                .alignment(Alignment
                    .left()
                    .right()
                    .top()
                    .bottom())
        }
        .preserveParentPadding(false)
        .padding(5)
        .verify(self, size: CGSize(width: 30, height: 30))
    }
}
