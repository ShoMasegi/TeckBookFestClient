import UIKit

extension UICollectionView {
    func registerFromNib<T: UICollectionViewCell>(_: T.Type) {
        let className = String(describing: T.self)
        let nib = UINib(nibName: className, bundle: Bundle(for: T.self))
        register(nib, forCellWithReuseIdentifier: className)
    }

    func dequeueReusableCell<T: UICollectionViewCell>(for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withReuseIdentifier: String(describing: T.self), for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(String(describing: T.self))")
        }
        return cell
    }
}
