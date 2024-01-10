//
//  VideoChoicesVC.swift
//  quiz
//
//  Created by Omer on 15.11.2023.
//

import UIKit
import Kingfisher
import YouTubeiOSPlayerHelper

class VideoChoicesVC: BaseViewController {

    @IBOutlet weak var attachTableView: UITableView!
    @IBOutlet weak var videoTitleLabel: UITextField!
    @IBOutlet weak var youtubeURLTitle: UITextField!
 
    var videoChoicesViewModel = VideoChoicesViewModel()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        attachTableView.delegate = self
        attachTableView.dataSource = self
        
        videoChoicesViewModel.callbackFail = {[weak self] error in
            guard let self = self else { return }
            self.alert(title: "Upload Failed!", message: error.localizedDescription)
            
        }
        videoChoicesViewModel.callbackPublishQuiz = { [weak self] quiz in
            guard let self = self else { return }
            self.alert(title: "Success!", message: UploadSuccess.success.rawValue) { _ in
                       
                self.presentGameStartViewController(quiz: quiz)
            }
        }
    }
    
    @IBAction func AddVideoClick(_ sender: Any) {
        videoChoicesViewModel.url = youtubeURLTitle.text!
        let baseURL = videoChoicesViewModel.url.replacingOccurrences(of: " ", with: "")
        let title = videoTitleLabel.text!
        
        if baseURL.isEmpty == true || title.isEmpty == true {
            alert(title: "Empty Fields", message: "Please fill the fields")
            return
        }
      
        
        videoChoicesViewModel.loadThumbNail(url: baseURL, title: title, baseURL: baseURL) { done in
            self.youtubeURLTitle.text = ""
            self.videoTitleLabel.text = ""
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
    @IBAction func nextClick(_ sender: Any) {
        if videoChoicesViewModel.thumbNails.count > 1 {
            
            videoChoicesViewModel.addAttachmentsOnNextClick { [self] result in
                let vc = self.storyboard!.instantiateViewController(withIdentifier: "CreatePublishingVC") as? CreatePublishingVC
                
                if videoChoicesViewModel.thumbNails.count > 1 {
                    videoChoicesViewModel.publishQuiz(title: CreateQuizFields.shared.quizTitle!, image:CreateQuizFields.shared.quizHeaderImage!, categoryID: videoChoicesViewModel.categoryId, isVisible: true,is_image: videoChoicesViewModel.is_image, attachment_ids: videoChoicesViewModel.attachmentIds)
                }else{
                    alert(title: "Attachment fail", message: "Minimum attachment is 2 ")
                } 
            }
          
        }
      
     
    }
    
    func clearArrays() {
        videoChoicesViewModel.attachIdList.removeAll()
        WebService.shared.attachmentIdList.removeAll()
        self.videoChoicesViewModel.thumbNails.removeAll()
        self.videoChoicesViewModel.titleArray.removeAll()
    }
}

extension VideoChoicesVC:UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videoChoicesViewModel.thumbNails.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         
        let cell = tableView.dequeueReusableCell(withIdentifier: "VideoChoicesCell") as! VideoChoicesTableViewCell
        
        cell.videoTitleLabel.text = videoChoicesViewModel.titleArray[indexPath.row]
        cell.videoThumbnailImage.image = videoChoicesViewModel.thumbNails[indexPath.row]
        
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
        let title = self.videoChoicesViewModel.titleArray[index]
        let alert = UIAlertController(title: "Delete", message: "\(title) do you want to delete?", preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        let yes = UIAlertAction(title: "Delete", style: .destructive) {
            action in
            self.videoChoicesViewModel.removeAttachment(index: index)
            DispatchQueue.main.async {
                self.attachTableView.reloadData()
            }
            
        }
        
        alert.addAction(cancel)
        alert.addAction(yes)
        self.present(alert,animated: true)
        
    }
    
}
