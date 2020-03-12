//
//  AppCoordinator.swift
//  WorkContacts
//
//  Created by @esesmuedgars
//

import UIKit
import ContactsUI

protocol Coordinator {
    func startCoordinatorFlow()
}

private extension Coordinator {
    func setWindowRoot(viewController: UIViewController) {
        UIApplication.shared.keyWindow?.rootViewController = viewController
    }
}

protocol CoordinatorFlowDelegate: class {
    func pushDetailsViewController(for employee: Group.Employee)
    func pushContactViewController(for contact: CNContact)
}

final class AppCoordinator: Coordinator, CoordinatorFlowDelegate {

    private var navigationController: UINavigationController!
    private let storyboard = UIStoryboard(name: "Main", bundle: .main)

    func startCoordinatorFlow() {
        setRootContactsViewController()
    }

    private func setRootContactsViewController() {
        let viewController = storyboard.instantiateViewController(ofType: ContactsViewController.self)

        let viewModel = ContactsViewModel()
        viewModel.delegate = viewController
        viewModel.flowDelegate = self

        viewController.viewModel = viewModel

        navigationController = UINavigationController(rootViewController: viewController)
        setWindowRoot(viewController: navigationController)
    }

    // MARK: - CoordinatorFlowDelegate

    func pushDetailsViewController(for employee: Group.Employee) {
        let viewController = storyboard.instantiateViewController(ofType: DetailsViewController.self)

        let viewModel = DetailsViewModel(employee: employee)
        viewModel.flowDelegate = self

        viewController.viewModel = viewModel

        navigationController.pushViewController(viewController, animated: true)
    }

    func pushContactViewController(for contact: CNContact) {
        let viewController = CNContactViewController(for: contact)

        navigationController.pushViewController(viewController, animated: true)
    }
}
