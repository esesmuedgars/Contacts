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
        case .android: return "contacts.position.title.android".localized()
        case .ios: return "contacts.position.title.ios".localized()
        case .other: return "contacts.position.title.other".localized()
        case .pm: return "contacts.position.title.pm".localized()
        case .sales: return "contacts.position.title.sales".localized()
        case .tester: return "contacts.position.title.tester".localized()
        case .web: return "contacts.position.title.web".localized()
        }
    }

    var detailsTitle: String {
        switch self {
        case .android: return "contacts.position.details.title.android".localized()
        case .ios: return "contacts.position.details.title.ios".localized()
        case .other: return "contacts.position.details.title.other".localized()
        case .pm: return "contacts.position.details.title.pm".localized()
        case .sales: return "contacts.position.details.title.sales".localized()
        case .tester: return "contacts.position.details.title.tester".localized()
        case .web: return "contacts.position.details.title.web".localized()
        }
    }
}

extension Position {
    static func <(lhs: Position, rhs: Position) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
}
