//
//  TransactionResponseMapper.swift
//  Transactions
//
//  Created by Hardijs Ķirsis on 06/05/2023.
//

import Foundation
import DevToolsCore

protocol TransactionResponseMapper {
    func map(response: [TransactionsResponse.Transaction]) -> [Transaction]
}

class TransactionResponseMapperImpl {
    
}

extension TransactionResponseMapperImpl: TransactionResponseMapper {
    func map(response: [TransactionsResponse.Transaction]) -> [Transaction] {
        // TODO: Handle data issues, throw errors or skip data
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let items: [Transaction] = response.map { apiTransaction in
            let date = formatter.date(from: apiTransaction.date ?? "")
            let amount: NSDecimalNumber = NSDecimalNumber(string: apiTransaction.amount)
            return .init(id: apiTransaction.id ?? "", date: date ?? Date(), description: apiTransaction.description ?? "",
                         amount: amount as Money, type: Transaction.TransactionType(rawValue: apiTransaction.type ?? "") ?? .credit,
                         counterPartyAccount: apiTransaction.counterPartyAccount ?? "",
                         counterPartyName: apiTransaction.counterPartyName ?? "")
        }
        
        return items
    }
}
