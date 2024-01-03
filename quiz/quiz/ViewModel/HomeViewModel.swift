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
    var recentlyList : [QuizResponse]?
    var topQuizList:[QuizResponse]?
    let webService = WebService.shared
     
    func getCategories(completion: @escaping (String?) -> Void) {
      
        
        webService.getCategories { result in
            switch result {
                
            case .success(let category):
                self.categoryList = category.results
                completion("trigger")
            case .failure(let error):
                print("error")
            }
        }
 
    }
    
     func getTopRateQuiz(completion: @escaping (String?) -> Void){
        
         webService.getTopRate { result in
             switch result {
                 
             case .success(let quiz):
                 self.topQuizList = quiz.results
                 completion("trigger")
             case .failure(let error):
                 print("errorrr")
             }
         }

    }
    func getRecentlyQuiz(completion: @escaping (String?) -> Void){
      
        webService.getRecentlyQuiz { result in
            switch result {
                
            case .success(let quiz):
                self.recentlyList = quiz.results
                completion("trigger")
            case .failure(let error):
                print("errorrr")
            }
        }

 

    }
}
