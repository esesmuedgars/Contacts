//
//  DetailsViewModelTests.swift
//  WorkContacts
//
//  Created by @esesmuedgars
//

import XCTest
import Contacts
@testable import WorkContacts

final class DetailsViewModelTests: XCTestCase {
    
    private var flowDelegate: TestCoordinatorFlowDelegate!
    
    private func makeViewModel(projects: [String] = []) -> (DetailsViewModel, Group.Employee) {
        let employee = Group.Employee(contact: CNMutableContact(givenName: "John",
                                                                familyName: "Appleseed"),
                                      firstName: "John",
                                      lastName: "Appleseed",
                                      position: .ios,
                                      details: Details(email: "john.appleseed@apple.com",
                                                       phone: "8885555512"),
                                      projects: projects)
        
        let viewModel = DetailsViewModel(employee: employee)
        viewModel.flowDelegate = flowDelegate as? CoordinatorFlowDelegate
        
        return (viewModel, employee)
    }
    
    override func setUp() {
        super.setUp()
        
        let flowDelegate = TestClassCoordinatorFlowDelegate()
        self.flowDelegate = flowDelegate
    }
    
    override func tearDown() {
        flowDelegate = nil
        
        super.tearDown()
    }
    
    func testSectionHeaderTitle() {
        let (viewModel, _) = makeViewModel(projects: [])
        
        XCTAssertNil(viewModel.sectionHeaderTitle)
    }
    
    func testSectionHeaderTitle2() {
        let (viewModel, _) = makeViewModel(projects: ["MacBook"])
        
        XCTAssertEqual(viewModel.sectionHeaderTitle, "details.title.projects".localized())
    }
    
    func testPushContactViewControllerDelegateCallback() {
        let expectation = self.expectation(description: "`CoordinatorFlowDelegate.pushContactViewController(for:)` callback")
        let (viewModel, employee) = makeViewModel()
        
        flowDelegate.didPushContactViewController = { contact in
            XCTAssertEqual(contact, employee.contact, "Pushed `CNContactViewController` for incorrect contact")
            
            expectation.fulfill()
        }
        
        viewModel.pushContactViewController()
        
        wait(for: [expectation], timeout: 1)
    }
}
