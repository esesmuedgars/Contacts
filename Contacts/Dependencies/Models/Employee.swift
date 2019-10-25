//
//  Employee.swift
//  Contacts
//
//  Created by @esesmuedgars
//

struct Employee: Decodable, Hashable {
    let firstName: String
    let lastName: String
    private let position: Position
    let details: Details
    let projects: Set<String>

    var positionTitle: String {
        return position.fullTitle
    }

    private enum CodingKeys: String, CodingKey {
        case firstName = "fname"
        case lastName = "lname"
        case position
        case details = "contact_details"
        case projects
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        firstName = try container.decode(String.self, forKey: .firstName)
        lastName = try container.decode(String.self, forKey: .lastName)
        position = try container.decode(Position.self, forKey: .position)
        details = try container.decode(Details.self, forKey: .details)

        if let projects = try container.decodeIfPresent(Set<String>.self, forKey: .projects) {
            self.projects = projects
        } else {
            projects = Set<String>()
        }
    }
}
