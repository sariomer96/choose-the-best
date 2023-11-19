//
//  Category.swift
//  quiz
//
//  Created by Omer on 12.11.2023.
//

import Foundation
 
struct CategoryResult: Codable {
    let count: Int?
    let next: String?
    let previous: String?
    let results: [CategoryClass]?
}
struct CategoryClass: Codable {
    let id: Int
    let name: String
    let created_at: String?
    let updated_at: String?
}
