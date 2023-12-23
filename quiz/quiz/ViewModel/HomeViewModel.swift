//
//  HomeViewModel.swift
//  quiz
//
//  Created by Omer on 9.11.2023.
//

import Foundation
import RxSwift

class HomeViewModel {
    
    var categoryList = BehaviorSubject<[Category]>(value: [Category]())
 //   var topQuizList = BehaviorSubject<[QuizResponse]>(value: [QuizResponse]())
    var recentlyList : [QuizResponse]?
    var topQuizList:[QuizResponse]?
    let webService = WebService.shared
    
    init() {
        self.categoryList = WebService.shared.categoryList
      
      //  self.recentlyList = WebService.shared.recentlyList
        
    }
    func getCategories(completion: @escaping (String?) -> Void) {
      
        webService.AFGetRequest(requestType: WebService.GetRequestTypes.category, url:webService.categoryURL, modelResponseType: CategoryResponse.self, completion: completion)
       
        //WebService.shared.getCategories(completion: completion)
    }
    
     func getTopRateQuiz(completion: @escaping (String?) -> Void){
        
        webService.AFGetRequest(requestType: WebService.GetRequestTypes.topRate, url:webService.topURL , modelResponseType: ApiResponse.self) { res in
           // print(res)
            self.topQuizList = WebService.shared.topQuizList
            completion("trigger")
             
        }
       // WebService.shared.getTopRateQuiz(completion: completion)
    }
    func getRecentlyQuiz(completion: @escaping (String?) -> Void){
        webService.AFGetRequest(requestType: WebService.GetRequestTypes.recently, url: webService.recentlyURL, modelResponseType: ApiResponse.self) {
            result in
            self.recentlyList = WebService.shared.recentlyList
            completion("trigger")
        }
       // WebService.shared.getRecentlyUploads(completion: completion)
    }
}
