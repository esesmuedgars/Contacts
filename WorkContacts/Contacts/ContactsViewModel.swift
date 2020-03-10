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

                        // Initialize array of `Group` class user interface objects
                        // Sort employees alphabetically by last name
                        let groups = grouped.initUIClass(contacts, sortBy: <)
                            
                        // Sort groups alphabetically by position
                        let sortedGroups = groups.sorted(by: <)
                        
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
        let searchItems = string
            .components(separatedBy: .whitespaces)
            .remove({ strings, string in
                strings.contains(where: { $0.contains(string) })
            })
        
        var filteredGroups = groups
        
        searchItems.forEach { string in
            filteredGroups.filter(filteredBy: string)
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

fileprivate extension Dictionary where Key == Position, Value == [Employee] {
    /// Initialize array of `Group` class user interface objects with sorted employees using given predicate.
    /// - Parameters:
    ///   - contacts: List of contacts to match employees against.
    ///   - areInIncreasingOrder: A predicate that returns `true` if its first argument should be ordered before its second argument, otherwise `false`.
    func initUIClass(_ contacts: [CNContact], sortBy areInIncreasingOrder: (Group.Employee, Group.Employee) -> Bool) -> [Group] {
        map { position, employees in
            let employees = employees.map { employee in
                Group.Employee(contact: contacts.existingContact(employee),
                               firstName: employee.firstName,
                               lastName: employee.lastName,
                               position: employee.position,
                               details: employee.details,
                               projects: Array(employee.projects))
            }
            
            let sortedEmployees = employees.sorted(by: areInIncreasingOrder)
            
            return Group(position: position, employees: sortedEmployees)
        }
    }
}

fileprivate extension Array where Element == CNContact {
    /// Check if employee is saved as contact by matching first and last names.
    func existingContact(_ employee: Employee) -> CNContact? {
        first { contact in
            contact.givenName.isEqualCaseInsensitive(employee.firstName) &&
                contact.familyName.isEqualCaseInsensitive(employee.lastName)
        }
    }
}

fileprivate extension Array where Element == Group {
    /// Filters employees containing, in order, employees that contain predicate in first name, last name, email address, projects or position.
    mutating func filter(filteredBy string: String) {
        self = map { group in
            var mutable = group
            
            mutable.employees = group.employees.filter { employee in
                employee.firstName.localizedCaseInsensitiveContains(string) ||
                    employee.lastName.localizedCaseInsensitiveContains(string) ||
                    employee.position.fullTitle.localizedCaseInsensitiveContains(string) ||
                    employee.details.email.localizedCaseInsensitiveContains(string) ||
                    employee.projects.contains(where: { $0.localizedCaseInsensitiveContains(string) })
            }
            
            return mutable
        }
    }
}
