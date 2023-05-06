//
//  TransactionBalanceCalculator.swift
//  Transactions
//
//  Created by Hardijs Ķirsis on 06/05/2023.
//

import Foundation
import DevToolsCore

protocol TransactionBalanceCalculator {
    func calculateTotalCredits(transactions: [Transaction]) -> Money
    func calculateTotalDebits(transactions: [Transaction]) -> Money
    func calculateBalance(transactions: [Transaction]) -> Money
}
