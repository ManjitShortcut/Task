import Foundation
import UIKit

final class QuizInfoCoordinator: CoordinatorProtocol {
    
    internal var navigationController: UINavigationController?
    private(set) weak var parentCoordinator: ParentCoordinatorProtocol?
    private(set) lazy var childCoordinators = [CoordinatorProtocol]()
    private let dependencyContainer: DependencyContainer

    init(parentCoordinator: ParentCoordinatorProtocol?,
         navigationController: UINavigationController?,
         dependencyContainer: DependencyContainer) {
        self.navigationController = navigationController
        self.parentCoordinator = parentCoordinator
        self.dependencyContainer = dependencyContainer
    }
    
    // MARK: - CoordinatorProtocol

    func start() {

        let viewModel = QuizInfoViewModel(coordinator: self,
                                          quizInfoId: "fb4054fc-6a71-463e-88cd-243876715bc1",
                                          apiService: QuizService(apiService: dependencyContainer.network))
        let initialViewController = QuizInfoViewController(viewModel: viewModel,
                                                           theme: dependencyContainer.theme)
        navigationController?.hideNavigationBar()
        navigationController?.pushViewController(initialViewController, animated: false)
    }
    
    func childDidFinish(_ child: CoordinatorProtocol) {
        childCoordinators.removeAll { $0 === child }
    }
    
    func didFinishedAll() {
        childCoordinators.removeAll()
        parentCoordinator?.childDidFinish(self)
    }
}

// MARK: - QuizListViewModelCoordinating

extension QuizInfoCoordinator: QuizInfoViewModelCoordinating {
    
    func quizInfoViewModel(_ quizInfoViewModel: QuizInfoViewModel,
                           didNavigateToQuiz quiz: QuizInfo) {
        
        let viewModel = QuestionListViewModel(coordinator: self, quizInfo: quiz)
        let viewController = QuestionListViewController(viewModel: viewModel,
                                                    theme: dependencyContainer.theme)
        navigationController?.pushViewController(viewController, animated: false)
    }
    
    func quizInfoViewModel(_ quizInfoViewModel: QuizInfoViewModel,
                           didFailedToFetchQuizInfo error: Error?) {
        showAlert(with: "Error!", message: "Something went wrong.Please try again.", closeActionTitle: "Try Again", closeActionCompletion: {

        }, otherActionTitle: nil)
        
    }
}

extension QuizInfoCoordinator: QuestionListViewModelCoordinating {
    /// Dismissed Controller
    func questionListViewModelDidFinishQuestion(_ questionListViewModel: QuestionListViewModel) {
        
    }
}
