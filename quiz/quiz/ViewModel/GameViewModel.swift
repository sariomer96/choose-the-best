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
    mutating func matchQuiz(quiz:QuizResponse, playableCount:Int) {
        
        var tempAttachList = quiz.attachments
        
        for i in stride(from: 0, to: playableCount, by: 1) {
            
           let attachElement = tempAttachList.randomElement()
            randomChooseAttachList.append(attachElement!)
   
           
             
            if let index = tempAttachList.firstIndex(of: attachElement!) {
             tempAttachList.remove(at: index)
          }
        }
        
 
        for i in stride(from: 0, to: randomChooseAttachList.count, by: 2) {
            
            var match = [Attachment]()
            for j in stride(from:i, to: i+2 , by: 1){
                match.append(randomChooseAttachList[j])
            }
            matchedList.append(match)
           
        }
        print(matchedList)
    }
    
}
