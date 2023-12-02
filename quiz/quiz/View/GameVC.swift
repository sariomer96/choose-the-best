//
//  GameVC.swift
//  quiz
//
//  Created by Omer on 9.11.2023.
//

import UIKit

class GameVC: UIViewController {

    var quiz:QuizResponse?
    var playableCount = 0
    var viewModel = GameViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
 

    override func viewDidAppear(_ animated: Bool) {
         
        print(playableCount)
        viewModel.matchQuiz(quiz: quiz!,playableCount: playableCount)
    }
}
