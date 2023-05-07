//
//  TransactionsProviderImp.swift
//  Transactions
//
//  Created by Hardijs Ķirsis on 06/05/2023.
//

import Foundation
import DevToolsNetworking
import Moya

class TransactionsProviderImpl {
    
    // MARK: Properties
    
    // Private
    private let provider: MoyaProvider<BackendTarget>
    private let requestManager: RequestManager<BackendTarget>
    
    // MARK: Init
    
    init(provider: MoyaProvider<BackendTarget>, requestManager: RequestManager<BackendTarget>) {
        self.provider = provider
        self.requestManager = requestManager
    }
    
}

extension TransactionsProviderImpl: TransactionsProvider {
    func getRemoteTransactions() async throws -> [TransactionsResponse.Transaction] {
        try await withCheckedThrowingContinuation { cont in
            let target = BackendTarget(endpoint: .getTransactions)
            let launched = requestManager.launchSingleUniqueRequest(requestID: target.defaultUUID, target: target,
                                                                    provider: provider, hookRunning: true,
                                                                    retryMethod: .default) { result in
                DispatchQueue.global().async {
                    switch result {
                    case .success(let response):
                        do {
                            let response = try JSONDecoder().decode([TransactionsResponse.Transaction].self, from: response.data)
                            cont.resume(with: .success(response))
                        } catch (let decodeError) {
                            print(decodeError)
                            cont.resume(with: .failure(TransactionsProviderError.responseDecodeIssue))
                        }
                    case .failure(let err):
                        cont.resume(with: .failure(TransactionsProviderError.fetchFailed(code: err.errorCode)))
                    }
                }
            }
            
            if !launched {
                cont.resume(with: .failure(TransactionsProviderError.alreadyRunningRequest))
            }
        }
        
    }
}
