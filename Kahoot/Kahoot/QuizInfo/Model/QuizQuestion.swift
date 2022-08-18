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
            return .singleChoice
        }
    }
    
    var formattedQuestion: String {
        let formattedQuestion = self.question.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: .none)
        
        return formattedQuestion
    }
}

enum QuestionLayout {
    case trueFalse
    case singleChoice
     
    var layOutText: String {
        switch self {
        case .trueFalse:
            return "True/False"
        case .singleChoice:
            return "Quiz"
        }
    }
}
