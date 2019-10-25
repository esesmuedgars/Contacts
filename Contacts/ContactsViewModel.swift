//
//  ContactsViewModel.swift
//  Contacts
//
//  Created by @esesmuedgars
//

protocol ContactsViewModelDelegate: AnyObject {}

final class ContactsViewModel: ContactsViewModelType {

    weak var delegate: ContactsViewModelDelegate!
    weak var flowDelegate: CoordinatorFlowDelegate!

}
