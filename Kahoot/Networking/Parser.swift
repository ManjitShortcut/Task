import Foundation

public enum ParserError: Error {
    case dataMissing
    case internalParserError(Error)
}

public protocol DecodableParserProtocol {
    associatedtype ParsedObject
    func parse<T: Decodable>(data: Data?) async throws -> T
}

struct JSONDecodeAbleParser<T: Decodable>: DecodableParserProtocol {
    
    typealias ParsedObject = T
    let jsonDecoder: JSONDecoder
    
    public init(decoder: JSONDecoder = JSONDecoder()) {
        self.jsonDecoder = decoder
    }

    func parse<T>(data: Data?) async throws -> T where T: Decodable {
        guard let data = data else {
            throw ParserError.dataMissing
        }
        do {
           return try jsonDecoder.decode(T.self, from: data)
        } catch {
            throw error
        }
    }
    
}
