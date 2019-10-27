//
//  ContactsViewController.swift
//  WorkContacts
//
//  Created by @esesmuedgars
//

import UIKit
import ContactsUI

protocol ContactsViewModelType {
    var title: String { get }
    var cancelTitle: String { get }
    var retryTitle: String { get }
    var groups: [Group] { get }

    func fetchEmployeeList()

    func pushDetailsViewController(employee: Group.Employee)
    func pushContactViewController(contact: CNContact)
}

final class ContactsViewController: UIViewController, ContactsViewModelDelegate, EmployeeCellDelegate, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet private var tableView: UITableView!

    var viewModel: ContactsViewModelType!

    override func viewDidLoad() {
        super.viewDidLoad()

        title = viewModel.title
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        viewModel.fetchEmployeeList()
    }

    // MARK: - ContactsViewModelDelegate

    func viewModelDidFetchGroups() {
        tableView.reloadData()
    }

    func viewModelDidFail(withServiceError error: ServiceError) {
        let alertController = UIAlertController(title: nil,
                                                message: error.description,
                                                preferredStyle: .alert)

        let cancel = UIAlertAction(title: viewModel.cancelTitle, style: .cancel, handler: nil)
        let retry = UIAlertAction(title: viewModel.retryTitle, style: .default) { [unowned self] _ in
            self.viewModel.fetchEmployeeList()
        }

        alertController.addActions(cancel, retry)

        present(alertController, animated: true)
    }

    // MARK: - EmployeeCellDelegate

    func employeeCellOpenContactInfo(contact: CNContact) {
        viewModel.pushContactViewController(contact: contact)
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
        let cell = tableView.dequeueReusableCell(ofType: EmployeeCell.self, for: indexPath)
        cell.delegate = self

        let employee = viewModel.groups[indexPath.section].employees[indexPath.row]
        cell.configure(lastName: employee.lastName,
                       firstName: employee.firstName,
                       contact: employee.contact)

        return cell
    }

    // MARK: - UITableViewDelegate

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let employee = viewModel.groups[indexPath.section].employees[indexPath.row]
        viewModel.pushDetailsViewController(employee: employee)
    }
}

