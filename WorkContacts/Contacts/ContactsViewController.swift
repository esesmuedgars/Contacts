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
    var placeholder: String { get }
    var errorTitle: String { get }
    var errorMessage: String { get }
    var cancelTitle: String { get }
    var retryTitle: String { get }
    var groups: [Group] { get }
    var filteredGroups: [Group] { get }

    func fetchEmployeeList()
    func updateSearchResults(_: String)

    func pushDetailsViewController(employee: Group.Employee)
    func pushContactViewController(contact: CNContact)
}

final class ContactsViewController: UIViewController, ContactsViewModelDelegate, EmployeeCellDelegate, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating {

    @IBOutlet private var tableView: UITableView! {
        didSet {
            tableView.refreshControl = refreshControl
            tableView.tableFooterView = UIView()
        }
    }

    var viewModel: ContactsViewModelType!

    private let refreshControl = UIRefreshControl()
    private var shouldFetchInitialEmployeeList = true

    private lazy var searchController: UISearchController = {
        let controller = UISearchController(searchResultsController: nil)
        controller.searchResultsUpdater = self
        controller.obscuresBackgroundDuringPresentation = false

        return controller
    }()

    private var isSearching: Bool {
        guard let string = searchController.searchBar.text else {
            return true
        }

        return searchController.isActive && !string.isEmpty
    }

    private var groups: [Group] {
        return isSearching ? viewModel.filteredGroups : viewModel.groups
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        definesPresentationContext = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.searchController = searchController

        refreshControl.addTarget(self, action: #selector(fetchEmployeeList), for: .valueChanged)

        bindUI()
    }

    private func bindUI() {
        title = viewModel.title
        
        searchController.searchBar.placeholder = viewModel.placeholder
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if shouldFetchInitialEmployeeList {
            fetchEmployeeList()

            shouldFetchInitialEmployeeList = false
        }
    }

    @objc
    private func fetchEmployeeList() {
        viewModel.fetchEmployeeList()
    }

    // MARK: - ContactsViewModelDelegate

    func viewModelDidFetchGroups() {
        refreshControl.endRefreshing()
        tableView.reloadData()
    }

    func viewModelDidFail(withServiceError error: ServiceError) {
        let alertController = UIAlertController(title: viewModel.errorTitle,
                                                message: viewModel.errorMessage,
                                                preferredStyle: .alert)

        let cancel = UIAlertAction(title: viewModel.cancelTitle, style: .cancel) { [unowned self] _ in
            guard self.refreshControl.isRefreshing else {
                return
            }
            
            self.refreshControl.endRefreshing()
        }
        let retry = UIAlertAction(title: viewModel.retryTitle, style: .default) { [unowned self] _ in
            self.fetchEmployeeList()
        }

        alertController.addActions(cancel, retry)

        present(alertController, animated: true)
    }

    func viewModelDidUpdateSearchResults() {
        tableView.reloadData()
    }

    // MARK: - EmployeeCellDelegate

    func employeeCellOpenContactInfo(contact: CNContact) {
        viewModel.pushContactViewController(contact: contact)
    }

    // MARK: - UITableViewDataSource

    func numberOfSections(in tableView: UITableView) -> Int {
        return groups.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return groups[section].position.fullTitle
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups[section].employees.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(ofType: EmployeeCell.self, for: indexPath)
        cell.delegate = self

        let employee = groups[indexPath.section].employees[indexPath.row]
        cell.configure(lastName: employee.lastName,
                       firstName: employee.firstName,
                       contact: employee.contact)

        return cell
    }

    // MARK: - UITableViewDelegate

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let employee = groups[indexPath.section].employees[indexPath.row]
        viewModel.pushDetailsViewController(employee: employee)
    }

    // MARK: - UISearchResultsUpdating

    public func updateSearchResults(for searchController: UISearchController) {
        if let string = searchController.searchBar.text {
            viewModel.updateSearchResults(string)
        }
    }
}

