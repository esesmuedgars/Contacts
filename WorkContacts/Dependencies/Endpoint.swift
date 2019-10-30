//
//  Endpoint.swift
//  WorkContacts
//
//  Created by @esesmuedgars
//

import Foundation

enum Base: String {
    case tartu = "https://tartu-jobapp.aw.ee"
    case tallinn = "https://tallinn-jobapp.aw.ee"
}

enum Endpoint: String {
    case employees = "employee_list"
}

extension Endpoint {
    func url(base: Base) -> URL? {
        var url = URL(string: base.rawValue)
        url?.appendPathComponent(rawValue)
        return url
    }
}
