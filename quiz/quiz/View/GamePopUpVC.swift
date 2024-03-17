//
//  GamePopUpVC.swift
//  quiz
//
//  Created by Omer on 11.01.2024.
//

import UIKit
import Kingfisher

final class GamePopUpVC: BaseViewController {

    @IBOutlet weak var quizImageView: UIImageView!

    @IBOutlet weak var testTitleLabel: UILabel!
    @IBOutlet weak var rateButton: UIButton!
    let gamePopUpViewModel = GamePopUpViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        showRateDropDown()

        gamePopUpViewModel.callbackRateQuiz = { [weak self]  in
            guard let self = self else {return }
               rateQuiz()
        }
    }

    override func viewDidAppear(_ animated: Bool) {

        setAttachment()

            self.navigationController?.setNavigationBarHidden(true, animated: true)

    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    func rateQuiz() {
        gamePopUpViewModel.rateQuiz()
    }

    func showRateDropDown() {
        gamePopUpViewModel.showRateDropDown(dropDownButton: rateButton)
    }

    func setAttachment() {
        let imgUrl = gamePopUpViewModel.attachment?.image
        let title =  gamePopUpViewModel.attachment?.title
        guard let imgUrl = imgUrl, let title = title else { return }
        quizImageView.kf.setImage(with: URL(string: imgUrl))
        testTitleLabel.text = title
    }
    @IBAction func playAgainClicked(_ sender: Any) {

        if gamePopUpViewModel.vote == true {
            guard let gameQuiz = gamePopUpViewModel.quiz else { return }
            self.presentGameStartViewController(quiz: gameQuiz)
        } else {
            alert(title: "Empty Field", message: "Please vote the quiz")
        }
    }
}
