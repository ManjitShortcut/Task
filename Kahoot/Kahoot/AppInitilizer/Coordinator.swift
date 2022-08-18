import Foundation
import UIKit

protocol ParentCoordinatorProtocol: AnyObject {
    /// An array containing child coordinators that this coordinator holds a
    /// reference to to keep them alive.
    var childCoordinators: [CoordinatorProtocol] { get }

    /// Called when a child coordinator has finished.
    func childDidFinish(_ child: CoordinatorProtocol)
    
    /// Called when parent coordinator remove from stack.
    
    func didFinishedAll()
    
}

protocol CoordinatorProtocol: ParentCoordinatorProtocol, AlertProtocol {
    
    var navigationController: UINavigationController? { get }
    
    /// A reference to the parent coordinator of this coordinator. Child coordinator
    /// use it to call `childDidFinish` if necessary.
    
    var parentCoordinator: ParentCoordinatorProtocol? { get }

    /// Called when the coordinator is asked to take over control.
    func start()
    
    /// Show Alert
    ///
}

extension CoordinatorProtocol {
    
    var navigationController: UINavigationController? { return nil }

    func start() {
        
    }
    
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
        navigationController?.present(alert)
    }
}
