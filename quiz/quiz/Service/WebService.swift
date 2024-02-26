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
    func request(endpoint:Endpoint,completion: @escaping  (Result<Bool,Error>) -> Void){
        let method =   endpoint.method
       let  alamofireMethod = Alamofire.HTTPMethod(rawValue: method.rawValue)
   
       endpoint.request { params, url,header in
            
           AF.request(url,method: alamofireMethod, parameters: params,encoding: JSONEncoding.default).response { response in
                switch response.result {
                case .success(let data):
              
                        completion(.success((data != nil)))
                          
                    
                case .failure(let fail):
                    completion(.failure(fail))
                }
                
            }
        }
    }
    func request<T: Codable>(endpoint:Endpoint,completion:@escaping (Result<T,Error>) ->Void) {
         
        let method =   endpoint.method
       let  alamofireMethod = Alamofire.HTTPMethod(rawValue: method.rawValue)
   
       endpoint.request { params, url,header in
            
           AF.request(url,method: alamofireMethod, parameters: params,encoding: JSONEncoding.default).response { response in
                switch response.result {
                case .success(let data):
                    do {
                        
                   
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
                     print(T.self)
                     let object = try JSONDecoder().decode(T.self, from: success!)
                     
                     completion(.success(object))
                 }catch{
                     print("error  \(error.localizedDescription)")
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
    func updateAttachment(titles:[String],ids:[Int],completion: @escaping (Result<Bool,Error>) -> Void) {
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
    


    func getYoutubeID (url:String) -> String {
     
        let regexPattern = #"^(?:(?:https?:)?\/\/)?(?:www\.)?(?:youtube\.com\/(?:[^\/\n\s]+\/\S+\/|(?:v|e(?:mbed)?)\/|\S*?[?&]v=)|youtu\.be\/)([a-zA-Z0-9_-]{11})"#

           do {
               let regex = try NSRegularExpression(pattern: regexPattern, options: .caseInsensitive)
               let string = url
               let range = NSRange(location: 0, length: string.utf16.count)

               if let match = regex.firstMatch(in: string, options: [], range: range) {
                   let idRange = Range(match.range(at: 1), in: string)!
                   let id = String(string[idRange])
                   print("Valid: true")
                   print("ID: \(id)")
                   return id
               } else {
                   print("Valid: false")
                   return ""
               }
           } catch {
               print("Error creating regex: \(error)")
               return ""
           }
      
    }
    
    func loadYoutubeThumbnail(url:String,title:String,completion: @escaping (Bool,UIImage?,String) -> Void) {
      
         let id =  getYoutubeID(url: url)
         
        if id.isEmpty == true {
            //invalid url 
            completion(false,nil,"invalid URL")
            return
        }
        DispatchQueue.main.async { [self] in

        let thumbNail = URL(string: "https://img.youtube.com/vi/\(id)/0.jpg")!
               
            let image = UIImageView()
            
            image.kf.setImage(with: thumbNail) { [self] result in
                switch result {
                case .failure(let error):
                   
                    completion(false,nil,"image set error")
                case .success(let success):
                    var embedUrl = "https://www.youtube.com/embed/"
                    embedUrl.append(id)
                    completion(true,image.image!,embedUrl)
                }
            }
            
        }
    }
        
}



