//
//  GameStartViewModel.swift
//  quiz
//
//  Created by Omer on 9.11.2023.
//
import RxSwift
import Foundation

struct GameStartViewModel {
    
    
    func getQuiz(quizID:Int,completion: @escaping (QuizResponse) -> Void) {
        WebService.shared.getQuiz(quizID: quizID,completion: completion)
    }
}
