//
//  ContactsServiceMock.swift
//  WorkContacts
//
//  Created by @esesmuedgars
//

import Contacts
@testable import WorkContacts

protocol ContactsServiceMockProtocol: class {
    var fetchContactListResult: Result<[CNContact], ContactsServiceError>? { get set }
}

final class ContactsServiceMock: ContactsServiceMockProtocol, ContactsServiceProtocol {
    
    var fetchContactListResult: Result<[CNContact], ContactsServiceError>?
    
    func fetchContactList(completionHandler complete: @escaping ContactListCompletionBlock) {
        guard let result = fetchContactListResult else {
            return
        }
        
        complete(result)
    }
}
