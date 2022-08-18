import XCTest
@testable import Kahoot

class QuestionListViewModelTestCase: XCTestCase {

    var quizInfoViewModel: QuestionListViewModel?
    
    override func setUpWithError() throws {
        
        let  quizQuestion = QuizQuestion(question: "quiz", type: "<b>True or false: </b>The list of seven wonders is based on ancient Greek guidebooks for tourists.", time: 20000, pointsMultiplier: 1, layout: "TRUE_FALSE", image: URL(string: "https://media.kahoot.it/8d195530-548a-423e-8604-47f0cabd96e6_opt"), resources: "Photo by Dariusz Sankowski on Unsplash /CCO", choices: [Choice(answer: "true", correct: true, languageInfo: nil), Choice(answer: "false", correct: false, languageInfo: nil)])
        
        let  quizQuestion2 = QuizQuestion(question: "quiz", type: "The Great Pyramid of Giza is the oldest of the wonders. What was its purpose?", time: 30000, pointsMultiplier: 1, layout: nil, image: URL(string: "https://media.kahoot.it/8d195530-548a-423e-8604-47f0cabd96e6_opt"), resources: "Photo by Dariusz Sankowski on Unsplash /CCO", choices: [Choice(answer: "A monument to the god Ra", correct: false, languageInfo: nil), Choice(answer: "A momument to a great war victory", correct: false, languageInfo: nil), Choice(answer: "A temple", correct: false, languageInfo: nil), Choice(answer: "A tomb", correct: true, languageInfo: nil)])

        let quizInfo = QuizInfo(uuid: "fb4054fc-6a71-463e-88cd-243876715bc1", language: "English", creator: "4c1574ee-de54-40a2-be15-8d72b333afad", creatorPrimaryUsage: "teacher", folderId: "12212121", themeId: "4c1574ee-de54-40a2-be15-8d72b333afad", audience: "21211", cover: nil, title: "Testyour question", description: "A geography quiz about the Seven Wonders of the Ancient World. See how much you know about these ancient buildings and monuments!", type: "quiz", questions: [quizQuestion, quizQuestion2])
        
        quizInfoViewModel = QuestionListViewModel(coordinator: nil, quizInfo: quizInfo)

        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testCorrectChoice() {
        quizInfoViewModel?.setQuizPosition(quizPosition: 0)
        quizInfoViewModel?.didSelectedOptionIndex(index: 0)
        guard let option = quizInfoViewModel?.selectedChoice else {
            XCTAssertFalse(false, "fail to select optintype")
            return
        }
        XCTAssertTrue(option.correct, "correct answer")
    }
    
    func testWrongChoice() {
        quizInfoViewModel?.setQuizPosition(quizPosition: 0)
        quizInfoViewModel?.didSelectedOptionIndex(index: 1)
        guard let option = quizInfoViewModel?.selectedChoice else {
            XCTAssertFalse(false, "fail to select optintype")
            return
        }
        XCTAssertFalse(option.correct, "wrong answer")
    }
    
    func testQuestionTimeOut() {
        quizInfoViewModel?.setQuizPosition(quizPosition: 0)
        guard  let question = quizInfoViewModel?.selectedQuizQuestion else {
            XCTAssertFalse(false, "fail to select question")
            return
        }
        XCTAssertEqual(question.timeOut, 20, "Fail this time out should be invalid")
    }
    
    func testQuestionTypeTrueFalse() {
        quizInfoViewModel?.setQuizPosition(quizPosition: 0)
        guard  let question = quizInfoViewModel?.selectedQuizQuestion else {
            XCTAssertFalse(false, "fail to select question")
            return
        }
        XCTAssertEqual(question.questionLayoutType, QuestionLayout.trueFalse, "Fail this should be true false layout")
    }
    
    func testQuestionTypeQuiz() {
        quizInfoViewModel?.setQuizPosition(quizPosition: 1)
        guard  let question = quizInfoViewModel?.selectedQuizQuestion else {
            XCTAssertFalse(false, "fail to select question")
            return
        }
        XCTAssertEqual(question.questionLayoutType, QuestionLayout.other, "Fail this should be true false layout")
    }
    
    func testFormattedHtmlString() {
        let htmlString = "<b>Test html sting<b>"
        XCTAssertEqual(htmlString.formattedHtml(), "Test html sting", "fail  html formtting test")
    }
    
}
