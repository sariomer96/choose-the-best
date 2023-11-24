//
//  WebService.swift
//  quiz
//
//  Created by Omer on 9.11.2023.
//

import Foundation
import Alamofire
import RxSwift
import UIKit

// MARK: ENUMS  --------------
enum ErrorType: Error{
    case networkError
    case parseError
}
extension ErrorType {
    public var description: String {
           switch self {
           case .networkError:
               return "Network error."
           case .parseError:
               return "Response failed."
           }
       }
}
enum FormDataError:Error {
    case uploadError
}

extension FormDataError {
    public var description: String {
           switch self {
           case .uploadError:
               return "Upload failed."
      
   
           }
       }
}
enum UploadSuccess : String {
    case success = " Upload succesful"
}
// MARK: ENUMS END -------------------


class WebService {
    
    static let shared = WebService()
    let topURL = "http://127.0.0.1:8000/quizes/top-rated"
    let recentlyURL = "http://127.0.0.1:8000/quizes/?ordering=-created_at"
    let categoryURL = "http://127.0.0.1:8000/categories"
    let quizListFromCategoryURL = "http://127.0.0.1:8000/quizes?category__id="

    func AFGetRequest<T: Decodable>(url: String, modelResponseType: T.Type, completion: @escaping (String?) -> Void) {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601

            AF.request(url, method: .get).response { response in
                switch response.result {
                case .success(let data):
                    do {
                        let result = try decoder.decode(modelResponseType, from: data!)
                    
                         let apiRes = result as? ApiResponse
                        
                        if let list = apiRes?.results {
                            self.quizList.onNext(list)
                        }
                        
                        let topRate = result as? TopRate
                        
                        if let topRate = topRate?.results {
                             
                            if url == self.topURL {
                                self.topQuizList.onNext(topRate)
                            }else{
                                self.recentlyList.onNext(topRate)
                            }
                        }
                        
                        let category = result as? CategoryResult
                        
                        if let category = category?.results {
                            self.categoryList.onNext(category)
                        }
                        
                    } catch {
                        print("\(error.localizedDescription) III")
                        completion(ErrorType.parseError.description)
                    }
                case .failure(let error):
                    print("\(error.localizedDescription) III")
                    completion(ErrorType.networkError.description)
                }
            }
        }
    var recentlyList = BehaviorSubject<[TopRateResult]>(value: [TopRateResult]())
    
    func getRecentlyUploads (completion: @escaping (String?) -> Void) {
        
        AFGetRequest(url: recentlyURL, modelResponseType: TopRate.self) { error in
            
        }
   }
    var categoryList = BehaviorSubject<[CategoryClass]>(value: [CategoryClass]())
    
    func getCategories(completion: @escaping (String?) -> Void)  {
        
        AFGetRequest(url: categoryURL, modelResponseType: CategoryResult.self) { error in
            
        }
}
    var quizList = BehaviorSubject<[QuizResponse]>(value: [QuizResponse]())
    
    func getQuizListFromCategory(categoryId:Int, completion: @escaping (String?) -> Void) {
        AFGetRequest(url: "\(quizListFromCategoryURL)\(categoryId)", modelResponseType: ApiResponse.self) { error in
            
        }

    }
    var topQuizList = BehaviorSubject<[TopRateResult]>(value: [TopRateResult]())
    
    func getTopRateQuiz(completion: @escaping (String?) -> Void) {
        AFGetRequest(url:topURL , modelResponseType: TopRate.self) { error in
        
        }
    }
    
    func searchQuiz(searchText:String,completion: @escaping (String) -> Void){
        
    }

    func createQuiz(title: String, image: UIImage, categoryID: Int, isVisible: Bool,completion: @escaping (String?,Bool) -> Void) {
      
        let url = "http://localhost:8000/quizes/"
        
        guard let imageData = image.jpegData(compressionQuality: 0.5) else {
            print("Could not get JPEG representation of image")
            return
        }
      
        let parameters: [String: Any] = [
            "title": title,
            "image": imageData,
            "category_id": categoryID,
            "is_visible": isVisible
        ]
        
        print("Request URL: \(url)")
        print("Parameters: \(parameters)")
        
        // Alamofire ile POST isteği gönderme
        AF.upload(multipartFormData: { multipartFormData in
            for (key, value) in parameters {
                if let data = value as? Data {
                    multipartFormData.append(data, withName: key, fileName: "image.jpeg", mimeType: "image/jpeg")
                    
                } else if let value = value as? Int {
                    let intData = Data(String(value).utf8)
                    multipartFormData.append(intData, withName: key)
               
                }else if let value = value as? String {
                    let stringData = Data(value.utf8)
                    multipartFormData.append(stringData, withName: key)
                }else if let value = value as? Bool {
                    let boolData = Data("\(value)".utf8)
                    multipartFormData.append(boolData, withName: key)
                }

            }
        }, to: url,method: .post, headers:  ["Content-Type": "multipart/form-data; boundary=\(UUID().uuidString)"])
        .response { response in
            switch response.result {
            case .success(let data):
                print("Upload successful: \(data)")
               
                completion(UploadSuccess.success.rawValue, true)
            case .failure(let error):
                print("Error uploading image: \(error)")
                completion(FormDataError.uploadError.description,false)
            }
        }
    }
}

