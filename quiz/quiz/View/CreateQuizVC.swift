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
    var viewModel = CreateQuizViewModel()

    @IBOutlet weak var categorySelectButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        viewModel.recognizer(imageView: coverImageView, view: self)
        categorySelectButton.isHidden = true
        viewModel.getCategory { result in
            self.showSelectCategoryButton()
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        viewModel.didSelectCategory = false
    }
   
    func showSelectCategoryButton(){
         
        let  action = viewModel.getDropDownActions()
        categorySelectButton.isHidden = false
        if  action != nil {
 
            categorySelectButton.menu = UIMenu(children : action)
            categorySelectButton.showsMenuAsPrimaryAction = true
            categorySelectButton.changesSelectionAsPrimaryAction = true
        }
    }

    func setQuizFields(quiztype:QuizType) {
        
         let isEmpty = viewModel.checkIsEmptyFields(title: quizTitleLabel.text!, view: self)
          
          
          if isEmpty == false, viewModel.isSelectedImage == true{
              CreateQuizFields.shared.quizHeaderImage = coverImageView.image!
              CreateQuizFields.shared.quizTitle = quizTitleLabel.text!
              
              
              if quiztype == QuizType.image {
                  
                  let vc = self.storyboard!.instantiateViewController(withIdentifier: "ImageChoicesVC") as! ImageChoicesVC
                  
                 
                 self.navigationController?.pushViewController(vc, animated: true)
                  
              }else {
                  
                  let vc = self.storyboard!.instantiateViewController(withIdentifier: "VideoChoicesVC") as! VideoChoicesVC
                 self.navigationController!.pushViewController(vc, animated: true)
              }
             //  performSegue(withIdentifier: identifier, sender: nil)
                 
          }else {
              AlertManager().delegateAlert?.alert(view: self, title: "Empty Fields", message: "Please fill title and select image")
             // viewModel.delegateAlert?.alert(view: self, title: "Empty Fields", message: "Please fill title and select image")
          }
    }
    
    enum QuizType {
        case image
        case video
    }
    @IBAction func imageQuizclicked(_ sender: Any) {
        setQuizFields(quiztype: QuizType.image)
      
    }
    @IBAction func videoQuizClick(_ sender: Any) {
        setQuizFields(quiztype: QuizType.video)
    }
    
}
