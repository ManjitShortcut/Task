
import UIKit

class Label: UILabel {
    
    /// font size
    public var style: Style {
        didSet { setFontStyle(style: style) }
    }
    
    public var textStyle: UIFont.TextStyle {
        didSet { setFontStyle(style: style) }
    }
    
    public override var adjustsFontForContentSizeCategory: Bool {
        didSet { setFontStyle(style: style) }
    }
    
    public init(style: Style,
                textStyle: UIFont.TextStyle = .body) {
        self.style = style
        self.textStyle = textStyle
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        self.style = .Mont16
        self.textStyle = .body
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        // Set up accessibility stuff here?
        
        adjustsFontForContentSizeCategory = true
        numberOfLines = 0
        setFontStyle(style: style)
    }
    
    
    private func setFontStyle(style: Style) {
        font = style.font(textStyle: textStyle,
                          dynamic: adjustsFontForContentSizeCategory)
    }
    
}

extension Label {
    
    public enum Style {
        
        /** Montserrat UI (12pt) - Normal */
        
        case Mont12
        
        /** Montserrat UI (14pt) - Normal */
        case Mont14
        
        /** Montserrat UI (16pt) - Normal */
        case Mont16
        
        /** Montserrat UI (20pt) - Normal */
        case Mont20
        
        /** Montserrat UI (20pt) - Normal */
        case Mont28

        /// Uses the font given or other font
        case custom(UIFont)
        
        // swiftlint:disable:next cyclomatic_complexity
        public func font(textStyle: UIFont.TextStyle = .body,
                         dynamic: Bool = true) -> UIFont {
            switch self {
            case .Mont12:
                
                return .font(ofSize: .Montserrat12,
                             weight: .regular,
                             textStyle: textStyle)
                
            case .Mont14:
                return .font(ofSize: .Montserrat14,
                             weight: .regular,
                             textStyle: textStyle)
            case .Mont16:
                return .font(ofSize: .Montserrat16, weight: .regular, textStyle: textStyle)
            case .Mont20:
                return .font(ofSize: .Montserrat20, weight: .regular, textStyle: textStyle)
                
            case .Mont28:
                return .font(ofSize: .Montserrat28, weight: .regular, textStyle: textStyle)

            case .custom(let font):
                return font
            }
        }
    }
}


extension Label {
    
    func textDropShadow() {
        layer.masksToBounds = false
        layer.shadowOpacity = 0.35
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 4, height: 2)
    }
}
