//
//  APIService.swift
//  WorkContacts
//
//  Created by @esesmuedgars
//

import Foundation

enum APIServiceError: Error {
    case invalidURL
    case emptyDataOrError
    case unexpectedStatusCode(statusCode: Int)
    case unableToParseDataWith(error: Error)
}

extension APIServiceError {
    var description: String {
        switch self {
        case .invalidURL:
            return "Failed to construct URL."
        case .emptyDataOrError:
            return "Request did not fetch data or returned error."
        case .unexpectedStatusCode(let statusCode):
            return "Expected request status code between 200 - 299, received \(statusCode)."
        case .unableToParseDataWith(let error):
            return "Unable to parse data, with error: \(error)."
        }
    }
}

typealias EmployeeListCompletionBlock = (Result<Set<Employee>, APIServiceError>) -> Void

protocol APIServiceProtocol {
    func fetchEmployeeList(completionHandler: @escaping EmployeeListCompletionBlock)
}

final class APIService: APIServiceProtocol {

    private func fetchEmployees(location: Base, completionHandler complete: @escaping EmployeeListCompletionBlock) {
        guard let url = Endpoint.employees.url(base: location) else {
            complete(.failure(.invalidURL))
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, let response = response as? HTTPURLResponse, error == nil else {
                complete(.failure(.emptyDataOrError))
                return
            }

            guard 200 ..< 300 ~= response.statusCode else {
                complete(.failure(.unexpectedStatusCode(statusCode: response.statusCode)))
                return
            }

            do {
                let model = try JSONDecoder().decode(EmployeeList.self, from: data)
                complete(.success(model.employees))
            } catch {
                complete(.failure(.unableToParseDataWith(error: error)))
            }
        }.resume()
    }

    // MARK: - APIServiceProtocol

    func fetchEmployeeList(completionHandler complete: @escaping EmployeeListCompletionBlock) {
        fetchEmployees(location: .tartu) { [unowned self] result in
            switch result {
            case .success(let tartuEmployees):
                self.fetchEmployees(location: .tallinn) { result in
                    switch result {
                    case .success(let tallinnEmployees):
                        let employees = tartuEmployees.union(tallinnEmployees)
                        complete(.success(employees))

                    case .failure(let error):
                        complete(.failure(error))
                    }
                }

            case .failure(let error):
                complete(.failure(error))
            }
        }
    }
}
