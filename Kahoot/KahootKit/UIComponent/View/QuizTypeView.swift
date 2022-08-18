import UIKit

open class QuizTypeView: UIView {
    
    var theme: ThemeProtocol? {
        didSet {
            didSetColor()
        }
    }
    
    var title: String = "" {
        didSet {
            didSetTitle()
        }
    }
    
    let imageView: UIImageView = {
        let backGroundImageView = UIImageView()
        backGroundImageView.image = Asset.Figma.Quiz.quiz.image
        backGroundImageView.translatesAutoresizingMaskIntoConstraints = false
        return backGroundImageView
    }()
    
    private let titleLabel: Label = {
        let titleLabel = Label(style: .Mont14)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.accessibilityTraits = .header
        return titleLabel
    }()
    
    private lazy var parentStackView: UIStackView = {
        let parentStackView = UIStackView()
        parentStackView.axis = .horizontal
        parentStackView.translatesAutoresizingMaskIntoConstraints = false
        parentStackView.spacing = 8
        return parentStackView
    }()
    
    // MARK: - Life Cycle

    init(title: String = "",
         theme: ThemeProtocol? = nil) {
        self.title = title
        self.theme = theme
        super.init(frame: CGRect.zero)
        commonInit()
        didSetTitle()
        didSetColor()
    }
    
    required public init?(coder: NSCoder) {
        self.title = ""
        self.theme = nil
        super.init(coder: coder)
        commonInit()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = self.frame.height/2
    }
    
    // MARK: - Private methods

    private func commonInit() {
        clipsToBounds = true
        isAccessibilityElement = true
        
        addSubview(parentStackView)
        parentStackView.addArrangedSubview(imageView)
        parentStackView.addArrangedSubview(titleLabel)
        setupLayout()
    }
    
    private func setupLayout() {

        NSLayoutConstraint.activate([
            parentStackView.leadingAnchor.constraint(equalTo: leadingAnchor,
                                                     constant: 12),
            parentStackView.trailingAnchor.constraint(equalTo: trailingAnchor,
                                                      constant: -12).priorityLow(),
            parentStackView.topAnchor.constraint(equalTo: topAnchor, constant: 4),
            parentStackView.bottomAnchor.constraint(equalTo: bottomAnchor,
                                                    constant: -4).priorityLow(),
            imageView.heightAnchor.constraint(equalToConstant: 24),
            imageView.widthAnchor.constraint(equalToConstant: 24),
        ])
    }
    
    private func didSetColor() {
        backgroundColor = theme?.white
        titleLabel.textColor = theme?.darkGray
    }
    
    private func didSetTitle() {
        titleLabel.text = title
        accessibilityValue = title
    }
}
