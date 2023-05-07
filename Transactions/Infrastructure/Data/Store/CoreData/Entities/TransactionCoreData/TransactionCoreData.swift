//
//  TransactionCoreData.swift
//  Transactions
//
//  Created by Hardijs Ķirsis on 06/05/2023.
//

import Foundation
import DevToolsCore
import DevToolsCoreData

extension TransactionCoreData: PersistedModelProtocol {

    public enum PersistedField: String, PersistedModelFieldProtocol {
        case date
        case description
        case amount
        case type
        case counterPartyAccount
        case counterPartyName
    }

    public func toDomain(fields: Set<PersistedField>) throws -> Transaction {
        // TODO: Throw errors
        return .init(id: id ?? "", date: date ?? Date(), description: desc ?? "", amount: amount! as Money,
                     type: .init(rawValue: self.type ?? "") ?? .credit, counterPartyAccount: counterPartyAccount ?? "",
                     counterPartyName: counterPartyName ?? "")
    }

    public func update(with model: Transaction, fields: Set<PersistedField>) {
        self.id = model.id
        self.date = model.date
        self.desc = model.description
        self.amount = (model.amount) as NSDecimalNumber
        self.type = model.type.rawValue
        self.counterPartyAccount = model.counterPartyAccount
        self.counterPartyName = model.counterPartyName
    }
}
