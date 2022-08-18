import UIKit

class ShadowButton: UIButton {
    
    var title: String = "" {
        didSet {
            setTitle()
        }
    }
    var theme: ThemeProtocol? {
        didSet {
            updateTheme()
        }
    }
    
    var style: Style = .filled {
        didSet {
            updateStyle()
        }
    }
    
    var shape: Shape = .squareRadius(radius: 4) {
        didSet {
            updateShape()
        }
    }
    
    // MARK: - Life Cycle

    init(style: Style = .filled,
         shape: Shape = .squareRadius(radius: 4)) {
        super.init(frame: CGRect.zero)
        updateStyle()
        updateShape()
        setFont()
        titleLabel?.textAlignment = .center
    }
   
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private methods

    private func updateTheme() {
        updateStyle()
    }
    
    private func updateShape() {
        switch shape {
        case .squareRadius(let radius):
            super.layer.cornerRadius = radius
            super.clipsToBounds = true
        }
    }
    
    private func updateStyle() {
        switch style {
        case .filled:
            setTitleColor(theme?.darkGray, for: state)
            setBackgroundImage(UIImage(color: theme?.white ?? .white), for: state)
        }
    }
    
    private func setTitle() {
        setTitle(title, for: .normal)
        setTitle(title, for: .selected)
    }
    
    private func setFont() {
        titleLabel?.font =  .font(ofSize: .Montserrat16,
                     weight: .regular,
                                  textStyle: .body)
    }
}

extension ShadowButton {
    
    public enum Style {
        case filled
    }
    
    public enum Shape {
        case squareRadius(radius: CGFloat)
        var cornerRadis: CGFloat {
            switch self {
            case .squareRadius(let radius):
                return radius
            }
        }
    }
}
