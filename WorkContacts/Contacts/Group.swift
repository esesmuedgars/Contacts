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
        let contact: CNContact?
        let firstName: String
        let lastName: String
        let position: Position
        let details: Details
        let projects: [String]
    }
}
