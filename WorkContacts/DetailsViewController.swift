//
//  DetailsViewController.swift
//  WorkContacts
//
//  Created by @esesmuedgars
//

import UIKit

protocol DetailsViewModelType {
}

final class DetailsViewController: UIViewController, DetailsViewModelDelegate, UITableViewDataSource, UITableViewDelegate {

    var viewModel: DetailsViewModelType!

    // MARK: - DetailsViewModelDelegate

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
