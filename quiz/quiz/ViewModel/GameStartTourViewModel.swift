//
//  GameStartTourViewModel.swift
//  quiz
//
//  Created by Omer on 2.12.2023.
//

import Foundation
import UIKit

let roundsKey = [
    "Final",
    "Semi Final",
    "Quarter Round",
    "Round Of 16",
    "Round Of 32",
    "Round Of 64",
    "Round Of 128"
    
    
]

 

class GameStartTourViewModel {
    var rounds = [2,4,8,16,32,64,128]
    var defaulPlayableCount = 2
    var maxPlayableCount = 2
    var quiz:QuizResponse?
 
    var action = [UIAction]()
//   
//    
//    enum Round:String{
//        case Final
//        case SemiFinal
//        case quarter
//        case round16
//        case round32
//        case round64
//        case round128
//    }
    func getDropDownActions(attachmentCount:Int,completion: @escaping (Int) -> Void) -> [UIAction] {
      
        let optionClosure = { [self] (action : UIAction) in
              
            switch action.title{
            case roundsKey[0]:
                completion(self.rounds[0])
            case roundsKey[1]:
                completion(self.rounds[1])
            case roundsKey[2]:
                completion(self.rounds[2])
            case roundsKey[3]:
                completion(self.rounds[3])
            case roundsKey[4]:
                completion(self.rounds[4])
            case roundsKey[5]:
                completion(self.rounds[5])
            case roundsKey[6]:
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
