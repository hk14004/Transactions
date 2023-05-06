//
//  Transaction.swift
//  Transactions
//
//  Created by Hardijs Ķirsis on 05/05/2023.
//

import Foundation
import DevToolsCore

struct Transaction {
    let id: String
    let date: Date
    let description: String
    let amount: Money
    let type: TransactionType
    let counterPartyAccount: String
    let counterPartyName: String
}

extension Transaction: Equatable, Hashable {}

extension Transaction {
    enum TransactionType {
        case debit
        case credit
    }
}
