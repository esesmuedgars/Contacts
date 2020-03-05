//
//  DetailsViewController.swift
//  WorkContacts
//
//  Created by @esesmuedgars
//

import UIKit

protocol DetailsViewModelType {
    var sectionHeaderTitle: String? { get }
    var positionTitle: String { get }
    var emailTitle: String { get }
    var phoneNumberTitle: String { get }

    var fullName: String { get }
    var position: String { get }
    var email: String { get }
    var phoneNumber: String? { get }
    var projects: [String] { get }

    var withoutPhoneNumber: Bool { get }
    var isContact: Bool { get }

    func pushContactViewController()
}

final class DetailsViewController: UIViewController, UITableViewDataSource {

    @IBOutlet private var tableView: UITableView! {
        didSet {
            tableView.tableFooterView = UIView()
        }
    }
    @IBOutlet private var fullNameLabel: UILabel!
    @IBOutlet private var positionTitleLabel: UILabel!
    @IBOutlet private var positionLabel: UILabel!
    @IBOutlet private var emailTitleLabel: UILabel!
    @IBOutlet private var emailLabel: UILabel!
    @IBOutlet private var phoneNumberStackView: UIStackView!
    @IBOutlet private var phoneNumberTitleLabel: UILabel!
    @IBOutlet private var phoneNumberLabel: UILabel!

    var viewModel: DetailsViewModelType!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.largeTitleDisplayMode = .never

        bindUI()
    }

    private func bindUI() {
        fullNameLabel.text = viewModel.fullName
        positionLabel.text = viewModel.position
        emailLabel.text = viewModel.email
        phoneNumberLabel.text = viewModel.phoneNumber

        positionTitleLabel.text = viewModel.positionTitle
        emailTitleLabel.text = viewModel.emailTitle
        phoneNumberTitleLabel.text = viewModel.phoneNumberTitle

        phoneNumberStackView.isHidden = viewModel.withoutPhoneNumber

        if viewModel.isContact {
            navigationItem.rightBarButtonItem = UIBarButtonItem(imageName: "Contact", style: .plain, target: self, selector: #selector(pushContactViewController))
        }
    }

    @objc
    private func pushContactViewController() {
        viewModel.pushContactViewController()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        tableView.layoutTableHeaderView()
    }

    // MARK: - UITableViewDataSource

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        viewModel.sectionHeaderTitle
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.projects.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(ofType: ProjectCell.self, for: indexPath)

        let project = viewModel.projects[indexPath.row]
        cell.configure(project: project)

        return cell
    }
}
