//
//  TransactionsResponse.swift
//  Transactions
//
//  Created by Hardijs Ķirsis on 06/05/2023.
//

import Foundation

struct TransactionsResponse: Codable {
    struct Transaction: Codable {
        let id: String?
        let date: String?
        let description: String?
        let amount: String?
        let type: String?
        let counterPartyAccount: String?
        let counterPartyName: String?
    }
}
