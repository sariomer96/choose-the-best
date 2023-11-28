//
//  ImageChoicesViewModel.swift
//  quiz
//
//  Created by Omer on 15.11.2023.
//

import Foundation
import UIKit
import RxSwift

struct ImageChoicesViewModel {
   
    var attachIdList = BehaviorSubject<[Int]>(value: [Int]())
    
    init() {
        self.attachIdList = WebService.shared.attachIdList
    }
    
    func addAttachment(title:String,videoUrl:String,image:UIImage,score:Int,completion :@escaping (String?, Bool) -> Void) {
        WebService.shared.createAttachment(title: title, videoUrl: videoUrl, image: image, score: score, completion: completion)
    }
    
}
