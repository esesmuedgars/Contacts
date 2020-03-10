//
//  Extensions.swift
//  WorkContacts
//
//  Created by @esesmuedgars
//

import UIKit

extension String: Error {}

extension String {
    func localized() -> String {
        NSLocalizedString(self, comment: self)
    }

    /// Compares if the string and the given string are equal, using a case-insensitive, localized comparison.
    func isEqualCaseInsensitive(_ string: String) -> Bool {
        localizedCaseInsensitiveCompare(string) == .orderedSame
    }
}

extension Array where Element: Comparable {
    /// Remove all values from the collection that match closure predicate.
    func remove(_ isExcluded: (Array, Array.Element) -> Bool) -> [Element] {
        reduce([], { isExcluded($0, $1) ? $0 : $0 + [$1] })
    }
}


extension UIStoryboard {
    func instantiateViewController<Controller: UIViewController>(ofType type: Controller.Type) -> Controller {
        instantiateViewController(withIdentifier: String(describing: type)) as! Controller
    }
}

extension UITableView {
    func dequeueReusableCell<Cell: UITableViewCell>(ofType type: Cell.Type, for indexPath: IndexPath) -> Cell {
        dequeueReusableCell(withIdentifier: String(describing: type), for: indexPath) as! Cell
    }

    func layoutTableHeaderView() {
        guard let headerView = tableHeaderView else { return }

        headerView.translatesAutoresizingMaskIntoConstraints = false

        let width = headerView.frame.width
        let temporaryWidthConstraint = headerView.widthAnchor.constraint(equalToConstant: width)

        headerView.addConstraint(temporaryWidthConstraint)

        let height = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        var frame = headerView.frame

        frame.size.height = height
        headerView.frame = frame

        headerView.removeConstraint(temporaryWidthConstraint)
        headerView.translatesAutoresizingMaskIntoConstraints = true

        tableHeaderView = headerView
    }
}

extension UIAlertController {
    func addActions(_ actions: UIAlertAction...) {
        for action in actions {
            addAction(action)
        }
    }
}

extension UIBarButtonItem {
    convenience init(imageName named: String, style: UIBarButtonItem.Style, target: Any?, selector action: Selector?) {
        self.init(image: UIImage(named: named), style: .plain, target: target, action: action)
    }
}
