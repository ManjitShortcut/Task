import UIKit

class BaseViewController: UIViewController {

    lazy var loadIngView: LoadingView  = {
        let loader = LoadingView()
        loader.translatesAutoresizingMaskIntoConstraints = false
        return loader
    }()
    
    private let backGroundImageView: UIImageView = {
        let backGroundImageView = UIImageView()
        backGroundImageView.image = Asset.Figma.Background.background.image
        backGroundImageView.translatesAutoresizingMaskIntoConstraints = false
        return backGroundImageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setBackgroundImage()
    }
    
    private func setBackgroundImage() {
        view.addSubview(backGroundImageView)
        backGroundImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            backGroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backGroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backGroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backGroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

// MARK: - LoaderProtocol

extension BaseViewController: LoaderProtocol {
    
    func showLoading(color: UIColor) {
        loadIngView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loadIngView)
        loadIngView.color = color
        NSLayoutConstraint.activate([
            loadIngView.topAnchor.constraint(equalTo: view.topAnchor),
            loadIngView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            loadIngView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            loadIngView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func hideLoading() {

        loadIngView.removeFromSuperview()
    }
}
