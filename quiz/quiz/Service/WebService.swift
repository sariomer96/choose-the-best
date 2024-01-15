import Foundation
import Alamofire
import UIKit
 
 
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
            
           AF.request(url,method: alamofireMethod, parameters: params,encoding: JSONEncoding.default).response { response in
                switch response.result {
                case .success(let data):
                    do {
                        
                        print(T.self)
                        guard let data = data else {return }
                        let result = try JSONDecoder().decode(T.self, from: data)
                        completion(.success(result))
                         
                    }catch{
                        print("DECODE ERROR \(error.localizedDescription) \(response.response?.statusCode)")
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
                    print("set image")
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
    func createAttachment(title:String,videoUrl:String,image:UIImage,completion: @escaping (Result<Attachment,Error>) -> Void){
       
        let imageData = image.jpegData(compressionQuality: 0.5)
        guard let imageData = imageData else {return}
        
        let endpoint = Endpoint.createAttachment(title: title, videoUrl: videoUrl, imageData: imageData)
        
        upload(endpoint: endpoint, completion: completion)
        
    }
    func updateAttachment(titles:[String],ids:[Int],completion: @escaping (Result<Attachment,Error>) -> Void) {
        let endpoint = Endpoint.updateAttachment(titles: titles, ids: ids)
        
        request(endpoint: endpoint, completion: completion)
        
    }
    func deleteAttachment(attachmentID:Int, completion: @escaping (Result<(Attachment),Error>) -> Void){
        let endpoint = Endpoint.deleteAttachment(attachmentID: attachmentID)
        
        request(endpoint: endpoint, completion: completion)
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
   
    enum GetRequestTypes {
        case topRate
        case recently
        case category
        case quizList
        
    }
    
    func getYoutubeID (url:String) -> String {
        var videoID = ""
        let linkStart = "https://youtu.be/"
       let isSharedLink =  url.hasPrefix(linkStart)
        
        
        if isSharedLink == true {
            let splitUrl = url.split(separator: linkStart)[0]
           let id =   splitUrl.split(separator: "?")[0]
          
            videoID = String(id)
        }else {
            let baseUrl = url.split(separator: "?v=")[1]
     
            let id = baseUrl.split(separator: "&")
            
             videoID = String(id[0])
        }
         return videoID
    }
    
    func loadYoutubeThumbnail(url:String,title:String,completion: @escaping (Bool,UIImage?) -> Void) {
      
         let id =  getYoutubeID(url: url)
        
         
        DispatchQueue.main.async { [self] in

        let thumbNail = URL(string: "https://img.youtube.com/vi/\(id)/0.jpg")!
               
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



