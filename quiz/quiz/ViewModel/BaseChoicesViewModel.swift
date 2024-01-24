//
//  BaseChoicesViewModel.swift
//  quiz
//
//  Created by Omer on 10.01.2024.
//

import Foundation
import UIKit

class BaseChoicesViewModel {
    var attachmentIds = [Int]()
    var callbackPublishQuiz:CallBack<QuizResponse>?
    var callbackFail:CallBack<Error>?
    var is_image:Bool = true
    var categoryId = 1 // default  -> onceki vcden gelen secime gore bunu setle
    
    func setVariables(is_image:Bool,attachID:[Int]) {
        self.is_image = is_image
        self.attachmentIds = attachID
    }
    
    func setCategoryID(id:Int){
        categoryId = id
    }
    func publishQuiz(title: String, image: UIImage, categoryID: Int, isVisible: Bool,is_image:Bool, attachment_ids:[Int]){
        
        WebService.shared.postQuiz(title: title, image:image , categoryID: categoryID, isVisible: true, is_image: true, attachment_ids: attachment_ids){ result in
           
            
            switch result{
                
            case .success(let quiz):
                self.attachmentIds.removeAll()
                    
                self.callbackPublishQuiz?(quiz)
 
             case .failure(let error):
        
                
                self.callbackFail?(error)
 
            }
        }
  
    }
}
