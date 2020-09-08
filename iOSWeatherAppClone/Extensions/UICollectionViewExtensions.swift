import Foundation
import UIKit

extension UICollectionView {
    func register<T: UICollectionViewCell>(cellType: T.Type, bundle: Bundle? = nil) {
        let className = cellType.typeName
        let nib = UINib(nibName: className, bundle: bundle)
        register(nib, forCellWithReuseIdentifier: className)
    }

    func register<T: UICollectionViewCell>(cellTypes: [T.Type], bundle: Bundle? = nil) {
        cellTypes.forEach { register(cellType: $0, bundle: bundle) }
    }

    func dequeueReusableCell<T: UICollectionViewCell>(with type: T.Type, for indexPath: IndexPath) -> T {
        return self.dequeueReusableCell(withReuseIdentifier: type.typeName, for: indexPath) as! T
    }
}
