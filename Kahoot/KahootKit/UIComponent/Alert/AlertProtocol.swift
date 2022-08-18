import Foundation
protocol AlertProtocol {
    /// Show alert
    /// Depend your case  implement the protocol to specific class or coordinator
    ///
    /// Parameters:
    /// - Parameter title: Title of the alert message
    /// - message: Description of the alert message.
    /// - closeActionTitle: Close action title
    /// - closeActionCompletion : Close action completion callback
    /// - otherActionTitle: Other action title
    /// - otherActionCompletion: Other action completion call back
    func showAlert(with title: String,
                   message: String,
                   closeActionTitle: String,
                   closeActionCompletion: (() -> Void)?,
                   otherActionTitle: String?,
                   otherActionCompletion: (() -> Void)?)
}
