//
//  GameStartVC.swift
//  quiz
//
//  Created by Omer on 9.11.2023.
//

import UIKit
import Kingfisher

final class GameStartVC: BaseViewController {
    @IBOutlet weak var attachTableView: UITableView!
    @IBOutlet weak var quizTitleLabel: UILabel!
    @IBOutlet weak var quizHeaderImageView: UIImageView!

    var gameStartViewModel = GameStartViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        attachTableView.delegate = self
        attachTableView.dataSource = self

        gameStartViewModel.callbackFailAlert = { [weak self] error in
            guard let self = self else { return }
            self.alert(title: "Error", message: error.localizedDescription)
        }

    }
    override func viewWillAppear(_ animated: Bool) {
        quizTitleLabel.text = ""

        gameStartViewModel.getQuizResponse { _ in

          let img =  self.gameStartViewModel.getQuizImage()
            if img.isEmpty == true {
                return
            }
            let url = img
            self.quizHeaderImageView.kf.setImage(with: URL(string: url))
            DispatchQueue.main.async {
                self.attachTableView.reloadData()
            }
        }

    }

    override func viewDidAppear(_ animated: Bool) {
        let quiz = gameStartViewModel.getQuiz()
        guard let quiz = quiz else {return}
        quizTitleLabel.text = quiz.title

    }
    @IBAction func startClicked(_ sender: Any) {

        let viewC = self.storyboard!.instantiateViewController(withIdentifier: "GameStartTourVC") as? GameStartTourVC

        let quiz = gameStartViewModel.getQuiz()
        guard let quiz = quiz else { return }
        viewC?.viewModel.quiz = quiz

        self.navigationController!.pushViewController(viewC ?? GameStartTourVC(), animated: true)
     }
}

extension GameStartVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        let attach = gameStartViewModel.getAttachments()
        guard let attach = attach else { return 0 }

        return attach.count

    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GameStartTableViewCell") as? GameStartTableViewCell

        let attachment = gameStartViewModel.getAttachments()
        guard let attachment = attachment else { return cell ?? GameStartTableViewCell()}
        cell?.attachName.text = attachment[indexPath.row].title

        DispatchQueue.main.async { [self] in
            let score = attachment[indexPath.row].score

            if self.gameStartViewModel.totalAttachScore > 0 {
                let resultScore = CGFloat(score!)/CGFloat(gameStartViewModel.totalAttachScore)

                gameStartViewModel.progress = CGFloat(resultScore)
            } else {
                gameStartViewModel.progress = 0
            }
            cell?.winRateCircleBar.progress = gameStartViewModel.progress
            cell?.attachImageView.kf.setImage(with: URL(string: (attachment[indexPath.row].image!)))
        }
        return cell ?? GameStartTableViewCell()

    }
}
