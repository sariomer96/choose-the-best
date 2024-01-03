//
//  EndPoint.swift
//  quiz
//
//  Created by Omer on 3.01.2024.
//

import Foundation
import UIKit
/// "http://127.0.0.1:8000/"
///
/////   let topURL = "http://127.0.0.1:8000/quizes/top-rated"
//let recentlyURL = "http://127.0.0.1:8000/quizes/?ordering=-created_at"
//let categoryURL = "http://127.0.0.1:8000/categories"
//let quizListFromCategoryURL = "http://127.0.0.1:8000/quizes?category__id="
//let createQuizURL = "http://localhost:8000/quizes/"
//let createAttachmentURL = "http://localhost:8000/attachments/"
//let rateQuizURL = "http://localhost:8000/quiz-rates/"
///   let url = "http://localhost:8000/attachments/\(attachID)/set-score/"
///
///
///
///

protocol EndPointProtocol {
    var baseURL: String {get}
    var path : String {get}
    var method: HTTPMethods {get}
    var header: [String: String]? {get}
    var parameters: [String:Any]?{get}
    func request(completion: @escaping (([String:Any])?,URL,[String : String]?)->Void)
      
    
    
}

enum HTTPMethods: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
}

enum Endpoint {
    case getTopRated
    case getRecently
    case getQuizList
    case getCategories
    case createQuiz(title:String,image:Data,categoryID: Int, isVisible: Bool,is_image:Bool, attachment_ids:[Int])
    case createAttachment
    case rateQuiz(quizID:Int,rateScore:Int)
    case getQuiz(quizID:Int)
    case setAttachmentScore(attachID:Int)
   // case setQuizScore
}

extension Endpoint: EndPointProtocol {
   
    
 
  
    var parameters: [String : Any]? {
        if case .createQuiz(let title, let image, let categoryID, let isVisible, let is_image, let attachment_ids) = self {
            return [   "title":title,
                       "attachment_ids":attachment_ids,
                       "image": image,
                       "category_id":categoryID,
                       "is_visible":isVisible,
                       "is_image":is_image
                  ]
        }
        else if case .rateQuiz(let quizID, let rateScore) = self {
          return  [
                "quiz_id":quizID,
                "rate_score":rateScore,
                 
            ]
        }
        return nil
    }
    
    var baseURL: String {
         "http://localhost:8000/"
        
    }
    
    var path: String {
        switch self{
            
        case .getTopRated:
            return "quizes/top-rated"
        case .getRecently:
            return "quizes/?ordering=-created_at"
        case .getQuizList:
            return "quizes?category__id="
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
        }
    }
    
    var method: HTTPMethods {
        switch self{
            
        case .getTopRated, .getRecently, .getQuizList, .getCategories , .getQuiz:
            return .get
        case .createQuiz, .createAttachment, .rateQuiz:
            return .post
        case .setAttachmentScore(attachID: let attachID):
            return .put
        }
    }
    
    var header: [String : String]? {
        switch self{
            
        case .getTopRated: break
            
        case .getRecently: break
            
        case .getQuizList: break
            
        case .getCategories: break
            
        case .createQuiz(title: let title, image: let image, categoryID: let categoryID, isVisible: let isVisible, is_image: let is_image, attachment_ids: let attachment_ids):
            return ["Content-Type": "multipart/form-data; boundary=\(UUID().uuidString)"]
        case .createAttachment:
            return ["Content-Type": "multipart/form-data; boundary=\(UUID().uuidString)"]
        case .rateQuiz: break
        
            
        case .getQuiz: break
            
        case .setAttachmentScore(attachID: let attachID): break
            
        }
        return nil
    }
  
    func request(completion: @escaping (([String:Any])?,URL,[String : String]?)->Void) {
        guard var components = URLComponents(string: baseURL) else {
            fatalError("URL error")
            
        }
        var url:URL? = nil
        if case .getQuiz(let quizID) = self {
             url = URL(string: "\(baseURL)\(path)\(quizID)/")
            print("set url = \(url)")
         //   components.queryItems = [URLQueryItem(name: "", value: String(quizID))]
        } else{
            
                   url = URL(string: "\(baseURL)\(path)")
        }

     
       // components.path = path
      //  var request = URLRequest(url: components.url? )
       // request.httpMethod = method.rawValue
      
 
        
//        if let header = header {
//            for (key,value) in header {
//                request.setValue(value, forHTTPHeaderField: key)
//            }
//        }
        completion(parameters,url!,header)
       
 
    }
    
    
}

