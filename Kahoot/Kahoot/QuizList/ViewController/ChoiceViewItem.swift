import Foundation
import UIKit

class ChoiceViewItem: ShadowCollectionViewItem {

    var choiceStatusLeadingConstraint: NSLayoutConstraint?
    var choiceStatusTrailingConstraint: NSLayoutConstraint?

    let shapeImageView: UIImageView = {
        let shapeImageView = UIImageView()
        shapeImageView.translatesAutoresizingMaskIntoConstraints = false
        return shapeImageView
    }()
    
    let choiceResultIconImageView: UIImageView = {
        let correctImageView = UIImageView()
        correctImageView.translatesAutoresizingMaskIntoConstraints = false
        return correctImageView
    }()
    
    private lazy var choiceInfoLabel: Label = {
        let choiceInfoLabel = Label(style: .Mont14)
        choiceInfoLabel.textAlignment = .center
        choiceInfoLabel.textColor = .white
        choiceInfoLabel.textDropShadow(shadowColor: Color.textShadow.color)
        choiceInfoLabel.translatesAutoresizingMaskIntoConstraints = false
        return choiceInfoLabel
    }()
    
    // MARK: Life Cycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInitView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInitView()
    }
    
    private func commonInitView() {
        isAccessibilityElement = true
        accessibilityTraits = [.button]
        contentView.addSubview(choiceInfoLabel)
        contentView.addSubview(shapeImageView)
        contentView.addSubview(choiceResultIconImageView)
        if UIDevice.current.isIPad {
            choiceInfoLabel.style = .Mont24
        } 

        NSLayoutConstraint.activate([
            choiceInfoLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            choiceInfoLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            choiceInfoLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            choiceInfoLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            shapeImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            shapeImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            choiceResultIconImageView.heightAnchor.constraint(equalToConstant: 32),
            choiceResultIconImageView.widthAnchor.constraint(equalToConstant: 32),
            choiceResultIconImageView.leadingAnchor.constraint(equalTo: leadingAnchor)
        ])
    }
    
    open func bind(viewModel: ChoiceViewModel) {
        accessibilityLabel = viewModel.choice.answer
        accessibilityHint = "Double tap to select"
        choiceInfoLabel.text = viewModel.choice.answer
        shapeImageView.isHidden = true
        choiceResultIconImageView.isHidden = true
        isUserInteractionEnabled = true
        contentView.alpha = 1
        shadowLayer.opacity = 0.6

        switch viewModel.state {
        case .timeOut:
            isUserInteractionEnabled = false
            contentView.backgroundColor = viewModel.getChoiceStatusBackgroundColor()
            shadowLayer.backgroundColor = contentView.backgroundColor?.cgColor
            choiceResultIconImageView.isHidden = false
            choiceResultIconImageView.image = viewModel.getChoiceStatusIcon()
            isUserInteractionEnabled = false

//            switch viewModel.getChoicePositionDirection() {
//            case .left:
//                NSLayoutConstraint.activate([
//                    choiceResultIconImageView.leadingAnchor.constraint(equalTo: leadingAnchor)])
//
//            case .right:
//            }
                
        case .normal:
            shapeImageView.isHidden = false
            isUserInteractionEnabled = true
            shapeImageView.image = viewModel.getImageShapeForPosition()
            contentView.backgroundColor = viewModel.getBackgroundColorForPosition()
            shadowLayer.backgroundColor = contentView.backgroundColor?.cgColor
        case .selectChoice:
            isUserInteractionEnabled = false
            shapeImageView.isHidden = false
            shapeImageView.image = viewModel.getImageShapeForPosition()
            if viewModel.didUserSelectOption {
                contentView.backgroundColor = viewModel.getBackgroundColorForPosition()
            } else {
                contentView.alpha = 0.3
                shadowLayer.opacity = 0.1
            }
        }
    }
}
