//
//  VideoChoicesViewModel.swift
//  quiz
//
//  Created by Omer on 15.11.2023.
//

import Foundation
import UIKit
import RxSwift
import YouTubeiOSPlayerHelper
import Kingfisher

class VideoChoicesViewModel {
   
 
    var url = ""
    var attachIdList = [Int]()
    var thumbNails = [UIImage]()
    var titleArray = [String]()
    
    init() {
        self.attachIdList = WebService.shared.attachmentIdList
    }
    func addAttachment(title:String,videoUrl:String,image:UIImage?,score:Int) {
        WebService.shared.createAttachment(title: title, videoUrl: videoUrl, image:image) { _,_  in
      
            self.attachIdList = WebService.shared.attachmentIdList
            print("self.attachIdList  \(self.attachIdList)")
        }
    }
    
    
    func loadThumbNail(url:String,title:String,baseURL:String,completion: @escaping (Bool) -> Void) {
        WebService.shared.loadYoutubeThumbnail(url: url, title: title) { boolResult, uiimage in
            self.thumbNails.append(uiimage!)
            self.titleArray.append(title)
                           
            
            if boolResult == true {
              
                    completion(true)
                self.addAttachment(title: title, videoUrl: baseURL, image: uiimage, score: 0)
            }
        }
    }
 
    
}
