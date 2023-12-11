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
   
    var titleArrayRX =  BehaviorSubject<[String]>(value: [String]())
    var thumbNailArrayRX = BehaviorSubject<[UIImage]>(value: [UIImage]())
    var attachIdList = BehaviorSubject<[Int]>(value: [Int]())
    var thumbNails = [UIImage]()
    var titleArray = [String]()
    
    init() {
        self.attachIdList = WebService.shared.attachIdList
    }
    func addAttachment(title:String,videoUrl:String,image:UIImage?,score:Int,completion :@escaping (String?, Bool) -> Void) {
        WebService.shared.createAttachment(title: title, videoUrl: videoUrl, image:image, score: score, completion: completion)
    }
    
    func loadYoutubeThumbnail(url:String,title:String,completion: @escaping (Bool,UIImage?) -> Void) {
      
      
                let t = url.split(separator: "v=")
        
                let last = t[1]
                let id = last.split(separator: "&")
                print(last)
                print(id[0])
                let videoID = String(id[0])
                 
                DispatchQueue.main.async { [self] in
        
        
                let thumbNail = URL(string: "https://img.youtube.com/vi/\(videoID)/0.jpg")!
                       
                   var image = UIImageView()
                    
                    image.kf.setImage(with: thumbNail) { [self] result in
                        switch result {
                        case .failure(let error):
                            print(error)
                            completion(false,nil)
                        case .success(let success):
                             
                            
                            thumbNails.append(image.image!)
                            thumbNailArrayRX.onNext(thumbNails)
                            
                            titleArray.append(title)
                            titleArrayRX.onNext(titleArray)
                            completion(true,image.image!)
                        }
                    }
                    
                }
    }
    
}
