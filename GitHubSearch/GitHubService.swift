//
//  GitHubService.swift
//  GitHubSearch
//
//  Created by Alexey Rodionov on 10/9/18.
//  Copyright © 2018 Alexey Rodionov. All rights reserved.
//

import Foundation
import Moya

enum GitHubService {
    case repositorySearch(parameters: [String: Any])
}

extension GitHubService: TargetType {
    var baseURL: URL {
        guard let url = URL(string: "https://api.github.com") else { fatalError("baseURL could not be configured") }
        return url
    }
    
    var path: String {
        switch self {
        case .repositorySearch(_):
            return "search/repositories"
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var sampleData: Data {
        return Data() // Fix to make Unit tests
    }
    
    var task: Task {
        switch self {
        case .repositorySearch(let parameters):
            return .requestParameters(parameters: parameters , encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
    
}
