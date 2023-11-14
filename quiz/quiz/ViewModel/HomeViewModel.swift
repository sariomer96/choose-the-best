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
    var topQuizList = BehaviorSubject<[Result]>(value: [Result]())
    
    init() {
        self.categoryList = WebService.shared.categoryList
        self.topQuizList = WebService.shared.topQuizList
    }
    func getCategories() {
        print("list count \(categoryList)")
        WebService.shared.getCategories()
    }
    
    func getTopRateQuiz(){
        WebService.shared.getTopRateQuiz()
    }
}
