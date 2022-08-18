import UIKit
class AppInitializerViewController: UIViewController {
    
    let viewModel: AppInitializerViewModel
    let theme: ThemeProtocol
    
    // MARK: - Life Cycle
    
    init(viewModel: AppInitializerViewModel, theme: ThemeProtocol) {
        self.viewModel =  viewModel
        self.theme = theme
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.red
        viewModel.didNavigateToNext()
    }
}
