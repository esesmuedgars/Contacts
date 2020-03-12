//
//  TestClassContactsViewModelDelegate.swift
//  WorkContacts
//
//  Created by @esesmuedgars
//

@testable import WorkContacts

protocol TestContactsViewModelDelegate: class {
    var didFetchGroups: OptionalBlock<Void> { get set }
    var didFail: OptionalBlock<ServiceError> { get set }
    var didUpdateSearchResults: OptionalBlock<Void> { get set }
}

final class TestClassContactsViewModelDelegate: TestContactsViewModelDelegate, ContactsViewModelDelegate {
    
    var didFetchGroups: OptionalBlock<Void> = nil
    
    func viewModelDidFetchGroups() {
        didFetchGroups?(())
    }
    
    var didFail: OptionalBlock<ServiceError> = nil
    
    func viewModelDidFail(withServiceError error: ServiceError) {
        didFail?(error)
    }
    
    var didUpdateSearchResults: OptionalBlock<Void> = nil
    
    func viewModelDidUpdateSearchResults() {
        didUpdateSearchResults?(())
    }
}
