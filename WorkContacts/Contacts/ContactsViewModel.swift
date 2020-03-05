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
    func viewModelDidFail(withServiceError error: ServiceError)
    func viewModelDidUpdateSearchResults()
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

    var filteredGroups = [Group]() {
        didSet {
            DispatchQueue.main.async {
                self.delegate?.viewModelDidUpdateSearchResults()
            }
        }
    }

    let title = "contacts.navigation.title".localized()
    let placeholder = "contacts.navigation.search.placeholder".localized()
    let errorTitle = "contacts.error.alert.title".localized()
    let errorMessage = "contacts.error.alert.message".localized()
    let cancelTitle = "contacts.error.alert.button.cancel".localized()
    let retryTitle = "contacts.error.alert.button.retry".localized()

    init(apiService: APIServiceProtocol = Dependencies.shared.apiService,
         contactsService: ContactsServiceProtocol = Dependencies.shared.contactsService) {
        self.apiService = apiService
        self.contactsService = contactsService
    }

    func fetchEmployeeList() {
        apiService.fetchEmployeeList { [unowned self] result in
            switch result {
            case .success(let employees):
                self.contactsService.fetchContactList { [unowned self] result in
                    switch result {
                    case .success(let contacts):
                        // Group employees by position
                        var grouped = [Position: [Employee]]()
                        employees.forEach {
                            grouped[$0.position, default: []].append($0)
                        }

                        // Initialize array of `Group` class for UI
                        let groups = grouped.map(contacts.initUIClass)

                        // Sort groups alphabetically
                        let sortedGroups = groups.sorted { $0.position < $1.position }
                        
                        self.groups = sortedGroups

                    case .failure(let error):
                        DispatchQueue.main.async {
                            self.delegate?.viewModelDidFail(withServiceError: error)
                        }
                    }
                }

            case .failure(let error):
                DispatchQueue.main.async {
                    self.delegate?.viewModelDidFail(withServiceError: error)
                }
            }
        }
    }

    func updateSearchResults(_ string: String) {
        let string = string.lowercased()

        let filteredGroups = groups.compactMap { group -> Group? in
            // Filter employees by first name, last name, email, projects or position
            let filteredEmployees = group.employees.filter { employee in
                return employee.firstName.lowercased().contains(string) || employee.lastName.lowercased().contains(string) || employee.position.fullTitle.lowercased().contains(string) ||
                    employee.details.email.lowercased().contains(string) ||
                    employee.projects.contains(where: { $0.lowercased().contains(string) })
            }

            // Remove group if there are no employees
            return filteredEmployees.isEmpty ? nil : Group(position: group.position, employees: filteredEmployees)
        }

        self.filteredGroups = filteredGroups
    }

    func pushDetailsViewController(employee: Group.Employee) {
        flowDelegate?.pushDetailsViewController(for: employee)
    }

    func pushContactViewController(contact: CNContact) {
        flowDelegate?.pushContactViewController(for: contact)
    }
}

fileprivate extension Array where Element == CNContact {
    func initUIClass(position: Position, employees: [Employee]) -> Group {
        let employees = employees.map { employee -> Group.Employee in
            // Check if employee is saved as contact
            let contact = first { contact in
                contact.givenName.lowercased() == employee.firstName.lowercased() &&
                    contact.familyName.lowercased() == employee.lastName.lowercased()
            }

            return Group.Employee(contact: contact,
                                  firstName: employee.firstName,
                                  lastName: employee.lastName,
                                  position: employee.position,
                                  details: employee.details,
                                  projects: Array<String>(employee.projects))
        }

        // Sort employees by last name
        let sortedEmployees = employees.sorted { $0.lastName < $1.lastName }

        return Group(position: position, employees: sortedEmployees)
    }
}
