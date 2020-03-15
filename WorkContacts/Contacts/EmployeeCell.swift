//
//  EmployeeCell.swift
//  WorkContacts
//
//  Created by @esesmuedgars
//

import UIKit
import ContactsUI

protocol EmployeeCellDelegate: class {
    func employeeCellOpenContactInfo(contact: CNContact)
}

final class EmployeeCell: UITableViewCell {

    @IBOutlet private var lastNameLabel: UILabel!
    @IBOutlet private var firstNameLabel: UILabel!
    @IBOutlet private var contactButton: UIButton!

    @IBAction private func touchUpInside(_ sender: UIButton) {
        if let contact = contact {
            delegate?.employeeCellOpenContactInfo(contact: contact)
        }
    }

    weak var delegate: EmployeeCellDelegate!

    private var contact: CNContact?

    func configure(lastName: String, firstName: String, contact: CNContact?) {
        firstNameLabel.text = firstName
        lastNameLabel.text = lastName

        let isHidden = contact == nil
        contactButton.isHidden = isHidden

        self.contact = contact
    }
}
