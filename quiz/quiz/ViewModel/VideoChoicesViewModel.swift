//
//  VideoChoicesViewModel.swift
//  quiz
//
//  Created by Omer on 15.11.2023.
//

import Foundation
import UIKit

import YouTubeiOSPlayerHelper
import Kingfisher



class VideoChoicesViewModel {
   
 
    var url = ""
    var attachIdList = [Int]()
    var thumbNails = [UIImage]()
    var titleArray = [String]()
    var videoUrlList = [String]()
    
    init() {
        self.attachIdList = WebService.shared.attachmentIdList
    }
    func removeAttachment(index:Int) {
         
        thumbNails.remove(at: index)
        titleArray.remove(at: index)
        videoUrlList.remove(at: index)
    }
    func addAttachment(title:String,videoUrl:String,image:UIImage?,score:Int, completion: @escaping (Bool)->Void) {
        WebService.shared.createAttachment(title: title, videoUrl: videoUrl, image:image) { _,_  in
      
            self.attachIdList = WebService.shared.attachmentIdList
            
                completion(true)
        }
    }
     
    func addAttachmentsOnNextClick(completion: @escaping (Bool)->Void) {
        
        var count = 0
        for (index,obj) in videoUrlList.enumerated() {
            
            addAttachment(title: titleArray[index], videoUrl: obj, image: thumbNails[index], score: 0) { result in
                  count += 1
                if count == self.videoUrlList.count  {
                    completion(true)
                }
            }
        }
    }
    func loadThumbNail(url:String,title:String,baseURL:String,completion: @escaping (Bool) -> Void) {
        WebService.shared.loadYoutubeThumbnail(url: url, title: title) { boolResult, uiimage in
            self.thumbNails.append(uiimage!)
            self.titleArray.append(title)
            self.videoUrlList.append(baseURL)
            
            if boolResult == true {
              
                    completion(true)
            
                
              //  self.addAttachment(title: title, videoUrl: baseURL, image: uiimage, score: 0)
            }
        }
    }
 
    
}
