//
//  HomeViewModel.swift
//  quiz
//
//  Created by Omer on 9.11.2023.
//

import Foundation
import RxSwift

class HomeViewModel {
    
    var categoryList = BehaviorSubject<[CategoryClass]>(value: [CategoryClass]())
    
    init() {
        self.categoryList = WebService.shared.categoryList
    }
    func getCategories() {
        print("list count \(categoryList)")
        WebService.shared.getCategories()
    }
}
