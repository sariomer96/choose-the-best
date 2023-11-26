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
    
    func publishQuiz(title: String, image: UIImage, categoryID: Int, isVisible: Bool, completion: @escaping (String?,Bool) -> Void) {
        
        WebService.shared.createQuiz(title: title, image: image, categoryID: categoryID, isVisible: isVisible, completion: completion)
    }
}
