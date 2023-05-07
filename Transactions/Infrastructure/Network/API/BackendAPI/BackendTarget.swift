//
//  BackendTarget.swift
//  Transactions
//
//  Created by Hardijs Ķirsis on 06/05/2023.
//

import Foundation
import DevToolsNetworking
import Moya

struct BackendTarget: RequestManagerTarget {
    
    enum Endpoint: String, CaseIterable {
        case getTransactions
    }
    
    var endpoint: Endpoint
        
    var defaultUUID: String {
        endpoint.rawValue
    }
    
    var resourceIDs: [String]?
    
    var urlParameters: [String : Any]?
    
    var bodyParameters: [String : Any]?
    
    var headerParameter: [String : String]?
    
    var baseURL: URL {
        return URL(string: Hosts.BACKEND)!
    }
    
    var path: String {
        switch endpoint {
        case .getTransactions:
            return "/transactions"
        }
    }
    
    var method: Moya.Method {
        switch endpoint {
        case .getTransactions:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self.method {
        case .get:
            if let urlParameters = urlParameters {
                return .requestParameters(parameters: urlParameters, encoding: URLEncoding.queryString)
            }
        default:
            if let bodyParameters = bodyParameters {
                return .requestParameters(parameters: bodyParameters, encoding: JSONEncoding.default)
            }
        }
        
        return .requestPlain
    }
    
    var headers: [String : String]?
    
}
