import Foundation

public protocol DependencyContainerType {
    var theme: ThemeProtocol { get }
    var network: NetworkService { get }
}

class DependencyContainer: DependencyContainerType {
    private(set) lazy var theme: ThemeProtocol = {
        DynamicTheme()
    }()

    private(set) lazy var network: NetworkService = {
        Network()
    }()
}
