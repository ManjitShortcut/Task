import Foundation
public typealias NetworkCompletion = (_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Void

public enum NetworkError: String, Error {
    case missingURL = "URL is nil."
    case unableCreateRequest = "missingRequest"
}

public protocol NetworkServiceProtocol {
    func request(_ route: EndPointType) async throws -> ResponseResult
    func cancel()
}

public struct ResponseResult {
    
    let data: Data?
    let urlResponse: URLResponse?
    init(data: Data?, response: URLResponse?) {
        self.data = data
        self.urlResponse = response
    }
}

class NetworkService: NSObject, URLSessionTaskDelegate {
    
    private var task: URLSessionTask?
    private let session: URLSession
    
    override init() {
        let configuration = URLSessionConfiguration.default
        configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        configuration.urlCache = nil
        let session = URLSession(configuration: configuration, delegate: nil, delegateQueue: nil)
        self.session = session
        super.init()
    }
    
    // MARK: Private functions
    
    private func performRequest(_ request: URLRequest) async throws -> ResponseResult {
        do {
            let result = try await session.data(for: request, delegate: self)
            return ResponseResult(data: result.0, response: result.1)
        } catch {
            throw error
        }
    }
    
     // TODO: Add other request form
    /// Add Request body
    /// Url encoding
        
    private func buildRequest(from route: EndPointType) throws -> URLRequest {
        
        var request = URLRequest(url: route.baseURL.appendingPathComponent(route.path),
                                 cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
                                 timeoutInterval: 30.0)
        request.httpMethod = route.httpMethod.rawValue
        switch route.task {
        case .request:
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        return request
    }
}

extension NetworkService: NetworkServiceProtocol {
    
    func request(_ route: EndPointType) async throws -> ResponseResult {
        do {
            let request = try buildRequest(from: route)
            do {
                return try await performRequest(request)
            } catch {
                throw error
            }
        } catch {
            throw error
        }
    }
    
    func cancel() {
        task?.cancel()
    }
}
