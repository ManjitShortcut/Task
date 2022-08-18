import Foundation

struct AppConfiguration {
    
    struct ApiConfiguration {
        static let tragetServer: String = {
            return Environment.DEV.rawValue
        }()
    }
}

enum Environment: String {
    
    case DEV = "https://create.kahoot.it"
    
    var host: String {
        switch self {
        case .DEV:
            return "create.kahoot.it"
        }
    }
}
