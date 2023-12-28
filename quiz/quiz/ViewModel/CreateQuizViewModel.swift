//
//  CreateQuizViewModel.swift
//  quiz
//
//  Created by Omer on 9.11.2023.
//

import Foundation
import UIKit

protocol AlertProtocol:AnyObject {
    func alert(view:UIViewController,title:String,message:String)
}
 
protocol UiViewDelegate:AnyObject {
    func getUiViewController(view:UIViewController)
}

class CreateQuizViewModel:NSObject {
   
    var uiView:UIViewController?
    var recogDelegate:UiViewDelegate?
    var isSelectedImage:Bool = false
    var coverImage:UIImageView?

    override init() {
        super.init()
    
        recogDelegate = self
    }
    
    func createQuiz(title: String, image: UIImage, categoryID: Int, isVisible: Bool,is_image:Bool,
                    attachment_ids:[Int],completion: @escaping (String?, Bool,QuizResponse?) -> Void){
        
        WebService.shared.createQuiz(title: title, image: image, categoryID: categoryID, isVisible: isVisible,is_image: is_image, attachment_ids: attachment_ids, completion: completion)
    }
    func checkIsEmptyFields(title:String, view:UIViewController) -> Bool{
      
        let trimmedString = title.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmedString.isEmpty   {
           
            return true
        }else{
            return false
        }
    }
}


/// IMAGE RECOGNIZER
extension CreateQuizViewModel:UiViewDelegate ,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    func getUiViewController(view: UIViewController) {
        uiView = view
 
    }
    
    func recognizer(imageView:UIImageView,view:UIViewController) {
        
        
        recogDelegate?.getUiViewController(view: view)
        imageView.isUserInteractionEnabled = true
        coverImage = imageView
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(chooseImage))
        coverImage!.addGestureRecognizer(gestureRecognizer)
 
    }
    
    @objc func chooseImage() {
         
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        uiView?.present(picker,animated: true,completion: nil)
  
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        coverImage?.image = info[.originalImage] as? UIImage
        uiView?.dismiss(animated: true)
       
        isSelectedImage = true
        
    }
     
}
