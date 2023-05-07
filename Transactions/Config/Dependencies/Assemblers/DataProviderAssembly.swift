//
//  DataProviderAssambler.swift
//  Transactions
//
//  Created by Hardijs Ķirsis on 06/05/2023.
//

import Foundation
import Swinject
import Moya
import DevToolsNetworking

class DataProviderAssambly: Assembly {
    
    func assemble(container: Container) {
        container.register(MoyaProvider<BackendTarget>.self) { resolver in
            MoyaProvider()
        }
        
        container.register(RequestManager<BackendTarget>.self) { resolver in
            RequestManager()
        }
        
        container.register(TransactionsProvider.self) { resolver in
            TransactionsProviderImpl(provider: resolver.resolve(MoyaProvider<BackendTarget>.self)!,
                                     requestManager: resolver.resolve(RequestManager<BackendTarget>.self)!)
            
        }
    }
    
}
