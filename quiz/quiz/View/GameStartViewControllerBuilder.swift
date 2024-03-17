//
//  GameStartViewControllerBuilder.swift
//  quiz
//
//  Created by Omer on 5.01.2024.
//

import Foundation

final class GameStartViewControllerBuilder {
    class func build(quiz: QuizResponse) -> GameStartVC {
        let viewController =  GameStartVC.instantiateFromStoryboard()
        viewController.gameStartViewModel.setQuiz(quiz: quiz)
        return viewController
    }
}
