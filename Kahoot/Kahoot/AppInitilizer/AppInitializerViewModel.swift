import Foundation

protocol AppInitializerViewModelCoordinating: AnyObject {
    func appInitializerViewModelDidNavigateToNext(_ appInitializerViewModel: AppInitializerViewModel)
}

protocol AppInitializerViewModelDelegate: AnyObject {

    func appInitializerViewModel(_ appInitializerViewModel: AppInitializerViewModel,
                                 didFetchingQuizLoadingState state: LoadingState)
}

class AppInitializerViewModel {
    
    weak var delegate: AppInitializerViewModelDelegate?
    private weak var coordinator: AppInitializerViewModelCoordinating?
    
    // MARK: - Life Cycle
    
    init(coordinator: AppInitializerViewModelCoordinating?) {
        self.coordinator = coordinator
    }
    
    // MARK: - Public Methods

    func didNavigateToNext() {
        coordinator?.appInitializerViewModelDidNavigateToNext(self)
    }
}
