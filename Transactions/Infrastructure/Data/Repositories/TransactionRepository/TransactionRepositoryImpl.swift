//
//  TransactionRepositoryImpl.swift
//  Transactions
//
//  Created by Hardijs Ķirsis on 06/05/2023.
//

import Foundation
import Combine
import DevToolsCore

class TransactionRepositoryImpl {

    // MARK: Properties
    
    /// Private
    private let store: BasePersistedLayerInterface<Transaction>
    private let remoteProvider: TransactionsProvider
    private let mapper: TransactionResponseMapper
    
    // MARK: Init
    
    init(store: BasePersistedLayerInterface<Transaction>, remoteProvider: TransactionsProvider, mapper: TransactionResponseMapper) {
        self.store = store
        self.remoteProvider = remoteProvider
        self.mapper = mapper
    }
}

extension TransactionRepositoryImpl: TransactionRepository {
    func refreshTransactions() async {
        do {
            let response = try await remoteProvider.getRemoteTransactions()
            let items = mapper.map(response: response)
            await store.replace(with: items)
        } catch (let err) {
            printError(err)
        }
        
    }

    func observeTransactions() -> AnyPublisher<[Transaction], Never> {
        store.observeList(predicate: .init(value: true), sortedByKeyPath: "date", ascending: true)
    }
}
