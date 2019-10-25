//
//  DetailsViewModel.swift
//  Contacts
//
//  Created by @esesmuedgars
//

protocol DetailsViewModelDelegate: AnyObject {
}

final class DetailsViewModel: DetailsViewModelType {

    weak var delegate: DetailsViewModelDelegate!
    weak var flowDelegate: CoordinatorFlowDelegate!

}
