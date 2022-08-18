
import Foundation
import UIKit

extension UIViewController {
    public func present(_ viewControllerToPresent: UIViewController) {
        self.present(viewControllerToPresent, animated: true, completion: nil)
    }
    
    public func hideNavigationBackButton() {
        self.navigationItem.setHidesBackButton(true, animated: true)
    }
    
    var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
}

extension UIViewController: AlertProtocol {
    
    func showAlert(with title: String,
                   message: String,
                   closeActionTitle: String = "Ok",
                   closeActionCompletion: (() -> Void)? = nil,
                   otherActionTitle: String? = nil,
                   otherActionCompletion: (() -> Void)? = nil) {
        
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: closeActionTitle,
                                      style: .cancel,
                                      handler: { _ in
            closeActionCompletion?()
        }))
        
        if let actionTitle = otherActionTitle {
            alert.addAction(UIAlertAction(title: actionTitle,
                                          style: .default,
                                          handler: {_ in
                otherActionCompletion?()
            }))
        }
        
        self.present(alert)
    }
}
