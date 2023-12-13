//
//  CreatePublishingViewModel.swift
//  quiz
//
//  Created by Omer on 9.11.2023.
//

import Foundation
import RxSwift
import UIKit

struct CreatePublishingViewModel {
    
    var categoryList = BehaviorSubject<[Category]>(value: [Category]())
    let webService = WebService.shared
    init() {
        self.categoryList = WebService.shared.categoryList
    }
    
    func getCategory(completion: @escaping (String?) -> Void) {
        
          webService.AFGetRequest(requestType: WebService.GetRequestTypes.category, url:webService.categoryURL, modelResponseType: CategoryResponse.self, completion: completion)
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
}
