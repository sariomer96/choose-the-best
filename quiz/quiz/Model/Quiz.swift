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
   
    let id:Int
    let title: String?
    let image: String?
    let attachments: [Attachment]
    let category: Category
    let created_at: String?
    let is_visible : Bool?
    let is_image : Bool?
    let average_rate: Double?
//    enum CodingKeys: String, CodingKey {
//           case userID = "user_id"
//           case fullName = "full_name"
//           case emailAddress = "email_address"
//       }
}

struct CreateAttachmentRequestModel: Codable {
    let attachmentList: [AttachmentRequestObject]?
}

struct AttachmentRequestObject: Codable {
    let title: String?
    let imageData: Data?
    let score: String?
}

struct CreateAttachmentResponseModel: Codable {
    let attachmentIdList: [Int]?
}



/*
 "title":attachList[i].title!,
 "url":attachList[i].url!,
 "image":imageData!,
 "score":0
 */
//"title":attachList[i].title!,
//"url":attachList[i].url!,
//"image":imageData!,
//"score":0
struct AttachmentResponseModel: Codable {
    
}

struct QuestionCreateRequestModel: Codable {
    let title: String?
    let questionImage: String?
    
}

struct Attachment: Codable{
    
    let id:Int?
    let title: String?
    let url: String?
    let image : String?
    let score: Int?
    let created_at: String?
    let updated_at: String?
}

struct QuizRate :Codable{
    let id: Int
    let created_at, updated_at: String
    let quiz: QuizResponse
    let rate_score: Int
}
 

struct Category: Codable {
    let id: Int?
    let name: String?
    let created_at: String?
    let updated_at: String?
}
