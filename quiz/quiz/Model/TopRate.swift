//
//  TopRate.swift
//  quiz
//
//  Created by Omer on 17.11.2023.
//

import Foundation


// MARK: - Welcome3
struct TopRate:Codable {
    let results: [TopRateResult]
}

// MARK: - Result
struct TopRateResult:Codable {
       let id: Int
       let title: String?
       let attachments: [Attachment?]
       let image: String
       let category: Category?
       let created_at: String?
       let is_visible: Bool?
       let average_rate: Double?
}

// MARK: - Quiz
 


