//
//  ContactsViewController.swift
//  WorkContacts
//
//  Created by @esesmuedgars
//

import UIKit

protocol ContactsViewModelType {
    var groups: [Group] { get }

    func fetchEmployeeList()
}

final class ContactsViewController: UIViewController, ContactsViewModelDelegate, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet private var tableView: UITableView!

    var viewModel: ContactsViewModelType!

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.fetchEmployeeList()
    }

    // MARK: - ContactsViewModelDelegate

    func viewModelDidFetchGroups() {
        tableView.reloadData()
    }

    // MARK: - UITableViewDataSource

    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.groups.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.groups[section].position.fullTitle
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.groups[section].employees.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(ofType: UITableViewCell.self, for: indexPath)

        return cell
    }

    // MARK: - UITableViewDelegate

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}

