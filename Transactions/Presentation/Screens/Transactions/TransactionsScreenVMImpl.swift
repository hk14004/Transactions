//
//  TransactionsVM.swift
//  Transactions
//
//  Created by Hardijs Ķirsis on 05/05/2023.
//

import Combine
import DevToolsCore
import Foundation

class TransactionsScreenVMImpl: TransactionsScreenVM {
    
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
    private let balanceCalculator: TransactionBalanceCalculator
    
    // MARK: Init
    
    init(transactionsRepository: TransactionRepository, balanceCalculator: TransactionBalanceCalculator) {
        self.transactionsRepository = transactionsRepository
        self.balanceCalculator = balanceCalculator
        startup()
    }
    
    deinit {
        print(":)")
    }
}

// MARK: Private

extension TransactionsScreenVMImpl {
    private func startup() {
        // TODO: Optionally load data in sync for faster display
        Task {
            sections = makeSections()
            observe()
            await refreshRemoteData()
        }
    }
        
    private func observe() {
        observeTransactions()
    }
    
    private func observeTransactions() {
        transactionsRepository.observeTransactions().removeDuplicates().sink { [weak self] list in
            guard let self = self else { return }
            self.cache.loadedTransactions = list
            self.onRenderTransactions(list: self.cache.loadedTransactions)
        }.store(in: &bag)
    }
    
    private func onRenderTransactions(list: [Transaction]?) {
        func onUpdateUI() {
            // Update balance section
            let balanceSection = makeBalanceSection(items: list)
            sections.addOrUpdate(section: balanceSection)
            
            // Update transaction list section
            let transactionListSection = makeTransactionListSection(items: list)
            sections.addOrUpdate(section: transactionListSection)
        }
        
        DispatchQueue.main.async {
            onUpdateUI()
        }
    }
    
    private func makeSections() -> [TransactionsScreenSection] {
        [
            makeBalanceSection(items: cache.loadedTransactions),
            makeTransactionListSection(items: cache.loadedTransactions)
        ]
    }
    
    private func makeTransactionListSection(items: [Transaction]?) -> TransactionsScreenSection {
        let cells: [TransactionsScreenSection.Cell] = {
            guard let loadedItems = items else {
                return [.loadingTransactions]
            }
            if loadedItems.isEmpty {
                if transactionsRefreshed {
                    return [] // TODO: Show some kind of empty cell
                } else {
                    return [.loadingTransactions]
                }
            } else {
                let loadedCells = loadedItems.map({TransactionsScreenSection.Cell.transaction(AnyTransactionTableViewCellVM(viewModel: TransactionTableViewCellVM(transaction: $0)))})
                return loadedCells
            }
            
        }()
        let section = TransactionsScreenSection(identifier: .transactionsList, title: "Transaction history", cells: cells)
        return section
    }
    
    private func makeBalanceSection(items: [Transaction]?) -> TransactionsScreenSection {
        let cells: [TransactionsScreenSection.Cell] = {
            guard let loadedItems = items else {
                return [.loadingBalance]
            }
            if loadedItems.isEmpty {
                if transactionsRefreshed {
                    return [] // TODO: Show some kind of empty cell
                } else {
                    return [.loadingBalance]
                }
            } else {
                let calculated = balanceCalculator.calculateBalance(transactions: items ?? [])
                return [
                    .balance(AnyBalanceTableViewCellVM(viewModel: BalanceTableViewCellVM(balance: calculated)))
                ]
            }
            
        }()
        let section = TransactionsScreenSection(identifier: .balance, title: "Balance", cells: cells)
        return section
    }
    
    private func refreshRemoteData() async {
        // TODO: Optionally throw error
        await transactionsRepository.refreshTransactions()
        transactionsRefreshed = true
    }
}
