//
//  HomeViewModel.swift
//  quiz
//
//  Created by Omer on 9.11.2023.
//

import Foundation
import RxSwift

class HomeViewModel {
    
    var categoryList = BehaviorSubject<[CategoryClass]>(value: [CategoryClass]())
    var topQuizList = BehaviorSubject<[TopRateResult]>(value: [TopRateResult]())
    var recentlyList = BehaviorSubject<[TopRateResult]>(value: [TopRateResult]())
    
    init() {
        self.categoryList = WebService.shared.categoryList
        self.topQuizList = WebService.shared.topQuizList
        self.recentlyList = WebService.shared.recentlyList
    }
    func getCategories() {
      
        WebService.shared.getCategories()
    }
    
    func getTopRateQuiz(){
        WebService.shared.getTopRateQuiz()
    }
    func getRecentlyQuiz(){
        WebService.shared.getRecentlyUploads()
    }
}
