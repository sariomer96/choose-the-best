//
//  CreateQuizVCViewController.swift
//  quiz
//
//  Created by Omer on 7.11.2023.
//

import UIKit

class CreateQuizVC: BaseViewController {
    
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var quizTitleLabel: UITextField!
    var viewModel = CreateQuizViewModel()

    @IBOutlet weak var categorySelectButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        recognizer(imageView: coverImageView)
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
    func recognizer(imageView:UIImageView) {
         
        imageView.isUserInteractionEnabled = true
   
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(chooseImage))
        imageView.addGestureRecognizer(gestureRecognizer)
 
    }
    @objc func chooseImage() {
         
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        present(picker,animated: true,completion: nil)
  
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
               alert(title: "Empty Fields", message: "Please fill title and select image")
              
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
extension CreateQuizVC:UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        coverImageView.image = info[.originalImage] as? UIImage
        dismiss(animated: true)
       
        viewModel.setSelectImageStatus(status:true)
       // isSelectedImage = true
        
    }
}
