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
    
    // MARK: Types
    
    class Cache {
        var loadedTransactions: [Transaction]?
    }
    
    // MARK: Properties
    
    /// Public
    @Published var sections: [TransactionsScreenSection] = []
    var sectionsPublisher: Published<[TransactionsScreenSection]>.Publisher {
        $sections
    }
    /// Private
    private let transactionsRepository: TransactionRepository
    private var bag = Set<AnyCancellable>()
    private var cache = Cache()
    private var transactionsRefreshed = false
    
    // MARK: Init
    
    init(transactionsRepository: TransactionRepository) {
        self.transactionsRepository = transactionsRepository
        startup()
    }
    
}

// MARK: TransactionsVMProtocol

extension TransactionsVM: TransactionsVMProtocol {}

// MARK: Private

extension TransactionsVM {
    private func startup() {
        observe()
        Task {
            await transactionsRepository.refreshTransactions()
        }
//        sections = [
//            .init(identifier: .balance, title: "Balance", cells: [.balance(AnyBalanceTableViewCellVM(viewModel: BalanceTableViewCellVM(balance: 533.41)))]),
//            .init(identifier: .transactionsList, title: "Transaction history", cells: [
//                .transaction(AnyTransactionTableViewCellVM(viewModel: TransactionTableViewCellVM(transaction: Transaction(id: "1", date: Date(), description: "invoice transaction at Lang, Bartell and Zemlak using card ending with ***(...9015) for PKR 894.94 in account ***74548458", amount: 123.32, type: .credit, counterPartyAccount: "VG37211Q1695809173005334", counterPartyName: "Gail Fay"))))
//            ])
//        ]
    }
    
    private func observe() {
        observeTransactions()
    }
    
    private func observeTransactions() {
        transactionsRepository.observeTransactions().removeDuplicates().sink { list in
            self.cache.loadedTransactions = list
            self.onTransactionsUpdated(list: self.cache.loadedTransactions)
        }.store(in: &bag)
    }
    
    private func onTransactionsUpdated(list: [Transaction]?) {
        func onUpdateUI() {
            let updatedSection = makeTransactionListSection(items: list)
            sections.addOrUpdate(section: updatedSection)
        }
        
        DispatchQueue.main.async {
            onUpdateUI()
        }
    }
    
    private func makeSections() -> [TransactionsScreenSection] {
        [
            makeTransactionListSection(items: cache.loadedTransactions)
        ]
    }
    
    private func makeTransactionListSection(items: [Transaction]?) -> TransactionsScreenSection {
        let cells: [TransactionsScreenSection.Cell] = {
            guard let loadedItems = items else {
                return [.loader]
            }
            if loadedItems.isEmpty {
                if transactionsRefreshed {
                    return [] // TODO: Show some kind of empty cell
                } else {
                    return [.loader]
                }
            } else {
                let loadedCells = loadedItems.map({TransactionsScreenSection.Cell.transaction(AnyTransactionTableViewCellVM(viewModel: TransactionTableViewCellVM(transaction: $0)))})
                return loadedCells
            }
            
        }()
        let section = TransactionsScreenSection(identifier: .transactionsList, title: "Transaction history", cells: cells)
        return section
    }
}
