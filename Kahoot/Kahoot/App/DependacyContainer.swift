import Foundation

public protocol DependencyContainerType {
    var theme: ThemeProtocol { get }
    var network: NetworkServiceProtocol { get }
}

class DependencyContainer: DependencyContainerType {
    
    private(set) lazy var theme: ThemeProtocol = {
        DynamicTheme()
    }()

    private(set) lazy var network: NetworkServiceProtocol = {
        NetworkService()
    }()
}
