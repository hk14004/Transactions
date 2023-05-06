//
//  BalanceTableViewCellVM.swift
//  Transactions
//
//  Created by Hardijs Ķirsis on 05/05/2023.
//

import Foundation
import Combine
import DevToolsCore

class BalanceTableViewCellVM {
    
    // MARK: Properties
    
    /// Public
    var id: String = UUID().uuidString
    @Published var balanceLabel: String = ""
    var balanceLabelPublisher: Published<String>.Publisher {
        $balanceLabel
    }
    /// Private
    private let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "EUR"
        return formatter
    }()
    
    private var balance: Money
    
    // MARK: Init
    
    init(balance: Money) {
        self.balance = balance
        startup()
    }
}

// MARK: BalanceTableViewCellVMProtocol

extension BalanceTableViewCellVM: BalanceTableViewCellVMProtocol {
    func onBalanceChanged(balance: Money) {
        balanceLabel = makeBalanceString(balance: balance)
    }
}

// MARK: Private

extension BalanceTableViewCellVM {
    private func startup() {
        balanceLabel = makeBalanceString(balance: balance)
    }
    
    private func makeBalanceString(balance: Money) -> String {
        numberFormatter.string(from: balance as NSNumber) ?? ""
    }
}
