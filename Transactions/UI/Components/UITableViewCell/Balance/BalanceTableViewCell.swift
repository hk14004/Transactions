//
//  BalanceTableViewCell.swift
//  Transactions
//
//  Created by Hardijs Ķirsis on 05/05/2023.
//

import UIKit
import Combine

class BalanceTableViewCell: UITableViewCell {

    // MARK: Properties
    
    /// Public
    static let reuseID = String(describing: BalanceTableViewCell.self)
    @IBOutlet weak var balanceLabel: UILabel!
    weak var viewModel: (any BalanceTableViewCellVMProtocol)?
    
    /// Private
    private var bag = Set<AnyCancellable>()
}

// MARK: Public

extension BalanceTableViewCell {
    func bindTo(viewModel: any BalanceTableViewCellVMProtocol) {
        bag.removeAll()
        self.viewModel = viewModel
        viewModel.balanceLabelPublisher.sink { text in
            self.balanceLabel.text = text
        }.store(in: &bag)
    }
}
