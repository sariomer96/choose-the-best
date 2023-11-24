//
//  HomeViewModel.swift
//  quiz
//
//  Created by Omer on 9.11.2023.
//

import Foundation
import RxSwift

struct HomeViewModel {
    
    var categoryList = BehaviorSubject<[CategoryClass]>(value: [CategoryClass]())
    var topQuizList = BehaviorSubject<[TopRateResult]>(value: [TopRateResult]())
    var recentlyList = BehaviorSubject<[TopRateResult]>(value: [TopRateResult]())
    
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
