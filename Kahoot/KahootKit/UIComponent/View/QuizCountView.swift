import Foundation
import UIKit
open class QuizCountView: UIView {
    
    var theme: ThemeProtocol? {
        didSet {
            didSetColor()
        }
    }

    var title: String = "" {
        didSet {
            didSetText(text: title)
        }
    }
    
    private let titleLabel: Label = {
        let titleLabel = Label(style: .Mont16)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        return titleLabel
    }()
    
    // MARK: - Life Cycle

    init(title: String = "0/0") {
        self.title = title
        super.init(frame: CGRect.zero)
        commonInit()
        didSetText(text: title)
        didSetColor()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.height/2
    }
    
    // MARK: - Private methods

    private func commonInit() {
        clipsToBounds = true
        isAccessibilityElement = true
        addSubview(titleLabel)
        setUpLayout()
    }
    
    private func setUpLayout() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 6),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -6)
        ])
    }
    
    private func didSetColor() {
        titleLabel.textColor = theme?.darkGray
        backgroundColor = theme?.white
    }

    private func didSetText(text: String) {
        titleLabel.text = text
        accessibilityValue = text
    }
}
