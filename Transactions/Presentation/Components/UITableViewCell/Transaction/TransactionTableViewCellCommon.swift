//
//  TransactionTableViewCellCommon.swift
//  Transactions
//
//  Created by Hardijs Ķirsis on 06/05/2023.
//

import Foundation
import DevToolsCore

protocol TransactionTableViewCellVMProtocol: Hashable, Equatable, AnyObject {
    var id: String { get }
    var amountLabelPublisher: Published<String>.Publisher { get }
    var nameLabelPublisher: Published<String>.Publisher { get }
    var infoLabelPublisher: Published<String>.Publisher { get }
    var dateLabelPublisher: Published<String>.Publisher { get }
    var creditPublisher: Published<Bool>.Publisher { get }
    
    func onTransactionUpdated(transaction: Transaction)
}

extension TransactionTableViewCellVMProtocol {
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
}

class AnyTransactionTableViewCellVM: TransactionTableViewCellVMProtocol {
    var creditPublisher: Published<Bool>.Publisher {
        viewModel.creditPublisher
    }
    
    func onTransactionUpdated(transaction: Transaction) {
        viewModel.onTransactionUpdated(transaction: transaction)
    }
    
    var amountLabelPublisher: Published<String>.Publisher {
        viewModel.amountLabelPublisher
    }
    
    var nameLabelPublisher: Published<String>.Publisher {
        viewModel.nameLabelPublisher
    }
    
    var infoLabelPublisher: Published<String>.Publisher {
        viewModel.infoLabelPublisher
    }
    
    var dateLabelPublisher: Published<String>.Publisher {
        viewModel.dateLabelPublisher
    }
    
    var id: String {
        viewModel.id
    }
    
    private let viewModel: any TransactionTableViewCellVMProtocol
    
    init(viewModel: any TransactionTableViewCellVMProtocol) {
        self.viewModel = viewModel
    }
    
}
