//
//  RepositoryAssambler.swift
//  Transactions
//
//  Created by Hardijs Ķirsis on 06/05/2023.
//

import Foundation
import Swinject
import DevToolsCore
import DevToolsCoreData

class RepositoryAssembly: Assembly {

    func assemble(container: Container) {
        
        container.register(TransactionResponseMapper.self) { resolver in
            TransactionResponseMapperImpl()
        }
        
        container.register(TransactionRepository.self) { resolver in
            TransactionRepositoryImpl(store: resolver.resolve(PersistentCoreDataStore<Transaction>.self)!,
                                      remoteProvider: resolver.resolve(TransactionsProvider.self)!,
                                      mapper: resolver.resolve(TransactionResponseMapper.self)!)
        }.inObjectScope(.container)
        
    }
}
