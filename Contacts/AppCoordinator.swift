//
//  AppCoordinator.swift
//  Contacts
//
//  Created by @esesmuedgars
//

import UIKit

protocol Coordinator {
    func startCoordinatorFlow()
}

private extension Coordinator {
    func setWindowRoot(viewController: UIViewController) {
        UIApplication.shared.keyWindow?.rootViewController = viewController
    }
}

protocol CoordinatorFlowDelegate: AnyObject {
    func presentDetailsViewController()
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

    func presentDetailsViewController() {
        let viewController = storyboard.instantiateViewController(ofType: DetailsViewController.self)

        let viewModel = DetailsViewModel()
        viewModel.delegate = viewController
        viewModel.flowDelegate = self

        viewController.viewModel = viewModel

        navigationController.present(viewController, animated: true)
    }
}
