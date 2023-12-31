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
    let rateQuizURL = "http://localhost:8000/quiz-rates/"
    enum GetRequestTypes {
        case topRate
        case recently
        case category
        case quizList
        
    }
    
    func getQuiz(quizID:Int,completion: @escaping (QuizResponse) -> Void) {
      let url = "http://localhost:8000/quizes/\(quizID)/"
        
        AF.request(url, method: .get).response { response in
            switch response.result {
            case .success(let data):
                
                do {
                    let data = try JSONDecoder().decode(QuizResponse.self, from: data!)
                    
                    if data != nil{
                    
                      
                        completion(data)
                    }
                }catch {
                    print(error.localizedDescription)
                }
                
                
                
            case .failure(let fail):
                print(fail)
                
            }
        }
        
    }
    
    func getQuizList() {
        
        let url = "\(quizListFromCategoryURL)4"
        
        AF.request(url,method: .get).response { response in
            switch response.result {
            case .success(let data):
                do {
                    let result = try JSONDecoder().decode(ApiResponse.self, from: data!)
                    let apiRes = result as? ApiResponse
                    print(apiRes?.results)
                    
                }catch{
                    print(error.localizedDescription)
                }
               
            case .failure(let fail):
                print("fail")
            }
         
        }
    }
    func AFGetRequest<T: Decodable>(requestType:GetRequestTypes , url: String, modelResponseType: T.Type, completion: @escaping (String?) -> Void) {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        AF.request(url, method: .get).response { response in
            switch response.result {
            case .success(let data):
                do {
                  
                    let result = try decoder.decode(modelResponseType, from: data!)
                    
                     
                    let apiRes = result as? ApiResponse
                    print(requestType)
                    switch requestType{
                        
                  
                    case .topRate:
                        guard let apiRes = apiRes?.results else{return}
                            self.topQuizList = apiRes
                            completion("AAA")
                       
                    case .recently:
                        guard let apiRes = apiRes?.results else{return}
                            self.recentlyList = apiRes
                            completion("AAA")
                     
                    case .category:
                        let category = result as? CategoryResponse
                        
                        if let category = category?.results {
                            self.categoryList = category
                            completion("AAA")
                        }
                        
                    case .quizList:
                        guard let apiRes = apiRes?.results else{return}
                        print("getquizz")
                        self.quizList = apiRes
                       
                        completion("tetik1")
                        
                    
                    }
                } catch {
                    
                    completion(ErrorType.parseError.description)
                }
            case .failure(let error):
                
                completion(ErrorType.networkError.description)
            }
        }
    }
    var recentlyList = [QuizResponse]()
   // var categoryList = BehaviorSubject<[Category]>(value: [Category]())
    var categoryList = [Category]()
    var quizList =  [QuizResponse]()
    //var topQuizList = BehaviorSubject<[QuizResponse]>(value: [QuizResponse]())
    var topQuizList = [QuizResponse]()
   // var attachIdList = [Int]()
    func searchQuiz(searchText:String,categoryID:Int,completion: @escaping ([QuizResponse])->Void){
        
        let url = "http://localhost:8000/quizes/?category__id=\(categoryID)&search=\(searchText)"
        
        AF.request(url, method: .get).response { response in
            switch response.result {
            case .success(let data):
           
                do {
                    let data = try JSONDecoder().decode(ApiResponse.self, from: data!)
                    
                    if data != nil{
                   
                        self.quizList = data.results!
                        completion(self.quizList)
                    }
                }catch {
                    print(error.localizedDescription)
                }
                
                
                
            case .failure(let fail):
                print(fail)
                
            }
        }
    }
    func createAttachments(attachList:[Attachment],imageList:[UIImage],completion: @escaping (String?,Bool) -> Void) {
        
     
        var emptyArray: [[String: Any]] = []
        
        for i in stride(from: 0, to: attachList.count, by: 1) {
            
            var imageData = imageList[i].jpegData(compressionQuality: 0.5)
            if imageList[i] != nil {
                
                
                guard let data = imageData else {
                    print("Could not get JPEG representation of image")
                    return
                }
                
            }
            print(attachList[i].title)
            let parameters: [String: Any] = [
                "title":attachList[i].title!,
                "url":attachList[i].url!,
                "image":imageData!,
                "score":0
            ]
            emptyArray.append(parameters)
        }
        let arr  = emptyArray
        print("COUNT \(arr.count)")
        AF.upload(multipartFormData: { multipartFormData in
            for object in arr{
            for (key, value) in object {
                     print("sayy \(key)  \(value)")
                    if let data = value as? Data {
                        print("set image")
                        multipartFormData.append(data, withName: key, fileName: "image.jpeg", mimeType: "image/jpeg")
                    } else if let value = value as? Int {
                        print("set int")
                        let intData = Data(String(value).utf8)
                        multipartFormData.append(intData, withName: key)
                    }else if let value = value as? String {
                        print("set str")
                        let stringData = Data(value.utf8)
                        multipartFormData.append(stringData, withName: key)
                    }
                }
            }
        }, to: createAttachmentURL,method: .post,  headers:  ["Content-Type": "multipart/form-data; boundary=\(UUID().uuidString)"])
        .uploadProgress { progress in
       
            
        }
        .response{ response in
           
            switch response.result {
            case .success(let value):
                do {
                    
                    guard let value = value else { return}
                    
                    let qz = try JSONDecoder().decode([Attachment].self, from: value)
                    print(qz)
                    // completion(UploadSuccess.success.rawValue, true,qz)
                  
                }
                catch{
                    print("CREATE ERROR : \(error.localizedDescription)")
                }
                
//                for item in value{
//                    self.attachmentIdList.append(Int(item.id!))
//                }
            //    self.attachIdList = self.attachmentIdList
                print("SUCCEESSS")
                completion(UploadSuccess.success.rawValue,true)
            case .failure(let error):
                print("Error uploading image: \(error)")
                completion(FormDataError.uploadError.description, false)
            }
            
            
        }
        
    }
    
    func createAttachment(title: String, videoUrl: String,image: UIImage?,completion: @escaping (String?,Bool) -> Void) {
        
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
            "score":0
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
            //    self.attachIdList = self.attachmentIdList
                completion(UploadSuccess.success.rawValue,true)
            case .failure(let error):
                print("Error uploading image: \(error)")
                completion(FormDataError.uploadError.description, false)
            }
            
            
        }
        
    }
    func setAttachmentScore(attachID:Int,completion: @escaping (String) -> Void) {
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let url = "http://localhost:8000/attachments/\(attachID)/set-score/"
        AF.request(url, method: .put ).response { response in
            switch response.result {
            case .success(let data):
                do {
                      completion("Vote Success  \(data)")
                }
                catch {
                    
                    completion(ErrorType.parseError.description)
                }
            case .failure(let error):
                
                completion(ErrorType.networkError.description)
            }
        }
    }
    func rateQuiz(quizID:Int,rateScore:Int, completion : @escaping (String) -> Void) {
        
        let parameters: [String: Any] = [
            "quiz_id":quizID,
            "rate_score":rateScore,
            
        ]
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        AF.request(rateQuizURL, method: .post, parameters: parameters).response { response in
            switch response.result {
            case .success(let data):
                do {
                      completion("Vote Success")
                }
                catch {
                    
                    completion(ErrorType.parseError.description)
                }
            case .failure(let error):
                
                completion(ErrorType.networkError.description)
            }
        }
    }
    
