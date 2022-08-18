import Foundation
import UIKit
// MARK: - CollectionView Create Data source

extension QuestionListViewController {
    
     /// This is new way of providing data source.
     /// This Is available form iOS 13.
     ///  You no need to provide data source section and cell item value

    func createSnapsShot() {
        var snapShot = NSDiffableDataSourceSnapshot<Section, ChoiceViewModel>()
        snapShot.appendSections([.choice])
        snapShot.appendItems(viewModel.choiceListViewModel)
        dataSource?.apply(snapShot, animatingDifferences: true, completion: nil)
    }
    
    /// Create data source of collection view
    ///
    /// This is new way of providing data source.
    /// This Is available form iOS 13.
    /// You no need to create cell for collection view
    
    func createDataSource() {

        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView,
                                                        cellProvider: { collectionView, indexPath, model -> UICollectionViewCell?  in
            let cell = collectionView.dequeue(ChoiceViewItem.self, for: indexPath)
            cell.bind(viewModel: model)
            return cell
        })
    }
}

// MARK: - Collection view layout delegate

extension QuestionListViewController: UICollectionViewDelegateFlowLayout {
    
    /// This method is call to provide the cell height and width
     
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
         let group = viewModel.choiceListViewModel.count / 2
        
        return CGSize(width: (collectionView.frame.size.width - (UIDevice.current.isIPad ? 16.0 : 8.0)) / 2,
                      height: (collectionView.frame.size.height - (UIDevice.current.isIPad ? 20.0 : 12.0)) / CGFloat(group))
    }
}

// MARK: - UICollectionViewDelegate

extension QuestionListViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        viewModel.didSelectedOptionIndex(index: indexPath.row)
        collectionView.isUserInteractionEnabled = false
        collectionView.reloadData()
    }
}
