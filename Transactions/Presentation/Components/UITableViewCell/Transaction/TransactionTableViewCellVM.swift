//
//  TransactionTableViewCellVM.swift
//  Transactions
//
//  Created by Hardijs Ķirsis on 06/05/2023.
//

import Foundation

class TransactionTableViewCellVM {
    
    // MARK: Properties
    
    /// Public
    var id: String = UUID().uuidString
    @Published var amountLabel: String = ""
    var amountLabelPublisher: Published<String>.Publisher {
        $amountLabel
    }
    @Published var nameLabel: String = ""
    var nameLabelPublisher: Published<String>.Publisher {
        $nameLabel
    }
    @Published var infoLabel: String = ""
    var infoLabelPublisher: Published<String>.Publisher {
        $infoLabel
    }
    @Published var dateLabel: String = ""
    var dateLabelPublisher: Published<String>.Publisher {
        $dateLabel
    }
    
    /// Private
    private var transaction: Transaction
    
    // MARK: Init
    
    init(transaction: Transaction) {
        self.transaction = transaction
        onTransactionUpdated(transaction: transaction)
    }
    
}

// MARK: BalanceTableViewCellVMProtocol

extension TransactionTableViewCellVM: TransactionTableViewCellVMProtocol {
    func onTransactionUpdated(transaction: Transaction) {
        self.transaction = transaction
        updateNameLabel()
        updateAmountLabel()
        updateInfoLabel()
        updateDateLabel()
    }
}

// MARK: Private

extension TransactionTableViewCellVM {
    private func updateNameLabel() {
        nameLabel = transaction.counterPartyName
    }
    private func updateAmountLabel() {
        amountLabel = transaction.amount.asString(currencyCode: "EUR")
    }
    private func updateInfoLabel() {
        infoLabel = "\(transaction.description)"
    }
    private func updateDateLabel() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        dateLabel = dateFormatter.string(from: transaction.date)
    }
}
