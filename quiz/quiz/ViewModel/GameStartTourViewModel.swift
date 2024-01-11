//
//  GameStartTourViewModel.swift
//  quiz
//
//  Created by Omer on 2.12.2023.
//

import Foundation
import UIKit

let roundsKey = [
    "final",
    "semi",
    "quarter",
    "round16",
    "round32",
    "round64",
    "round128"
]
class GameStartTourViewModel {
    var rounds = [2,4,8,16,32,64,128]
    var defaulPlayableCount = 2
    var maxPlayableCount = 2
    var quiz:QuizResponse?
 
    var action = [UIAction]()
   
    
    enum Round:String{
        case final
        case semi
        case quarter
        case round16
        case round32
        case round64
        case round128
    }
    func getDropDownActions(attachmentCount:Int,completion: @escaping (Int) -> Void) -> [UIAction] {
      
        let optionClosure = { [self] (action : UIAction) in
              
            switch action.title{
            case Round.final.rawValue:
                completion(self.rounds[0])
            case Round.semi.rawValue:
                completion(self.rounds[1])
            case Round.quarter.rawValue:
                completion(self.rounds[2])
            case Round.round16.rawValue:
                completion(self.rounds[3])
            case Round.round32.rawValue:
                completion(self.rounds[4])
            case Round.round64.rawValue:
                completion(self.rounds[5])
            case Round.round128.rawValue:
                completion(self.rounds[6])


            default:
                completion(self.rounds[0])
                
            }
           
        }
     
        let round =  getClosestRound(count: (attachmentCount), rounds: rounds, completion: completion)
       
        
      
        let index =  rounds.firstIndex(of: round!)
        
  
         
        for i in stride(from: 0, to: index!+1, by: 1) {

   
            action.append(UIAction(title: roundsKey[i], state : .on , handler: optionClosure))

        }
        
        return action
    }
 
    func getClosestRound(count:Int, rounds:[Int], completion: @escaping (Int) -> Void) -> Int? {
        
        
        guard let closest = rounds.filter({ $0 <= count }).max() else {
            return nil
        }
          // completion(closest)
        return closest
    }
}
