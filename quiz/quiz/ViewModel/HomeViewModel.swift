//
//  HomeViewModel.swift
//  quiz
//
//  Created by Omer on 9.11.2023.
//

import Foundation
import RxSwift

struct HomeViewModel {
    
    var categoryList = BehaviorSubject<[Category]>(value: [Category]())
    var topQuizList = BehaviorSubject<[QuizResponse]>(value: [QuizResponse]())
    var recentlyList = BehaviorSubject<[QuizResponse]>(value: [QuizResponse]())
    
    init() {
        self.categoryList = WebService.shared.categoryList
        self.topQuizList = WebService.shared.topQuizList
        self.recentlyList = WebService.shared.recentlyList
    }
    func getCategories(completion: @escaping (String?) -> Void) {
      
        WebService.shared.getCategories(completion: completion)
    }
    
    func getTopRateQuiz(completion: @escaping (String?) -> Void){
        WebService.shared.getTopRateQuiz(completion: completion)
    }
    func getRecentlyQuiz(completion: @escaping (String?) -> Void){
        WebService.shared.getRecentlyUploads(completion: completion)
    }
}
