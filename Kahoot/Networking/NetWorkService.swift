
import Foundation

public typealias NetworkCompletion = (_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Void

public enum NetworkError: String, Error {
    case missingURL = "URL is nil."
    case unableCreateRequest = "missingRequest"
}

public protocol NetworkServiceProtocol {
    func request(_ route: EndPointType,
                 completion: @escaping NetworkCompletion)
    func cancel()
}

class NetworkService: NSObject {
    
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
    
    private func performRequest(_ request: URLRequest,
                                completion: @escaping NetworkCompletion) {
        task = session.dataTask(with: request,
                                completionHandler: { data, response, error in
            completion(data, response, error)
        })
        task?.resume()
    }
    
 //TODO: Add other request form
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
    
    func request(_ route: EndPointType,
                 completion: @escaping NetworkCompletion) {
        do {
            let request = try buildRequest(from: route)
            performRequest(request, completion: completion)
        } catch {
            completion(nil, nil, NetworkError.unableCreateRequest)
        }
    }
    
    func cancel() {
        task?.cancel()
    }
}
