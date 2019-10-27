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
        case .ios: return "iOS developers"
        case .android: return "Android developers"
        case .pm: return "Project managers"
        case .web: return "Front-end developers"
        case .tester: return "Quality assurance specialists"
        case .sales: return "Sales managers"
        case .other: return "Other positions"
        }
    }
}

extension Position {
    static func <(lhs: Position, rhs: Position) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }
}
