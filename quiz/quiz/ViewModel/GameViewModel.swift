//
//  GameViewModel.swift
//  quiz
//
//  Created by Omer on 9.11.2023.
//

import Foundation

struct GameViewModel {
    // match quiz

    var randomChooseAttachList = [Attachment]()
    var matchedList = [[Attachment]]()
    mutating func matchQuiz(attachment:[Attachment], playableCount:Int) -> [[Attachment]] {
        
        print("match worked")
        matchedList.removeAll()
        var tempAttachList = attachment
        
      
        tempAttachList.shuffle()
      
              
        for i in stride(from: 0, to: playableCount/2, by: 1) {
            
            var match = [Attachment]()
            for j in stride(from:i, to: i+2 , by: 1){
 
             
                match.append(tempAttachList[0])
                tempAttachList.remove(at: 0)
            }
            matchedList.append(match)
           
           
        }
        print(matchedList.count)
       return matchedList
    }
   

    
}
