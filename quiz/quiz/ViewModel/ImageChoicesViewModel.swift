//
//  ImageChoicesViewModel.swift
//  quiz
//
//  Created by Omer on 15.11.2023.
//

import Foundation
import UIKit
import RxSwift
import PhotosUI

class ImageChoicesViewModel {
   
    var imageArray = [UIImage]()
    var attachIdList = [Int]()
    var tableView:UITableView
    var attachNameLabelList = [String]()
    init(tableView:UITableView) {
        self.attachIdList = WebService.shared.attachIdList
        self.tableView = tableView
       
    }
    
    func addAttachment(title:String,videoUrl:String,image:UIImage,score:Int,completion :@escaping (String?, Bool) -> Void) {
        WebService.shared.createAttachment(title: title, videoUrl: videoUrl, image: image, completion: completion)
    }
    
     func addAttachmentDidpick(results: [PHPickerResult]) {
        var num = 1
         
         
        for result in results {
            result.itemProvider.loadObject(ofClass: UIImage.self) { object, error in
                if let image = object as? UIImage {
                    
                    self.imageArray.append(image)
                   
                    DispatchQueue.main.async { [self] in
                         
                            self.tableView.reloadData()
                            addAttachment(title: String(num), videoUrl: "", image: self.imageArray[num-1], score: 0) {error, isSuccess in
 
                        }
                        num += 1
                            
                    }
                    
                }
            }
        }
    }
    
}
