//
//  Dependencies.swift
//  WorkContacts
//
//  Created by @esesmuedgars
//

import Foundation

final class Dependencies {

    static var shared = Dependencies()

    let apiService: APIServiceProtocol

    private init() {
        apiService = APIService()
    }
}
