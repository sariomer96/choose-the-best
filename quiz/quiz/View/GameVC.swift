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
        
        leftImageView.layer.borderWidth = 2
        leftImageView.layer.borderColor = UIColor.cyan.cgColor
        
        rightImageView.layer.borderWidth = 2
        rightImageView.layer.borderColor = UIColor.green.cgColor
        popUpView.isHidden = true
     
        initVM()
    }
    
    func fadeInOrOut(alpha:Double, imageView:UIImageView) {
        UIView.animate(withDuration: 1.1, animations: {
            imageView.alpha = alpha
        })
    }
    func initVM() {
        gameViewModel.callbackShowAlert = { [weak self] alertInfo in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.showAlert(alertInfo.alertTitle, alertInfo.description)
            }
        }
        gameViewModel.callbackSetTitle = { [weak self] titles in
            
            self?.leftTitleLabel.text = titles.0
            self?.rightTitleLabel.text = titles.1
        }
        gameViewModel.callbackSetImageURL = { [weak self] image in
            guard let self = self else { return }
            leftImageView.kf.setImage(with: URL(string: image.0) ) { _ in
                self.fadeInOrOut(alpha: 1.0, imageView: self.leftImageView)
            }
            
            rightImageView.kf.setImage(with: URL(string: image.1) ) { _ in
                self.fadeInOrOut(alpha: 1.0, imageView: self.rightImageView)
            }
        }
        
        gameViewModel.callBackSetSideImage = { [weak self] sideResult in
            guard let self = self else { return }
            
            switch sideResult.1 {
            case 0:
                setImageAlpha(alpha: sideResult.0, imageView: leftImageView)
            case 1:
                setImageAlpha(alpha: sideResult.0, imageView: rightImageView)
                
            default:
                break
            }
        }
        gameViewModel.callbackWin = { [weak self] title in
            guard let self = self else {return}
            winLabel.textColor = .systemRed
            winLabel.text = "\(title) WIN!!"
            popUpView.isHidden = false
             
              setImageInteraction(value: false)
        }
        
        func setImageInteraction(value : Bool) {
            leftImageView.isUserInteractionEnabled = value
            rightImageView.isUserInteractionEnabled = value
        }
        gameViewModel.callbackShowPopUp = { [weak self] result in
            guard let self = self else {return}
            
            popUpQuizImageView.kf.setImage(with: URL(string: result.0),placeholder: UIImage(named: "add"))
            popUpQuizTitle.text = result.1
        }
        gameViewModel.callbackDisableUIElements = { [weak self] in
            guard let self = self else {return}
            leftTitleLabel.isHidden = true
            rightTitleLabel.isHidden = true
            roundLabel.isHidden = true
        }
        gameViewModel.callbackImageMoveCenter = { [weak self] index in
            guard let self = self else {return}
            
            switch index {
            case 0:
                setWinImage(winImageView: leftImageView)
            case 1:
                setWinImage(winImageView: rightImageView)
            default:
                break
            }
            
        }
        
        func setWinImage(winImageView:UIImageView) {
            winImageView.alpha = 1
            winImageView.translatesAutoresizingMaskIntoConstraints = false
         
            NSLayoutConstraint.activate([
                winImageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                winImageView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
            ])
        }
        
        gameViewModel.callbackSetRoundText = { [weak self] text in
            guard let self = self else {return}
            roundLabel.text = text
        }
        
        func setImageAlpha(alpha:Double,imageView:UIImageView) {
            UIView.animate(withDuration: 1.1, animations: {
                imageView.alpha = alpha
            })
        }
    }
        override func viewWillAppear(_ animated: Bool) {
            roundLabel.text = ""
        }
        override func viewDidAppear(_ animated: Bool) {
            
            gameViewModel.imageTap(imageViewLeft: leftImageView, imageViewRight: rightImageView)
            // gameViewModel.view = view
            
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
                guard let gameQuiz = gameViewModel.quiz else{return}
                self.presentGameStartViewController(quiz: gameQuiz)
            } else {
                alert(title: "Empty Field", message: "Please vote the quiz")
            }
            
        }
        
        @IBAction func voteClick(_ sender: Any) {
            if gameViewModel.isRateSelected == true {
                
                gameViewModel.vote = true
                gameViewModel.rateQuiz()
                
            }else {
                alert(title: "Empty Field", message: "Please vote the quiz")
            }
        }
        
    }
