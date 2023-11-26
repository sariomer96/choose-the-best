//
//  QuizListViewModel.swift
//  quiz
//
//  Created by Omer on 9.11.2023.
//

import Foundation
import RxSwift

protocol QuizListProtocol {
    func getQuizList(categoryId:Int,completion: @escaping (String?) -> Void)
}
struct QuizListViewModel : QuizListProtocol {
    
    var quizList = BehaviorSubject<[QuizResponse]>(value: [QuizResponse]())
    let webService = WebService.shared
    init() {
        self.quizList = WebService.shared.quizList
    }
    
    func getQuizList(categoryId:Int, completion: @escaping (String?) -> Void) {
        
        webService.AFGetRequest(requestType: WebService.GetRequestTypes.quizList, url: "\(webService.quizListFromCategoryURL)\(categoryId)", modelResponseType: ApiResponse.self,completion: completion)
      
    }
    
    func search(searchText:String,completion: @escaping (String) -> Void) {
        WebService.shared.searchQuiz(searchText: searchText, completion: completion)
    }
    
    
    
}
