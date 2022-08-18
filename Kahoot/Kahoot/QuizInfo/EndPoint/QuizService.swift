import Foundation

protocol QuizServiceProtocol {
    func fetchQuizList(forQuizId quizId: String,
                       withCompletionHandler completion: @escaping (Result<QuizInfo, Error>) -> Void)
}

struct QuizService: QuizServiceProtocol {

    let apiService: NetworkServiceProtocol

    init(apiService: NetworkServiceProtocol) {
        self.apiService = apiService
    }
    
    func fetchQuizList(forQuizId quizId: String,
                       withCompletionHandler completion: @escaping (Result<QuizInfo, Error>) -> Void) {

        apiService.request(QuizEndPoint.getQuizList(quizId: quizId), completion: { data, _, error in
            if let networkError = error {
                completion(.failure(networkError))
            } else {
                
                DispatchQueue.main.async {
                    let result: Result<QuizInfo, Error> = JSONDecodeableParser<QuizInfo>().parse(data: data)
                    completion(result)
                }
            }
        })
    }
}
