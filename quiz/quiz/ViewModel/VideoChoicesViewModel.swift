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
        self.attachIdList = WebService.shared.attachIdList
    }
    func addAttachment(title:String,videoUrl:String,image:UIImage?,score:Int) {
        WebService.shared.createAttachment(title: title, videoUrl: videoUrl, image:image) { _,_  in}
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
//    func loadYoutubeThumbnail(url:String,title:String,completion: @escaping (Bool,UIImage?) -> Void) {
//      
//      
//        let baseUrl = url.split(separator: "v=")[1]
// 
//        let id = baseUrl.split(separator: "&")
//        
//        let videoID = String(id[0])
//         
//        DispatchQueue.main.async { [self] in
//
//        let thumbNail = URL(string: "https://img.youtube.com/vi/\(videoID)/0.jpg")!
//               
//           var image = UIImageView()
//            
//            image.kf.setImage(with: thumbNail) { [self] result in
//                switch result {
//                case .failure(let error):
//                    print(error)
//                    completion(false,nil)
//                case .success(let success):
//                     
//                    thumbNails.append(image.image!)
//                    thumbNailArrayRX.onNext(thumbNails)
//                    
//                    titleArray.append(title)
//                    titleArrayRX.onNext(titleArray)
//                    completion(true,image.image!)
//                }
//            }
//            
//        }
//    }
    
}
