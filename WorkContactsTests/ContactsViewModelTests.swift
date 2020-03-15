//
//  ContactsViewModelTests.swift
//  WorkContacts
//
//  Created by @esesmuedgars
//

import XCTest
import Contacts
@testable import WorkContacts

final class ContactsViewModelTests: XCTestCase {
    
    private var apiService: APIServiceMockProtocol!
    private var contactsService: ContactsServiceMockProtocol!
    private var delegate: TestContactsViewModelDelegate!
    private var flowDelegate: TestCoordinatorFlowDelegate!
    private var viewModel: ContactsViewModel!

    override func setUp() {
        super.setUp()
        
        let apiService = APIServiceMock()
        self.apiService = apiService
        
        let contactsService = ContactsServiceMock()
        self.contactsService = contactsService
        
        let delegate = TestClassContactsViewModelDelegate()
        self.delegate = delegate
        
        let flowDelegate = TestClassCoordinatorFlowDelegate()
        self.flowDelegate = flowDelegate
        
        viewModel = ContactsViewModel(apiService: apiService, contactsService: contactsService)
        viewModel.delegate = delegate
        viewModel.flowDelegate = flowDelegate
    }

    override func tearDown() {
        apiService = nil
        contactsService = nil
        delegate = nil
        flowDelegate = nil
        viewModel = nil
        
        super.tearDown()
    }
    
    func testFetchEmployeeListSuccessResult() {
        let expectation = self.expectation(description: "`ContactsViewModelDelegate.viewModelDidFetchGroups` callback")
        let testEmployee = Employee(firstName: "John",
                                    lastName: "Appleseed",
                                    position: .ios,
                                    details: Details(email: "john.appleseed@apple.com",
                                                     phone: "8885555512"),
                                    projects: Set<String>())
        let testContact = CNMutableContact(givenName: "John",
                                           familyName: "Appleseed")
        
        apiService.fetchEmployeeListResult = .success(Set([testEmployee]))
        
        contactsService.fetchContactListResult = .success([testContact])
        
        delegate.didFetchGroups = { [unowned viewModel] _ in
            guard let employee = viewModel?.groups.first?.employees.first else {
                return
            }
            
            XCTAssertEqual(employee.contact, testContact)
            XCTAssertEqual(employee.firstName, testEmployee.firstName)
            XCTAssertEqual(employee.lastName, testEmployee.lastName)
            XCTAssertEqual(employee.position, testEmployee.position)
            XCTAssertEqual(employee.details, testEmployee.details)
            
            expectation.fulfill()
        }
        
        viewModel.fetchEmployeeList()
        
        wait(for: [expectation], timeout: 1)
    }
    
    func testFetchEmployeeListFailureResultWithAPIServiceError() {
        let expectation = self.expectation(description: "`ContactsViewModelDelegate.viewModelDidFail(withServiceError:)` callback")
        let testError: APIServiceError = .emptyDataOrError
        
        apiService.fetchEmployeeListResult = .failure(testError)
        
        delegate.didFail = { error in
            XCTAssertEqual(error.description, testError.description)
            
            expectation.fulfill()
        }
        
        viewModel.fetchEmployeeList()
        
        wait(for: [expectation], timeout: 1)
    }
    
    func testFetchEmployeeListFailureResultWithContactsServiceError() {
        let expectation = self.expectation(description: "`ContactsViewModelDelegate.viewModelDidFail(withServiceError:)` callback")
        let testError: ContactsServiceError = .permissionDeniedOrRestricted
        
        apiService.fetchEmployeeListResult = .success(Set<Employee>())
        
        contactsService.fetchContactListResult = .failure(testError)
        
        delegate.didFail = { error in
            XCTAssertEqual(error.description, testError.description)
            
            expectation.fulfill()
        }
        
        viewModel.fetchEmployeeList()
        
        wait(for: [expectation], timeout: 1)
    }
    
    func testGroupEmployeeFilter() {
        let expectationA = self.expectation(description: "`ContactsViewModelDelegate.viewModelDidUpdateSearchResults` first callback")
        let expectationB = self.expectation(description: "`ContactsViewModelDelegate.viewModelDidUpdateSearchResults` second callback")
        
        let johnAppleseed = Group.Employee(contact: CNMutableContact(givenName: "John",
                                                                     familyName: "Appleseed"),
                                           firstName: "John",
                                           lastName: "Appleseed",
                                           position: .ios,
                                           details: Details(email: "john.appleseed@apple.com",
                                                            phone: "8885555512"),
                                           projects: [])
        let kateBell = Group.Employee(contact: CNMutableContact(givenName: "Kate",
                                                                familyName: "Bell"),
                                      firstName: "Kate",
                                      lastName: "Bell",
                                      position: .other,
                                      details: Details(email: "kate.bell@apple.com",
                                                       phone: nil),
                                      projects: [])
        let jonyIve = Group.Employee(contact: nil,
                                     firstName: "Jony",
                                     lastName: "Ive",
                                     position: .other,
                                     details: Details(email: "jony.ive@love.from",
                                                      phone: nil),
                                     projects: ["iPhone", "iMac", "MacBook"])
        
        viewModel.groups = [
            .init(position: .ios, employees: [johnAppleseed]),
            .init(position: .other, employees: [kateBell, jonyIve]),
        ]
        
        delegate.didUpdateSearchResults = { [unowned viewModel] _ in
            guard let groups = viewModel?.filteredGroups else {
                return
            }
            
            let testGroups: [Group] = [
                .init(position: .ios, employees: []),
                .init(position: .other, employees: [kateBell, jonyIve]),
            ]
            
            XCTAssertEqual(groups, testGroups)
            
            expectationA.fulfill()
        }
        
        viewModel.updateSearchResults("Other")
        
        wait(for: [expectationA], timeout: 1)
        
        delegate.didUpdateSearchResults = { [unowned viewModel] _ in
            guard let groups = viewModel?.filteredGroups else {
                return
            }
            
            let testGroups: [Group] = [
                .init(position: .ios, employees: []),
                .init(position: .other, employees: [jonyIve]),
            ]
            
            XCTAssertEqual(groups, testGroups)
            
            expectationB.fulfill()
        }
        
        viewModel.updateSearchResults("Other iPhone")
        
        wait(for: [expectationB], timeout: 1)
    }
        
    func testPushDetailsViewControllerDelegateCallback() {
        let expectation = self.expectation(description: "`CoordinatorFlowDelegate.pushDetailsViewController(for:)` callback")
        let testEmployee = Group.Employee(contact: nil,
                                          firstName: "John",
                                          lastName: "Appleseed",
                                          position: .ios,
                                          details: Details(email: "john.appleseed@apple.com",
                                                           phone: "8885555512"),
                                          projects: [])
        
        flowDelegate.didPushDetailsViewController = { employee in
            XCTAssertEqual(employee, testEmployee)
            
            expectation.fulfill()
        }
        
        viewModel.pushDetailsViewController(employee: testEmployee)
        
        wait(for: [expectation], timeout: 1)
    }
    
    func testPushContactViewControllerDelegateCallback() {
        let expectation = self.expectation(description: "`CoordinatorFlowDelegate.pushContactViewController(for:)` callback")
        let testContact = CNMutableContact(givenName: "John",
                                           familyName: "Appleseed")
                
        flowDelegate.didPushContactViewController = { contact in
            XCTAssertEqual(contact, testContact)
            
            expectation.fulfill()
        }
        
        viewModel.pushContactViewController(contact: testContact)
        
        wait(for: [expectation], timeout: 1)
    }
}
