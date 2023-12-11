//
//  GameVideoVC.swift
//  quiz
//
//  Created by Omer on 11.12.2023.
//

import UIKit
import YouTubeiOSPlayerHelper

class GameVideoVC: UIViewController {

    @IBOutlet weak var bottomAttachmentTitle: UILabel!
    @IBOutlet weak var topAttachmentTitle: UILabel!
  
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var topVideoView: YTPlayerView!
    var viewModel = GameVideoViewModel()
    var matchedAttachs = [[Attachment]]()
    var quiz:QuizResponse?
    var winAttachs = [Attachment]()
    var startIndex = 0
    var roundIndex = 1
    var playableCount = 2 
    @IBOutlet weak var bottomVideoView: YTPlayerView!
    override func viewDidLoad() {
        super.viewDidLoad()
     
        //print(quiz!)
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        viewModel.activity = activityIndicator
        viewModel.winAttachs = winAttachs
        viewModel.playableCount = playableCount
        
        startQuiz()
    }
    
    func startQuiz() {
        viewModel.matchedAttachs = viewModel.matchQuiz(attachment: quiz!.attachments, playableCount: playableCount)
        
      
       // viewModel!.setRound(roundIndex: 1, tourCount: matchedAttachs.count)
        
        viewModel.setVideo(videoView: topVideoView, matchIndex: 0, rowIndex: 0)
        viewModel.setVideo(videoView: bottomVideoView, matchIndex: 0, rowIndex: 1)
    }
    @IBAction func bottomChooseClick(_ sender: Any) {
        viewModel.chooseClick(bottomVideoView: bottomVideoView, topVideoView: topVideoView, rowIndex: 0)
    }
    
    @IBAction func topChooseClick(_ sender: Any) {
        viewModel.chooseClick(bottomVideoView: bottomVideoView, topVideoView: topVideoView, rowIndex: 1)
    }
    
}
