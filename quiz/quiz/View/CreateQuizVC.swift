//
//  CreateQuizVCViewController.swift
//  quiz
//
//  Created by Omer on 7.11.2023.
//

import UIKit

class CreateQuizVC: UIViewController {

    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var quizTitleLabel: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    var viewModel = CreateQuizViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.recognizer(imageView: coverImageView, view: self)
    }
     
    
    @IBAction func nextButtonClick(_ sender: Any) {
      
       let isEmpty = viewModel.checkIsEmptyFields(title: quizTitleLabel.text!, view: self)
        
        if isEmpty == false {
            performSegue(withIdentifier: "toChoices", sender: nil)
        }
    }
    
}
