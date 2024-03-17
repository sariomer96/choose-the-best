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

final class VideoChoicesViewModel: BaseChoicesViewModel {

    var callbackAlert: CallBack<String>?

    var url = ""

    var thumbNails = [UIImage]()
    var titleArray = [String]()
    var videoUrlList = [String]()

    func removeAttachment(index: Int) {

        thumbNails.remove(at: index)
        titleArray.remove(at: index)
        videoUrlList.remove(at: index)
    }
    func addAttachment(title: String, videoUrl: String, image: UIImage?, score: Int,
                       completion: @escaping (Bool) -> Void) {

        guard let image = image else {return}
        WebService.shared.createAttachment(title: title, videoUrl: videoUrl, image: image) { attachment  in

            switch attachment {

            case .success(let attach):
                guard let id = attach.id else {return}
                self.attachmentIds.append(id)
                completion(true)
            case .failure(_):
                print("fail")
            }
        }
    }

    func addAttachmentsOnNextClick(completion: @escaping (Bool) -> Void) {

        var count = 0
        for (index, obj) in videoUrlList.enumerated() {

            addAttachment(title: titleArray[index], videoUrl: obj, image: thumbNails[index], score: 0) { _ in
                  count += 1
                if count == self.videoUrlList.count {
                    completion(true)
                }
            }
        }
    }
    func loadThumbNail(url: String, title: String, baseURL: String, completion: @escaping (Bool) -> Void) {
        WebService.shared.loadYoutubeThumbnail(url: url, title: title) { boolResult, uiimage, result  in

            if boolResult == true {
                self.thumbNails.append(uiimage!)
                self.titleArray.append(title)
                self.videoUrlList.append(result)
                    completion(true)

            } else {
                self.callbackAlert?(result)
            }

        }
    }
}
