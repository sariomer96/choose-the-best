//
//  GameVC.swift
//  quiz
//
//  Created by Omer on 9.11.2023.
//

import UIKit
import Kingfisher

extension UIColor {
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        var hexValue = hex.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()

        if hexValue.hasPrefix("#") {
            hexValue.remove(at: hexValue.startIndex)
        }

        var rgbValue: UInt64 = 0
        Scanner(string: hexValue).scanHexInt64(&rgbValue)

        let red = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgbValue & 0x0000FF) / 255.0

        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}

final class GameVC: BaseViewController {

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

        let red =  UIColor(hex: "#FF5050", alpha: 0.85)
        let blue = UIColor(hex: "0066FF", alpha: 0.85)

        roundNameLabel.layer.masksToBounds = true
        roundLabel.layer.masksToBounds = true
        roundNameLabel.layer.cornerRadius = 10
        roundLabel.layer.cornerRadius = 1

        leftImageView.layer.masksToBounds = true
        rightImageView.layer.masksToBounds = true

       leftImageView.layer.borderWidth = 2
        leftImageView.layer.cornerRadius = 5
        rightImageView.layer.cornerRadius = 5

        leftImageView.layer.borderColor = blue.cgColor
        rightImageView.layer.borderWidth = 2
        rightImageView.layer.borderColor = red.cgColor

        initVM()
    }

    func fadeInOrOut(alpha: Double, imageView: UIImageView) {
        UIView.animate(withDuration: 1.1, animations: {
            imageView.alpha = alpha
        })
    }

    func initVM() {
        gameViewModel.callbackShowAlert = { [weak self] alertInfo in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.alert(title: alertInfo.alertTitle, message: alertInfo.description)
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

            let viewC = storyboard.instantiateViewController(withIdentifier: "GamePopUpVC") as? GamePopUpVC
            guard let viewC = viewC else { return }

            viewC.gamePopUpViewModel.quiz = gameViewModel.quiz
            viewC.gamePopUpViewModel.attachment = attachment

           self.navigationController?.pushViewController(viewC, animated: false)

        }

        func setImageInteraction(value: Bool) {
            leftImageView.isUserInteractionEnabled = value
            rightImageView.isUserInteractionEnabled = value
        }
        gameViewModel.callbackShowPopUp = { [weak self] _ in
            guard let self = self else {return}

        }
        gameViewModel.callbackDisableUIElements = { [weak self] in
            guard let self = self else {return}

            roundLabel.isHidden = true
        }

        func setWinImage(winImageView: UIImageView) {
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

        func setImageAlpha(alpha: Double, imageView: UIImageView) {
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
