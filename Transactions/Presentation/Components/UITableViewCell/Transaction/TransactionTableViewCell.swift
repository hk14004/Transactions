//
//  TransactionTableViewCell.swift
//  Transactions
//
//  Created by Hardijs Ķirsis on 05/05/2023.
//

import UIKit
import Combine

class TransactionTableViewCell: UITableViewCell {

    // MARK: Properties
    
    /// Public
    static let reuseID = String(describing: TransactionTableViewCell.self)
    @IBOutlet weak var contentVStack: UIStackView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    weak var viewModel: (any TransactionTableViewCellVMProtocol)?
    
    /// Private
    private var bag = Set<AnyCancellable>()
}

// MARK: Public

extension TransactionTableViewCell {
    func bindTo(viewModel: any TransactionTableViewCellVMProtocol) {
        bag.removeAll()
        self.viewModel = viewModel
        viewModel.nameLabelPublisher.sink { text in
            self.nameLabel.text = text
        }.store(in: &bag)
        viewModel.amountLabelPublisher.sink { text in
            self.amountLabel.text = text
        }.store(in: &bag)
        viewModel.dateLabelPublisher.sink { text in
            self.dateLabel.text = text
        }.store(in: &bag)
        viewModel.infoLabelPublisher.sink { text in
            self.infoLabel.text = text
        }.store(in: &bag)
    }
}
