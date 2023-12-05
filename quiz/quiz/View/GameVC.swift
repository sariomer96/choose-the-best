//
//  GameVC.swift
//  quiz
//
//  Created by Omer on 9.11.2023.
//

import UIKit
import Kingfisher

class GameVC: UIViewController {

    
    @IBOutlet weak var winLabel: UILabel!
    @IBOutlet weak var rightImageView: UIImageView!
    @IBOutlet weak var leftImageView: UIImageView!
    
    @IBOutlet weak var roundLabel: UILabel!
    var roundIndex = 1
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
    override func viewWillAppear(_ animated: Bool) {
        roundLabel.text = ""
    }
        override func viewDidAppear(_ animated: Bool) {
           
        
            rightImageView.alpha = 0.0
            leftImageView.alpha = 0.0
            startQuiz()
    }
    func startQuiz() {
        matchedAttachs = viewModel.matchQuiz(attachment: quiz!.attachments, playableCount: playableCount)
        
        setRound(roundIndex: 1, tourCount: matchedAttachs.count)
        
//        for i in matchedAttachs {
//          print("\(i[0].title) \(i[1].title) ")
//        }
  
      
     
         setImages(index: startIndex)
         setTitle(index: startIndex)
    }
    
    func setRound(roundIndex:Int, tourCount:Int) {
        roundLabel.text = "\(roundIndex) / \(tourCount)"
    }
    
    func imageTap() {
    
     let tapGestureLeft = UITapGestureRecognizer(target: self, action: #selector(imageClickedLeft))
     let tapGestureRight = UITapGestureRecognizer(target: self, action: #selector(imageClickedRight))

       leftImageView.addGestureRecognizer(tapGestureLeft)
       leftImageView.isUserInteractionEnabled = true
    
       rightImageView.addGestureRecognizer(tapGestureRight)
       rightImageView.isUserInteractionEnabled = true
    }
    
    @objc func imageClickedLeft() {
        ///
     
   
        self.fadeInOrOut(alpha:0.0)

        print("ekle \(startIndex)")
        winAttachs.append(matchedAttachs[startIndex][0])
      
       
        startIndex += 1
        roundIndex += 1
      
        if startIndex < matchedAttachs.count {
            
             
            setImages(index: startIndex)
            
            setTitle(index: startIndex)
        }
        
        print("startind \(startIndex)   \(matchedAttachs.count)")
        if winAttachs.count  == matchedAttachs.count  {
            print("tur bitti")
            getNextTour()
            return
        }
        print("winatt \(winAttachs.count)")
        setRound(roundIndex: roundIndex, tourCount: matchedAttachs.count)
    }
    @objc func imageClickedRight() {
      
        self.fadeInOrOut(alpha:0.0)
        print("ekle \(startIndex)")
        winAttachs.append(matchedAttachs[startIndex][1])
      
       
        startIndex += 1
        roundIndex += 1
       
        if startIndex < matchedAttachs.count {
            
             
            setImages(index: startIndex)
            
            setTitle(index: startIndex)
        }
        
        print("startind \(startIndex)   \(matchedAttachs.count)")
        if winAttachs.count  == matchedAttachs.count  {
            print("tur bitti")
            getNextTour()
            return
        }
        setRound(roundIndex: roundIndex, tourCount: matchedAttachs.count)
        print("winatt \(winAttachs.count)")
    }
    func setImages(index:Int) {
        
        print("index \(index)   \(matchedAttachs.count)")
        leftImageView.kf.setImage(with: URL(string: matchedAttachs[index][0].image!)) {
            res in
            self.fadeInOrOut(alpha:1.0)
        }
        rightImageView.kf.setImage(with: URL(string: matchedAttachs[index][1].image!)) {
            _ in
            self.fadeInOrOut(alpha:1.0)
        }
    }
    
    func fadeInOrOut(alpha:Double) {
        UIView.animate(withDuration: 1.1, animations: {
               
         
                self.leftImageView.alpha = alpha
                self.rightImageView.alpha = alpha
            })
    }
    
    func setTitle(index:Int) {
        
        leftTitleLabel.text = matchedAttachs[index][0].title!
        rightTitleLabel.text = matchedAttachs[index][1].title!
    }
    func getNextTour() {
        if winAttachs.count == 1 {
            let upper = winAttachs[0].title?.uppercased()
            winLabel.textColor = .systemRed
            winLabel.text = "\(upper!) WIN!!"
            print("GAME WON")
            return
        }
        startIndex = 0
        playableCount = playableCount/2
        matchedAttachs = viewModel.matchQuiz(attachment: winAttachs, playableCount: playableCount)
        roundIndex = 1
        setRound(roundIndex: roundIndex, tourCount: matchedAttachs.count)
        print("new matchedAttach  \(matchedAttachs)")
        
        setImages(index: startIndex)
        setTitle(index: startIndex)
        winAttachs.removeAll()
        
    }
}
