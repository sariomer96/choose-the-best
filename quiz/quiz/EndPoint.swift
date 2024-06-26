//
//  EndPoint.swift
//  quiz
//
//  Created by Omer on 3.01.2024.
//

import Foundation
import UIKit

protocol EndPointProtocol {
    var baseURL: String {get}
    var path: String {get}
    var method: HTTPMethods {get}
    var header: [String: String]? {get}
    var parameters: [String: Any]? {get}
    func request(completion: @escaping (([String: Any])?, URL, [String: String]?) -> Void)
}

enum HTTPMethods: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}

enum Endpoint {
    case getTopRated(page: Int, count: Int)
    case getRecently(page: Int, count: Int)
    case getQuizList(categoryID: Int, page: Int, count: Int)
    case getCategories
    case createQuiz(title: String, image: Data, categoryID: Int, isVisible: Bool, isImage: Bool, attachmentIds: [Int])
    case createAttachment(title: String, videoUrl: String, imageData: Data)
    case rateQuiz(quizID: Int, rateScore: Int)
    case getQuiz(quizID: Int)
    case setAttachmentScore(attachID: Int)
    case searchQuiz(searchText: String, categoryID: Int)
    case updateAttachment(titles: [String], ids: [Int])
    case deleteAttachment(attachmentID: Int)
   // case setQuizScore
}

extension Endpoint: EndPointProtocol {

    var parameters: [String: Any]? {
        if case .createQuiz(let title, let image, let categoryID,
                            let isVisible,
                            let isImage,
                            let attachmentIds) = self {
            return [   "title": title,
                       "attachment_ids": attachmentIds,
                       "image": image,
                       "category_id": categoryID,
                       "is_visible": isVisible,
                       "is_image": isImage
                  ]
        } else if case .rateQuiz(let quizID, let rateScore) = self {
          return  [
                "quiz_id": quizID,
                "rate_score": rateScore
            ]
        } else if case .createAttachment(let title, let videoUrl, let imageData) = self {
            return   [
                "title": title,
                "url": videoUrl,
                "image": imageData,
                "score": 0
            ]
        } else if case .updateAttachment(let titles, let ids) = self {

            return   [
                "titles": titles,
                "ids": ids

            ]
        }
        return nil
    }

    var baseURL: String {
         "https://www.choosethebest.xyz/"

    }

    var path: String {
        switch self {

        case .getTopRated(page: let page, count: let pageSize):
            return "quizes/top-rated?page_size=\(pageSize)&page=\(page)"
        case .getRecently(page: let page, count: let pageSize):
            return "quizes/?ordering=-created_at&page_size=\(pageSize)&page=\(page)"
        case .getQuizList(categoryID: let categoryID, page: let page, count: let pageSize):
            return "quizes?category__id=\(categoryID)&page_size=\(pageSize)&page=\(page)"
        case .getCategories:
            return "categories"
        case .createQuiz:
            return "quizes/"
        case .createAttachment:
            return "attachments/"
        case .rateQuiz:
            return "quiz-rates/"

        case .getQuiz:
            return "quizes/"
        case .setAttachmentScore(attachID: let attachID):
            return "attachments/\(attachID)/set-score/"
        case .searchQuiz(searchText: let searchText, categoryID: let categoryID):

            return "quizes/?category__id=\(categoryID)&search=\(searchText)"

        case .updateAttachment:
            return "attachments/update-titles/"
        case .deleteAttachment(attachmentID: let attachmentID):
            return "attachments/\(attachmentID)/"
        }
    }

    var method: HTTPMethods {
        switch self {

        case .getTopRated, .getRecently, .getQuizList, .getCategories, .getQuiz, .searchQuiz:
            return .get
        case .createQuiz, .createAttachment, .rateQuiz:
            return .post
        case .setAttachmentScore:
            return .put
        case .updateAttachment:
            return .patch
        case .deleteAttachment(attachmentID: let attachmentID):
            return .delete
        }

    }

    var header: [String: String]? {
        switch self {

        case .getTopRated: break

        case .getRecently: break

        case .getQuizList: break

        case .getCategories: break

        case .createQuiz(title: let title, image: let image, categoryID: let categoryID,
                         isVisible: let isVisible,
                         isImage: let isImage,
                         attachmentIds: let attachmentIds):
            return ["Content-Type": "multipart/form-data; boundary=\(UUID().uuidString)"]
        case .createAttachment:
            return ["Content-Type": "multipart/form-data; boundary=\(UUID().uuidString)"]
        case .rateQuiz: break

        case .getQuiz: break

        case .setAttachmentScore(attachID: let attachID): break

        case .searchQuiz(searchText: let searchText, categoryID: let categoryID): break

        case .updateAttachment:
            break
        case .deleteAttachment(attachmentID: let attachmentID):
            break
        }
        return nil
    }

    func request(completion: @escaping (([String: Any])?, URL, [String: String]?) -> Void) {
        guard var components = URLComponents(string: baseURL) else {
            fatalError("URL error")

        }
        var url: URL?
        if case .getQuiz(let quizID) = self {
             url = URL(string: "\(baseURL)\(path)\(quizID)/")

        } else {
           url = URL(string: "\(baseURL)\(path)")
        }
        guard let url = url else {return}

        completion(parameters, url, header)
    }
}
