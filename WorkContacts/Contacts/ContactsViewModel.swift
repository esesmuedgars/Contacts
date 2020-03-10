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
        let searchItems = string.components(separatedBy: .whitespaces)
    
        filteredGroups = filterGroups(filteredBy: searchItems)
    }
    
    private func filterGroups(filteredBy strings: [String]) -> [Group] {
        var filteredGroupList = [[Group]]()
        
        // Apply filter criteria using each individual string as predicate
        for string in strings {
            // Filter employees by first name, last name, email address, projects or position
            let filteredGroups = groups.filter(filteredBy: string)
    
            filteredGroupList.append(filteredGroups)
        }
        
        // Combine all filtered groups into single list with unique elements
        let combinedFilteredGroups = filteredGroupList
            .flatMap({ $0 })
            .reduce([], { $0.contains($1) ? $0 : $0 + [$1] })
        
        var groupDictionary = [Position: [Group.Employee]]()
        
        // Merge employees of groups with matching positions
        // Sort employees alphabetically by last name
        combinedFilteredGroups.forEach { group in
            var employees = groupDictionary[group.position, default: []]
            
            for employee in group.employees {
                if !employees.contains(employee) {
                    employees.append(contentsOf: group.employees)
                }
            }

            employees.sort(by: <)
            
            groupDictionary.updateValue(employees, forKey: group.position)
        }
        
        // Initialize array of `Group` class user interface objects
        // Sort groups alphabetically by position
        let result = groupDictionary
            .map(Group.init)
            .sorted(by: <)
        
        return result
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
    
    /// Check if employee is saved as contact by matching `givenName` with `firstName` and `familyName` with `lastName`.
    /// - Parameter employee: `Employee` object used in comparison.
    /// - returns: `CNContact` if localized case insensitive comparison result returned `orderSame`, otherwise `nil`.
    func existingContact(_ employee: Employee) -> CNContact? {
        first { contact in
            contact.givenName.isEqualCaseInsensitive(employee.firstName) &&
                contact.familyName.isEqualCaseInsensitive(employee.lastName)
        }
    }
}

fileprivate extension Array where Element == Group {
    
    /// Returns array of `Group` with values where given string was contained within employee's first name, last name, email address, projects or position.
    /// - Parameter string: Predicate used employee filteration in case-insensitive, non-literal search, taking into account the current locale.
    func filter(filteredBy string: String) -> [Group] {
        compactMap { group -> Group? in
            var mutatingGroup = group
            
            mutatingGroup.employees = group.employees.filter { employee in
                employee.firstName.localizedCaseInsensitiveContains(string) ||
                    employee.lastName.localizedCaseInsensitiveContains(string) ||
                    employee.position.fullTitle.localizedCaseInsensitiveContains(string) ||
                    employee.details.email.localizedCaseInsensitiveContains(string) ||
                    employee.projects.contains(where: { $0.localizedCaseInsensitiveContains(string) })
            }
            
            return mutatingGroup.employees.isEmpty ? nil : mutatingGroup
        }
    }
}
