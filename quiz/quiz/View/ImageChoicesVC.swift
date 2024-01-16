//
//  ImageChoicesVC.swift
//  quiz
//
//  Created by Omer on 15.11.2023.
//
import PhotosUI
import UIKit


class ImageChoicesVC: BaseViewController {
     

    @IBOutlet weak var tableView: UITableView!
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
    }
    
    func initVM() {
        imageChoicesViewModel.callbackReloadTableView = { [weak self] in
            guard let self = self else { return }
//            DispatchQueue.main.async {
//                self.tableView.reloadData()
//            }
            UIView.transition(with: tableView,
                              duration: 0.35,
                              options: .transitionCrossDissolve,
                              animations: { self.tableView.reloadData() })
        }
        
        imageChoicesViewModel.callbackFail = {[weak self] error in
            guard let self = self else { return }
            self.alert(title: "Upload Failed!", message: error.localizedDescription)
            
        }
        imageChoicesViewModel.callbackPublishQuiz = { [weak self] quiz in
            guard let self = self else { return }
            self.alert(title: "Success!", message: UploadSuccess.success.rawValue) { _ in
            
 
                self.clearArrays()
                self.presentGameStartViewController(quiz: quiz)
            }
        }
    }
    func clearArrays() {
        self.imageChoicesViewModel.imageArray.removeAll()
        self.imageChoicesViewModel.attachIdList.removeAll()
        self.imageChoicesViewModel.attachNameList.removeAll()
        WebService.shared.attachmentIdList.removeAll()
    }
    @IBAction func nextClick(_ sender: Any) {
         
        if imageChoicesViewModel.imageArray.count > 1 {
             
                imageChoicesViewModel.updateAttachment() { [weak self] _ in
                    guard let self = self else {return}
                  
                    imageChoicesViewModel.publishQuiz(title: CreateQuizFields.shared.quizTitle!, image:CreateQuizFields.shared.quizHeaderImage!, categoryID: imageChoicesViewModel.categoryId, isVisible: true,is_image: imageChoicesViewModel.is_image, attachment_ids: imageChoicesViewModel.attachmentIds)
 
 
                }
              
       }else {
            alert(title: "Fail", message: "need 2 attachments")
         
        }
       
    }
    @IBAction func pickerClick(_ sender: Any) {
        var config = PHPickerConfiguration()
        
        config.selectionLimit = 128
        
        let phPickerVC = PHPickerViewController(configuration: config)
        phPickerVC.delegate = self
        self.present(phPickerVC,animated: true)
    }
   
    
}
extension ImageChoicesVC:PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        
        dismiss(animated: true)
        imageChoicesViewModel.addAttachmentDidpick(results: results)
        
    }
}

extension ImageChoicesVC:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return imageChoicesViewModel.imageArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ImagePickerTableViewCell") as! ImagePickerTableViewCell
        cell.delegate = self
        cell.attachImageView.image = imageChoicesViewModel.imageArray[indexPath.row]
        cell.nameTextField.text =   imageChoicesViewModel.attachNameList[indexPath.row]
        cell.index = indexPath.row
       
        return cell
    } 
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete"){
            contextualAction,view,bool in
         
            self.removeAttachment(index: indexPath.row)
          
    }
    return UISwipeActionsConfiguration(actions: [deleteAction])
  }
    
    func removeAttachment(index:Int) {
        let title = self.imageChoicesViewModel.attachNameList[index]
        let alert = UIAlertController(title: "Delete", message: "\(title) do you want to delete?", preferredStyle: .alert)
    
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        let yes = UIAlertAction(title: "Delete", style: .destructive) {
        action in
              print(self.imageChoicesViewModel.attachIdList[index])
            self.imageChoicesViewModel.removeAttachment(index: index, attachmentID: self.imageChoicesViewModel.attachIdList[index])
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
      }
    
        alert.addAction(cancel)
        alert.addAction(yes)
        self.present(alert,animated: true)
    
    }
}
extension ImageChoicesVC: ImagePickerTableViewCellDelegate {
    func didEndTextChange(text: String?, index: Int) {
        imageChoicesViewModel.editTitle(index: index, title: text)
    }
}
