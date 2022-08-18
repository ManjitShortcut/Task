import UIKit

public enum ChoiceStatus {
    case wrong
    case correct
    var text: String {
        switch self {
        case .wrong:
            return "Wrong"
        case .correct:
            return "Correct"
        }
    }
}

class AnswerResultView: UIView {

    var choiceStatus = ChoiceStatus.wrong {
        didSet{
            didSetChoiceStatus(status: choiceStatus)
            didSetColor()
        }
    }
    
    var theme: ThemeProtocol? {
        didSet {
            didSetColor()
        }
    }
    
    private let titleLabel: Label = {
        let titleLabel = Label(style: .Mont20)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textAlignment = .center
        titleLabel.textDropShadow(shadowColor: Color.textShadow.color)
        return titleLabel
    }()
    
    // MARK: - Life Cycle

    init(_ status: ChoiceStatus,
         theme: ThemeProtocol? = nil) {
        self.theme = theme
        self.choiceStatus = status
        super.init(frame: CGRect.zero)
        commonInit()
        didSetColor()
        didSetChoiceStatus(status: status)
    }
    
    required init?(coder: NSCoder) {
        self.theme = nil
        super.init(coder: coder)
        commonInit()
    }
    
    // MARK: - Private methods

    private func commonInit() {
        clipsToBounds = true
        isAccessibilityElement = true
        
        addSubview(titleLabel)
        setupLayout()
    }
    
    private func setupLayout() {
        if UIDevice.current.isIPad {
            titleLabel.style = .Mont28
        }
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor,
                                                constant: .defaultMargin),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor,
                                                 constant: -.defaultMargin),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    private func didSetColor() {
        titleLabel.textColor = theme?.white
        switch choiceStatus {
        case .wrong:
            backgroundColor = theme?.red
        case .correct:
            backgroundColor = theme?.green
        }
    }
    
    private func didSetChoiceStatus(status: ChoiceStatus) {
        accessibilityLabel = status.text
        titleLabel.text = status.text
    }
}
