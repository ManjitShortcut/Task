
import Foundation
import UIKit

protocol ReusableCell {
    static var identifier: String { get }
}

extension ReusableCell {
    static var identifier: String {
        String(describing: self)
    }
}

extension UICollectionReusableView: ReusableCell {}


extension UICollectionView {
    
    func register(_ cellClass: UICollectionViewCell.Type) {
        register(cellClass.self, forCellWithReuseIdentifier: cellClass.identifier)
    }

    func dequeue<T>(_ cellClass: T.Type, for indexPath: IndexPath) -> T where T: UICollectionViewCell {
        guard let cell = dequeueReusableCell(
            withReuseIdentifier: cellClass.identifier,
            for: indexPath
        ) as? T else {
            fatalError("cellForItemAt: unknown cell type")
        }
        return cell
    }
}
    
    
/// All our items must inherit from this cell.
open class CollectionViewItem: UICollectionViewCell {
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    internal func commonInit() {
        clipsToBounds = false
        backgroundView = UIView()
        backgroundView?.layer.masksToBounds = false
        backgroundView?.layer.borderColor = UIColor.clear.cgColor
        contentView.layer.cornerRadius = 4
        contentView.clipsToBounds = true
    }
}
