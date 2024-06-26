//
//  GameVideoVC.swift
//  quiz
//
//  Created by Omer on 11.12.2023.
//

import UIKit
import YouTubeiOSPlayerHelper
import Kingfisher

final class GameVideoVC: BaseViewController {

    @IBOutlet weak var roundNameLabel: UILabel!
    @IBOutlet weak var roundLabel: UILabel!
    @IBOutlet weak var bottomAttachmentTitleLabel: UILabel!
    @IBOutlet weak var topAttachmentTitleLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var topVideoView: YTPlayerView!
    @IBOutlet weak var bottomVideoView: YTPlayerView!
    var viewModel = GameVideoViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.callbackWin = { [weak self] attachment in
            guard let self = self else {return}
            let storyboard = UIStoryboard(name: "Main", bundle: nil)

            let viewC = storyboard.instantiateViewController(withIdentifier: "GamePopUpVC") as? GamePopUpVC
            guard let viewC = viewC else { return }

            viewC.gamePopUpViewModel.quiz = viewModel.quiz
            viewC.gamePopUpViewModel.attachment = attachment

            self.navigationController?.pushViewController(viewC, animated: false)
        }
        viewModel.callbackSetAttachmentTitle = { [weak self] result in
            guard let self = self else {return}

            switch result.1 {

            case .top:
                topAttachmentTitleLabel.text = result.0
            case .bottom:
                bottomAttachmentTitleLabel.text = result.0

            }
        }

        viewModel.callbackSetRoundLabel = { [weak self] title in
            guard let self = self else {return}
            roundLabel.text = title
        }
        self.viewModel.callbackRoundName = { [weak self] name in
            guard let self = self else {return}
            roundNameLabel.text = name
        }
        viewModel.callbackLoadIndicator = { [weak self] isPlaying in
            guard let self = self else {return}
            activityIndicator.isHidden = !isPlaying
            if isPlaying == true {
                activityIndicator.startAnimating()
            } else {
                activityIndicator.stopAnimating()
                activityIndicator.isHidden = true
            }
         }

    }
    override func viewWillAppear(_ animated: Bool) {

        startQuiz()

    }

    func startQuiz() {
        viewModel.matchedAttachs = viewModel.matchQuiz(attachment: viewModel.quiz!.attachments,
                                                       playableCount: viewModel.playableCount)
        self.viewModel.setRoundName(index: viewModel.matchedAttachs.count-1)
        viewModel.setRound(roundIndex: 1, tourCount: viewModel.matchedAttachs.count)

        viewModel.setVideo(videoView: topVideoView, matchIndex: 0, rowIndex: 0)
        viewModel.setVideo(videoView: bottomVideoView, matchIndex: 0, rowIndex: 1)

        topAttachmentTitleLabel.text = viewModel.matchedAttachs[0][0].title
        bottomAttachmentTitleLabel.text = viewModel.matchedAttachs[0][1].title
    }
    @IBAction func bottomChooseClick(_ sender: Any) {
        viewModel.chooseClick(bottomVideoView: bottomVideoView, topVideoView: topVideoView, rowIndex: 1) { _ in

        }
    }

    @IBAction func topChooseClick(_ sender: Any) {
        viewModel.chooseClick(bottomVideoView: bottomVideoView, topVideoView: topVideoView, rowIndex: 0) { _ in

        }
    }
}
