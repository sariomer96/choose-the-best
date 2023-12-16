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
    
    var attachmentIdList = [Int]()
    static let shared = WebService()
    let topURL = "http://127.0.0.1:8000/quizes/top-rated"
    let recentlyURL = "http://127.0.0.1:8000/quizes/?ordering=-created_at"
    let categoryURL = "http://127.0.0.1:8000/categories"
    let quizListFromCategoryURL = "http://127.0.0.1:8000/quizes?category__id="
    let createQuizURL = "http://localhost:8000/quizes/"
    let createAttachmentURL = "http://localhost:8000/attachments/"
    
    enum GetRequestTypes {
        case topRate
        case recently
        case category
        case quizList
        
    }
    func AFGetRequest<T: Decodable>(requestType:GetRequestTypes , url: String, modelResponseType: T.Type, completion: @escaping (String?) -> Void) {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        AF.request(url, method: .get).response { response in
            switch response.result {
            case .success(let data):
                do {
                    completion("SUCCESS")
                    let result = try decoder.decode(modelResponseType, from: data!)
                    
                    let apiRes = result as? ApiResponse
                    switch requestType{
                        
                    case .topRate:
                        if let list = apiRes?.results {
                            self.topQuizList.onNext(list)
                        }
                    case .recently:
                        if let list = apiRes?.results {
                            self.recentlyList.onNext(list)
                        }
                    case .category:
                        let category = result as? CategoryResponse
                        
                        if let category = category?.results {
                            self.categoryList.onNext(category)
                        }
                        
                    case .quizList:
                        if let quizList = apiRes?.results {
                            self.quizList.onNext(quizList)
                        }
                        
                        
                    }
                } catch {
                  
                    completion(ErrorType.parseError.description)
                }
            case .failure(let error):
               
                completion(ErrorType.networkError.description)
            }
        }
    }
    var recentlyList = BehaviorSubject<[QuizResponse]>(value: [QuizResponse]())
    var categoryList = BehaviorSubject<[Category]>(value: [Category]())
    var quizList = BehaviorSubject<[QuizResponse]>(value: [QuizResponse]())
    var topQuizList = BehaviorSubject<[QuizResponse]>(value: [QuizResponse]())
    var attachIdList = BehaviorSubject<[Int]>(value: [Int]())
    func searchQuiz(searchText:String,completion: @escaping (String) -> Void){
        
        let url = "http://127.0.0.1:8000/categories/search?=fed"
        AF.request(url, method: .get).response { response in
            switch response.result {
            case .success(let data):
                print(data)
                
            case .failure(let fail):
                print(fail)
                
            }
        }
    }
    
    
    func createAttachment(title: String, videoUrl: String,image: UIImage?, score : Int,completion: @escaping (String?,Bool) -> Void) {
        
        var imageData = image?.jpegData(compressionQuality: 0.5)
        if image != nil {
            
            
            guard let data = imageData else {
                print("Could not get JPEG representation of image")
                return
            }
        
        }
         
        let parameters: [String: Any] = [
            "title":title,
            "url":videoUrl,
            "image":imageData,
            "score":score
        ]
        
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
                }
            }
        }, to: createAttachmentURL,method: .post,  headers:  ["Content-Type": "multipart/form-data; boundary=\(UUID().uuidString)"])
        .uploadProgress { progress in
             print(progress.fractionCompleted)
                   
                }
        .responseDecodable(of: Attachment.self){ response in
            switch response.result {
            case .success(let value):
                
                self.attachmentIdList.append(Int(value.id!))
                self.attachIdList.onNext(self.attachmentIdList)
                completion(UploadSuccess.success.rawValue,true)
            case .failure(let error):
                print("Error uploading image: \(error)")
                completion(FormDataError.uploadError.description, false)
            }
            
            
        }
        
    }
    
    func createQuiz(title: String, image: UIImage, categoryID: Int, isVisible: Bool,is_image:Bool, attachment_ids:[Int],completion: @escaping (String?,Bool,QuizResponse?) -> Void) {
        
        guard let imageData = image.jpegData(compressionQuality: 0.1) else {
            print("Could not get JPEG representation of image")
            return
        }
        print("-----\(imageData.description)-----")
        let parameters: [String: Any] = [
            "title":title,
            "attachment_ids":attachment_ids,
            "image": imageData,
            "category_id":categoryID,
            "is_visible":isVisible,
          //  "is_image":is_image
            
        ]
        
        AF.upload(multipartFormData: { multipartFormData in
            for (key, value) in parameters {
                if let data = value as? Data {
                    multipartFormData.append(data, withName: key, fileName: "image.jpeg", mimeType: "image/jpeg")
                    
                }else  if let intArray = value as? [Int] {
                  for intValue in intArray {
                    let intData = Data(String(intValue).utf8)
                 
                    multipartFormData.append(intData, withName: key )
                   }
                }
                else if let value = value as? Int {
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
        }, to: createQuizURL,method: .post, headers:  ["Content-Type": "multipart/form-data; boundary=\(UUID().uuidString)"])
        .uploadProgress(closure: { progress in
            print(progress.description)
        })
        .responseDecodable(of : QuizResponse.self) { response in
       
            switch response.result {
            case .success(let quiz):
                 
                                     
                completion(UploadSuccess.success.rawValue, true,quiz)
            case .failure(let error):
                print("Error uploading image: \(error)")
                completion(FormDataError.uploadError.description,false, nil)
            }
        }
        
    }
    
}


