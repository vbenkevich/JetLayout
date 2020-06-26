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

class LayoutTestCase: FBSnapshotTestCase {
    
    var size = CGSize(width: 100, height: 100)
    
    func verify(_ view: View, size: CGSize? = nil, identifier: String? = nil, suffixes: NSOrderedSet = FBSnapshotTestCaseDefaultSuffixes(), perPixelTolerance: CGFloat = 0, overallTolerance: CGFloat = 0, file: StaticString = #file, line: UInt = #line) {
        let hostView = UIView(frame: CGRect(origin: .zero, size: size ?? self.size))
        hostView.layoutMargins = .zero
        
        view.attach(to: hostView)
        
        hostView.setNeedsLayout()
        hostView.layoutIfNeeded()
        
        FBSnapshotVerifyView(hostView, identifier: identifier, suffixes: suffixes, perPixelTolerance: perPixelTolerance, overallTolerance: overallTolerance, file: file, line: line)
    }
    
    func verify(_ views: [View], size: CGSize? = nil, identifier: String? = nil, suffixes: NSOrderedSet = FBSnapshotTestCaseDefaultSuffixes(), perPixelTolerance: CGFloat = 0, overallTolerance: CGFloat = 0, file: StaticString = #file, line: UInt = #line) {
        let hostView = UIView(frame: CGRect(origin: .zero, size: size ?? self.size))
        hostView.layoutMargins = .zero
        hostView.layoutIfNeeded()
        
        views.forEach {
            $0.attach(to: hostView)
        }
        
        hostView.setNeedsLayout()
        hostView.layoutIfNeeded()
        
        FBSnapshotVerifyView(hostView, identifier: identifier, suffixes: suffixes, perPixelTolerance: perPixelTolerance, overallTolerance: overallTolerance, file: file, line: line)
    }
}

extension View {
    
    func attach(to view: UIView) {
        let body = self.body
        
        if body.alignment.isDefault {
            body.alignment = .fill()
        }
        
        body.layout(container: view)
    }
    
    func verify(_ testCase: LayoutTestCase, size: CGSize? = nil, identifier: String? = nil, suffixes: NSOrderedSet = FBSnapshotTestCaseDefaultSuffixes(), perPixelTolerance: CGFloat = 0, overallTolerance: CGFloat = 0, file: StaticString = #file, line: UInt = #line) {
        
        testCase.verify(self, size: size, identifier: identifier, suffixes: suffixes, perPixelTolerance: perPixelTolerance, overallTolerance: overallTolerance, file: file, line: line)
    }
}

extension Array where Element: View {
    func verify(_ testCase: LayoutTestCase, size: CGSize? = nil, identifier: String? = nil, suffixes: NSOrderedSet = FBSnapshotTestCaseDefaultSuffixes(), perPixelTolerance: CGFloat = 0, overallTolerance: CGFloat = 0, file: StaticString = #file, line: UInt = #line) {
        
        testCase.verify(self, size: size, identifier: identifier, suffixes: suffixes, perPixelTolerance: perPixelTolerance, overallTolerance: overallTolerance, file: file, line: line)
    }
}

