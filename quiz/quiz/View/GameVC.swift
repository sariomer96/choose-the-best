//
//  GameVC.swift
//  quiz
//
//  Created by Omer on 9.11.2023.
//

import UIKit
import Kingfisher

class GameVC: UIViewController {

    @IBOutlet weak var quizRateDropDownButton: UIButton!
    
    
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
    var viewModel:GameViewModel?
    var matchedAttachs = [[Attachment]]()
    var winAttachs = [Attachment]()
    var isFinishQuiz = false
   
    override func viewDidLoad() {
        super.viewDidLoad()

 
    }
    override func viewWillAppear(_ animated: Bool) {
        roundLabel.text = ""
    }
    override func viewDidAppear(_ animated: Bool) {
        viewModel = GameViewModel(leftImageView: leftImageView, rightImageView: rightImageView, matchedAttachs: matchedAttachs, leftTitleLabel: leftTitleLabel, rightTitleLabel: rightTitleLabel, playableCount: playableCount, roundLabel: roundLabel, winAttachs: winAttachs, winLabel: winLabel)

        viewModel!.imageTap(imageViewLeft: leftImageView, imageViewRight: rightImageView)
        viewModel!.view = view

        
         startQuiz()
         showRateDropDown()
    }
    func showRateDropDown() {
        let  action = viewModel?.getDropDownActions(completion: { result in
            
        })
         print("action \(action)")
        if  action != nil {
             print("setactt")
            quizRateDropDownButton.menu = UIMenu(children : action!)
     
            quizRateDropDownButton.showsMenuAsPrimaryAction = true
            quizRateDropDownButton.changesSelectionAsPrimaryAction = true
        }
    }
    func startQuiz() {
        viewModel!.matchedAttachs = viewModel!.matchQuiz(attachment: quiz!.attachments, playableCount: playableCount)
        print("AAAA  :\(viewModel?.matchedAttachs.count)")
        viewModel!.setRound(roundIndex: 1, tourCount: viewModel!.matchedAttachs.count)
        

        viewModel!.setImages(index: startIndex)
        viewModel!.setTitle(index: startIndex)
    }
  
    
    @IBAction func quizDetailClick(_ sender: Any) {
        
        
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "GameStartVC") as! GameStartVC
        
        
        vc.quiz = quiz
        self.navigationController!.pushViewController(vc, animated: true)
      //  performSegue(withIdentifier: "toQuizDetail", sender: quiz)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let vc = segue.destination as? GameStartVC
        
        let quiz = sender as? QuizResponse
        
        if let vc = vc {
            vc.quiz = quiz
        }
    }
    

}
