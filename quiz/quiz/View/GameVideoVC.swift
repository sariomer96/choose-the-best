//
//  GameVideoVC.swift
//  quiz
//
//  Created by Omer on 11.12.2023.
//

import UIKit
import YouTubeiOSPlayerHelper
import Kingfisher

class GameVideoVC: BaseViewController {
 
    
    @IBOutlet weak var roundLabel: UILabel!
    @IBOutlet weak var bottomAttachmentTitle: UILabel!
    @IBOutlet weak var topAttachmentTitle: UILabel!
  
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var topVideoView: YTPlayerView!
    var viewModel = GameVideoViewModel()


    @IBOutlet weak var bottomVideoView: YTPlayerView!
    override func viewDidLoad() {
        super.viewDidLoad()
     
        viewModel.callbackWin = { [weak self] attachment in
            guard let self = self else {return}
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
      
            let vc = storyboard.instantiateViewController(withIdentifier: "GamePopUpVC") as? GamePopUpVC
            guard let vc = vc else{return}
            
            vc.gamePopUpViewModel.quiz = viewModel.quiz
            vc.gamePopUpViewModel.attachment = attachment
          
            self.navigationController?.pushViewController(vc, animated: false)
        }
        viewModel.callbackSetAttachmentTitle = { [weak self] result in
            guard let self = self else {return}
            
            switch result.1 {
                
            case .top:
                topAttachmentTitle.text = result.0
            case .bottom:
                bottomAttachmentTitle.text = result.0
            default :
                break
            }
      
        }
        
        viewModel.callbackSetRoundLabel = { [weak self] title in
            guard let self = self else {return}
            roundLabel.text = title
        }
        
        viewModel.callbackLoadIndicator =  { [weak self] isPlaying in
            guard let self = self else {return}
            activityIndicator.isHidden = !isPlaying
            if isPlaying == true {
                activityIndicator.startAnimating()
            }else {
                activityIndicator.stopAnimating()
                activityIndicator.isHidden = true
            }
         }
 
    }
    override func viewWillAppear(_ animated: Bool) {
 
        startQuiz()
         
    }
 
 
    func startQuiz() {
        viewModel.matchedAttachs = viewModel.matchQuiz(attachment: viewModel.quiz!.attachments, playableCount: viewModel.playableCount)
         
        viewModel.setRound(roundIndex: 1, tourCount: viewModel.matchedAttachs.count)
        
        viewModel.setVideo(videoView: topVideoView, matchIndex: 0, rowIndex: 0)
        viewModel.setVideo(videoView: bottomVideoView, matchIndex: 0, rowIndex: 1)
        
        topAttachmentTitle.text = viewModel.matchedAttachs[0][0].title
        bottomAttachmentTitle.text = viewModel.matchedAttachs[0][1].title
    }
    @IBAction func bottomChooseClick(_ sender: Any) {
        viewModel.chooseClick(bottomVideoView: bottomVideoView, topVideoView: topVideoView, rowIndex: 1) {
            attachment in
  
            
   
        }
    }
    
    @IBAction func topChooseClick(_ sender: Any) {
        viewModel.chooseClick(bottomVideoView: bottomVideoView, topVideoView: topVideoView, rowIndex: 0) {
            attachment in
            
 
        }
    }
    
}
