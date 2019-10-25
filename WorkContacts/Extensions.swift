//
//  Extensions.swift
//  WorkContacts
//
//  Created by @esesmuedgars
//

import UIKit

extension UIStoryboard {
    func instantiateViewController<Controller: UIViewController>(ofType type: Controller.Type) -> Controller {
        return instantiateViewController(withIdentifier: String(describing: type)) as! Controller
    }
}
