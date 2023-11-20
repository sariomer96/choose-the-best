//
//  QuizListViewModel.swift
//  quiz
//
//  Created by Omer on 9.11.2023.
//

import Foundation
import RxSwift

protocol QuizListProtocol {
    func getQuizList(categoryId:Int)
}
class QuizListViewModel : QuizListProtocol {
    
    var quizList = BehaviorSubject<[Result]>(value: [Result]())
    
    init() {
        self.quizList = WebService.shared.quizList
    }
    
    func getQuizList(categoryId:Int) {
        WebService.shared.getQuizListFromCategory(categoryId: categoryId)
    }
    
    func search(searchText:String) {
        WebService.shared.searchQuiz(searchText: searchText)
    }
    
    
    
}
