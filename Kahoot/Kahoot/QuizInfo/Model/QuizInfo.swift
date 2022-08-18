import Foundation

struct QuizInfo: Decodable {
    let uuid: String
    let language: String
    let creator: String?
    let creatorPrimaryUsage: String?
    let folderId: String?
    let themeId: String?
    let audience: String?
    let cover: URL?

    let title: String?
    let description: String?
    let type: String?
    
    let questions: [QuizQuestion]?
    
    enum CodingKeys: String, CodingKey {
        case uuid, language, creator, folderId, themeId, audience, cover
        case title, description, type, questions
        case creatorPrimaryUsage = "creator_primary_usage"
    }
}
