//
//  CreatePublishingViewModel.swift
//  quiz
//
//  Created by Omer on 9.11.2023.
//

import Foundation
import RxSwift
import UIKit

class CreatePublishingViewModel {
    
    var categoryList: [Category]?
    let webService = WebService.shared
    var action = [UIAction]()
    var is_image:Bool = true
    var didSelectCategory = false
 
    var isVisible = true
    var categoryID = 1
    var attachmentIds = [Int]()
    init() {
       // self.categoryList = WebService.shared.categoryList
    }
    
    func getCategory(completion: @escaping (Bool) -> Void) {
        
        webService.AFGetRequest(requestType: WebService.GetRequestTypes.category, url:webService.categoryURL, modelResponseType: CategoryResponse.self) {
            result in
            self.categoryList = self.webService.categoryList
              completion(true)
        }
    }
    
    func publishQuiz(uiview:UIViewController, title: String, image: UIImage, categoryID: Int, isVisible: Bool,is_image:Bool, attachment_ids:[Int]){
        
        WebService.shared.createQuiz(title: title, image: image, categoryID: categoryID, isVisible: isVisible,is_image: is_image, attachment_ids: attachment_ids) {error,isSuccess, quiz  in
           
            if isSuccess == true {
                AlertManager.shared.alert(view: uiview, title: "Success!", message: UploadSuccess.success.rawValue) { _ in
              
                    let vc = uiview.storyboard!.instantiateViewController(withIdentifier: "GameStartVC") as! GameStartVC
                    vc.quiz = quiz
                    
                    uiview.navigationController!.pushViewController(vc, animated: true)
                     //uiview.performSegue(withIdentifier: "toGameStartVC", sender: quiz)
                }
            }
            if let error = error {
                AlertManager.shared.alert(view: uiview, title: "Upload Failed!", message: error)
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
        
            }
           //" completion(selectedCategoryIndex)
            // Now you can use selectedCategoryIndex to identify which categoryList index is selected
            print("Selected category index: \(selectedCategoryIndex)")
        }
        print("categoryList \(categoryList?.count)")
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
