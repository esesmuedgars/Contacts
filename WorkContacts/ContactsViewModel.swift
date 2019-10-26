//
//  ContactsViewModel.swift
//  WorkContacts
//
//  Created by @esesmuedgars
//

import Foundation

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
                var dictionary = [Position: [Employee]]()
                employees.forEach {
                    dictionary[$0.position, default: []].append($0)
                }

                let groups = dictionary.map { (position, employees) -> Group in
                    let employees = employees.map {
                        Group.Employee(firstName: $0.firstName,
                                        lastName: $0.lastName,
                                        details: $0.details,
                                        projects: Array($0.projects))
                    }

                    return Group(position: position, employees: employees)
                }

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
    }
}

//protocol UIGroup {
//    var position: Position { get }
//    var employees: [Group.Employee] { get }
//}

struct Group {
    let position: Position
    var employees: [Employee]

    struct Employee {
        let firstName: String
        let lastName: String
        let details: Details
        let projects: [String]
    }
}
