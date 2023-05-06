//
//  TransactionsVM.swift
//  Transactions
//
//  Created by Hardijs Ķirsis on 05/05/2023.
//

import Combine
import DevToolsCore
import Foundation

class TransactionsVM: ObservableObject {
    
    // MARK: Properties
    
    /// Public
    @Published var sections: [TransactionsScreenSection] = []
    var sectionsPublisher: Published<[TransactionsScreenSection]>.Publisher {
        $sections
    }
    
    // MARK: Init
    
    init() {
        startup()
    }
}

// MARK: TransactionsVMProtocol

extension TransactionsVM: TransactionsVMProtocol {}

// MARK: Private

extension TransactionsVM {
    private func startup() {
        sections = [
            .init(identifier: .balance, title: "Balance", cells: [.balance(AnyBalanceTableViewCellVM(viewModel: BalanceTableViewCellVM(balance: 533.41)))]),
            .init(identifier: .transactionsList, title: "Transaction history", cells: [
                .transaction(AnyTransactionTableViewCellVM(viewModel: TransactionTableViewCellVM(transaction: Transaction(id: "1", date: Date(), description: "invoice transaction at Lang, Bartell and Zemlak using card ending with ***(...9015) for PKR 894.94 in account ***74548458", amount: 123.32, type: .credit, counterPartyAccount: "VG37211Q1695809173005334", counterPartyName: "Gail Fay"))))
            ])
        ]
    }
}
