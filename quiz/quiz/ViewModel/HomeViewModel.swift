//
//  HomeViewModel.swift
//  quiz
//
//  Created by Omer on 9.11.2023.
//

import Foundation
import RxSwift

class HomeViewModel {
    
    var categoryList : [Category]?
 //   var topQuizList = BehaviorSubject<[QuizResponse]>(value: [QuizResponse]())
    var recentlyList : [QuizResponse]?
    var topQuizList:[QuizResponse]?
    let webService = WebService.shared
    
    
    func getCategories(completion: @escaping (String?) -> Void) {
      
        webService.AFGetRequest(requestType: WebService.GetRequestTypes.category, url:webService.categoryURL, modelResponseType: CategoryResponse.self) {
            result in
            self.categoryList = self.webService.categoryList
            completion("AAA")
        }
       
        //WebService.shared.getCategories(completion: completion)
    }
    
     func getTopRateQuiz(completion: @escaping (String?) -> Void){
        
        webService.AFGetRequest(requestType: WebService.GetRequestTypes.topRate, url:webService.topURL , modelResponseType: ApiResponse.self) { res in
           // print(res)
            self.topQuizList = self.webService.topQuizList
            completion("trigger")
             
        }
       // WebService.shared.getTopRateQuiz(completion: completion)
    }
    func getRecentlyQuiz(completion: @escaping (String?) -> Void){
        webService.AFGetRequest(requestType: WebService.GetRequestTypes.recently, url: webService.recentlyURL, modelResponseType: ApiResponse.self) {
            result in
            self.recentlyList = self.webService.recentlyList
            completion("trigger")
        }
       // WebService.shared.getRecentlyUploads(completion: completion)
    }
}
