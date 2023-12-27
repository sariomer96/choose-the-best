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


protocol EditTitle {
    func editTitle(index:Int, title:String)
}
class ImageChoicesViewModel:EditTitle {
   
     static let shared = ImageChoicesViewModel()
    var editTitleDelegate:EditTitle?
    var imageArray = [UIImage]()
    var attachIdList = [Int]()
    var tableView:UITableView?
    var attachNameList = [String]()
    var total = 0
    
    init() {
        self.attachIdList = WebService.shared.attachmentIdList
        
        editTitleDelegate = self
      //  self.tableView = tableView
    
    }
    
   
    func addAttachment(title:String,videoUrl:String,image:UIImage,score:Int,completion :@escaping (Bool) -> Void) {
        WebService.shared.createAttachment(title: title, videoUrl: videoUrl, image: image) { _,_ in
            self.attachIdList = WebService.shared.attachmentIdList
            completion(true)
        }
    }
  

    func onClickNext(completion: @escaping (Bool)->Void) {
         
        for (index, i) in attachNameList.enumerated() {
            
            print("henuz bitmedi   \(index)   \(self.attachNameList.count - 1)")
            addAttachment(title: i, videoUrl: "", image: self.imageArray[index], score: 0) { boolResult in
                
                print("\(index)")
                // if  result fail  - show alert!!
              
                
                if index == self.attachNameList.count - 1 {
                    // NEXT SCENE
                    print("botti")
                    completion(true)
                    
                }
            }
        }
    }
    func removeAttachment(index:Int) {
        //attachIdList.remove(at: index)
        imageArray.remove(at: index)
        attachNameList.remove(at: index)
    }
    
    func editTitle(index:Int, title:String) {
         attachNameList[index] = title
    }
    var num = 1
     func addAttachmentDidpick(results: [PHPickerResult]) {
      
         
         total = results.count
        for result in results {
            result.itemProvider.loadObject(ofClass: UIImage.self) { object, error in
                if let image = object as? UIImage {
                    
                    self.imageArray.append(image)
                    self.attachNameList.append(String(self.num))
                    print(self.attachNameList)
                   
                    DispatchQueue.main.async { [self] in
                         
                        self.tableView?.reloadData()

                        
                            
                    }
                    self.num += 1
                    
                }
                
            }
        }
    
    }
    
}
