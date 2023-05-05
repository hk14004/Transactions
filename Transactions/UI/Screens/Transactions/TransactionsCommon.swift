//
//  TransactionsScreen.swift
//  Transactions
//
//  Created by Hardijs Ķirsis on 05/05/2023.
//

import Foundation
import DevToolsCore
import DevToolsUI

protocol TransactionsVMProtocol {
    var sections: [TransactionsScreenSection] { get }
    var sectionsPublisher: Published<[TransactionsScreenSection]>.Publisher { get }
}

class TransactionsScreenSection: UISectionModelProtocol {
    
    // MARK: Types
    
    enum Identifiers: String, CaseIterable {
        case balance
        case transactionsList
    }
    
    enum Cell: Hashable {
        case balance(AnyBalanceTableViewCellVM)
        case transaction(Transaction)
    }
    
    // MARK: Properties
    
    let identifier: Identifiers
    var title: String
    var cells: [Cell]
    
    // MARK: Init
    
    init(identifier: Identifiers, title: String, cells: [Cell]) {
        self.identifier = identifier
        self.title = title
        self.cells = cells
    }
}
