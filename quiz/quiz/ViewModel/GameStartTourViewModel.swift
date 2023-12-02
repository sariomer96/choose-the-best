//
//  GameStartTourViewModel.swift
//  quiz
//
//  Created by Omer on 2.12.2023.
//

import Foundation
import UIKit

class GameStartTourViewModel {
    var rounds = [2,4,8,16,32,64,128]
    var action = [UIAction]()
    
    func getDropDownActions(attachmentCount:Int) -> [UIAction] {
        let optionClosure = { (action : UIAction) in
            print(action.title)}
        
        let round =  getClosestRound(count: (attachmentCount), rounds: rounds)
       
        let index =  rounds.index(of: round!)
        
        for i in stride(from: 0, to: index!+1, by: 1) {
            action.append(UIAction(title: String(rounds[i]), state : .on , handler: optionClosure))
        }
        return action
    }
 
    func getClosestRound(count:Int, rounds:[Int]) -> Int? {
        guard let closest = rounds.filter({ $0 <= count }).max() else {
            return nil
        }

        return closest
    }
}
