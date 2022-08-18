import UIKit

class QuestionListViewController: BaseViewController {
    let viewModel: QuestionListViewModel
    let theme: ThemeProtocol?
    
    var dataSource: UICollectionViewDiffableDataSource<Section, ChoiceViewModel>?

    // MARK: - UIComponent

    public lazy var collectionViewLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 8
        return layout
    }()
    
    public lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: collectionViewLayout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.alwaysBounceVertical = true
        collectionView.delaysContentTouches = false
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        collectionView.register(ChoiceViewItem.self)
        collectionView.isScrollEnabled = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

    private let quizTypeView: QuizTypeView = {
        let quizTypeView = QuizTypeView()
        quizTypeView.accessibilityIdentifier = "quizTypeView"
        quizTypeView.translatesAutoresizingMaskIntoConstraints = false
        return quizTypeView
    }()
    
    private let quizCountView: QuizCountView = {
        let quizCountView = QuizCountView()
        quizCountView.accessibilityIdentifier = "quizCountView"
        quizCountView.translatesAutoresizingMaskIntoConstraints = false
        return quizCountView
    }()
    
    private var progressBarView: ProgressBarView?
    private var answerResultView: AnswerResultView?
    
    private let questionInfoView: QuestionInfoViewItem = {
        let questionInfoView = QuestionInfoViewItem()
        questionInfoView.translatesAutoresizingMaskIntoConstraints = false
        return questionInfoView
    }()
    
    private lazy var continueButton: ShadowButton = {
        let continueButton = ShadowButton()
        continueButton.theme = theme
        continueButton.title = "Continue"
        continueButton.isHidden = true
        continueButton.accessibilityIdentifier = "Contine_Button"
        continueButton.translatesAutoresizingMaskIntoConstraints = false
        continueButton.addTarget(self, action: #selector(didTappedContinueButton(_:)), for: .touchUpInside)
        return continueButton
    }()

    // MARK: - Life Cycle
    
    init(viewModel: QuestionListViewModel, theme: ThemeProtocol?) {
        self.viewModel =  viewModel
        self.theme = theme
        super.init(nibName: nil, bundle: nil)
        viewModel.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        viewModel.inValidateTimeOut()
    }
    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addChildView()
        createDataSource()
        viewModel.setQuizPosition()
    }

    /// check font and also device orientation
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
    }
    
    // MARK: - Private methods

    private func addChildView() {
        
        view.addSubview(quizTypeView)
        view.addSubview(quizCountView)
        view.addSubview(questionInfoView)
        view.addSubview(continueButton)
        view.addSubview(collectionView)
    
        setUpLayout()
        setUpTheme()
    }
    
    private func setUpLayout() {
         
        if UIDevice.current.isIPad {
            collectionViewLayout.minimumLineSpacing = 16
            collectionViewLayout.minimumInteritemSpacing = 16
            continueButton.setFont(size: .Montserrat20)
        }
        
        let margins = view.layoutMarginsGuide
        NSLayoutConstraint.activate([
            quizTypeView.topAnchor.constraint(equalTo: margins.topAnchor, constant: 4),
            quizTypeView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            quizTypeView.heightAnchor.constraint(equalToConstant: 32),

            quizCountView.topAnchor.constraint(equalTo: margins.topAnchor, constant: 4),
            quizCountView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: .defaultMargin),
            quizCountView.widthAnchor.constraint(greaterThanOrEqualToConstant: 52),
            quizCountView.heightAnchor.constraint(equalToConstant: 32),

            questionInfoView.topAnchor.constraint(equalTo: quizTypeView.bottomAnchor, constant: .defaultMargin),
            questionInfoView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: .defaultMargin),
            questionInfoView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -.defaultMargin),
            questionInfoView.bottomAnchor.constraint(equalTo: collectionView.topAnchor, constant: -16),
            
            collectionView.heightAnchor.constraint(equalToConstant: UIDevice.current.isIPad ? 376 : 230),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: .defaultMargin),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -.defaultMargin),
            collectionView.bottomAnchor.constraint(equalTo: continueButton.topAnchor, constant: -.defaultMargin),

            continueButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: UIDevice.current.isIPad ? 250 : 90),
            continueButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: UIDevice.current.isIPad ? -259 : -90),
            continueButton.heightAnchor.constraint(equalToConstant: 48),
            continueButton.bottomAnchor.constraint(equalTo: margins.bottomAnchor, constant: -24)
        ])
    }
    
    private func setUpTheme() {
        quizCountView.theme = theme
        quizTypeView.theme = theme
        questionInfoView.theme = theme
    }
    
    /// Create a progress Bar
    ///
    /// Create progress bar and add to self view
    private func createProgressBar() {
        removeProgressView()
        
        let progressBar = ProgressBarView(animationDuration: 1)
        progressBar.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(progressBar)
        progressBar.isHidden = false
        progressBar.delegate = self
        progressBar.borderColor = theme?.fuchsiaBlue20 ?? .blue
        progressBar.fillColor = theme?.fuchsiaBlue ?? .blue
        progressBar.textColor = theme?.white ?? .white
        progressBar.translatesAutoresizingMaskIntoConstraints = false
        let margins = view.layoutMarginsGuide
        NSLayoutConstraint.activate([
            progressBar.heightAnchor.constraint(equalToConstant: UIDevice.current .isIPad ? 36 : 18),
            progressBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: .defaultMargin),
            progressBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -.defaultMargin),
            progressBar.bottomAnchor.constraint(equalTo: margins.bottomAnchor, constant: -24)])
        progressBarView = progressBar
    }
    
    /// Remove Progress Bar
    ///
    /// Remove ProgressBar from self view
    ///
    private func removeProgressView() {
        progressBarView?.isHidden = true
        progressBarView?.removeAllAnimation()
        progressBarView?.removeFromSuperview()
        progressBarView = nil
    }

    /// DidNotifyChoiceStatus
    ///
    /// Show choice status view on the top:
    /// Notify user that the selected choice is correct or not.
    /// - Show wrong view hen selected option wrong
    /// - Show correct view when selected option correct
    ///
    private func didNotifyChoiceStatus(_ status: ChoiceStatus) {
        
        removeChoiceStatus()
        let answerResultView = AnswerResultView(status, theme: theme)
        answerResultView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(answerResultView)
        answerResultView.translatesAutoresizingMaskIntoConstraints = false

        var height = UIDevice.current.isIPad ? 72.0 : 96.0
        if UIDevice.current.hasNotch {
            height += 24
        }

        NSLayoutConstraint.activate([
            answerResultView.topAnchor.constraint(equalTo: view.topAnchor),
            answerResultView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            answerResultView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            answerResultView.heightAnchor.constraint(equalToConstant: height)])
        
        self.answerResultView = answerResultView
    }
    
    /// removeChoiceStatus

    /// Remove it from self view.
    func removeChoiceStatus() {
        answerResultView?.removeFromSuperview()
        answerResultView = nil
    }
    
    /// UpdateQuestion
    /// Update question view when user selection new question
    ///
    private func updateQuestion(question: QuizQuestion) {
        questionInfoView.questionInfo = question
        quizTypeView.title = question.questionLayoutType.layOutText
        removeChoiceStatus()
        continueButton.isHidden = true
        createSnapsShot()
        createProgressBar()
        collectionView.isUserInteractionEnabled = true
        progressBarView?.animationDuration = CGFloat(question.timeOut)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.progressBarView?.didUpdatedProgressView()
        }
    }
    
    /// Voice over announcement:
    /// - Announce voice over when selected option wrong or correct
    /// - Announce voice over when time out

    private func postVoiceOverAnnouncement(_ announcement: String = "") {
        if UIAccessibility.isVoiceOverRunning {
            UIAccessibility.post(notification: .announcement, argument: announcement)
       }
    }
    
    // MARK: - Button Action

    @objc private func didTappedContinueButton(_: UIButton) {
        viewModel.didTappedContinueButton()
    }
}

