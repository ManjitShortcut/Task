import Foundation
public enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}

public protocol EndPointType {
    var baseURL: URL { get }
    var rootPath: String { get }
    var path: String { get }
    var httpMethod: HTTPMethod { get }
    var task: HTTPTask { get }
    var headers: HTTPHeaders? { get }
}

extension EndPointType {
    
    var rootPath: String {
        return AppConfiguration.ApiConfiguration.tragetServer
    }
    var httpMethod: HTTPMethod { .get }
    var headers: HTTPHeaders? {
        return nil
    }
    
    var baseURL: URL {
        guard let url = URL(string: "\(rootPath)")
        else { fatalError("baseURL could not be configured.") }
        return url
    }
}
