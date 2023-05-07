//
//  DomainAssembly.swift
//  Transactions
//
//  Created by Hardijs Ķirsis on 07/05/2023.
//

import Foundation
import Swinject

class DomainAssembly: Assembly {

    func assemble(container: Container) {
        
        container.register(TransactionBalanceCalculator.self) { resolver in
            TransactionBalanceCalculatorImpl()
        }
        
    }
    
}
