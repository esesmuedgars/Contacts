//
//  Extensions.swift
//  WorkContacts
//
//  Created by @esesmuedgars
//

import UIKit

extension String: Error {}

extension UIStoryboard {
    func instantiateViewController<Controller: UIViewController>(ofType type: Controller.Type) -> Controller {
        return instantiateViewController(withIdentifier: String(describing: type)) as! Controller
    }
}

extension UITableView {
    func dequeueReusableCell<Cell: UITableViewCell>(ofType type: Cell.Type, for indexPath: IndexPath) -> Cell {
        return dequeueReusableCell(withIdentifier: String(describing: type), for: indexPath) as! Cell
    }
}

extension UIColor {

    /// #F6F5F8
    static var mooncascadeLightGray: UIColor {
        return #colorLiteral(red: 0.9647058824, green: 0.9607843137, blue: 0.9725490196, alpha: 1)
    }

    /// #FFD000
    static var mooncascadeYellow: UIColor {
        return #colorLiteral(red: 1, green: 0.8156862745, blue: 0, alpha: 1)
    }
}

extension UIAlertController {
    func addActions(_ actions: UIAlertAction...) {
        for action in actions {
            addAction(action)
        }
    }
}