// MARK: - QuestionListViewModelDelegate

extension QuestionListViewController: QuestionListViewModelDelegate {
    func questionListViewModel(_ questionListViewModel: QuestionListViewModel, didUpdateContinueButtonTitle title: String) {
        continueButton.title = title
    }
    
    /// Update  time out
    func questionListViewModel(_ questionListViewModel: QuestionListViewModel,
                               didUpdateTimeOut value: Int) {
        progressBarView?.text = "\(value)"
    }
    
    /// Show  alert that there are no choice answer for question
    ///
    func questionListViewModelDidFailToGetOptions(_ questionListViewModel: QuestionListViewModel) {
        showAlert(with: "Sorry", message: "Unable to find question options.", closeActionTitle: "Move Next", closeActionCompletion: { [weak self] in
            self?.removeProgressView()
            self?.viewModel.didTappedContinueButton()
        }, otherActionTitle: nil)
    }
    
    /// Wrong Answer
    ///
    /// Update UI :
    /// - Show Answer popup view with wrong status
    /// - Reload collection view cell
    /// - Make collection unable to select other option
    /// - Show continue button
    /// - Remove progress view
    ///
    ///
    func questionListViewModelDidSelectWrongAnswer(_ questionListViewModel: QuestionListViewModel) {
        didNotifyChoiceStatus(ChoiceStatus.wrong)
        collectionView.reloadData()
        collectionView.isUserInteractionEnabled = false
        
        postVoiceOverAnnouncement("You have choose wrong answer")

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.continueButton.isHidden = false
            self.removeProgressView()
        }
    }
    
    /// Correct Answer
    ///
    /// Update UI :
    /// - Show Answer popup view with correct status
    /// - Reload collection view cell
    /// - Make collection unable to select other option
    /// - Show continue button
    /// - Remove progress view
    ///
    ///
    func questionListViewModelDidSelectCorrectAnswer(_ questionListViewModel: QuestionListViewModel) {
        didNotifyChoiceStatus(ChoiceStatus.correct)
        collectionView.reloadData()
        collectionView.isUserInteractionEnabled = false
        postVoiceOverAnnouncement("You have choose correct answer")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.continueButton.isHidden = false
            self.removeProgressView()
        }
    }
    
    func questionListViewModel(_ questionListViewModel: QuestionListViewModel,
                               didSelectQuestion question: QuizQuestion,
                               questionNumber: String) {
        quizCountView.title = questionNumber
        updateQuestion(question: question)
    }
    
}

// MARK: - ProgressBarViewDelegate

extension QuestionListViewController: ProgressBarViewDelegate {
    
    func progressBarViewDidFinishedAnimation(_ progressBarView: ProgressBarView) {
        progressBarView.isHidden = true
        viewModel.didCheckedAnswer()
        collectionView.isUserInteractionEnabled = false
    }
}
