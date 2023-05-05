//
//  Common.swift
//  Transactions
//
//  Created by Hardijs Ķirsis on 05/05/2023.
//

import Foundation
import DevToolsCore

protocol BalanceTableViewCellVMProtocol: Hashable, Equatable, AnyObject {
    var id: String { get }
    var balanceLabelPublisher: Published<String>.Publisher { get }
    
    func onBalanceChanged(balance: Money)
}

extension BalanceTableViewCellVMProtocol {
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
}

class AnyBalanceTableViewCellVM: BalanceTableViewCellVMProtocol {
    var id: String {
        viewModel.id
    }
    
    var balanceLabelPublisher: Published<String>.Publisher {
        viewModel.balanceLabelPublisher
    }
    
    func onBalanceChanged(balance: DevToolsCore.Money) {
        viewModel.onBalanceChanged(balance: balance)
    }
    
    
    private let viewModel: any BalanceTableViewCellVMProtocol
    
    init(viewModel: any BalanceTableViewCellVMProtocol) {
        self.viewModel = viewModel
    }
    
}
