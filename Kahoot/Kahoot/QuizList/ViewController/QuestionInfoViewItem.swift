import Foundation
import UIKit
import Kingfisher

class QuestionInfoViewItem: UIView {
    
    var theme: ThemeProtocol? {
        didSet {
            didSetTheme()
        }
    }
    
    var questionInfo: QuizQuestion? {
        didSet {
            didSetQuestion(questionInfo: questionInfo)
        }
    }
    
    // MARK: - UIComponent

    private let questionImageView: UIImageView = {
        let questionImageView = UIImageView()
        questionImageView.clipsToBounds = true
        questionImageView.layer.cornerRadius = 4
        questionImageView.translatesAutoresizingMaskIntoConstraints = false
        return questionImageView
    }()

    private let questionLabel: Label = {
        let questionLabel = Label(style: .Mont16)
        questionLabel.textAlignment = .center
        questionLabel.translatesAutoresizingMaskIntoConstraints = false
        return questionLabel
    }()
    
    private let questionBgView: UIView = {
        let questionBgView = UIView()
        questionBgView.clipsToBounds = true
        questionBgView.layer.cornerRadius = 4
        questionBgView.translatesAutoresizingMaskIntoConstraints = false
        return questionBgView
    }()

    // MARK: - Life Cycle
    
    init(questionInfo: QuizQuestion? = nil,
         theme: ThemeProtocol? = nil) {
        self.questionInfo = questionInfo
        super.init(frame: CGRect.zero)
        commonInit()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    // MARK: - Private methods
    
    private func commonInit() {
        clipsToBounds = true
        isAccessibilityElement = true
        addSubview(questionImageView)
        addSubview(questionBgView)
        addSubview(questionLabel)
        setUpLayout()
    }
    
    private func setUpLayout() {
       
        if UIDevice.current.isIPad {
            questionLabel.style = .Mont28
        }
        
        NSLayoutConstraint.activate([
            questionImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .defaultSpacing),
            questionImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.defaultSpacing),
            questionImageView.topAnchor.constraint(equalTo: topAnchor, constant: .defaultSpacing),
            
            questionLabel.topAnchor.constraint(equalTo: questionImageView.bottomAnchor, constant: UIDevice.current.isIPad ? 22 * 2 : 2 * .defaultSpacing),
            
            questionLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: UIDevice.current.isIPad ? -22 : -.defaultSpacing),
            questionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: UIDevice.current.isIPad ? .double : .single),
            questionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: UIDevice.current.isIPad ? -.double : -.single),
            
            questionBgView.leadingAnchor.constraint(equalTo: leadingAnchor),
            questionBgView.trailingAnchor.constraint(equalTo: trailingAnchor),
            questionBgView.bottomAnchor.constraint(equalTo: bottomAnchor),
            questionBgView.heightAnchor.constraint(equalTo: questionLabel.heightAnchor,
                                                   constant: UIDevice.current.isIPad ? 22 * 2 : 2 * .defaultSpacing)
        ])
        
        questionImageView.setContentHuggingPriority(.defaultLow, for: .vertical)
        questionLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
    }
    
    private func didSetQuestion(questionInfo: QuizQuestion?) {

        if let questionInfo = questionInfo {
            questionLabel.text = questionInfo.formattedQuestion
            accessibilityLabel = questionInfo.formattedQuestion
            accessibilityValue = questionInfo.formattedQuestion
            self.layoutIfNeeded()
            if let url = questionInfo.image {
                DispatchQueue.main.async {
                    self.questionImageView.kf.setImage(with: url,
                                                       options: [.processor(DownsamplingImageProcessor(size: self.questionImageView.bounds.size)),
                                                        .scaleFactor(UIScreen.main.scale),
                                                        .cacheOriginalImage])
                }
            } else {
                questionImageView.isHidden = true
            }
        } else {
            accessibilityLabel = nil
        }
    }
    
    private func didSetTheme() {
        questionLabel.textColor = theme?.darkGray
        questionBgView.backgroundColor = theme?.white
    }
}
