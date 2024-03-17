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
    var callbackPublishQuiz: CallBack<QuizResponse>?
    var callbackFail: CallBack<Error>?
    var isImage: Bool = true
    var categoryId = 1

    func setVariables(isImage: Bool, attachID: [Int]) {
        self.isImage = isImage
        self.attachmentIds = attachID
    }

    func setCategoryID(id: Int) {
        categoryId = id
    }
    func publishQuiz(title: String,
                     image: UIImage,
                     categoryID: Int,
                     isVisible: Bool,
                     isImage: Bool,
                     attachmentIds: [Int]) {

        WebService.shared.postQuiz(title: title,
                                   image: image,
                                   categoryID: categoryID,
                                   isVisible: true,
                                   isImage: isImage,
                                   attachmentIds: attachmentIds) { result in
            switch result {

            case .success(let quiz):
                self.attachmentIds.removeAll()

                self.callbackPublishQuiz?(quiz)

             case .failure(let error):
                self.callbackFail?(error)

            }
        }

    }
}
