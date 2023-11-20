//
//  GameStartVC.swift
//  quiz
//
//  Created by Omer on 9.11.2023.
//

import UIKit
import Kingfisher

class GameStartVC: UIViewController {

    @IBOutlet weak var quizTitleLabel: UILabel!
    @IBOutlet weak var quizHeaderImageView: UIImageView!
     var quizTitle:String?
     var quizImage:String?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        quizTitleLabel.text = ""
        quizHeaderImageView.image = nil
    }
    
    override func viewDidAppear(_ animated: Bool) {
        quizTitleLabel.text = quizTitle
        let url = quizImage!
        quizHeaderImageView.kf.setImage(with: URL(string: url))
    }
    @IBAction func startClick(_ sender: Any) {
        performSegue(withIdentifier: "toGameVC", sender: nil)
    }
    
}
