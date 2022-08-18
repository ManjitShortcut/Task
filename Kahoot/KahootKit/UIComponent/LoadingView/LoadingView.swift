
import UIKit

protocol LoaderProtocol {
    var loadIngView: LoadingView { get }
    func showLoading(color: UIColor)
    func hideLoading()
}

class LoadingView: UIView {
    
    var color: UIColor = .white {
        didSet {
            didSetActivityColor()
        }
    }

    private lazy var loadingActivityIndicator: UIActivityIndicatorView = {
        let loadingActivityIndicator = UIActivityIndicatorView()
        loadingActivityIndicator.style = .large
        loadingActivityIndicator.color = color
        loadingActivityIndicator.translatesAutoresizingMaskIntoConstraints = false
        loadingActivityIndicator.startAnimating()
        return loadingActivityIndicator
    }()
    
    private lazy var blurEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.alpha = 0.2
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        return blurEffectView
    }()
    
    // MARK: - Life Cycle
    
    init() {
        super.init(frame: CGRect.zero)
        addSubView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods
    
    private func addSubView() {
        addSubview(blurEffectView)
        addSubview(loadingActivityIndicator)
        setupLayOut()
    }
    
    private func setupLayOut() {
        
        NSLayoutConstraint.activate([
            blurEffectView.topAnchor.constraint(equalTo: topAnchor),
            blurEffectView.leadingAnchor.constraint(equalTo: leadingAnchor),
            blurEffectView.trailingAnchor.constraint(equalTo: trailingAnchor),
            blurEffectView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            loadingActivityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            loadingActivityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor),
            loadingActivityIndicator.widthAnchor.constraint(equalToConstant: 64),
            loadingActivityIndicator.heightAnchor.constraint(equalToConstant: 64)
        ])
    }
    
    private func didSetActivityColor() {
        loadingActivityIndicator.color = color
    }
}
