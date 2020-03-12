//
//  Helpers.swift
//  WorkContacts
//
//  Created by @esesmuedgars
//

import Contacts

typealias OptionalBlock<CapturedType> = ((CapturedType) -> Void)?

extension CNMutableContact {
    convenience init(givenName: String, familyName: String) {
        self.init()
        
        self.givenName = givenName
        self.familyName = familyName
    }
}
