//
//  VideoChoicesVC.swift
//  quiz
//
//  Created by Omer on 15.11.2023.
//

import UIKit
import Kingfisher
import YouTubeiOSPlayerHelper
import RxSwift
class VideoChoicesVC: UIViewController {

    @IBOutlet weak var attachTableView: UITableView!
//    @IBOutlet weak var testImage: UIImageView!
//    @IBOutlet var playerView: YTPlayerView!
    @IBOutlet weak var videoTitleLabel: UITextField!
    @IBOutlet weak var youtubeURLTitle: UITextField!
    var titleArray = [String]()
    var thumbNailArray = [UIImage]()
    var viewModel = VideoChoicesViewModel()
    var attachIdList = [Int]()
    var bag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        attachTableView.delegate = self
        attachTableView.dataSource = self
        _ = viewModel.thumbNailArrayRX.subscribe(onNext: {  list in
            self.thumbNailArray = list
            
            
            DispatchQueue.main.async {
                self.attachTableView.reloadData()
            }
            
            
        }).disposed(by: bag)
        
        _ = viewModel.attachIdList.subscribe(onNext: {  list in
            self.attachIdList = list
            
            
        }).disposed(by: bag)
        
        _ = viewModel.titleArrayRX.subscribe(onNext: {  list in
            self.titleArray = list
            
            
            DispatchQueue.main.async {
                self.attachTableView.reloadData()
            }
            
            
        }).disposed(by: bag)
    
        // Do any additional setup after loading the view.
    }
    
    @IBAction func AddVideoClick(_ sender: Any) {
        let url = youtubeURLTitle.text!
        let baseURL = url.replacingOccurrences(of: " ", with: "")
        let title = videoTitleLabel.text!
        
        if baseURL.isEmpty == true || title.isEmpty == true {
            AlertManager.shared.alert(view: self, title: "Empty Fields", message: "Please fill the fields")
            return
        }
       print("atladi")
        self.viewModel.loadYoutubeThumbnail(url: baseURL, title: title) { result,image in
            if result == true {
                self.youtubeURLTitle.text = ""
                self.videoTitleLabel.text = ""
                self.viewModel.addAttachment(title: title, videoUrl: baseURL, image: image, score: 5) { res, success in
                     
                }
            }
        }
       
        
    }
    @IBAction func nextClick(_ sender: Any) {
        if thumbNailArray.count > 1 {
            performSegue(withIdentifier: "toPublish", sender: attachIdList)
        }else {
            AlertManager.shared.alert(view: self, title: "Attachment fail", message: "Minimum attachment is 2 ")
        }
     
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toPublish" {
            let vc = segue.destination as? CreatePublishingVC
            
            let idList = sender as? [Int]
            vc?.attachmentIds = idList!
            vc?.is_image = false
        }
    }
     

}

extension VideoChoicesVC:UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return thumbNailArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         
        let cell = tableView.dequeueReusableCell(withIdentifier: "VideoChoicesCell") as! VideoChoicesTableViewCell
        
        cell.videoTitleLabel.text = titleArray[indexPath.row]
        cell.videoThumbnailImage.image = thumbNailArray[indexPath.row]
        
        return cell
    }


}
