//
//  GameViewModel.swift
//  quiz
//
//  Created by Omer on 9.11.2023.
//

import Foundation
import UIKit

//protocol ImageViewPro {
// 
//    var leftImageView:UIImageView? {get set}
//    var rightImageView:UIImageView? {get set}
//    
//}
//
//
//protocol SetLabels {
//    var leftTitleLabel:UILabel? {get set}
//    var rightTitleLabel:UILabel? {get set}
//    var roundLabel:UILabel? {get set}
//    var winLabel:UILabel? {get set}
//}
// 



protocol GameViewModelProtocol {
    var callbackShowAlert: CallBack<(alertTitle: String, description: String )>? { get set }
    var callbackSetImageURL:CallBack<(String,String)>? { get set }
    var callbackSetTitle:CallBack<(String,String)>? { get set }
    var callbackWin:CallBack<String>? { get set }
    var callbackShowPopUp:CallBack<(String,String)>? { get set }
    var callbackDisableUIElements:VoidCallBack? {get set}
    var callbackSetRoundText:CallBack<String>? {get set}
    var callbackImageMoveCenter:CallBack<Int>? {get set}
}

final class GameViewModel: GameViewModelProtocol/* ImageViewPro,SetLabels*/ {
    var callbackWin: CallBack<String>?
    
     
    var callbackImageMoveCenter: CallBack<Int>?
    
    var callbackSetRoundText: CallBack<String>?
    
    var callbackDisableUIElements: VoidCallBack?
    
    
    
    var callbackShowPopUp: CallBack<(String, String)>?
    
    var callbackSetTitle: CallBack<(String, String)>?
    
    var callbackSetImageURL: CallBack<(String,String)>?
    var callBackSetSideImage: CallBack<(Double,Int)>?
    var callbackShowAlert: CallBack<(alertTitle: String, description: String)>?

  //  var playableDelegate:PlayableCount?
//    var attachTitleDelegate:SetLabels?
//
//    var imageViewDelegate:ImageViewPro?
    
    
    var matchedAttachs = [[Attachment]]()
  
    var winAttachs = [Attachment]()
     
  //  var view:UIView = UIView()
    var playableCount: Int?
//    var winLabel: UILabel?
//    var roundLabel: UILabel?
//    var leftImageView: UIImageView?
//    var rightImageView: UIImageView?
//    var leftTitleLabel: UILabel?
//    var rightTitleLabel: UILabel?
//    var popUpView:UIView?
    var isFinishQuiz = false
    
    var startIndex = 0
    var quiz:QuizResponse?
    var rate = 0
    var isRateSelected = false
    var vote = false
    var roundIndex = 1
   // var viewController:UIViewController?
   
    
//    init() {
//      
//        attachTitleDelegate = self
//        imageViewDelegate = self
//        
//    }

    // match quiz
    
    var randomChooseAttachList = [Attachment]()
    var matchedList = [[Attachment]]()
    var action = [UIAction]()
    var rates = [0,1,2,3,4,5]
 
    enum ImageSide {
       case leftImage
       case rightImage
    }
    func setPlayableCount(count: Int) {
          playableCount  = count
    }
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
        action.append(UIAction(title: "Select..", state : .on , handler: optionClosure))
        for i in rates {
            action.append(UIAction(title: String(i), state : .on , handler: optionClosure))
        }

        
        return action
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
//        leftImageView?.kf.setImage(with: URL(string: matchedAttachs[index][0].image!)) { [self]
//            res in
//            fadeInOrOut(alpha: 1.0, imageView: leftImageView ?? UIImageView())
//        }
//        rightImageView?.kf.setImage(with: URL(string: matchedAttachs[index][1].image!)) { [self]
//            _ in
//            fadeInOrOut(alpha: 1.0, imageView: rightImageView ?? UIImageView())
//        }
    }
    func setTitle(index:Int) {
           
        guard let leftTitle = matchedAttachs[index][0].title,
              let rightTitle = matchedAttachs[index][1].title else {return}
        
        callbackSetTitle?((leftTitle,rightTitle))
     //   leftTitleLabel?.text = matchedAttachs[index][0].title!
     //   rightTitleLabel?.text = matchedAttachs[index][1].title!
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
            callbackWin?(upper)
            
//            winLabel?.textColor = .systemRed
//            winLabel?.text = "\(upper!) WIN!!"
//            popUpView?.isHidden = false
            let url = winAttachs[0].image!
            setPopUpView(imageUrl: url, title: upper ?? "")
            isFinishQuiz = true
//            rightImageView?.isUserInteractionEnabled = false
//            leftImageView?.isUserInteractionEnabled = false
//           
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
    
    func rateQuiz() {
        WebService.shared.rateQuiz(quizID: 33, rateScore: rate) { result in
            switch result {
            case .success(_): // let response
                self.callbackShowAlert?(("Alert", "Rate success"))

            case .failure(let error):
                print(error)
            }
        }
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
    func showRateDropDown(dropDownButton:UIButton) {
        let  action = getDropDownActions(completion: { result in
            
            if result > -1 {
                self.isRateSelected = true
                self.rate = result
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
    func startQuiz() {
        
        matchedAttachs =  matchQuiz(attachment: quiz!.attachments, playableCount: playableCount!)
     
       
        setRound(roundIndex: 1, tourCount: matchedAttachs.count)
         
        setImages(index: startIndex)
        setTitle(index: startIndex)
    }
    
}

 
