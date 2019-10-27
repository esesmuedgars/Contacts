//
//  EmployeeCell.swift
//  WorkContacts
//
//  Created by @esesmuedgars
//

import UIKit
import ContactsUI

protocol EmployeeCellDelegate: AnyObject {
    func employeeCellOpenContactInfo(contact: CNContact)
}

class EmployeeCell: UITableViewCell {

    @IBOutlet private var firstNameLabel: UILabel!
    @IBOutlet private var lastNameLabel: UILabel!
    @IBOutlet private var contactButton: UIButton!

    @IBAction private func touchUpInside(_ sender: UIButton) {
        if let contact = contact {
            delegate?.employeeCellOpenContactInfo(contact: contact)
        }
    }

    weak var delegate: EmployeeCellDelegate!

    private var contact: CNContact?

    func configure(firstName: String, lastName: String, contact: CNContact?) {
        firstNameLabel.text = firstName
        lastNameLabel.text = lastName

        let isHidden = contact == nil
        contactButton.isHidden = isHidden

        self.contact = contact
    }
}
