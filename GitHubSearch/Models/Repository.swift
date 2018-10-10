//
//  Repository.swift
//  GitHubSearch
//
//  Created by Alexey Rodionov on 10/10/18.
//  Copyright © 2018 Alexey Rodionov. All rights reserved.
//

import Foundation

struct Repository: Decodable {
    let id: Int?
    let name: String?
    let full_name: String?
    let html_url: String?
    let description: String?
    let url: String?
    let stargazers_count: Int?
    let language: String?
    let updated_at: String?
}
