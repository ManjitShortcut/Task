import Foundation
import UIKit

final class AppInitializerCoordinator: CoordinatorProtocol {
    internal var navigationController: UINavigationController?
    private var window: UIWindow
    private(set) weak var parentCoordinator: ParentCoordinatorProtocol?
    private(set) lazy var childCoordinators = [CoordinatorProtocol]()
    private let dependencyContainer: DependencyContainer

    init(window: UIWindow,
         dependencyContainer: DependencyContainer) {
        self.dependencyContainer = dependencyContainer
        self.window = window
    }
    
    // MARK: - CoordinatorProtocol

    func start() {
        let viewModel = AppInitializerViewModel(coordinator: self)
        let initialViewController = AppInitializerViewController(viewModel: viewModel,
                                                                 theme: dependencyContainer.theme)
        navigationController = UINavigationController(rootViewController: initialViewController)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
    
    func childDidFinish(_ child: CoordinatorProtocol) {
        childCoordinators.removeAll { $0 === child }
    }
    
    func didFinishedAll() {
        childCoordinators.removeAll()
        parentCoordinator?.childDidFinish(self)
    }
    
    func showAlert(with title: String,
                   message: String,
                   closeActionTitle: String,
                   closeActionCompletion: (() -> Void)?,
                   otherActionTitle: String?,
                   otherActionCompletion: (() -> Void)?) {
        
    }
}

// MARK: - AppInitializerViewModelCoordinating

extension AppInitializerCoordinator: AppInitializerViewModelCoordinating {
    
    func appInitializerViewModelDidNavigateToNext(_ appInitializerViewModel: AppInitializerViewModel) {
        let quizInfoCoordinator = QuizInfoCoordinator(parentCoordinator: self,
                                                      navigationController: navigationController,
                                                      dependencyContainer: dependencyContainer)
        childCoordinators.append(quizInfoCoordinator)
        quizInfoCoordinator.start()
    }
}
