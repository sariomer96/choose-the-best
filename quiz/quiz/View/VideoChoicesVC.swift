//
//  VideoChoicesVC.swift
//  quiz
//
//  Created by Omer on 15.11.2023.
//

import UIKit
import Kingfisher
import YouTubeiOSPlayerHelper

final class VideoChoicesVC: BaseViewController {

    @IBOutlet weak var attachTableView: UITableView!
    @IBOutlet weak var videoTitleTextField: UITextField!
    @IBOutlet weak var youtubeURLTitleTextField: UITextField!
    @IBOutlet weak var publishButton: UIButton!
    @IBOutlet weak var loaderIndicator: UIActivityIndicatorView!
    var videoChoicesViewModel = VideoChoicesViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        loaderIndicator.isHidden = true
        attachTableView.delegate = self
        attachTableView.dataSource = self
        attachTableView.allowsSelection = false

        videoChoicesViewModel.callbackFail = {[weak self] error in
            guard let self = self else { return }
            self.alert(title: "Upload Failed!", message: error.localizedDescription)
            self.loaderIndicator.isHidden = true
            self.loaderIndicator.stopAnimating()
            self.publishButton.isEnabled = true

        }
        videoChoicesViewModel.callbackAlert = {[weak self] errorMessage in
            guard let self = self else { return }
            self.alert(title: "Error!", message: errorMessage)

        }
        videoChoicesViewModel.callbackPublishQuiz = { [weak self] quiz in
            guard let self = self else { return }
            self.alert(title: "Success!", message: UploadSuccess.success.rawValue) { _ in
                self.loaderIndicator.isHidden = true
                self.loaderIndicator.stopAnimating()
                self.publishButton.isEnabled = true
                self.presentGameStartViewController(quiz: quiz)
            }
        }
    }
    @IBAction func addVideoClicked(_ sender: Any) {
        videoChoicesViewModel.url = youtubeURLTitleTextField.text!
        let baseURL = videoChoicesViewModel.url.replacingOccurrences(of: " ", with: "")
        let title = videoTitleTextField.text!

        if baseURL.isEmpty == true || title.isEmpty == true {
            alert(title: "Empty Fields", message: "Please fill the fields")
            return
        }

        videoChoicesViewModel.loadThumbNail(url: baseURL, title: title, baseURL: baseURL) { _ in
            self.youtubeURLTitleTextField.text = ""
            self.videoTitleTextField.text = ""
            DispatchQueue.main.async {
                self.attachTableView.reloadData()
            }
        }

    }
    override func viewDidAppear(_ animated: Bool) {
        clearArrays()
        DispatchQueue.main.async {
            self.attachTableView.reloadData()
        }
    }
    @IBAction func nextClicked(_ sender: Any) {
        if videoChoicesViewModel.thumbNails.count > 1 {
            publishButton.isEnabled = false
            loaderIndicator.isHidden = false
            loaderIndicator.startAnimating()
            videoChoicesViewModel.addAttachmentsOnNextClick { [self] _ in

            if videoChoicesViewModel.thumbNails.count > 1 {
                videoChoicesViewModel.publishQuiz(title: CreateQuizFields.shared.quizTitle!,
                                                  image: CreateQuizFields.shared.quizHeaderImage!,
                    categoryID: videoChoicesViewModel.categoryId,
                    isVisible: true,
                    isImage: false,
                    attachmentIds: videoChoicesViewModel.attachmentIds)
            } else {
                alert(title: "Attachment fail", message: "Minimum attachment is 2 ")
            }
        }

    }

    }

    func clearArrays() {
        self.videoChoicesViewModel.attachmentIds.removeAll()
        self.videoChoicesViewModel.thumbNails.removeAll()
        self.videoChoicesViewModel.titleArray.removeAll()
    }
}

extension VideoChoicesVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videoChoicesViewModel.thumbNails.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "VideoChoicesCell") as? VideoChoicesTableViewCell

        guard let cell = cell else { return VideoChoicesTableViewCell() }
        cell.videoTitleLabel.text = videoChoicesViewModel.titleArray[indexPath.row]
        cell.videoThumbnailImage.image = videoChoicesViewModel.thumbNails[indexPath.row]

        return cell
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath)
    -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { _, _, _ in

            self.removeAttachment(index: indexPath.row)

        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }

    func removeAttachment(index: Int) {
        let title = self.videoChoicesViewModel.titleArray[index]
        let alert = UIAlertController(title: "Delete", message: "\(title) do you want to delete?",
                                      preferredStyle: .alert)

        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        let yes = UIAlertAction(title: "Delete", style: .destructive) { _ in
            self.videoChoicesViewModel.removeAttachment(index: index)
            DispatchQueue.main.async {
                self.attachTableView.reloadData()
            }

        }

        alert.addAction(cancel)
        alert.addAction(yes)
        self.present(alert, animated: true)

    }

}
