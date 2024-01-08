//
//  GameVC.swift
//  quiz
//
//  Created by Omer on 9.11.2023.
//

import UIKit
import Kingfisher

class GameVC: BaseViewController {

    @IBOutlet weak var popUpQuizTitle: UILabel!
    @IBOutlet weak var popUpQuizImageView: UIImageView!
    @IBOutlet weak var popUpView: UIView!
    
    
    
    @IBOutlet weak var quizRateDropDownButton: UIButton!
    @IBOutlet weak var winLabel: UILabel!
    @IBOutlet weak var rightImageView: UIImageView!
    @IBOutlet weak var leftImageView: UIImageView!
    @IBOutlet weak var roundLabel: UILabel!
    @IBOutlet weak var leftTitleLabel: UILabel!
    @IBOutlet weak var rightTitleLabel: UILabel!
    lazy var gameViewModel = GameViewModel()
    // MARK: Life Cycles Method
    override func viewDidLoad() {
        
        super.viewDidLoad()
        popUpView.isHidden = true
        gameViewModel.imageViewDelegate?.leftImageView = leftImageView
        gameViewModel.imageViewDelegate?.rightImageView = rightImageView
        gameViewModel.popUpView = popUpView
        gameViewModel.attachTitleDelegate?.leftTitleLabel = leftTitleLabel
        gameViewModel.attachTitleDelegate?.rightTitleLabel = rightTitleLabel
        gameViewModel.attachTitleDelegate?.winLabel = winLabel
        gameViewModel.attachTitleDelegate?.roundLabel = roundLabel
        gameViewModel.viewController = self
        initVM()
    }
    func initVM() {
        gameViewModel.callbackShowAlert = { [weak self] alertInfo in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.showAlert(alertInfo.alertTitle, alertInfo.description)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        roundLabel.text = ""
    }
    override func viewDidAppear(_ animated: Bool) {
        
        gameViewModel.imageTap(imageViewLeft: leftImageView, imageViewRight: rightImageView)
        gameViewModel.view = view

         startQuiz()
         showRateDropDown()
    }
    func showRateDropDown() {
        gameViewModel.showRateDropDown(dropDownButton: quizRateDropDownButton)
    }
    func startQuiz() {
        gameViewModel.startQuiz()
    }

    @IBAction func playAgainClick(_ sender: Any) {
        
        if gameViewModel.vote == true {
            self.presentGameStartViewController(quiz: gameViewModel.quiz)
        } else {
            AlertManager.shared.alert(view: self, title: "Empty Field", message: "Please vote the quiz")
        }

    }

    @IBAction func voteClick(_ sender: Any) {
        if gameViewModel.isRateSelected == true {
 
            gameViewModel.vote = true
            gameViewModel.rateQuiz()
           
        }else {
            AlertManager.shared.alert(view: self, title: "Empty Field", message: "Please vote the quiz")
        }
    }

}
