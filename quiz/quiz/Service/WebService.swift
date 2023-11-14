//
//  WebService.swift
//  quiz
//
//  Created by Omer on 9.11.2023.
//

import Foundation
import Alamofire
import RxSwift

class WebService {
    
    static let shared = WebService()
   
     
    
    func getRecentlyUploads () {
        
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
                    print("result \(list.count)")
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
    var topQuizList = BehaviorSubject<[Result]>(value: [Result]())
    
    func getTopRateQuiz() {

            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601

        AF.request("http://127.0.0.1:8000/quizes",method: .get).response { response in
            if let data = response.data{
                do{

                    var cevap = try decoder.decode(ApiResponse.self, from: data)

                    if let list = cevap.results {
                        self.topQuizList.onNext(list)
                        print("wrok")
                    }
                  
                 

                }catch{
                    print("\(error.localizedDescription) III")
                }
            }

        }
    }
    func postQuiz() {
        
    }
   
}

