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

public extension Alignment {
    
    init(left: CGFloat? = nil, top: CGFloat? = nil, right: CGFloat? = nil, bottom: CGFloat? = nil,
         centerX: CGFloat? = nil, centerY: CGFloat? = nil, priority: UILayoutPriority = .defaultHigh) {
        self.leftAnchor.constant = left
        self.rightAnchor.constant = right
        self.topAnchor.constant = top
        self.bottomAnchor.constant = bottom
        self.centerXAnchor.constant = centerX
        self.centerYAnchor.constant = centerY
        self.setPriority(priority)
    }
    
    mutating func setPriority(_ priority: UILayoutPriority) {
        leftAnchor.priority = priority
        rightAnchor.priority = priority
        topAnchor.priority = priority
        bottomAnchor.priority = priority
        centerYAnchor.priority = priority
        centerXAnchor.priority = priority
    }
}

public extension Alignment {
    
    func left(_ offset: CGFloat = 0, toPadding: Bool? = true, priority: UILayoutPriority = UILayoutPriority.required) -> Alignment {
        var alignmet = self
        alignmet.leftAnchor.constant = offset
        alignmet.leftAnchor.priority = priority
        
        if let toPadding = toPadding {
            alignmet.leftAnchor.isPaddingRelative = toPadding
        }
        
        return alignmet
    }
    
    func right(_ offset: CGFloat = 0, toPadding: Bool? = true, priority: UILayoutPriority = UILayoutPriority.required) -> Alignment {
        var alignmet = self
        alignmet.rightAnchor.constant = offset
        alignmet.rightAnchor.priority = priority
        
        if let toPadding = toPadding {
            alignmet.rightAnchor.isPaddingRelative = toPadding
        }
        
        return alignmet
    }
    
    func top(_ offset: CGFloat = 0, toPadding: Bool? = true, priority: UILayoutPriority = UILayoutPriority.required) -> Alignment {
        var alignmet = self
        alignmet.topAnchor.constant = offset
        alignmet.topAnchor.priority = priority
        
        if let toPadding = toPadding {
            alignmet.topAnchor.isPaddingRelative = toPadding
        }
        
        return alignmet
    }
    
    func bottom(_ offset: CGFloat = 0, toPadding: Bool? = true, priority: UILayoutPriority = UILayoutPriority.required) -> Alignment {
        var alignmet = self
        alignmet.bottomAnchor.constant = offset
        alignmet.bottomAnchor.priority = priority
        
        if let toPadding = toPadding {
            alignmet.bottomAnchor.isPaddingRelative = toPadding
        }
        
        return alignmet
    }
    
    func centerX(_ offset: CGFloat = 0, toPadding: Bool? = true, priority: UILayoutPriority = UILayoutPriority.required) -> Alignment {
        var alignmet = self
        alignmet.centerXAnchor.constant = offset
        alignmet.centerXAnchor.priority = priority
        
        if let toPadding = toPadding {
            alignmet.centerXAnchor.isPaddingRelative = toPadding
        }
        
        return alignmet
    }
    
    func centerY(_ offset: CGFloat = 0, toPadding: Bool? = true, priority: UILayoutPriority = UILayoutPriority.required) -> Alignment {
        var alignmet = self
        alignmet.centerYAnchor.constant = offset
        alignmet.centerYAnchor.priority = priority
        
        if let toPadding = toPadding {
            alignmet.centerYAnchor.isPaddingRelative = toPadding
        }
        
        return alignmet
    }
}

public extension Alignment {
  
    static func fill(_ offset: CGFloat = 0, toPadding: Bool = true, priority: UILayoutPriority = UILayoutPriority.required) -> Alignment {
        var alignmet = Alignment(left: offset, top: offset, right: offset, bottom: offset, priority: priority)
        alignmet.leftAnchor.isPaddingRelative = toPadding
        alignmet.rightAnchor.isPaddingRelative = toPadding
        alignmet.topAnchor.isPaddingRelative = toPadding
        alignmet.bottomAnchor.isPaddingRelative = toPadding
        alignmet.centerYAnchor.isPaddingRelative = toPadding
        alignmet.centerXAnchor.isPaddingRelative = toPadding
        return alignmet
    }
    
    static func left(_ offset: CGFloat = 0, toPadding: Bool = true, priority: UILayoutPriority = UILayoutPriority.required) -> Alignment {
        var alignmet =  Alignment(left: offset, priority: priority)
        alignmet.leftAnchor.isPaddingRelative = toPadding
        return alignmet
    }
    
    static func top(_ offset: CGFloat = 0, toPadding: Bool = true, priority: UILayoutPriority = UILayoutPriority.required) -> Alignment {
        var alignmet =  Alignment(top: offset, priority: priority)
        alignmet.topAnchor.isPaddingRelative = toPadding
        return alignmet
    }
    
    static func right(_ offset: CGFloat = 0, toPadding: Bool = true, priority: UILayoutPriority = UILayoutPriority.required) -> Alignment {
        var alignmet =  Alignment(right: offset, priority: priority)
        alignmet.rightAnchor.isPaddingRelative = toPadding
        return alignmet
    }
    
    static func bottom(_ offset: CGFloat = 0, toPadding: Bool = true, priority: UILayoutPriority = UILayoutPriority.required) -> Alignment {
        var alignmet =  Alignment(bottom: offset, priority: priority)
        alignmet.bottomAnchor.isPaddingRelative = toPadding
        return alignmet
    }
    
    static func center(toPadding: Bool = true, priority: UILayoutPriority = UILayoutPriority.required) -> Alignment {
        var alignmet =  Alignment(centerX: 0, centerY: 0, priority: priority)
        alignmet.centerXAnchor.isPaddingRelative = toPadding
        alignmet.centerYAnchor.isPaddingRelative = toPadding
        return alignmet
    }
    
    static func centerX(_ offset: CGFloat = 0, toPadding: Bool = true, priority: UILayoutPriority = UILayoutPriority.required) -> Alignment {
        var alignmet =  Alignment(centerX: offset, priority: priority)
        alignmet.centerXAnchor.isPaddingRelative = toPadding
        return alignmet
    }
    
    static func centerY(_ offset: CGFloat = 0, toPadding: Bool = true, priority: UILayoutPriority = UILayoutPriority.required) -> Alignment {
        var alignmet =  Alignment(centerY: offset, priority: priority)
        alignmet.centerYAnchor.isPaddingRelative = toPadding
        return alignmet
    }
}
