import Foundation
import UIKit

// reference taken from https://medium.com/livefront/practical-dynamic-type-d2b5774e8a8a

extension UIFont {
    
    public enum FontSize {
        /// Custom size
        case custom(CGFloat)
        case Montserrat12
        case Montserrat14
        case Montserrat16
        case Montserrat20
        case Montserrat24
        case Montserrat28

        var value: CGFloat {
            switch self {
            case .custom(let size):
                return size
            case .Montserrat12:
                return 12
            case .Montserrat14:
                return 14
            case .Montserrat16:
                return 16
            case .Montserrat20:
                return 20
            case .Montserrat28:
                return 28
            case .Montserrat24:
                return 24
            }
        }
    }

    private class func maxPointSize(for size: FontSize) -> CGFloat {
        return size.value * 1.4
    }

    public class func font(ofSize size: FontSize,
                           weight: UIFont.Weight = .regular,
                           isDynamic: Bool = true,
                           textStyle: TextStyle = .body) -> UIFont {
        let fontName = fontNameForWeight(weight)
        let fontMetrics = UIFontMetrics(forTextStyle: textStyle)
        if let font = UIFont(name: fontName, size: size.value) {
            return isDynamic ? fontMetrics.scaledFont(for: font, maximumPointSize: size.value) : font
        } else {
            print("Missing font: Montserrat. Using system font.")
            let font = UIFont.systemFont(ofSize: size.value, weight: weight)
            return isDynamic ? fontMetrics.scaledFont(for: font, maximumPointSize: size.value) : font
        }
    }
    
    private class func fontNameForWeight(_ weight: UIFont.Weight) -> String {
        switch weight {
        case .regular:
            return "Montserrat-Regular"
        default:
            print("Unsupported font weight \(weight). Defaulting to regular.")
            return "Montserrat-Regular"
        }
    }
}
