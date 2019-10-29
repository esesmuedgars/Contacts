//
//  Position.swift
//  WorkContacts
//
//  Created by @esesmuedgars
//

enum Position: String, Decodable, Hashable {
    case android = "ANDROID"
    case ios = "IOS"
    case other = "OTHER"
    case pm = "PM"
    case sales = "SALES"
    case tester = "TESTER"
    case web = "WEB"

    var fullTitle: String {
        switch self {
        case .android: return "Android developers"
        case .ios: return "iOS developers"
        case .other: return "Other positions"
        case .pm: return "Project managers"
        case .sales: return "Sales managers"
        case .tester: return "Testers"
        case .web: return "Web developers"
        }
    }

    var detailsTitle: String {
        switch self {
        case .android: return "Android developer"
        case .ios: return "iOS developer"
        case .other: return "Unspecified"
        case .pm: return "Project manager"
        case .sales: return "Sales manager"
        case .tester: return "Quality assurance specialist"
        case .web: return "Front-end developer"
        }
    }
}

extension Position {
    static func <(lhs: Position, rhs: Position) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }
}
