//
//  GameViewModel.swift
//  quiz
//
//  Created by Omer on 9.11.2023.
//

import Foundation
import UIKit

protocol ImageViewPro {
 
    var leftImageView:UIImageView? {get set}
    var rightImageView:UIImageView? {get set}
    
}


protocol SetLabels {
    var leftTitleLabel:UILabel? {get set}
    var rightTitleLabel:UILabel? {get set}
    var roundLabel:UILabel? {get set}
    var winLabel:UILabel? {get set}
}
protocol PlayableCount {
    var playableCount:Int? {get set}
}

class GameViewModel:ImageViewPro,SetLabels,PlayableCount {
    var playableDelegate:PlayableCount?
    var attachTitleDelegate:SetLabels?

    var imageViewDelegate:ImageViewPro?
    
    
    var matchedAttachs = [[Attachment]]()
  
    var winAttachs = [Attachment]()
    
    
    var view:UIView = UIView()
    var playableCount: Int?
    var winLabel: UILabel?
    var roundLabel: UILabel?
    var leftImageView: UIImageView?
    var rightImageView: UIImageView?
    var leftTitleLabel: UILabel?
    var rightTitleLabel: UILabel?
    
    var isFinishQuiz = false
    
    var startIndex = 0
    var quiz:QuizResponse?
    var rate = 0
    var isRateSelected = false
    var vote = false
    var roundIndex = 1
    var viewController:UIViewController?
   
    
    init() {
        playableDelegate = self
        attachTitleDelegate = self
        imageViewDelegate = self
    }
    
    // match quiz
    
    var randomChooseAttachList = [Attachment]()
    var matchedList = [[Attachment]]()
    var action = [UIAction]()
    var rates = [0,1,2,3,4,5]
 
    func getDropDownActions(completion: @escaping (Int) -> Void) -> [UIAction] {
      
        let optionClosure = { [self] (action : UIAction) in
                 
            print(action.title)
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
        
        print("match worked \(playableCount)  \(attachment)")
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
        
        print("COUNTL  :  \(matchedList.count)")
        leftImageView?.kf.setImage(with: URL(string: matchedAttachs[index][0].image!)) { [self]
            res in
            fadeInOrOut(alpha: 1.0, imageView: leftImageView ?? UIImageView())
        }
        rightImageView?.kf.setImage(with: URL(string: matchedAttachs[index][1].image!)) { [self]
            _ in
            fadeInOrOut(alpha: 1.0, imageView: rightImageView ?? UIImageView())
        }
    }
    func setTitle(index:Int) {
        
        leftTitleLabel?.text = matchedAttachs[index][0].title!
        rightTitleLabel?.text = matchedAttachs[index][1].title!
    }
    func getAttachmentID(side:Int) -> Int{
        
        let id =  matchedAttachs[startIndex][side].id
         return id!
         
    }
    @objc func imageClickedLeft() {
        
        let id =   getAttachmentID(side: 0)
        setAttachmentScore(attachID: id) {
            result in
            print(result)
        }
        self.fadeInOrOut(alpha: 0.0, imageView: leftImageView ?? UIImageView())
        self.fadeInOrOut(alpha: 0.0, imageView: rightImageView ?? UIImageView())
  
        
        winAttachs.append(matchedAttachs[startIndex][0])
       
        startIndex += 1
        roundIndex += 1
      
        if startIndex < matchedAttachs.count {
            setImages(index: startIndex)
            setTitle(index: startIndex)
        }
        if winAttachs.count  == matchedAttachs.count  {
            print("tur bitti")
            getNextTour(winImageView: leftImageView ?? UIImageView())
            return
        }
        setRound(roundIndex: roundIndex, tourCount: matchedAttachs.count)
    }
    func winState(winImageView:UIImageView ) -> Bool {
        if winAttachs.count == 1 {
           
            let upper = winAttachs[0].title?.uppercased()
            winLabel?.textColor = .systemRed
            winLabel?.text = "\(upper!) WIN!!"
       
            isFinishQuiz = true
            rightImageView?.isUserInteractionEnabled = false
            leftImageView?.isUserInteractionEnabled = false
           
            imageMoveToCenter(winImageView: winImageView)
             return true
        }
        return false
    }
    func imageMoveToCenter(winImageView:UIImageView) {
        winImageView.alpha = 1
  
        winImageView.translatesAutoresizingMaskIntoConstraints = false
         //view.addSubview(winImageView)

        NSLayoutConstraint.activate([
            winImageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            winImageView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        ])
    }
    func getNextTour(winImageView:UIImageView) {
         
       var finish =   winState(winImageView: winImageView)
         
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
            print(result)
        }
        
        self.fadeInOrOut(alpha: 0.0, imageView: leftImageView ?? UIImageView())
        self.fadeInOrOut(alpha: 0.0, imageView: rightImageView ?? UIImageView())
 
        winAttachs.append(matchedAttachs[startIndex][1])
      
        startIndex += 1
        roundIndex += 1
       
        if startIndex < matchedAttachs.count {
            setImages(index: startIndex)
            setTitle(index: startIndex)
        }
        if winAttachs.count  == matchedAttachs.count  {
            print("tur bitti")
            getNextTour(winImageView: rightImageView ?? UIImageView())
            return
        }
        setRound(roundIndex: roundIndex, tourCount: matchedAttachs.count)
    }
    func setRound(roundIndex:Int, tourCount:Int) {
        roundLabel?.text = "\(roundIndex) / \(tourCount)"
    }
    func fadeInOrOut(alpha:Double, imageView:UIImageView) {
        UIView.animate(withDuration: 1.1, animations: {
                  imageView.alpha = alpha
            })
    }
    
    func disableLabels() {
        leftTitleLabel?.isHidden = true
        rightTitleLabel?.isHidden = true
        roundLabel?.isHidden = true
        
    }
    
    func rateQuiz() {
        WebService.shared.rateQuiz(quizID: quiz?.id ?? 1, rateScore: rate) { result in
            
            AlertManager.shared.alert(view: self.viewController ?? UIViewController(), title: "Alert", message: result)
        }
    }
    func setAttachmentScore(attachID:Int,completion: @escaping (String) -> Void) {
        WebService.shared.setAttachmentScore(attachID: attachID, completion: completion)
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
        print("quiz \(quiz)   play \(playableCount)")
        matchedAttachs =  matchQuiz(attachment: quiz!.attachments, playableCount: playableCount!)
     
       
        setRound(roundIndex: 1, tourCount: matchedAttachs.count)
         
        setImages(index: startIndex)
        setTitle(index: startIndex)
    }
    
}

 
