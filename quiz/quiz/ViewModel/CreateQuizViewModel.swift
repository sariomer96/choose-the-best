//
//  CreateQuizViewModel.swift
//  quiz
//
//  Created by Omer on 9.11.2023.
//

import Foundation
import UIKit
 
class CreateQuizViewModel:NSObject {
    var categoryList: [Category]?
    var action = [UIAction]()
    var categoryID = 1
    var didSelectCategory = false
    
    
    var isSelectedImage:Bool = false
    var coverImage:UIImageView?

    override init() {
        super.init()
    
      //  recogDelegate = self
    }
 
    func setSelectImageStatus(status:Bool) {
        isSelectedImage = status
    }
    func checkIsEmptyFields(title:String, view:UIViewController) -> Bool{
      
        let trimmedString = title.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmedString.isEmpty   {
           
            return true
        }else{
            return false
        }
    }
    func getCategory(completion: @escaping (Bool) -> Void) {
        
        WebService.shared.getCategories { result in
            switch result {
            case .success(let success):
                self.categoryList = success.results
                  completion(true)
            case .failure(let fail):
                print (fail)
            }
        }
 
    }
    func getDropDownActions() -> [UIAction] {
        var categoryActionMap: [UIAction: Int] = [:]
         action.removeAll()
        let optionClosure = { [self] (action: UIAction) in
            guard let selectedCategoryIndex = categoryActionMap[action] else {
                return
            }
             
            if selectedCategoryIndex != -1 {
                self.categoryID = selectedCategoryIndex
                self.didSelectCategory = true
        
            }else{
                self.didSelectCategory = false
            }
        }
        for i in stride(from: 0, to: (categoryList?.count ?? 0) + 1, by: 1) {
            if i == 0 {
                action.append( UIAction(title: "Select..", state: .on, handler: optionClosure))
                categoryActionMap[action[0]] = -1
            }else {
                let categoryAction = UIAction(title: String(categoryList?[i-1].name! ?? ""), state: .on, handler: optionClosure)
                  
                  // Map the action to its corresponding index
                categoryActionMap[categoryAction] = categoryList?[i-1].id
                  
                  action.append(categoryAction)
            }
        }
     
   
        return action
    }
}


/// IMAGE RECOGNIZER
extension CreateQuizViewModel:UIImagePickerControllerDelegate,UINavigationControllerDelegate {
//    func getUiViewController(view: UIViewController) {
//        uiView = view
// 
//    }
    
//    func recognizer(imageView:UIImageView) {
//        
//        
//        recogDelegate?.getUiViewController(view: view)
//        imageView.isUserInteractionEnabled = true
//        coverImage = imageView
//        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(chooseImage))
//        coverImage!.addGestureRecognizer(gestureRecognizer)
// 
//    }
//    
//    @objc func chooseImage() {
//         
//        let picker = UIImagePickerController()
//        picker.delegate = self
//        picker.sourceType = .photoLibrary
//        uiView?.present(picker,animated: true,completion: nil)
//  
//    }
    
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        coverImage?.image = info[.originalImage] as? UIImage
//        uiView?.dismiss(animated: true)
//       
//        isSelectedImage = true
//        
//    }
//    
    
  
     
}
