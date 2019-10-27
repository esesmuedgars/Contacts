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
                // Group employees by position
                var grouped = [Position: [Employee]]()
                employees.forEach {
                    grouped[$0.position, default: []].append($0)
                }

                // Initialize `Group` class for UI
                let groups = grouped.map { (position, employees) -> Group in
                    let employees = employees.map {
                        Group.Employee(firstName: $0.firstName,
                                       lastName: $0.lastName,
                                       details: $0.details,
                                       projects: Array($0.projects))
                    }

                    return Group(position: position, employees: employees)
                }

                // Sort groups alphabetically and employees by last name
                let sortedGroups = groups.sorted { $0.position < $1.position }
                for var group in sortedGroups {
                    group.employees.sort { $0.lastName < $1.lastName }
                }

                self.compareEmployeesAgainstContact(groups: sortedGroups) { result in
                    switch result {
                    case .success(let groups):
                        self.groups = groups

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

    private func compareEmployeesAgainstContact(groups: [Group], completionHandler complete: @escaping (Result<[Group], ContactsServiceError>) -> Void) {
        contactsService.fetchContactList { result in
            switch result {
            case .success(let contacts):
                let groups = groups.map { group -> Group in
                    var mutableGroup = group
                    mutableGroup.employees = mutableGroup.employees.map { employee -> Group.Employee in

                        var mutableEmployee = employee
                        mutableEmployee.contact = contacts.first { contact in
                            contact.givenName == employee.firstName &&
                                contact.familyName == employee.lastName
                        }

                        return mutableEmployee
                    }

                    return mutableGroup
                }

                complete(.success(groups))

            case .failure(let error):
                complete(.failure(error))
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