func createQuiz(title: String, image: UIImage, categoryID: Int, isVisible: Bool,is_image:Bool, attachment_ids:[Int],completion: @escaping (String?,Bool,QuizResponse?) -> Void) {
    
    guard let imageData = image.jpegData(compressionQuality: 0.1) else {
        print("Could not get JPEG representation of image")
        return
    }
       print(" title  \(title) attacghid \(attachment_ids) categoryid  \(categoryID)  imageDAta \(imageData)")
    let parameters: [String: Any] = [
        "title":title,
        "attachment_ids":attachment_ids,
        "image": imageData,
        "category_id":categoryID,
        "is_visible":isVisible,
        "is_image":is_image
        
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
    }).response { response in
   // .responseDecodable(of : QuizResponse.self) { response in
        
        switch response.result {
        case .success(let quiz):
         
            do {
                
                guard let quiz = quiz else { return}
                print(quiz)
                let qz = try JSONDecoder().decode(QuizResponse.self, from: quiz)
                
                 completion(UploadSuccess.success.rawValue, true,qz)
              
            }
            catch{
                print("CREATE ERROR : \(error.localizedDescription)")
            }
            
        case .failure(let error):
            print("Error  \(error)")
            completion(FormDataError.uploadError.description,false, nil)
        }
    }
    
}
    
     
    func loadYoutubeThumbnail(url:String,title:String,completion: @escaping (Bool,UIImage?) -> Void) {
      
      
        let baseUrl = url.split(separator: "v=")[1]
 
        let id = baseUrl.split(separator: "&")
        
        let videoID = String(id[0])
         
        DispatchQueue.main.async { [self] in

        let thumbNail = URL(string: "https://img.youtube.com/vi/\(videoID)/0.jpg")!
               
           var image = UIImageView()
            
            image.kf.setImage(with: thumbNail) { [self] result in
                switch result {
                case .failure(let error):
                    print(error)
                    completion(false,nil)
                case .success(let success):
                     
                    completion(true,image.image!)
                }
            }
            
        }
    }
        
}



