//
//  Position.swift
//  WorkContacts
//
//  Created by @esesmuedgars
//

enum Position: String, Decodable, Hashable {
    case ios = "IOS"
    case android = "ANDROID"
    case pm = "PM"
    case web = "WEB"
    case tester = "TESTER"
    case sales = "SALES"
    case other = "OTHER"

    var fullTitle: String {
        switch self {
        case .ios: return "iOS developer"
        case .android: return "Android developer"
        case .pm: return "Project manager"
        case .web: return "Front-end developer"
        case .tester: return "Quality assurance specialist"
        case .sales: return "Sales manager"
        case .other: return "Employee"
        }
    }
}

extension Position {
    static func <(lhs: Position, rhs: Position) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }
}
