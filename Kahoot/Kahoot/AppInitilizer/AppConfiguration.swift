import Foundation

struct AppConfiguration {
    
    struct ApiConfiguration {
        static let tragetServer: String = {
          #if PROD
            return Environment.DEV.rawValue
           #else
            return Environment.DEV.rawValue
          #endif
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
