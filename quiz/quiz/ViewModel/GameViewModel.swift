//
//  GameViewModel.swift
//  quiz
//
//  Created by Omer on 9.11.2023.
//

import Foundation
import UIKit

protocol ImageViewPro {
 
    var leftImageView:UIImageView {get set}
    var rightImageView:UIImageView {get set}
    
}

protocol AttachListPro {
    var matchedAttachs:[[Attachment]] { get set }
    var winAttachs:[Attachment] {get set}
}
protocol AttachTitlePro {
    var leftTitleLabel:UILabel {get set}
    var rightTitleLabel:UILabel {get set}
    var roundLabel:UILabel {get set}
    var winLabel:UILabel {get set}
}
protocol PlayableCount {
    var playableCount:Int {get set}
}

class GameViewModel:ImageViewPro,AttachListPro,AttachTitlePro,PlayableCount {
    
    var view:UIView = UIView()
    var playableCount: Int
    
    var winLabel: UILabel
    
    var roundLabel: UILabel
    
    var winAttachs: [Attachment]
    
    var leftImageView: UIImageView
    
    var rightImageView: UIImageView
    
    var matchedAttachs: [[Attachment]]
    
    var leftTitleLabel: UILabel
    
    var rightTitleLabel: UILabel
    var isFinishQuiz = false
    
    init(leftImageView: UIImageView, rightImageView: UIImageView, matchedAttachs: [[Attachment]], leftTitleLabel: UILabel, rightTitleLabel: UILabel,
         playableCount:Int,roundLabel:UILabel,winAttachs:[Attachment],winLabel:UILabel) {
        self.leftImageView = leftImageView
        self.rightImageView = rightImageView
        self.matchedAttachs = matchedAttachs
        self.leftTitleLabel = leftTitleLabel
        self.rightTitleLabel = rightTitleLabel
     
        self.winLabel = winLabel
        self.roundLabel = roundLabel
        self.playableCount = playableCount
        self.winAttachs = winAttachs
    }
    
    
    // match quiz
    var startIndex = 0
    var roundIndex = 1
    var randomChooseAttachList = [Attachment]()
    var matchedList = [[Attachment]]()
    var action = [UIAction]()
    var rates = [0,1,2,3,4,5]
//    let rateKey = [
//        "final",
//        "semi",
//        "quarter",
//        "round16",
//        "round32",
//        "round64",
//        "round128"
//    ]
    
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
                completion(self.rates[3])
              
            }
           
        }
        for i in rates {
            action.append(UIAction(title: String(i), state : .on , handler: optionClosure))
        }

        
        return action
    }
    func matchQuiz(attachment:[Attachment], playableCount:Int) -> [[Attachment]] {
        
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
        
        leftImageView.kf.setImage(with: URL(string: matchedAttachs[index][0].image!)) { [self]
            res in
            fadeInOrOut(alpha: 1.0, imageView: leftImageView)
        }
        rightImageView.kf.setImage(with: URL(string: matchedAttachs[index][1].image!)) { [self]
            _ in
            fadeInOrOut(alpha: 1.0, imageView: rightImageView)
        }
    }
    func setTitle(index:Int) {
        
        leftTitleLabel.text = matchedAttachs[index][0].title!
        rightTitleLabel.text = matchedAttachs[index][1].title!
    }
    @objc func imageClickedLeft() {
        
        self.fadeInOrOut(alpha: 0.0, imageView: leftImageView)
        self.fadeInOrOut(alpha: 0.0, imageView: rightImageView)
  
        winAttachs.append(matchedAttachs[startIndex][0])
       
        startIndex += 1
        roundIndex += 1
      
        if startIndex < matchedAttachs.count {
            setImages(index: startIndex)
            setTitle(index: startIndex)
        }
        if winAttachs.count  == matchedAttachs.count  {
            print("tur bitti")
            getNextTour(winImageView: leftImageView)
            return
        }
        setRound(roundIndex: roundIndex, tourCount: matchedAttachs.count)
    }
    func winState(winImageView:UIImageView ) -> Bool {
        if winAttachs.count == 1 {
            print("WIIINN")
            let upper = winAttachs[0].title?.uppercased()
            winLabel.textColor = .systemRed
            winLabel.text = "\(upper!) WIN!!"
       
            isFinishQuiz = true
            rightImageView.isUserInteractionEnabled = false
            leftImageView.isUserInteractionEnabled = false
           
            imageMoveToCenter(winImageView: winImageView)
             return true
        }
        return false
    }
    func imageMoveToCenter(winImageView:UIImageView) {
        winImageView.alpha = 1
  
        winImageView.translatesAutoresizingMaskIntoConstraints = false
         view.addSubview(winImageView)

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
        
        playableCount = playableCount/2
        resetIndexes()
        matchedAttachs = matchQuiz(attachment: winAttachs, playableCount: playableCount)
   
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
       
        self.fadeInOrOut(alpha: 0.0, imageView: leftImageView)
        self.fadeInOrOut(alpha: 0.0, imageView: rightImageView)
 
        winAttachs.append(matchedAttachs[startIndex][1])
      
        startIndex += 1
        roundIndex += 1
       
        if startIndex < matchedAttachs.count {
            setImages(index: startIndex)
            setTitle(index: startIndex)
        }
        if winAttachs.count  == matchedAttachs.count  {
            print("tur bitti")
            getNextTour(winImageView: rightImageView)
            return
        }
        setRound(roundIndex: roundIndex, tourCount: matchedAttachs.count)
    }
    func setRound(roundIndex:Int, tourCount:Int) {
        roundLabel.text = "\(roundIndex) / \(tourCount)"
    }
    func fadeInOrOut(alpha:Double, imageView:UIImageView) {
        UIView.animate(withDuration: 1.1, animations: {
                  imageView.alpha = alpha
            })
    }
    
    func disableLabels() {
        leftTitleLabel.isHidden = true
        rightTitleLabel.isHidden = true
        roundLabel.isHidden = true
        
    }
    
}

 
