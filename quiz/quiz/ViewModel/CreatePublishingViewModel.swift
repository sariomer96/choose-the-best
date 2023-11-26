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

    init() {
        self.categoryList = WebService.shared.categoryList
    }
    
    func getCategory(completion: @escaping (String?) -> Void) {
        WebService.shared.getCategories(completion: completion)
    }
    
    func publishQuiz(title: String, image: UIImage, categoryID: Int, isVisible: Bool, completion: @escaping (String?,Bool) -> Void) {
        
        WebService.shared.createQuiz(title: title, image: image, categoryID: categoryID, isVisible: isVisible, completion: completion)
    }
}
