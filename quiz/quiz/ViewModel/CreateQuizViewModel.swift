//
//  CreateQuizViewModel.swift
//  quiz
//
//  Created by Omer on 9.11.2023.
//

import Foundation
import UIKit

final class CreateQuizViewModel: NSObject {
    var categoryList: [Category]?
    var action = [UIAction]()
    var categoryID = 1
    var didSelectCategory = false

    var isSelectedImage: Bool = false
    var coverImage: UIImageView?
    var callbackCategoryFailed: CallBack<String>?

    func setSelectImageStatus(status: Bool) {
        isSelectedImage = status
    }
    func checkIsEmptyFields(title: String, view: UIViewController) -> Bool {

        let trimmedString = title.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmedString.isEmpty {

            return true
        } else {
            return false
        }
    }
    func getCategory(completion: @escaping (Bool) -> Void) {

        WebService.shared.getCategories { result, _ in
            switch result {
            case .success(let success):
                self.categoryList = success.results
                  completion(true)
            case .failure(let fail):

                self.callbackCategoryFailed?(fail.localizedDescription)

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

            } else {
                self.didSelectCategory = false
            }
        }
        for index in stride(from: 0, to: (categoryList?.count ?? 0) + 1, by: 1) {
            if index == 0 {
                action.append( UIAction(title: "Category", state: .on, handler: optionClosure))
                categoryActionMap[action[0]] = -1
            } else {
                let categoryAction = UIAction(title: String(categoryList?[index-1].name! ?? ""),
                                              state: .on, handler: optionClosure)

                categoryActionMap[categoryAction] = categoryList?[index-1].id

                  action.append(categoryAction)
            }
        }
        return action
    }
}
