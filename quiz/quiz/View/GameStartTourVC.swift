//
//  GameStartTourVC.swift
//  quiz
//
//  Created by Omer on 27.11.2023.
//

import UIKit
import Kingfisher

final class GameStartTourVC: BaseViewController {

    @IBOutlet weak var dropdownButton: UIButton!
    @IBOutlet weak var quizImageView: UIImageView!
    @IBOutlet weak var quizTitleLabel: UILabel!

    let viewModel = GameStartTourViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        showDropDown()

    }

    override func viewWillAppear(_ animated: Bool) {
        quizImageView.kf.setImage(with: URL(string: (viewModel.quiz?.image)!))
        quizTitleLabel.text = viewModel.quiz?.title
    }

    @IBAction func startClick(_ sender: Any) {

        if viewModel.quiz?.attachments[0].url?.lowercased().range(of: "youtu") != nil {

            let viewC = self.storyboard!.instantiateViewController(withIdentifier: "GameVideoVC")
            as? GameVideoVC

            if let viewC = viewC {

                viewC.viewModel.quiz = viewModel.quiz
                viewC.viewModel.playableCount = viewModel.maxPlayableCount
                self.navigationController!.pushViewController(viewC, animated: true)
            }

        } else {
            let viewC = self.storyboard!.instantiateViewController(withIdentifier: "GameVC") as? GameVC

            if let viewC = viewC {

                viewC.gameViewModel.quiz = viewModel.quiz

                viewC.gameViewModel.setPlayableCount(count: viewModel.maxPlayableCount)
                self.navigationController!.pushViewController(viewC, animated: true)
            }

        }
    }
    func showDropDown() {

        let  action = viewModel.getDropDownActions(attachmentCount: (viewModel.quiz?.attachments.count)!) { count in
            self.viewModel.maxPlayableCount = count

        }
             dropdownButton.menu = UIMenu(children: action)
             dropdownButton.showsMenuAsPrimaryAction = true

    }

}
