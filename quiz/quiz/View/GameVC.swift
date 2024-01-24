//
//  GameVC.swift
//  quiz
//
//  Created by Omer on 9.11.2023.
//

import UIKit
import Kingfisher

class GameVC: BaseViewController {
     
    @IBOutlet weak var roundNameLabel: UILabel!
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
        gameViewModel.callbackRoundName = { [weak self] name in
            guard let self = self else { return }
            roundNameLabel.text = name
            
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
        gameViewModel.callbackWin = { [weak self] attachment in
            guard let self = self else {return}
    
             
              setImageInteraction(value: false)
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
      
            let vc = storyboard.instantiateViewController(withIdentifier: "GamePopUpVC") as? GamePopUpVC
            guard let vc = vc else{return}
            
            vc.gamePopUpViewModel.quiz = gameViewModel.quiz
            vc.gamePopUpViewModel.attachment = attachment
          
            self.navigationController?.pushViewController(vc, animated: false)
     
        }
        
        func setImageInteraction(value : Bool) {
            leftImageView.isUserInteractionEnabled = value
            rightImageView.isUserInteractionEnabled = value
        }
        gameViewModel.callbackShowPopUp = { [weak self] result in
            guard let self = self else {return}
            
        }
        gameViewModel.callbackDisableUIElements = { [weak self] in
            guard let self = self else {return}
            leftTitleLabel.isHidden = true
            rightTitleLabel.isHidden = true
            roundLabel.isHidden = true
        }
 
        
        func setWinImage(winImageView:UIImageView) {
            winImageView.alpha = 1
            winImageView.translatesAutoresizingMaskIntoConstraints = false
         
            NSLayoutConstraint.activate([
                winImageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                winImageView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
            ])
        }
        
        gameViewModel.callbackSetRoundLabel = { [weak self] text in
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
           
            startQuiz()
             
        }
       
        func startQuiz() {
            gameViewModel.startQuiz()
        }
  
        
    }
