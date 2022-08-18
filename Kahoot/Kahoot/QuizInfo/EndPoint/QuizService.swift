import Foundation

protocol QuizServiceProtocol {
    func fetchQuizList(forQuizId quizId: String) async throws -> QuizInfo
}

struct QuizService: QuizServiceProtocol {

    let apiService: NetworkServiceProtocol

    init(apiService: NetworkServiceProtocol) {
        self.apiService = apiService
    }
    
    func fetchQuizList(forQuizId quizId: String) async throws -> QuizInfo {

        do {
            let result = try await apiService.request(QuizEndPoint.getQuizList(quizId: quizId))
            return try await JSONDecodeableParser<QuizInfo>().parse(data: result.data)
        } catch {
           throw error
        }
    }
}
