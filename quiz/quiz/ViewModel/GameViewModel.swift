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
 
    var callbackImageMoveCenter:CallBack<Int>? {get set}
}

final class GameViewModel: BaseGameViewModel,GameViewModelProtocol{
    var callbackWin: CallBack<Attachment>?
    
     
    var callbackImageMoveCenter: CallBack<Int>?
 
    var callbackDisableUIElements: VoidCallBack?
    var callbackShowPopUp: CallBack<(String, String)>?
    
    var callbackSetTitle: CallBack<(String, String)>?
    
    var callbackSetImageURL: CallBack<(String,String)>?
    var callBackSetSideImage: CallBack<(Double,Int)>?
    var callbackShowAlert: CallBack<(alertTitle: String, description: String)>?
 
 
  
    var winAttachs = [Attachment]()
      
    var playableCount: Int?
 
    var isFinishQuiz = false
  
    var quiz:QuizResponse?
    var rate = 0
    var isRateSelected = false
    var vote = false
    
    
    // match quiz
    
    var randomChooseAttachList = [Attachment]()
   
 
    enum ImageSide {
       case leftImage
       case rightImage
    }
    func setPlayableCount(count: Int) {
          playableCount  = count
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
         
        if matchedList.count == 0 || matchedList.count <= index{
            return
        }
         let quiz = matchedAttachs[index]
          
        guard let quiz0 = quiz[0].image , let quiz1 = quiz[1].image else{return}
        callbackSetImageURL?((quiz0,quiz1))
 
    }
    func setTitle(index:Int) {
           
        if matchedList.count == 0 || matchedList.count <= index{
            return
        }
        guard let leftTitle = matchedAttachs[index][0].title,
              let rightTitle = matchedAttachs[index][1].title else {return}
        
        callbackSetTitle?((leftTitle,rightTitle))
    }
   
    @objc func imageClickedLeft() {
        
        let id =   getAttachmentID(side: 0)
        setAttachmentScore(attachID: id)
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
        print(matchedAttachs.count)
        let result = Int(log2(Double(matchedAttachs.count)))
        self.setRoundName( index: result)
        setRound(roundIndex: roundIndex, tourCount: matchedAttachs.count)
        setImages(index: startIndex)
        setTitle(index: startIndex)
        winAttachs.removeAll()
        
    }
 
   
    @objc func imageClickedRight() {
       
        let id =   getAttachmentID(side: 1)
        setAttachmentScore(attachID: id)
        
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
  
    func fadeInOrOut(alpha:Double, side:Int) {
         
          callBackSetSideImage?((alpha,side))
       
    }
    
    func disableLabels() {
        
        callbackDisableUIElements?()
    
    }
    
     func startQuiz() {
        
        matchedAttachs =  matchQuiz(attachment: quiz!.attachments, playableCount: playableCount!)
         let result = Int(log2(Double(matchedAttachs.count)))
         self.setRoundName(index: result)
        setRound(roundIndex: 1, tourCount: matchedAttachs.count)
         
        setImages(index: startIndex)
        setTitle(index: startIndex)
    }
    
    
}

 
