import Foundation
import UIKit

public protocol ThemeProtocol {
    var black: UIColor { get }
    var blue: UIColor { get }
    var darkGreen: UIColor { get }
    var darkGray: UIColor { get }
    var fuchsiaBlue: UIColor { get }
    var fuchsiaBlue20: UIColor { get }
    var green: UIColor { get }
    var pink: UIColor { get }
    var radicalRed: UIColor { get }
    var red: UIColor { get }
    var white: UIColor { get }
    var yellow: UIColor { get }
}

extension ThemeProtocol {
    
    public var black: UIColor {
        return Color.black.color
    }
    
    public var blue: UIColor {
        return Color.blue.color
    }
    
    public var darkGreen: UIColor {
        return Color.darkGreen.color
    }
    
    public var darkGray: UIColor {
        return Color.darkGray.color
    }
    
    public var green: UIColor {
        return Color.green.color
    }
    
    public var pink: UIColor {
        return Color.pink.color
    }
    
    public var radicalRed: UIColor {
        return Color.radicalRed.color
    }

    public var fuchsiaBlue: UIColor {
        return Color.fuchsiaBlue.color
    }
    
    public var fuchsiaBlue20: UIColor {
        return Color.fuchsiaBlue20.color
    }
    
    public var red: UIColor {
        return Color.red.color
    }

    public var white: UIColor {
        return Color.white.color
    }
    
    public var yellow: UIColor {
        return Color.yellow.color
    }
    
}

struct DynamicTheme: ThemeProtocol {
    
    public init() {
        
    }
    
}
