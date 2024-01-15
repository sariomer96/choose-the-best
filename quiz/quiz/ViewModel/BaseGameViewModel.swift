//
//  BaseGameViewModel.swift
//  quiz
//
//  Created by Omer on 15.01.2024.
//

import Foundation

class BaseGameViewModel : BaseViewModel {
    
    var callbackSetRoundLabel:CallBack<String>?
    var callbackRoundName: CallBack<String>?
    var matchedList = [[Attachment]]()
    var startIndex = 0
    var matchedAttachs = [[Attachment]]()
    var roundIndex = 1
    
    func getAttachmentID(side:Int) -> Int{
        
        let id =  matchedAttachs[startIndex][side].id
         return id!
         
    }
    
    func setRoundName(index:Int) {
        let name =  roundsKey[index]
      
        callbackRoundName?(name)
    }
    func setRound(roundIndex:Int,tourCount:Int) {
        callbackSetRoundLabel?("\(roundIndex) / \(tourCount)")
       // roundLabel.text = "\(roundIndex) / \(tourCount)"
    }
    func setAttachmentScore(attachID:Int) {
        
        WebService.shared.setAttachmentScores(attachID: attachID) {
            result in
        }
    }
    
    func matchQuiz(attachment:[Attachment], playableCount:Int) -> [[Attachment]] {
         
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
       return matchedList
    }
    
    func resetIndexes() {
        startIndex = 0
        roundIndex = 1
    }
}
