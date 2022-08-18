import UIKit

public typealias AppMargin = CGFloat

extension AppMargin {
    public static var none: AppMargin {
        0.0
    }

    public static var single: AppMargin {
        8.0
    }

    public static var half: AppMargin {
        single / 2
    }

    public static var double: AppMargin {
        single * 2
    }

    public static var triple: AppMargin {
        single * 3
    }

    public static var quadruple: AppMargin {
        single * 4
    }
    
    public static var defaultMargin: AppMargin {
        return 16.0
    }
}

public typealias AppSpacing = CGFloat

extension AppSpacing {
    
    public static var defaultSpacing: AppSpacing {
        return 16.0
    }
}
 
