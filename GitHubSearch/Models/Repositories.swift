//
//  Repositories.swift
//  GitHubSearch
//
//  Created by Alexey Rodionov on 10/10/18.
//  Copyright © 2018 Alexey Rodionov. All rights reserved.
//

import Foundation

struct Repositories: Decodable {
    let total_count: Int
    let incomplete_results: Bool
    let items: [Repository]
}
