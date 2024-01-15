//
//  GamePopUpViewModel.swift
//  quiz
//
//  Created by Omer on 12.01.2024.
//

import Foundation
import UIKit

class GamePopUpViewModel {
    var attachment:Attachment?
    var quiz:QuizResponse?
    var isRateSelected = false
    var vote = false
    var action = [UIAction]()
    var rates = [0,1,2,3,4,5]
    var rate = 0
    var callbackShowAlert: CallBack<(alertTitle: String, description: String)>?
    var callbackRateQuiz: VoidCallBack?
    
    func getDropDownActions(completion: @escaping (Int) -> Void) -> [UIAction] {
      
        let optionClosure = { [self] (action : UIAction) in
             
            switch action.title{
            case String(rates[0]):
                completion(self.rates[0])
            case String(rates[1]):
                completion(self.rates[1])
            case String(rates[2]):
                completion(self.rates[2])
            case String(rates[3]):
                completion(self.rates[3])
            case String(rates[4]):
                completion(self.rates[4])
            case String(rates[5]):
                completion(self.rates[5])
        
            default:
                completion(-1)
              
            }
           
        }
        action.append(UIAction(title: "Rate Quiz", state : .on , handler: optionClosure))
        for i in rates {
            action.append(UIAction(title: String(i), state : .on , handler: optionClosure))
        }

        
        return action
    }
    func showRateDropDown(dropDownButton:UIButton) {
        let  action = getDropDownActions(completion: { result in
            
            if result > -1 {
                self.isRateSelected = true
                self.rate = result
                self.vote = true
                self.callbackRateQuiz?()
                
            }else {
                self.isRateSelected = false
            }
      
        })
      
        if  action != nil {
            
            dropDownButton.menu = UIMenu(children : action)
     
            dropDownButton.showsMenuAsPrimaryAction = true
            dropDownButton.changesSelectionAsPrimaryAction = true
        }
    }
    
    func rateQuiz() {
        WebService.shared.rateQuiz(quizID: self.quiz?.id ?? 1, rateScore: rate) { result in
            switch result {
            case .success(_): // let response
                self.callbackShowAlert?(("Alert", "Rate success"))

            case .failure(let error):
                print(error)
            }
        }
    }
}