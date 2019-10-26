//
//  ContactsService.swift
//  Contacts
//
//  Created by @esesmuedgars
//

import Contacts
import ContactsUI

enum ContactsServiceError: Error {
    case permissionDeniedOrRestricted
    case failedToFetchContactContainers(error: Error)
    case failedToFetchUnifiedContacts(error: Error)
}

extension ContactsServiceError {
    var description: String {
        switch self {
        case .permissionDeniedOrRestricted:
            return "User has denied permission to use contacts, or it is resticted."
        case .failedToFetchContactContainers(let error):
            return "Failed to fetch all contact containers, with error: \(error)."
        case .failedToFetchUnifiedContacts(let error):
            return "Failed to fetch all unified contacts, with error: \(error)"
        }
    }
}

typealias ContactListCompletionBlock = (Result<[CNContact], ContactsServiceError>) -> Void

protocol ContactsServiceProtocol {
    func fetchContactList(completionHandler complete: @escaping ContactListCompletionBlock)
}

final class ContactsService: ContactsServiceProtocol {

    typealias ContactsPermissionCompletionBlock = (Result<Bool, ContactsServiceError>) -> Void

    private let contactStore = CNContactStore()

    private func requestContactsPermissionIfNeeded(completionHandler complete: @escaping ContactsPermissionCompletionBlock) {
        switch CNContactStore.authorizationStatus(for: .contacts) {
        case .notDetermined:
            contactStore.requestAccess(for: .contacts) { (granted, error) in
                guard error == nil else {
                    complete(.failure(.permissionDeniedOrRestricted))
                    return
                }

                complete(.success(granted))
            }

        case .authorized:
            complete(.success(true))

        case .denied, .restricted:
            complete(.failure(.permissionDeniedOrRestricted))

        @unknown default:
            break
        }
    }

    private func fetchContacts(completionHandler complete: @escaping ContactListCompletionBlock) {
        DispatchQueue.global(qos: .userInteractive).async { [unowned self] in
            var containers = [CNContainer]()
            do {
                containers = try self.contactStore.containers(matching: nil)
            } catch {
                complete(.failure(.failedToFetchContactContainers(error: error)))
            }

            let keysToFetch = [
                CNContactGivenNameKey,
                CNContactFamilyNameKey,
                CNContactViewController.descriptorForRequiredKeys()
            ] as! [CNKeyDescriptor]

            var contacts = [CNContact]()
            for container in containers {
                let predicate = CNContact.predicateForContactsInContainer(withIdentifier: container.identifier)

                do {
                    let unifiedContacts = try self.contactStore.unifiedContacts(matching: predicate, keysToFetch: keysToFetch)
                    contacts.append(contentsOf: unifiedContacts)
                } catch {
                    complete(.failure(.failedToFetchUnifiedContacts(error: error)))
                }
            }

            complete(.success(contacts))
        }
    }

    // MARK: - ContactsServiceProtocol

    func fetchContactList(completionHandler complete: @escaping ContactListCompletionBlock) {
        requestContactsPermissionIfNeeded { [unowned self] result in
            switch result {
            case .success(let permitted):
                guard permitted else {
                    complete(.failure(.permissionDeniedOrRestricted))
                    return
                }

                self.fetchContacts { result in
                    complete(result)
                }

            case .failure(let error):
                complete(.failure(error))
            }
        }
    }
}
