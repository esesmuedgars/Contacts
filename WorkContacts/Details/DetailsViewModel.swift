//
//  DetailsViewModel.swift
//  WorkContacts
//
//  Created by @esesmuedgars
//

import Contacts

final class DetailsViewModel: DetailsViewModelType {

    weak var flowDelegate: CoordinatorFlowDelegate!

    var sectionHeaderTitle: String? {
        projects.isEmpty ? nil : "details.title.projects".localized()
    }

    let positionTitle = "details.title.position".localized()
    let emailTitle = "details.title.email".localized()
    let phoneNumberTitle = "details.title.phone_number".localized()

    let fullName: String
    let position: String
    let email: String
    let withoutPhoneNumber: Bool
    let phoneNumber: String?
    let projects: [String]
    let contact: CNContact?
    let isContact: Bool

    init(employee: Group.Employee) {
        fullName = String(format: "%@ %@", employee.firstName, employee.lastName)
        position = employee.position.detailsTitle
        email = employee.details.email
        withoutPhoneNumber = employee.details.phone == nil
        phoneNumber = employee.details.phone
        projects = employee.projects
        contact = employee.contact
        isContact = employee.contact != nil
    }

    func pushContactViewController() {
        if let contact = self.contact {
            flowDelegate?.pushContactViewController(for: contact)
        }
    }
}
