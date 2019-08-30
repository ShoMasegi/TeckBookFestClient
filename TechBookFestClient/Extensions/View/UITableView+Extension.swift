import UIKit

extension UITableView {
    func registerFromNib<T: UITableViewCell>(_: T.Type) {
        let className = String(describing: T.self)
        let nib = UINib(nibName: className, bundle: Bundle(for: T.self))
        register(nib, forCellReuseIdentifier: className)
    }

    func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: String(describing: T.self), for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(String(describing: T.self))")
        }
        return cell
    }

    func registerReusableHeaderFooterFromNib<T: UITableViewHeaderFooterView>(_: T.Type) {
        let className = String(describing: T.self)
        let nib = UINib(nibName: className, bundle: Bundle(for: T.self))
        register(nib, forHeaderFooterViewReuseIdentifier: className)
    }

    func dequeueReusableHeaderFooterView<T: UITableViewHeaderFooterView>() -> T {
        guard let view = dequeueReusableHeaderFooterView(withIdentifier: String(describing: T.self)) as? T else {
            fatalError("Could not dequeue HeaderFooterView view with identifier: \(String(describing: T.self))")
        }
        return view
    }
}
