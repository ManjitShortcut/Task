import Foundation

struct QuizQuestion: Decodable {
    let question: String
    let type: String?
    let time: Double
    let pointsMultiplier: Int
    let layout: String?
    let image: URL?
    let resources: String?
    let choices: [Choice]?

}

extension QuizQuestion {
    /// timeOut in second
    ///
    var timeOut: Int {
        return Int(time / 1000)
    }

    var questionLayoutType: QuestionLayout {

        if layout == "TRUE_FALSE" {
            return .trueFalse
        } else {
            return .other
        }
    }
    
    
    var formattedQuestion: String {
        return self.question.formattedHtml()
    }
}

extension String {
    func formattedHtml() -> String {
        let new = self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: .none)
        return new
    }
}

enum QuestionLayout {
    case trueFalse
    case other
     
    var layOutText: String {
        switch self {
        case .trueFalse:
            return "True/False"
        case .other:
            return "Quiz"
        }
    }
}
