import Foundation
internal enum LoadingState {
    case idle
    case progress
    case success
    case fail(error: Error?)
}

protocol QuizInfoViewModelCoordinating: AnyObject {
    func quizInfoViewModel(_ quizInfoViewModel: QuizInfoViewModel,
                           didNavigateToQuiz quiz: QuizInfo)
    func quizInfoViewModel(_ quizInfoViewModel: QuizInfoViewModel,
                           didFailedToFetchQuizInfo error: Error?)
}

protocol QuizInfoViewModelDelegate: AnyObject {
    
    func quizInfoViewModel(_ quizInfoViewModel: QuizInfoViewModel,
                           didFetchingQuizLoadingState state: LoadingState)
}

class QuizInfoViewModel {
    
    weak var delegate: QuizInfoViewModelDelegate?
    private weak var coordinator: QuizInfoViewModelCoordinating?
    private var apiService: QuizService
    
    private let quizInfoId: String
    
    // MARK: - Life Cycle
    
    init(coordinator: QuizInfoViewModelCoordinating?,
         quizInfoId: String,
         apiService: QuizService) {
        self.coordinator = coordinator
        self.quizInfoId = quizInfoId
        self.apiService = apiService
    }
    
    // MARK: - Public Methods

    func didFetchQuiz() {
        delegate?.quizInfoViewModel(self, didFetchingQuizLoadingState: .progress)
        Task {
            do {
                let quizInfo = try await apiService.fetchQuizList(forQuizId: quizInfoId)
                DispatchQueue.main.async {
                    self.delegate?.quizInfoViewModel(self, didFetchingQuizLoadingState: .success)
                    self.coordinator?.quizInfoViewModel(self, didNavigateToQuiz: quizInfo)
                }
            } catch {
                
                DispatchQueue.main.async {
                    self.delegate?.quizInfoViewModel(self, didFetchingQuizLoadingState: .fail(error: error))
                    self.coordinator?.quizInfoViewModel(self, didFailedToFetchQuizInfo: error)
                }
            }
        }
    }
}
