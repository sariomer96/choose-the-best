//
//  GamePopUpVC.swift
//  quiz
//
//  Created by Omer on 11.01.2024.
//

import UIKit
import Kingfisher

class GamePopUpVC: BaseViewController {

    @IBOutlet weak var quizImage: UIImageView!
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var testTitleLabel: UILabel!
    @IBOutlet weak var rate: UIButton!
    let gamePopUpViewModel = GamePopUpViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()

        showRateDropDown()
        gamePopUpViewModel.callbackShowAlert = { [weak self] alertTitle in
            guard let self = self else { return }
            alert(title: alertTitle.alertTitle, message: alertTitle.description)
            rate.isUserInteractionEnabled = false
        }
        
        gamePopUpViewModel.callbackRateQuiz = { [weak self]  in
            guard let self = self else {return }
               rateQuiz()
        }
       
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        configView()
    }
    override func viewDidAppear(_ animated: Bool) {
       
        show()
        setAttachment()
    }
    func rateQuiz() {
        gamePopUpViewModel.rateQuiz()
    }
    
    func showRateDropDown() {
        gamePopUpViewModel.showRateDropDown(dropDownButton: rate)
    }
    
    func setAttachment() {
        let imgUrl = gamePopUpViewModel.attachment?.image
        let title =  gamePopUpViewModel.attachment?.title
        guard let imgUrl = imgUrl , let title = title else { return }
        quizImage.kf.setImage(with: URL(string: imgUrl))
        testTitleLabel.text = title
    }
    @IBAction func playAgainClick(_ sender: Any) {
      
        if gamePopUpViewModel.vote == true {
            guard let gameQuiz = gamePopUpViewModel.quiz else{return}
            self.presentGameStartViewController(quiz: gameQuiz)
        } else {
            alert(title: "Empty Field", message: "Please vote the quiz")
        }
    }
   
 
    func configView(){
    
        self.popUpView.alpha = 0
        self.popUpView.layer.cornerRadius = 10
    }
    
    func appear(sender: UIViewController){
        sender.present(self,animated: true) {
          self.show()
        }
    }
    
    private func show() {
        UIView.animate(withDuration: 1, delay: 0.7){
            self.popUpView.alpha = 1
        }
    }
    
//    func hide() {
//        UIView.animate(withDuration: 1, delay: 0.0, options: .curveEaseOut){
//            self.popUpView.alpha = 0
//        } completion: { _ in
//            self.dismiss(animated: false)
//            self.removeFromParent()
//        }
//    }

}
