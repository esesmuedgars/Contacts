//
//  APIServiceMock.swift
//  WorkContacts
//
//  Created by @esesmuedgars
//

@testable import WorkContacts

protocol APIServiceMockProtocol: class {
    var fetchEmployeeListResult: Result<Set<Employee>, APIServiceError>? { get set }
}

final class APIServiceMock: APIServiceMockProtocol, APIServiceProtocol {
    
    var fetchEmployeeListResult: Result<Set<Employee>, APIServiceError>?
    
    func fetchEmployeeList(completionHandler complete: @escaping EmployeeListCompletionBlock) {
        guard let result = fetchEmployeeListResult else {
            return
        }
        
        complete(result)
    }
}
