//
//  Transaction.swift
//  Transactions
//
//  Created by Hardijs Ķirsis on 05/05/2023.
//

import Foundation
import DevToolsCore

public struct Transaction {
    public let id: String
    let date: Date
    let description: String
    let amount: Money
    let type: TransactionType
    let counterPartyAccount: String
    let counterPartyName: String
}

extension Transaction: Equatable, Hashable {}

extension Transaction {
    enum TransactionType: String {
        case debit
        case credit
    }
}

extension Transaction: PersistableDomainModelProtocol {
    public typealias StoreType = TransactionCoreData
}
