import Foundation
enum QuizEndPoint {
    case getQuizList(quizId: String)
}

extension QuizEndPoint: EndPointType {
    
    var path: String {
        switch self {
        case .getQuizList(let quizId):
            return "rest/kahoots/\(quizId)"
        }
    }
    
    var task: HTTPTask {
        return .request
    }
}
