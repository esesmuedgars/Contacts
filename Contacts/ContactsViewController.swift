//
//  ContactsViewController.swift
//  Contacts
//
//  Created by @esesmuedgars
//

import UIKit

protocol ContactsViewModelType {
}

final class ContactsViewController: UIViewController, ContactsViewModelDelegate, UITableViewDataSource, UITableViewDelegate {

    var viewModel: ContactsViewModelType!

    // MARK: - ContactsViewModelDelegate

    // MARK: - UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }

    // MARK: - UITableViewDelegate

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}

