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
