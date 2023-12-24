//
//  QuizListViewModel.swift
//  quiz
//
//  Created by Omer on 9.11.2023.
//

import Foundation
 

protocol QuizListProtocol {
    func getQuizList(categoryId:Int,completion: @escaping (String?) -> Void)
}
class QuizListViewModel : QuizListProtocol {
    
    var quizList : [QuizResponse]?
    let webService = WebService.shared
   
    
    func getQuizList(categoryId:Int, completion: @escaping (String?) -> Void) {
        
          print("call count")
        webService.AFGetRequest(requestType: WebService.GetRequestTypes.quizList, url: "\(webService.quizListFromCategoryURL)\(categoryId)", modelResponseType: ApiResponse.self) {
            result in
            print("tetik")
            self.quizList = self.webService.quizList
            completion("trigger")
            
            
        }
      
    }
    
    func search(searchText:String,categoryID:Int,completion: @escaping (String) -> Void) {
        WebService.shared.searchQuiz(searchText: searchText,categoryID:categoryID, completion: completion)
    }
    
    
    
}
