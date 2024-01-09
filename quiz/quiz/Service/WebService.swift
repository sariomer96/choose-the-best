import Foundation
import Alamofire
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
    var currentRecentlyQuestionPageCount = 0
    var currentTopRatedQuestionPageCount = 0

    private init(){}
    func request<T: Codable>(endpoint:Endpoint,completion:@escaping (Result<T,Error>) ->Void) {
         
        let method =   endpoint.method
       let  alamofireMethod = Alamofire.HTTPMethod(rawValue: method.rawValue)
   
       endpoint.request { params, url,header in
           
           print("REQUIEST \(url)")
           AF.request(url,method: alamofireMethod, parameters: params).response { response in
                switch response.result {
                case .success(let data):
                    do {
                        print(T.self)
                        let result = try JSONDecoder().decode(T.self, from: data!)
                        completion(.success(result))
                        
                        
                    }catch{
                        print("DECODE ERROR \(error.localizedDescription)")
                    }
                    
                case .failure(let fail):
                    completion(.failure(fail))
                }
                
            }
        }
        
   }
    var header:[String:String]? = nil
    func upload<T: Codable>(endpoint:Endpoint,completion:@escaping (Result<T,Error>) ->Void){
        
        var arr = [String:Any]()
        var urlLast:URL? = nil
   
      var req =   endpoint.request { params, url, header in
         
            urlLast = url
            arr = params!
          self.header = header
        }
         AF.upload(multipartFormData: { multipartFormData in
             for (key, value) in  arr{
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
         }, to: urlLast!,method: .post ,  headers: HTTPHeaders(self.header!))
        
         .response {  resp in
             
             switch resp.result {
                 
             case .success(let success):
                 do{
           
                     let object = try JSONDecoder().decode(T.self, from: success!)
                     
                     completion(.success(object))
                 }catch{
                      print("error json decode")
                 }
             case .failure(let fail):
                 completion(.failure(fail))
             }
         }
    }
    
    func postQuiz(title: String, image: UIImage, categoryID: Int, isVisible: Bool,is_image:Bool, attachment_ids:[Int],completion: @escaping (Result<QuizResponse,Error>) -> Void){
        
        let imageData = image.jpegData(compressionQuality: 0.5)
        guard let imageData = imageData else {return}
        
        let endpoint = Endpoint.createQuiz(title: title, image: imageData, categoryID: categoryID, isVisible: isVisible, is_image: is_image, attachment_ids: attachment_ids)
        
        upload(endpoint: endpoint, completion: completion)
    }
    
    func rateQuiz(quizID:Int,rateScore:Int, completion: @escaping (Result<ApiResponse,Error>) ->Void)  {
        let endpoint = Endpoint.rateQuiz(quizID: quizID, rateScore: rateScore)
           request(endpoint: endpoint, completion: completion)
    }
    
    func getTopRate(page:Int,count:Int,completion:@escaping (Result<ApiResponse,Error>) ->Void) {
        let endpoint = Endpoint.getTopRated(page: page, count: count)
           request(endpoint: endpoint, completion: completion)
    }
    func getRecentlyQuiz(page:Int,count:Int,completion:@escaping (Result<ApiResponse,Error>) ->Void) {
        let endpoint = Endpoint.getRecently(page: page, count: count)
           request(endpoint: endpoint, completion: completion)
    }
    
    func getCategories(completion:@escaping (Result<CategoryResponse,Error>) ->Void) {
        let endpoint = Endpoint.getCategories
           request(endpoint: endpoint, completion: completion)
    }
    
    func getQuiz(quizID:Int,completion:@escaping (Result<QuizResponse,Error>) ->Void) {
      let endpoint = Endpoint.getQuiz(quizID: quizID)
         
       request(endpoint: endpoint, completion: completion)
    }
    func getQuizList(pageSize:Int,page:Int,categoryID:Int,completion:@escaping (Result<ApiResponse,Error>) ->Void) {
        let endpoint = Endpoint.getQuizList(categoryID: categoryID, page: page, count: pageSize)
        
         request(endpoint: endpoint, completion: completion)
    }
    func setAttachmentScores(attachID:Int,completion: @escaping (Result<ApiResponse,Error>) ->Void ) {
        let endpoint = Endpoint.setAttachmentScore(attachID: attachID)
           
         request(endpoint: endpoint, completion: completion)
    }
    func searchQuizs(searchText:String,categoryID:Int,completion: @escaping (Result<ApiResponse,Error>) ->Void) {
        let endpoint = Endpoint.searchQuiz(searchText: searchText, categoryID: categoryID)
           
         request(endpoint: endpoint, completion: completion)
    }
    
    var attachmentIdList = [Int]()
  
    
    let createQuizURL = "http://localhost:8000/quizes/"
    let createAttachmentURL = "http://localhost:8000/attachments/"
   
    enum GetRequestTypes {
        case topRate
        case recently
        case category
        case quizList
        
    }
    func setParams(attachList:[Attachment],imageList:[UIImage]) -> [[String: Any]] {
        var emptyArray: [[String: Any]] = []
        
        for i in stride(from: 0, to: attachList.count, by: 1) {
            
            var imageData = imageList[i].jpegData(compressionQuality: 0.5)
            if imageList[i] != nil {
                
                
                guard let data = imageData else {
                    print("Could not get JPEG representation of image")
                    return [[String:Any]]()
                }
                
            }
          
            let parameters: [String: Any] = [
                "title":attachList[i].title!,
                "url":attachList[i].url!,
                "image":imageData!,
                "score":0
            ]
            emptyArray.append(parameters)
        }
        return emptyArray
    }
    func createAttachments(attachList:[Attachment],imageList:[UIImage],completion: @escaping (String?,Bool) -> Void) {
        
            
            let arr =   setParams(attachList: attachList, imageList: imageList)
       
    
        AF.upload(multipartFormData: { multipartFormData in
            for object in arr{
              
            for (key, value) in object {
                     
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
            }
        }, to: createAttachmentURL,method: .post,  headers:  ["Content-Type": "multipart/form-data; boundary=\(UUID().uuidString)"])
       
        .response{ response in
           
            switch response.result {
            case .success(let value):
                do {
                    
                    guard let value = value else { return}
                    
                    let qz = try JSONDecoder().decode([Attachment].self, from: value)
                  //  print("\(qz) \(qz.count)")
                    print(qz)
                    print("SUCCESS")
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
        
        let imageData = image?.jpegData(compressionQuality: 0.5)
            
            guard let imageData = imageData else {
                print("Could not get JPEG representation of image")
                return
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
func createQuiz(title: String, image: UIImage, categoryID: Int, isVisible: Bool,is_image:Bool, attachment_ids:[Int],completion: @escaping (String?,Bool,QuizResponse?) -> Void) {
    
    guard let imageData = image.jpegData(compressionQuality: 0.1) else {
        print("Could not get JPEG representation of image")
        return
    }
       
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
   
        switch response.result {
        case .success(let quiz):
         
            do {
                
                guard let quiz = quiz else { return}
              
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



