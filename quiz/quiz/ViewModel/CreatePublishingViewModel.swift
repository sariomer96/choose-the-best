//
//  CreatePublishingViewModel.swift
//  quiz
//
//  Created by Omer on 9.11.2023.
//

import Foundation
import UIKit

class CreatePublishingViewModel {
    
    var categoryList: [Category]?
    let webService = WebService.shared
    var callbackPublishQuiz:CallBack<QuizResponse>?
    var callbackFail:CallBack<Error>?
    var action = [UIAction]()
    var is_image:Bool = true
    var didSelectCategory = false
 
    var isVisible = true
 
    var attachmentIds = [Int]()
  
    func setVariables(is_image:Bool,attachID:[Int]) {
        self.is_image = is_image
        self.attachmentIds = attachID
    }
 
    
    func publishQuiz(title: String, image: UIImage, categoryID: Int, isVisible: Bool,is_image:Bool, attachment_ids:[Int]){
        
        WebService.shared.postQuiz(title: title, image:image , categoryID: categoryID, isVisible: true, is_image: true, attachment_ids: attachment_ids){ result in
           
            
            switch result{
                
            case .success(let quiz):
                self.attachmentIds.removeAll()
                self.callbackPublishQuiz?(quiz)
 
             case .failure(let error):
                 print(error)
                
                self.callbackFail?(error)
             }
        }
  
    }

}

