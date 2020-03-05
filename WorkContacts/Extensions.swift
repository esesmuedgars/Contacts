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
