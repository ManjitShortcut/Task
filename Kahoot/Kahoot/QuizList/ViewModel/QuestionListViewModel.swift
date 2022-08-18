import Foundation

protocol QuestionListViewModelCoordinating: AnyObject {
    
    func questionListViewModelDidFinishQuestion(_ questionListViewModel: QuestionListViewModel)
}

protocol QuestionListViewModelDelegate: AnyObject {

    func questionListViewModel(_ questionListViewModel: QuestionListViewModel,
                               didSelectedQuestion question: QuizQuestion,
                               questionNumber: String)
    func questionListViewModelDidSelectWrongAnswer(_ questionListViewModel: QuestionListViewModel)
    func questionListViewModelDidSelectCorrectAnswer(_ questionListViewModel: QuestionListViewModel)
    func questionListViewModelDidFailToGetOptions(_ questionListViewModel: QuestionListViewModel)
    func questionListViewModel(_ questionListViewModel: QuestionListViewModel,
                               didUpdateTimeOut value: Int)

}

final class QuestionListViewModel {
        
    weak var delegate: QuestionListViewModelDelegate?
    lazy var choiceListViewModel = [ChoiceViewModel]()

    private weak var coordinator: QuestionListViewModelCoordinating?
    private var quizInfo: QuizInfo
    
    private var selectedQuizQuestion: QuizQuestion? {
        didSet {
            didSelectQuestion()
        }
    }
    
    private var selectedChoice: Choice? {
        didSet {
            
        }
    }
    
    private var remainingTime = 0
    private var selectedQuestionIndex = 0
    private var timerTimeOut: Timer?

    // MARK: - Life Cycle

    init(coordinator: QuestionListViewModelCoordinating?,
         quizInfo: QuizInfo) {
        self.coordinator = coordinator
        self.quizInfo = quizInfo
    }
    
    // MARK: - Publice methods

    func didTappedContinueButton() {
        selectedQuestionIndex += 1
        guard let questionList = quizInfo.questions,
              selectedQuestionIndex < questionList.count  else {
            coordinator?.questionListViewModelDidFinishQuestion(self)
            return
        }
        
        didSetQuestion()
    }

    func setQuizPosition(quizPosition: Int = 0) {
        selectedQuestionIndex = quizPosition
        didSetQuestion()
    }
    
    func didCheckedAnswer() {
        
        inValidateTimeOut()
        
        for choice in choiceListViewModel {
            choice.state = .timeOut
        }

        guard let answer = selectedChoice else {
            didSelectedWrongAnswer()
            return
        }

        if answer.correct {
            didSelectedSuccessAnswer()
        } else {
            didSelectedWrongAnswer()
        }
    }

    // MARK: - Private methods

    private func didSetQuestion() {
        
        guard let questionList = quizInfo.questions, selectedQuestionIndex < questionList.count  else {
            coordinator?.questionListViewModelDidFinishQuestion(self)
            return
        }
        selectedQuizQuestion = quizInfo.questions?[selectedQuestionIndex]
    }
    
    /// When the question is selected
    ///
    private func didSelectQuestion() {

        choiceListViewModel.removeAll()
        guard let question = selectedQuizQuestion,
              let questionList = quizInfo.questions,
              let choices = question.choices,
              !questionList.isEmpty else {
            delegate?.questionListViewModelDidFailToGetOptions(self)
            return
        }
        createOptionViewModel(for: choices)
        remainingTime = question.timeOut
        let questionCount = "\(selectedQuestionIndex + 1)/\(questionList.count)"
        delegate?.questionListViewModel(self, didSelectedQuestion: question, questionNumber: questionCount)
        validateTimeOut()
    }
    
    private func didSelectedWrongAnswer() {
        delegate?.questionListViewModelDidSelectWrongAnswer(self)
    }
    
    private func didSelectedSuccessAnswer() {
        delegate?.questionListViewModelDidSelectCorrectAnswer(self)
    }

    private func createOptionViewModel(for choices: [Choice]) {
        choiceListViewModel.removeAll()
        for (index, choice) in choices.enumerated() {
            let viewModel = ChoiceViewModel(choice: choice, position: index)
            choiceListViewModel.append(viewModel)
        }
    }
    
    @objc private func calculateTimeOut() {
        
        remainingTime -= 1
        if remainingTime > 0 {
            delegate?.questionListViewModel(self, didUpdateTimeOut: remainingTime)
        } else {
            inValidateTimeOut()
        }
    }
    
    public func validateTimeOut() {
        inValidateTimeOut()
        timerTimeOut = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.calculateTimeOut), userInfo: nil, repeats: true)
    }
    
    public func inValidateTimeOut() {
        timerTimeOut?.invalidate()
        timerTimeOut = nil
    }
}

extension QuestionListViewModel {
    
    func didSelectedOptionIndex(index: Int) {
        for (indexPosition, choiceViewModel) in choiceListViewModel.enumerated() {
            if index == indexPosition {
                choiceViewModel.didUserSelectOption = true
            } else {
                choiceViewModel.didUserSelectOption = false
            }
            choiceViewModel.state = .selectChoice
        }
        
        let selectedItem = choiceListViewModel[index]
        self.selectedChoice = selectedItem.choice
    }
}
