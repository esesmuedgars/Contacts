//
//  Group.swift
//  WorkContacts
//
//  Created by @esesmuedgars
//

import Contacts

struct Group {
    let position: Position
    var employees: [Group.Employee]

    struct Employee {
        var contact: CNContact?
        let firstName: String
        let lastName: String
        let details: Details
        let projects: [String]
    }
}
