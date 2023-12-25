//
//  GameVC.swift
//  quiz
//
//  Created by Omer on 9.11.2023.
//

import UIKit
import Kingfisher

class GameVC: UIViewController {

    @IBOutlet weak var quizRateDropDownButton: UIButton!
    
    
    @IBOutlet weak var winLabel: UILabel!
    @IBOutlet weak var rightImageView: UIImageView!
    @IBOutlet weak var leftImageView: UIImageView!
    
    @IBOutlet weak var roundLabel: UILabel!
//    var roundIndex = 1
    @IBOutlet weak var leftTitleLabel: UILabel!
    
    @IBOutlet weak var rightTitleLabel: UILabel!
//    var startIndex = 0
//    var quiz:QuizResponse?
//    var playableCount = 0
    var viewModel = GameViewModel()
//    var matchedAttachs = [[Attachment]]()
//    var winAttachs = [Attachment]()
//    var isFinishQuiz = false
//    var rate = 0
//    var isRateSelected = false
//    var vote = false
    override func viewDidLoad() {
        super.viewDidLoad() 
        viewModel.imageViewDelegate?.leftImageView = leftImageView
        viewModel.imageViewDelegate?.rightImageView = rightImageView
        
        viewModel.attachTitleDelegate?.leftTitleLabel = leftTitleLabel
        viewModel.attachTitleDelegate?.rightTitleLabel = rightTitleLabel
        viewModel.attachTitleDelegate?.winLabel = winLabel
        viewModel.attachTitleDelegate?.roundLabel = roundLabel
        
        
 
    }
    @IBAction func voteClick(_ sender: Any) {
        if viewModel.isRateSelected == true {
 
            viewModel.vote = true
       
            viewModel.rateQuiz()
           
        }else {
            AlertManager.shared.alert(view: self, title: "Empty Field", message: "Please vote the quiz")
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        roundLabel.text = ""
    }
    override func viewDidAppear(_ animated: Bool) {
       

        viewModel.imageTap(imageViewLeft: leftImageView, imageViewRight: rightImageView)
        viewModel.view = view

        
         startQuiz()
         showRateDropDown()
    }
    func showRateDropDown() {
        viewModel.showRateDropDown(dropDownButton: quizRateDropDownButton)
    }
    func startQuiz() {
        viewModel.startQuiz()
    }
    @IBAction func playAgainClick(_ sender: Any) {
        
        if viewModel.vote == true {
            
            let vc = self.storyboard!.instantiateViewController(withIdentifier: "GameStartVC") as! GameStartVC
            
            
            vc.quiz = viewModel.quiz
            self.navigationController!.pushViewController(vc, animated: true)
        }else {
            AlertManager.shared.alert(view: self, title: "Empty Field", message: "Please vote the quiz")
        }
      //  performSegue(withIdentifier: "toQuizDetail", sender: quiz)
    }
    
    
}
