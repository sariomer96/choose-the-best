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

    let id: Int
    let title: String?
    let image: String?
    let attachments: [Attachment]
    let category: Category
    let createdAt: String?
    let isVisible: Bool?
    let isImage: Bool?
    let averageRate: Double?

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case image
        case attachments
        case category
        case createdAt = "created_at"
        case isVisible = "is_visible"
        case isImage = "is_image"
        case averageRate = "average_rate"

    }

}

struct Attachment: Codable {

    let id: Int?
    let title: String?
    let url: String?
    let image: String?
    let score: Int?
    let createdAt: String?
    let updatedAt: String?


    enum CodingKeys: String, CodingKey {
        case id
        case title
        case url
        case image
        case score
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }

}

struct QuizRate: Codable {
    let id: Int
    let createdAt, updatedAt: String
    let quiz: QuizResponse
    let rateScore: Int

    enum CodingKeys: String, CodingKey {
        case id
        case quiz
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case rateScore = "rate_score"
    }

}

struct Category: Codable {
    let id: Int?
    let name: String?
    let createdAt: String?
    let updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }

}
