//
//  Group.swift
//  WorkContacts
//
//  Created by @esesmuedgars
//

import Contacts

struct Group: Comparable {
    let position: Position
    var employees: [Group.Employee]

    struct Employee: Comparable {
        let contact: CNContact?
        let firstName: String
        let lastName: String
        let position: Position
        let details: Details
        let projects: [String]
        
        static func < (lhs: Group.Employee, rhs: Group.Employee) -> Bool {
            lhs.lastName < rhs.lastName
        }
    }
    
    static func < (lhs: Group, rhs: Group) -> Bool {
        lhs.position < rhs.position
    }
}
