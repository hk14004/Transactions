//
//  DependencyProvider.swift
//  Transactions
//
//  Created by Hardijs Ķirsis on 06/05/2023.
//

import Foundation
import Swinject

let DI = DependencyProvider()

class DependencyProvider {

    let container = Container()
    let assembler: Assembler

    init() {
        assembler = Assembler(
            [
                DomainAssembly(),
                PersistentStoreAssembly(),
                DataProviderAssambly(),
                RepositoryAssembly(),
            ],
            container: container
        )
    }
}
