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

class StackTests: LayoutTestCase {
    
    override func setUp() {
        super.setUp()
        self.recordMode = false
    }
    
    func testHStackDefaultBehaviour() {
        HStack(spacing: 2) {
            Empty(color: .red, width: 7)
             
            Empty(color: .green)
                .align(toPadding: false)
            
            Empty(color: .blue, width: 5)
                .align(top: 4, toPadding: false)
        }
        .background(.gray)
        .padding(left: 1, top: 2, right: 3, bottom: 4)
        .verify(self, size: CGSize(width: 30, height: 30))
    }
    
    func testVStackDefaultBehaviour() {
        VStack(spacing: 2) {
            Empty(color: .red, height: 7)
             
            Empty(color: .green)
                .align(toPadding: false)
            
            Empty(color: .blue, height: 5)
                .align(left: 4, toPadding: false)
        }
        .background(.gray)
        .padding(left: 1, top: 2, right: 3, bottom: 4)
        .verify(self, size: CGSize(width: 30, height: 30))
    }
    
    func testZStackDefualtBehavior() {
        ZStack {
            Empty(color: .white)
                .alignment(.fill(1, toPadding: false))
            
            Empty(color: .green)
                .alignment(.fill())
            
            Empty(color: .red, width: 6, height: 6)
                .alignment(Alignment.right(3, toPadding: false).bottom(2))
        }
        .background(.gray)
        .padding(left: 1, top: 2, right: 3, bottom: 4)
        .verify(self, size: CGSize(width: 15, height: 15))
    }
    
    func testZStackPaddingPreservation() {
        ZStack {
            ZStack {
                Empty(color: .red)
                    .alignment(Alignment.fill().top(toPadding: false))
                
                Empty(color: .black, width: 5, height: 5)
                    .alignment(Alignment.left(toPadding: false).bottom(toPadding: false))
            }
            .background(.green)
            .padding(horizontal: 4, vertical: 0)
            .preserveParentPadding()
            .alignment(Alignment.fill(toPadding: false).top(toPadding: true))
        }
        .background(.blue)
        .padding(left: 2, top: 2, right: 2, bottom: 2)
        .verify(self, size: CGSize(width: 15, height: 15))
    }
    
    func testTypicalLayout() {
        ZStack {
            Empty(color: .blue)
                .align(toPadding: false)
            
            VStack {
                // NavBar
                Empty(color: UIColor.white.withAlphaComponent(0.4), height: 6)
                    .align(toPadding: false)
                
                // Some content
                VStack(spacing: 4) {
                    Empty(color: .white, height: 8)
                    Empty(color: .green)
                }
                .distribution(.fillEqually)
                .align(toPadding: false)
                .preserveParentPadding()
                
                Spacer()
                
                // bottombar horizontal
                HStack(spacing: 4) {
                    Empty(color: .red, height: 6)
                    Empty(color: .green)
                    Empty(color: .yellow)
                }
                .padding(top: 2)
                .background(UIColor.white.withAlphaComponent(0.4))
                .pinToBottom(toPadding: false)
                .distribution(.fillEqually)
                .preserveParentPadding()
            }
            .align(toPadding: false)
            .preserveParentPadding()
        }
        .padding(horizontal: 2, vertical: 2)
        .verify(self, size: CGSize(width: 30, height: 60))
    }
}
