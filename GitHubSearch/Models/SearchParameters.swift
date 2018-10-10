//
//  SearchParameters.swift
//  GitHubSearch
//
//  Created by Alexey Rodionov on 10/9/18.
//  Copyright © 2018 Alexey Rodionov. All rights reserved.
//

import Foundation

enum Sort: String { // Default: results are sorted by best match.
    case stars
    case forks
    case updated
}

enum Order: String { // Default: desc
    case asc
    case desc
}

struct Page {
    var currentPage: Int
    var perPage: Int
}

struct SearchParameters {
    var qualifiers: String
    var sort: Sort?
    var order = Order.desc
    var page: Page?
    
    func make() -> [String: Any] {
        var parameters: [String: Any] = [:]
        parameters["q"] = qualifiers
        
        if let sort = sort {
            parameters["sort"] = sort.rawValue
        }
        
        if let page = page {
            parameters["page"] = page.currentPage
            parameters["per_page"] = page.perPage
        }
        
        return parameters
    }
    
}
