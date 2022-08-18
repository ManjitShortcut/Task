import XCTest
@testable import Kahoot

class QuestionListUITestCase: XCTestCase {
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

//        let  quizQuestion = QuizQuestion(question: "quiz", type: "<b>True or false: </b>The list of seven wonders is based on ancient Greek guidebooks for tourists.", time: 20000, pointsMultiplier: 1, layout: "TRUE_FALSE", image: URL(string: "https://media.kahoot.it/8d195530-548a-423e-8604-47f0cabd96e6_opt"), resources: "Photo by Dariusz Sankowski on Unsplash /CCO", choices: [Choice(answer: "true", correct: true, languageInfo: nil), Choice(answer: "false", correct: false, languageInfo: nil)])
//        
//        let  quizQuestion2 = QuizQuestion(question: "quiz", type: "The Great Pyramid of Giza is the oldest of the wonders. What was its purpose?", time: 30000, pointsMultiplier: 1, layout: nil, image: URL(string: "https://media.kahoot.it/8d195530-548a-423e-8604-47f0cabd96e6_opt"), resources: "Photo by Dariusz Sankowski on Unsplash /CCO", choices: [Choice(answer: "A monument to the god Ra", correct: false, languageInfo: nil), Choice(answer: "A momument to a great war victory", correct: false, languageInfo: nil), Choice(answer: "A temple", correct: false, languageInfo: nil), Choice(answer: "A tomb", correct: true, languageInfo: nil)])
//
//        let quizInfo = QuizInfo(uuid: "fb4054fc-6a71-463e-88cd-243876715bc1", language: "English", creator: "4c1574ee-de54-40a2-be15-8d72b333afad", creatorPrimaryUsage: "teacher", folderId: "12212121", themeId: "4c1574ee-de54-40a2-be15-8d72b333afad", audience: "21211", cover: nil, title: "Testyour question", description: "A geography quiz about the Seven Wonders of the Ancient World. See how much you know about these ancient buildings and monuments!", type: "quiz", questions: [quizQuestion, quizQuestion2])
//        
//        let quizInfoViewModel = QuestionListViewModel(coordinator: nil, quizInfo: quizInfo)
//
//        
//        questionListViewController = QuestionListViewController(viewModel: quizInfoViewModel, theme: nil)
//        questionListViewController?.viewDidLoad()
    
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
    
    func testQuizType() throws {
        
    }
}
