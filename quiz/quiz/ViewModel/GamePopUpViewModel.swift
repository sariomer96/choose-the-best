//
//  GamePopUpViewModel.swift
//  quiz
//
//  Created by Omer on 12.01.2024.
//

import Foundation
import UIKit

final class GamePopUpViewModel {
    var attachment: Attachment?
    var quiz: QuizResponse?
    var isRateSelected = false
    var vote = false
    var action = [UIAction]()
    var rates = [0, 1, 2, 3, 4, 5]
    var rate = 0
    var callbackShowAlert: CallBack<(alertTitle: String, description: String)>?

    var callbackRateQuiz: VoidCallBack?

     func getDropDownActions(completion: @escaping (Int) -> Void) -> [UIAction] {

        let optionClosure = { [weak self] (action: UIAction) in
            guard let self = self else { return }
            let rate = Int(action.title)
            guard let rate = rate else {return}

            completion(rate)

        }
        action.append(UIAction(title: "Rate Quiz", state: .on, handler: optionClosure))
        for index in rates {
            action.append(UIAction(title: String(index), state: .on, handler: optionClosure))
        }

        return action
    }
    func showRateDropDown(dropDownButton: UIButton) {
        let  action = getDropDownActions(completion: { result in

            if result > -1 {
                self.isRateSelected = true
                self.rate = result
                self.vote = true
                self.callbackRateQuiz?()

            } else {
                self.isRateSelected = false
            }

        })

        dropDownButton.menu = UIMenu(children: action)
        dropDownButton.showsMenuAsPrimaryAction = true
    }

    func rateQuiz() {
        WebService.shared.rateQuiz(quizID: self.quiz?.id ?? 1, rateScore: rate) { result, _ in
            switch result {
            case .success(_):
                self.callbackShowAlert?(("Alert", "Rate success"))

            case .failure(let error):

                self.callbackShowAlert?(("Rate Failed", error.localizedDescription))
            }
        }
    }
}
