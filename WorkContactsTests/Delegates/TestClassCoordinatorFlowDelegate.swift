//
//  TestClassCoordinatorFlowDelegate.swift
//  WorkContacts
//
//  Created by @esesmuedgars
//

import Contacts
@testable import WorkContacts

protocol TestCoordinatorFlowDelegate: class {
    var didPushDetailsViewController: OptionalBlock<Group.Employee> { get set }
    var didPushContactViewController: OptionalBlock<CNContact> { get set }
}

final class TestClassCoordinatorFlowDelegate: TestCoordinatorFlowDelegate, CoordinatorFlowDelegate {
    
    var didPushDetailsViewController: OptionalBlock<Group.Employee> = nil
    
    func pushDetailsViewController(for employee: Group.Employee) {
        didPushDetailsViewController?(employee)
    }
    
    var didPushContactViewController: OptionalBlock<CNContact> = nil
    
    func pushContactViewController(for contact: CNContact) {
        didPushContactViewController?(contact)
    }
}
