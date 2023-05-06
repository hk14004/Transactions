//
//  TransactionBalanceCalculatorImpl.swift
//  Transactions
//
//  Created by Hardijs Ķirsis on 06/05/2023.
//

import Foundation
import DevToolsCore

class TransactionBalanceCalculatorImpl {
    
}

extension TransactionBalanceCalculatorImpl: TransactionBalanceCalculator {
    func calculateTotalCredits(transactions: [Transaction]) -> Money {
        return transactions.filter { $0.type == .credit }.reduce(0) { $0 + $1.amount }
    }
    
    func calculateTotalDebits(transactions: [Transaction]) -> Money {
        return transactions.filter { $0.type == .debit }.reduce(0) { $0 + $1.amount }
    }
    
    func calculateBalance(transactions: [Transaction]) -> Money {
        let totalCredits = calculateTotalCredits(transactions: transactions)
        let totalDebits = calculateTotalDebits(transactions: transactions)
        return totalCredits - totalDebits
    }
}
