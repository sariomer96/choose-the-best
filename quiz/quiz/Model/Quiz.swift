//
//  test.swift
//  quiz
//
//  Created by Omer on 10.11.2023.
//

import Foundation
 
struct ApiResponse: Codable {
    let count: Int?
    let next: String?
    let previous: String?
    let results: [QuizResponse]?
}

struct QuizResponse: Codable {
   
    let title: String?
    let image: String?
    let attachments: [Attachment]
    let category: Category
    let created_at: String?
    let is_visible : Bool?
    let is_image : Bool?
    
    
    let average_rate: Double?
}

class Attachment: Codable{
    
    let id:Int?
    let title: String?
    let url: String?
    let image : String?
    let score: Int?
    let created_at: String?
    let updated_at: String?
}
extension Attachment: Equatable {
    static func == (lhs: Attachment, rhs: Attachment) -> Bool {
        return true
    }
    
   
}

struct Category: Codable {
    let id: Int?
    let name: String?
    let created_at: String?
    let updated_at: String?
}
