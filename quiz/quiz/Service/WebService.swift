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

class WebService {
    
    static let shared = WebService()
   
     
    
    var recentlyList = BehaviorSubject<[TopRateResult]>(value: [TopRateResult]())
    func getRecentlyUploads () {
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601

    
           AF.request("http://127.0.0.1:8000/quizes/?ordering=-created_at",method: .get).response { response in
        if let data = response.data{
            do{

                let cevap = try decoder.decode(TopRate.self, from: data)

                if cevap.results != nil {

                    let list = cevap.results
                    print("\(list[0].title) AAaaaaaa")
                    self.recentlyList.onNext(list)

                }

             

            }catch{
                print("\(error.localizedDescription) III")
            }
        }

    }
        
}
    
    func getSelectedQuizList() {
        
    }
    

    var categoryList = BehaviorSubject<[CategoryClass]>(value: [CategoryClass]())
    func getCategories() {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601

    AF.request("http://127.0.0.1:8000/categories",method: .get).response { response in
        if let data = response.data{
            do{
                
                var cevap = try decoder.decode(CategoryResult.self, from: data)
                
                if let list = cevap.results {
               
                    self.categoryList.onNext(list)
                }
                 
            }catch{
                print("\(error.localizedDescription) III")
            }
        }
        
    }
}
    var quizList = BehaviorSubject<[Result]>(value: [Result]())
    func getQuizListFromCategory(categoryId:Int) {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601

              AF.request("http://127.0.0.1:8000/quizes?category__id=\(categoryId)",method: .get).response { response in
        if let data = response.data{
            do{
                
                var cevap = try decoder.decode(ApiResponse.self, from: data)
                
                if let list = cevap.results {
                    self.quizList.onNext(list)
                }
                print(cevap.results)
                 
            }catch{
                print("\(error.localizedDescription) III")
            }
        }
        
     }
    }
    var topQuizList = BehaviorSubject<[TopRateResult]>(value: [TopRateResult]())
    
    func getTopRateQuiz() {

            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601

        
               AF.request("http://127.0.0.1:8000/quizes/top-rated",method: .get).response { response in
            if let data = response.data{
                do{

                    let cevap = try decoder.decode(TopRate.self, from: data)

                    if cevap.results != nil {

                        let list = cevap.results
                        print("\(list[0].title) AAaaaaaa")
                        self.topQuizList.onNext(list)

                    }

                 

                }catch{
                    print("\(error.localizedDescription) III")
                }
            }

        }
    }
  
 

    func createQuiz(title: String, image: UIImage, categoryID: Int, isVisible: Bool) {
      
        let url = "http://localhost:8000/quizes/"
        
        // Resmi Data tipine çevirme
        guard let imageData = image.jpegData(compressionQuality: 0.5) else {
            print("Could not get JPEG representation of image")
            return
        }
        print("uploadingg")
        print("tileee \(title)")
        // Gönderilecek parametreleri ayarlama
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
                    print("multidata \(data)")
                } else if let value = value as? Int {
                    let intData = Data(String(value).utf8)
                    multipartFormData.append(intData, withName: key)
                    print("int \(intData)")
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
            // İstek tamamlandığında yapılacak işlemler
            
            if let data = response.data, let responseString = String(data: data, encoding: .utf8) {
                   print("Server Response: \(responseString)")
               }
            switch response.result {
            case .success(let data):
                print("Upload successful: \(data)")
                // Başarılı işlem sonrası yapılacak işlemler
            case .failure(let error):
                print("Error uploading image: \(error)")
                // Hata durumunda yapılacak işlemler
            }
        }
    }

   
}

