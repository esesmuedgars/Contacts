//
//  ContactsViewModel.swift
//  WorkContacts
//
//  Created by @esesmuedgars
//

import Foundation
import Contacts

protocol ContactsViewModelDelegate: AnyObject {
    func viewModelDidFetchGroups()
}

final class ContactsViewModel: ContactsViewModelType {

    private let apiService: APIServiceProtocol
    private let contactsService: ContactsServiceProtocol

    weak var delegate: ContactsViewModelDelegate!
    weak var flowDelegate: CoordinatorFlowDelegate!

    var groups = [Group]() {
        didSet {
            DispatchQueue.main.async {
                self.delegate?.viewModelDidFetchGroups()
            }
        }
    }

    let title = "Employees"

    init(apiService: APIServiceProtocol = Dependencies.shared.apiService,
         contactsService: ContactsServiceProtocol = Dependencies.shared.contactsService) {
        self.apiService = apiService
        self.contactsService = contactsService
    }

    func fetchEmployeeList() {
        apiService.fetchEmployeeList { [weak self] result in
            guard let self = self else {
                // TODO: Call delegate with error
                return
            }

            switch result {
            case .success(let employees):
                self.contactsService.fetchContactList { result in
                    switch result {
                    case .success(let contacts):
                        // Group employees by position
                        var grouped = [Position: [Employee]]()
                        employees.forEach {
                            grouped[$0.position, default: []].append($0)
                        }

                        // Initialize `Group` class for UI
                        let groups = grouped.map { (position, employees) -> Group in
                            let employees = employees.map { employee -> Group.Employee in
                                // Check if employee is contact
                                let contact = contacts.first { contact in
                                    contact.givenName.lowercased() == employee.firstName.lowercased() &&
                                    contact.familyName.lowercased() == employee.lastName.lowercased()
                                }

                                return Group.Employee(contact: contact,
                                                      firstName: employee.firstName,
                                                      lastName: employee.lastName,
                                                      details: employee.details,
                                                      projects: Array(employee.projects))
                            }

                            return Group(position: position, employees: employees)
                        }

                        // Sort groups alphabetically and employees by last name
                        let sortedGroups = groups.sorted { $0.position < $1.position }
                        for var group in sortedGroups {
                            group.employees.sort { $0.lastName < $1.lastName }
                        }

                        self.groups = sortedGroups

                    case .failure(let error):
                        // TODO: call delegate with error
                        fatalError(error.description)
                    }
                }

            case .failure(let error):
                // TODO: call delegate with error
                fatalError(error.description)
            }
        }
    }

    func pushDetailsViewController(employee: Group.Employee) {
        flowDelegate?.pushDetailsViewController(for: employee)
    }

    func pushContactViewController(contact: CNContact) {
        flowDelegate?.pushContactViewController(for: contact)
    }
}
