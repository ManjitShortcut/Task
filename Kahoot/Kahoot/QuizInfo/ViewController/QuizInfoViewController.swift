import UIKit
class QuizInfoViewController: BaseViewController {

    let viewModel: QuizInfoViewModel
    let theme: ThemeProtocol
    
    // MARK: - Life Cycle
    
    init(viewModel: QuizInfoViewModel, theme: ThemeProtocol) {
        self.viewModel =  viewModel
        self.theme = theme
        super.init(nibName: nil, bundle: nil)
        self.viewModel.delegate = self
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.didFetchQuiz()
    }
}

// MARK: - QuizInfoViewModelDelegate

extension QuizInfoViewController: QuizInfoViewModelDelegate {
    
    func quizInfoViewModel(_ quizInfoViewModel: QuizInfoViewModel,
                           didFetchingQuizLoadingState state: LoadingState) {
        switch state {
        case .idle, .success, .fail:
            hideLoading()
        case .progress:
            showLoading(color: theme.white)
        }
    }

}
