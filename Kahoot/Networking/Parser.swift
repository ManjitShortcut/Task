import Foundation

public enum ParserError: Error {
    case dataMissing
    case internalParserError(Error)
}

public protocol DecodableParserProtocol {
    associatedtype ParsedObject
    func parse<T: Decodable>(data: Data?) -> Result<T, Error>
}

struct JSONDecodeableParser<T: Decodable>: DecodableParserProtocol {
   
    typealias ParsedObject = T
    let jsonDecoder: JSONDecoder
    
    public init(decoder: JSONDecoder = JSONDecoder()) {
        self.jsonDecoder = decoder
    }

    public func parse<T>(data: Data?) -> Result<T, Error> where T: Decodable {
        guard let data = data else {
            return .failure(ParserError.dataMissing)
        }
        return Result { try jsonDecoder.decode(T.self, from: data) }.mapError { error in
            ParserError.internalParserError(error)
        }
    }
}
