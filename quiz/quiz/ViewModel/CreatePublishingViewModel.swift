//
//  CreatePublishingViewModel.swift
//  quiz
//
//  Created by Omer on 9.11.2023.
//

import Foundation
import RxSwift

class CreatePublishingViewModel {
    
    var categoryList = BehaviorSubject<[CategoryClass]>(value: [CategoryClass]())

    init() {
        self.categoryList = WebService.shared.categoryList
    }
    
    func getCategory() {
        WebService.shared.getCategories()
    }
}
