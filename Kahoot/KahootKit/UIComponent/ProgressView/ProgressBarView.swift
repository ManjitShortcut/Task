import Foundation
import UIKit

protocol ProgressBarViewDelegate: AnyObject {
    func progressBarViewDidFinishedAnimation(_ progressBarView: ProgressBarView)
}
open class ProgressBarView: UIView {
    
    weak var delegate: ProgressBarViewDelegate?
    
    var borderWidth: CGFloat = 2 {
        didSet {
            didSetBorderWidth()
        }
    }
    
    var borderColor: UIColor = .black {
        didSet {
            didSetBorderColor()
        }
    }
    
    var fillColor: UIColor = .white {
        didSet {
            didSetFillColor()
        }
    }
  
    var textColor: UIColor = .white {
        didSet {
            didSetTextColor()
        }
    }
    
    var text: String = "" {
        didSet {
            didSetText(text: text)
        }
    }
    
    /// Change progress value to update progress view
    ///
    /// Call didUpdatedProgressView when progress Value change
    var animationDuration: CGFloat = 1 {
        didSet {
            didSetText(text: "\(Int(animationDuration))")
            self.isHidden = false
        }
    }
    
    private var viewWidth = 0.0
    private let progressLayerAnimation = CABasicAnimation(keyPath: "bounds.size.width")
    private let textLayerAnimation = CABasicAnimation(keyPath: "position.x")

    // MARK: - UIComponent

    let progressViewLayer: CAShapeLayer = {
        let progressLayer = CAShapeLayer()
         progressLayer.masksToBounds = true
         return progressLayer
    }()
    
    private var progressValueLabel: Label = {
        let progressValueLabel = Label(style: .Mont12)
        progressValueLabel.textAlignment = .left
        progressValueLabel.translatesAutoresizingMaskIntoConstraints = false
        progressValueLabel.backgroundColor = .clear
        progressValueLabel.adjustsFontSizeToFitWidth = true
        progressValueLabel.sizeToFit()
        return progressValueLabel
    }()
    
    // MARK: - Life Cycle

    init(animationDuration: CGFloat = 1) {
        self.animationDuration = animationDuration
        super.init(frame: CGRect.zero)
        commonInit()
        didSetBorderWidth()
        didSetBorderColor()
        didSetFillColor()
        didSetTextColor()
        clipsToBounds = true
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override open func draw(_ rect: CGRect) {
        super.draw(rect)
        let progressRect = CGRect(origin: .zero, size: CGSize(width: rect.width, height: rect.height))
        viewWidth = rect.width
        progressViewLayer.position = CGPoint(x: 0, y: 0)
        progressViewLayer.anchorPoint = CGPoint(x: 0, y: 0.5)
        progressViewLayer.frame = progressRect
        if UIDevice.current.isIPad {
            progressValueLabel.style = .Mont20
            progressValueLabel.frame = CGRect(x: rect.width - 40,
                                              y: (rect.height - 24)/2,
                                              width: 40,
                                              height: 24)
        } else {
            progressValueLabel.style = .Mont12
            progressValueLabel.frame = CGRect(x: rect.width - 20,
                                              y: (rect.height - 14)/2,
                                              width: 20,
                                              height: 14)
        }
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        progressViewLayer.cornerRadius = frame.height/2
    }
    
    // MARK: - Private method

    private func commonInit() {
        self.layer.addSublayer(progressViewLayer)
        self.addSubview(progressValueLabel)
    }
    
    private func didSetBorderWidth () {
        progressViewLayer.borderWidth = borderWidth
    }
    
    private func didSetBorderColor() {
        progressViewLayer.borderColor = borderColor.cgColor
    }
    
    private func didSetFillColor() {
        progressViewLayer.backgroundColor = fillColor.cgColor
    }
    
    private func didSetTextColor() {
        progressValueLabel.textColor = textColor
    }
    
    private func didSetText(text: String) {
        progressValueLabel.text = text
    }
    
    func didUpdatedProgressView() {
    
        progressLayerAnimation.delegate = self
        progressLayerAnimation.duration = animationDuration
        progressLayerAnimation.fromValue = viewWidth
        progressLayerAnimation.toValue = 0
        progressLayerAnimation.fillMode = CAMediaTimingFillMode.removed
        progressLayerAnimation.isRemovedOnCompletion = true
        progressViewLayer.add(progressLayerAnimation, forKey: "widthAnimation")
        textLayerAnimation.duration = animationDuration - 0.5
        if UIDevice.current.isIPad {
            textLayerAnimation.fromValue = viewWidth - 40
        } else {
            textLayerAnimation.fromValue = viewWidth - 20
        }
        textLayerAnimation.toValue = 0
        textLayerAnimation.fillMode = CAMediaTimingFillMode.removed
        textLayerAnimation.isRemovedOnCompletion = true
        progressValueLabel.layer.add(textLayerAnimation, forKey: "position")
    }
    
    func removeAllAnimation() {
        progressViewLayer.removeAllAnimations()
        progressValueLabel.layer.removeAllAnimations()
    }
}
extension ProgressBarView: CAAnimationDelegate {
    
    public func animationDidStop(_ animation: CAAnimation, finished flag: Bool) {
        progressViewLayer.isHidden = true
        delegate?.progressBarViewDidFinishedAnimation(self)
    }
}
