//
//  GameVideoVC.swift
//  quiz
//
//  Created by Omer on 11.12.2023.
//

import UIKit
import YouTubeiOSPlayerHelper
import Kingfisher

class GameVideoVC: UIViewController {
    @IBOutlet weak var quizRateButton: UIButton!
    
    @IBOutlet weak var roundLabel: UILabel!
    @IBOutlet weak var bottomAttachmentTitle: UILabel!
    @IBOutlet weak var topAttachmentTitle: UILabel!
    @IBOutlet weak var popUpAttachTitle: UILabel!
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var popUpAttachImage: UIImageView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var topVideoView: YTPlayerView!
    var viewModel = GameVideoViewModel()


    @IBOutlet weak var bottomVideoView: YTPlayerView!
    override func viewDidLoad() {
        super.viewDidLoad()
        popUpView.layer.cornerRadius = 20
        //print(quiz!)
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        viewModel.activity = activityIndicator
    
        viewModel.topAttachTitle = topAttachmentTitle
        viewModel.bottomAttachTitle = bottomAttachmentTitle
        viewModel.roundLabel = roundLabel
        startQuiz()
        showRateDropDown()
    }
    
    func showRateDropDown() {
        let  action = viewModel.getDropDownActions(completion: { [self] result in
            if result > -1 {
                viewModel.isRateSelected = true
                viewModel.rate = result
            }else {
                viewModel.isRateSelected = false
            }
        })
        if  action != nil {
            
            quizRateButton.menu = UIMenu(children : action)
            quizRateButton.showsMenuAsPrimaryAction = true
            quizRateButton.changesSelectionAsPrimaryAction = true
        }
    }
    @IBAction func voteClick(_ sender: Any) {
        if viewModel.isRateSelected == true {
            
            viewModel.vote = true
            viewModel.rateQuiz(quizID: viewModel.quiz!.id, rateScore: viewModel.rate)
            { result in
               print(result)
                AlertManager.shared.alert(view: self, title: "Alert", message: result)
            }
        }else {
            AlertManager.shared.alert(view: self, title: "Empty Field", message: "Please vote the quiz")
        }
    }
    
    @IBAction func popUpPlayAgainClick(_ sender: Any) {
         
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "GameStartVC") as? GameStartVC
        
        if let vc = vc {
            if viewModel.vote == true {
                vc.viewModel.quiz = viewModel.quiz
                self.navigationController!.pushViewController(vc, animated: true)
            }
        }
       // performSegue(withIdentifier: "toDetail", sender: quiz)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as? GameStartVC
        
        let quiz = sender as? QuizResponse
        
        if let vc = vc {
            vc.viewModel.quiz = quiz
        }
    }
  
    func startQuiz() {
        viewModel.matchedAttachs = viewModel.matchQuiz(attachment: viewModel.quiz!.attachments, playableCount: viewModel.playableCount)
         
        viewModel.setRound(roundIndex: 1, tourCount: viewModel.matchedAttachs.count, roundLabel: roundLabel)
        
        viewModel.setVideo(videoView: topVideoView, matchIndex: 0, rowIndex: 0)
        viewModel.setVideo(videoView: bottomVideoView, matchIndex: 0, rowIndex: 1)
        
        topAttachmentTitle.text = viewModel.matchedAttachs[0][0].title
        bottomAttachmentTitle.text = viewModel.matchedAttachs[0][1].title
    }
    @IBAction func bottomChooseClick(_ sender: Any) {
        viewModel.chooseClick(bottomVideoView: bottomVideoView, topVideoView: topVideoView, rowIndex: 1) {
            attachment in
            let url = attachment.image
            
            self.popUpAttachImage.kf.setImage(with: URL(string: url!))
            self.popUpAttachTitle.text = attachment.title
            self.viewModel.showPopUp(popUpView: self.popUpView)
        }
    }
    
    @IBAction func topChooseClick(_ sender: Any) {
        viewModel.chooseClick(bottomVideoView: bottomVideoView, topVideoView: topVideoView, rowIndex: 0) {
            attachment in
            
            let url = attachment.image!
            self.popUpAttachImage.kf.setImage(with: URL(string: url))
            self.popUpAttachTitle.text = attachment.title
            self.viewModel.showPopUp(popUpView: self.popUpView)
        }
    }
    
}
