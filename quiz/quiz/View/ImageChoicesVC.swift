//
//  ImageChoicesVC.swift
//  quiz
//
//  Created by Omer on 15.11.2023.
//
import PhotosUI
import UIKit

final class ImageChoicesVC: BaseViewController {

    enum LoadState {
        case loading
        case load

    }
    @IBOutlet weak var publishButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loaderIndicator: UIActivityIndicatorView!
    @IBOutlet weak var pickerButton: UIButton!
    lazy var imageChoicesViewModel = ImageChoicesViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.imageChoicesViewModel.num = 1
        clearArrays()
        initView()
        initVM()
    }

    func initView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.allowsSelection = false
    }

    func setLoader(state: LoadState) {
        switch state {
        case .loading:
            DispatchQueue.main.async {
                self.loaderIndicator.isHidden = false
                self.loaderIndicator.startAnimating()
            }
        case .load:
            DispatchQueue.main.async {
                self.loaderIndicator.isHidden = true
                self.loaderIndicator.stopAnimating()
            }

        }
    }

    func initVM() {
        loaderIndicator.isHidden = true
        imageChoicesViewModel.callbackReloadTableView = { [weak self] in
            guard let self = self else { return }

            UIView.transition(with: tableView,
                              duration: 0.35,
                              options: .transitionCrossDissolve,
                              animations: { self.tableView.reloadData() })
            self.setLoader(state: .load)

        }
        imageChoicesViewModel.callbackAttachmentUpdateFail = { [weak self] fail in
            guard let self = self else {return}
            self.alert(title: fail, message: "Attachment update failed")
        }
        imageChoicesViewModel.callbackAttachmentUpdateSuccess = { [weak self]  in
            guard let self = self else {return}

            imageChoicesViewModel.publishQuiz(title: CreateQuizFields.shared.quizTitle!,
              image: CreateQuizFields.shared.quizHeaderImage!,
              categoryID: imageChoicesViewModel.categoryId,
              isVisible: true,
              isImage: imageChoicesViewModel.isImage,
              attachmentIds: imageChoicesViewModel.attachmentIds)
        }
        imageChoicesViewModel.callbackAttachRemoveFail = { [weak self] alertStr in
            guard let self = self else { return}

            self.alert(title: "Remove process is failed", message: alertStr)
        }
        imageChoicesViewModel.callbackImageUploadFail = { [weak self] fail in
            guard let self = self else {return}
            self.alert(title: "Failed", message: fail)
        }

        imageChoicesViewModel.callbackFail = {[weak self] error in
            guard let self = self else { return }
            self.alert(title: "Upload Failed!", message: error.localizedDescription)
            self.setLoader(state: .load)

        }
        imageChoicesViewModel.callbackPublishQuiz = { [weak self] quiz in
            guard let self = self else { return }
            self.setLoader(state: .load)
            self.alert(title: "Success!", message: UploadSuccess.success.rawValue) { _ in

                self.clearArrays()
                self.presentGameStartViewController(quiz: quiz)
            }
        }
        imageChoicesViewModel.callbackStartLoader = {[weak self] in
            guard let self = self else {return}
            self.setLoader(state: .loading)

        }
    }
    func clearArrays() {
        self.imageChoicesViewModel.imageArray.removeAll()
        self.imageChoicesViewModel.attachmentIds.removeAll()
        self.imageChoicesViewModel.attachNameList.removeAll()

    }
    @IBAction func nextClicked(_ sender: Any) {

        if imageChoicesViewModel.imageArray.count > 1 {
            setLoader(state: .loading)
                 imageChoicesViewModel.updateAttachment()

       } else {
            alert(title: "Fail", message: "need 2 attachments")

        }

    }
    @IBAction func pickerClicked(_ sender: Any) {
        var config = PHPickerConfiguration()

        config.selectionLimit = 128

        let phPickerVC = PHPickerViewController(configuration: config)
        phPickerVC.delegate = self
        self.present(phPickerVC, animated: true)
    }

}
extension ImageChoicesVC: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {

        dismiss(animated: true)
        imageChoicesViewModel.addAttachmentDidpick(results: results)

    }
}

extension ImageChoicesVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return imageChoicesViewModel.imageArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "ImagePickerTableViewCell")
        as? ImagePickerTableViewCell

        guard let cell = cell else { return ImagePickerTableViewCell() }
        cell.delegate = self
        cell.attachImageView.image = imageChoicesViewModel.imageArray[indexPath.row]
        cell.nameTextField.text =   imageChoicesViewModel.attachNameList[indexPath.row]
        cell.index = indexPath.row

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
        let title = self.imageChoicesViewModel.attachNameList[index]
        let alert = UIAlertController(title: "Delete",
                                      message: "\(title) do you want to delete?", preferredStyle: .alert)

        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        let yes = UIAlertAction(title: "Delete", style: .destructive) { _ in

            self.imageChoicesViewModel.removeAttachment(index: index,
                                                        attachmentID: self.imageChoicesViewModel.attachmentIds[index])

      }
        alert.addAction(cancel)
        alert.addAction(yes)
        self.present(alert, animated: true)
    }
}
extension ImageChoicesVC: ImagePickerTableViewCellDelegate {
    func didEndTextChange(text: String?, index: Int) {
        imageChoicesViewModel.editTitle(index: index, title: text)
    }
}
