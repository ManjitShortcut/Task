import Foundation
protocol AlertProtocol {
    func showAlert(with title: String,
                   message: String,
                   closeActionTitle: String,
                   closeActionCompletion: (() -> Void)?,
                   otherActionTitle: String?,
                   otherActionCompletion: (() -> Void)?)
}
