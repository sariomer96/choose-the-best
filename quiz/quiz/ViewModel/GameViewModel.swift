//
//  GameViewModel.swift
//  quiz
//
//  Created by Omer on 9.11.2023.
//

import Foundation
import UIKit
  
protocol GameViewModelProtocol {
    var callbackShowAlert: CallBack<(alertTitle: String, description: String )>? { get set }
    var callbackSetImageURL:CallBack<(String,String)>? { get set }
    var callbackSetTitle:CallBack<(String,String)>? { get set }
    var callbackWin:CallBack<Attachment>? { get set }
    var callbackShowPopUp:CallBack<(String,String)>? { get set }
    var callbackDisableUIElements:VoidCallBack? {get set}
    var callbackSetRoundText:CallBack<String>? {get set}
    var callbackImageMoveCenter:CallBack<Int>? {get set}
}

final class GameViewModel: GameViewModelProtocol/* ImageViewPro,SetLabels*/ {
    var callbackWin: CallBack<Attachment>?
    
     
    var callbackImageMoveCenter: CallBack<Int>?
    
    var callbackSetRoundText: CallBack<String>?
    
    var callbackDisableUIElements: VoidCallBack?
    
    
    
    var callbackShowPopUp: CallBack<(String, String)>?
    
    var callbackSetTitle: CallBack<(String, String)>?
    
    var callbackSetImageURL: CallBack<(String,String)>?
    var callBackSetSideImage: CallBack<(Double,Int)>?
    var callbackShowAlert: CallBack<(alertTitle: String, description: String)>?
 
    var matchedAttachs = [[Attachment]]()
  
    var winAttachs = [Attachment]()
      
    var playableCount: Int?
 
    var isFinishQuiz = false
    
    var startIndex = 0
    var quiz:QuizResponse?
    var rate = 0
    var isRateSelected = false
    var vote = false
    var roundIndex = 1
 
   
  

    // match quiz
    
    var randomChooseAttachList = [Attachment]()
    var matchedList = [[Attachment]]()
   
 
    enum ImageSide {
       case leftImage
       case rightImage
    }
    func setPlayableCount(count: Int) {
          playableCount  = count
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
    
    func imageTap(imageViewLeft:UIImageView,imageViewRight:UIImageView) {
    
     let tapGestureLeft = UITapGestureRecognizer(target: self, action: #selector(imageClickedLeft))
     let tapGestureRight = UITapGestureRecognizer(target: self, action: #selector(imageClickedRight))

       imageViewLeft.addGestureRecognizer(tapGestureLeft)
       imageViewLeft.isUserInteractionEnabled = true
    
       imageViewRight.addGestureRecognizer(tapGestureRight)
       imageViewRight.isUserInteractionEnabled = true
    }
    func setImages(index:Int) {
         
         let quiz = matchedAttachs[index]
          
        guard let quiz0 = quiz[0].image , let quiz1 = quiz[1].image else{return}
        callbackSetImageURL?((quiz0,quiz1))
 
    }
    func setTitle(index:Int) {
           
        guard let leftTitle = matchedAttachs[index][0].title,
              let rightTitle = matchedAttachs[index][1].title else {return}
        
        callbackSetTitle?((leftTitle,rightTitle))
    }
    func getAttachmentID(side:Int) -> Int{
        
        let id =  matchedAttachs[startIndex][side].id
         return id!
         
    }
    @objc func imageClickedLeft() {
        
        let id =   getAttachmentID(side: 0)
        setAttachmentScore(attachID: id) {
            result in
         
        }
        self.fadeInOrOut(alpha: 0.0, side: 0)
        self.fadeInOrOut(alpha: 0.0, side: 1)
       
  
        
        winAttachs.append(matchedAttachs[startIndex][0])
       
        startIndex += 1
        roundIndex += 1
      
        if startIndex < matchedAttachs.count {
            setImages(index: startIndex)
            setTitle(index: startIndex)
        }
        if winAttachs.count  == matchedAttachs.count  {
      
            getNextTour(winImageSide: 0)
            return
        }
        setRound(roundIndex: roundIndex, tourCount: matchedAttachs.count)
    }
    func setPopUpView(imageUrl:String,title:String) {
        
        callbackShowPopUp?((imageUrl,title))
     }
    func winState(winImageSide:Int ) -> Bool {
        if winAttachs.count == 1 {
           
        
            let upper = winAttachs[0].title?.uppercased()
            guard let upper = upper else {return false}
            callbackWin?(winAttachs[0])
         
            let url = winAttachs[0].image!
            setPopUpView(imageUrl: url, title: upper ?? "")
            isFinishQuiz = true
 
            imageMoveToCenter(winImageSide: winImageSide)
             return true
        }
        return false
    }
    func imageMoveToCenter(winImageSide:Int) {
        
        callbackImageMoveCenter?(winImageSide)
      
    }
    func getNextTour(winImageSide:Int) {
         
       var finish =   winState(winImageSide: winImageSide)
         
        if finish == true{
            disableLabels()
            return
        }
        
        playableCount = playableCount!/2
        resetIndexes()
        matchedAttachs = matchQuiz(attachment: winAttachs, playableCount: playableCount!)
   
        setRound(roundIndex: roundIndex, tourCount: matchedAttachs.count)
        setImages(index: startIndex)
        setTitle(index: startIndex)
        winAttachs.removeAll()
        
    }
    func resetIndexes() {
        startIndex = 0
        roundIndex = 1
    }
   
    @objc func imageClickedRight() {
       
        let id =   getAttachmentID(side: 1)
        setAttachmentScore(attachID: id) {
            result in
      
        }
        
        self.fadeInOrOut(alpha: 0.0, side: 0)
        self.fadeInOrOut(alpha: 0.0, side: 1)
        
        winAttachs.append(matchedAttachs[startIndex][1])
      
        startIndex += 1
        roundIndex += 1
       
        if startIndex < matchedAttachs.count {
            setImages(index: startIndex)
            setTitle(index: startIndex)
        }
        if winAttachs.count  == matchedAttachs.count  {
          
            getNextTour(winImageSide: 1)
            return
        }
        setRound(roundIndex: roundIndex, tourCount: matchedAttachs.count)
    }
    func setRound(roundIndex:Int, tourCount:Int) {
        
        callbackSetRoundText?("\(roundIndex) / \(tourCount)")
      //  roundLabel?.text = "\(roundIndex) / \(tourCount)"
    }
    func fadeInOrOut(alpha:Double, side:Int) {
        
          
          callBackSetSideImage?((alpha,side))
       
    }
    
    func disableLabels() {
        
        callbackDisableUIElements?()
    
    }
     
    func setAttachmentScore(attachID:Int,completion: @escaping (String) -> Void) {
        
        WebService.shared.setAttachmentScores(attachID: attachID) {
            result in
            switch result {
                
            case .success(let success):
                  print(success)
            case .failure(let fail):
                print(fail)
            }
        }
    }
     func startQuiz() {
        
        matchedAttachs =  matchQuiz(attachment: quiz!.attachments, playableCount: playableCount!)
     
       
        setRound(roundIndex: 1, tourCount: matchedAttachs.count)
         
        setImages(index: startIndex)
        setTitle(index: startIndex)
    }
    
}

 
