//
//  TransactionsProvider.swift
//  Transactions
//
//  Created by Hardijs Ķirsis on 06/05/2023.
//

import Foundation

enum TransactionsProviderError: Swift.Error {
    
    case alreadyRunningRequest
    case responseDecodeIssue
    case fetchFailed(code: Int)
    case userError(description: String)
    
}


protocol TransactionsProvider {
    func getRemoteTransactions() async throws -> [TransactionsResponse.Transaction]
}
