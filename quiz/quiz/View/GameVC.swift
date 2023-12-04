//
//  GameVC.swift
//  quiz
//
//  Created by Omer on 9.11.2023.
//

import UIKit
import Kingfisher

class GameVC: UIViewController {

    
    @IBOutlet weak var rightImageView: UIImageView!
    @IBOutlet weak var leftImageView: UIImageView!
    
    @IBOutlet weak var leftTitleLabel: UILabel!
    
    @IBOutlet weak var rightTitleLabel: UILabel!
    var startIndex = 0
    var quiz:QuizResponse?
    var playableCount = 0
    var viewModel = GameViewModel()
    var matchedAttachs = [[Attachment]]()
    var winAttachs = [Attachment]()
    override func viewDidLoad() {
        super.viewDidLoad()
        imageTap()
    }
        override func viewDidAppear(_ animated: Bool) {
           startQuiz()
            
    }
    func startQuiz() {
        matchedAttachs = viewModel.matchQuiz(attachment: quiz!.attachments, playableCount: playableCount)
        
        
        for i in matchedAttachs {
          print("\(i[0].title) \(i[1].title) ")
        }
     //   print(matchedAttachs.count)
         setImages(index: startIndex)
         setTitle(index: startIndex)
    }
    
    func imageTap() {
    
     let tapGestureLeft = UITapGestureRecognizer(target: self, action: #selector(imageClickedLeft))
     let tapGestureRight = UITapGestureRecognizer(target: self, action: #selector(imageClickedRight))

       leftImageView.addGestureRecognizer(tapGestureLeft)
       leftImageView.isUserInteractionEnabled = true
    
       rightImageView.addGestureRecognizer(tapGestureRight)
       rightImageView.isUserInteractionEnabled = true
    }
    
    @objc func imageClickedLeft() {    /// TIKLADIKCA RESIMLER DEGISIYOR AMA ATTACH COUNTA GORE AYARLA
        ///
        startIndex += 1
  
     //   print("startIndex : \(startIndex)  \(a)   ---   matched \(matchedAttachs.count)")
        if startIndex  >= matchedAttachs.count {
            print("tur bitti")
      //      getNextTour()
            return
        }
        winAttachs.append(matchedAttachs[startIndex][0])
     
       
      
        setImages(index: startIndex)
        
        setTitle(index: startIndex)
    }
    @objc func imageClickedRight() {
        startIndex += 1
           if startIndex  >= matchedAttachs.count {
               print("tur bitti")
         //      getNextTour()
               return
           }
        
        winAttachs.append(matchedAttachs[startIndex][1])

      
        
        setImages(index: startIndex)
        setTitle(index: startIndex)
    }
    func setImages(index:Int) {
        
   
          print(index)
        leftImageView.kf.setImage(with: URL(string: matchedAttachs[index][0].image!))
        rightImageView.kf.setImage(with: URL(string: matchedAttachs[index][1].image!))
    }
    
    func setTitle(index:Int) {
        
        leftTitleLabel.text = matchedAttachs[index][0].title!
        rightTitleLabel.text = matchedAttachs[index][1].title!
    }
    func getNextTour() {
        startIndex = 0
        playableCount = playableCount/2
        matchedAttachs = viewModel.matchQuiz(attachment: winAttachs, playableCount: playableCount)
        setImages(index: startIndex)
        setTitle(index: startIndex)
        
    }
}
