//
//  NetworkManager.swift
//  GitHubSearch
//
//  Created by Alexey Rodionov on 10/10/18.
//  Copyright © 2018 Alexey Rodionov. All rights reserved.
//

import Foundation
import Moya

struct NetworkManager {
    var provider = MoyaProvider<GitHubService>(plugins: [NetworkLoggerPlugin(verbose: true)])
    
    func getRepositories(parameters: [String: Any], completion: @escaping (Repositories?, String?) -> ()) {
        provider.request(.repositorySearch(parameters: parameters)) { (result) in
            switch result {
            case .success(let response):
                do {
                    let result = try JSONDecoder().decode(Repositories.self, from: response.data)
                    completion(result, nil)
                } catch let error {
                    completion(nil, error.localizedDescription)
                }
                
            case .failure(let error):
                completion(nil, error.localizedDescription)
            }
        }
    }
}
