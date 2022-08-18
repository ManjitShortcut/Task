
import Foundation
import UIKit

public extension NSLayoutConstraint {
    
    /// Read more here:-https://aplus.rs/2017/one-solution-for-90pct-auto-layout/
    ///
    func collapsable() -> NSLayoutConstraint {
        self.priority = UILayoutPriority(999)
        return self
    }
    
    func priorityHigh() -> NSLayoutConstraint {
        self.priority = UILayoutPriority(1000)
        return self
    }
    
    func priorityLow() -> NSLayoutConstraint {
        self.priority = UILayoutPriority(250)
        return self
    }
}

extension CGFloat {
    
}

