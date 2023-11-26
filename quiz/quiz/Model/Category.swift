//
//  Category.swift
//  quiz
//
//  Created by Omer on 12.11.2023.
//

import Foundation
 
struct CategoryResponse: Codable {
    let count: Int?
    let next: String?
    let previous: String?
    let results: [Category]?
}
