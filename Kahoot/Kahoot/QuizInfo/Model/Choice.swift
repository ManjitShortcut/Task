import Foundation
struct Choice: Decodable {
    let answer: String
    let correct: Bool
    let languageInfo: LanguageInfo?
}
