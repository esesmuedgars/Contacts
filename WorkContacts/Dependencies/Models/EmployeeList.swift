//
//  EmployeeList.swift
//  WorkContacts
//
//  Created by @esesmuedgars
//

struct EmployeeList: Decodable {
    let employees: Set<Employee>

    private enum CodingKeys: String, CodingKey {
        case employees
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        employees = try container.decode(Set<Employee>.self, forKey: .employees)
    }
}
