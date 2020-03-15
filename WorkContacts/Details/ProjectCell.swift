//
//  ProjectCell.swift
//  WorkContacts
//
//  Created by @esesmuedgars
//

import UIKit

final class ProjectCell: UITableViewCell {

    @IBOutlet private var titleLabel: UILabel!

    func configure(project: String) {
        titleLabel.text = project
    }
}

