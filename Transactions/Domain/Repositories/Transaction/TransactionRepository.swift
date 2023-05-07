//
//  TransactionRepository.swift
//  Transactions
//
//  Created by Hardijs Ķirsis on 06/05/2023.
//

import Foundation
import Combine

protocol TransactionRepository {
    // Remote data
    func refreshTransactions() async
    
    // Local data
    func observeTransactions() -> AnyPublisher<[Transaction], Never>
}
