//
//  ImageChoicesViewModel.swift
//  quiz
//
//  Created by Omer on 15.11.2023.
//

import Foundation
import PhotosUI

typealias VoidCallBack = (() -> Void)
typealias CallBack<T> = ((T) -> Void)

final class ImageChoicesViewModel {
   
    static let shared = ImageChoicesViewModel()
    var attachIdList = WebService.shared.attachmentIdList
    var attachNameList = [String]()
    var imageArray = [UIImage]()
    var attachmentList = [Attachment]()
    var callbackReloadTableView: VoidCallBack?

    var attachmentRequestList = [AttachmentRequestObject]()
    var total = 0
    
    func addAttachment(title:String,videoUrl:String,image:UIImage,score:Int,completion :@escaping (Bool) -> Void) {
        WebService.shared.createAttachment(title: title, videoUrl: videoUrl, image: image) { _,_ in
            self.attachIdList = WebService.shared.attachmentIdList
            completion(true)
        }
    }
  
    func addAttachments(attachList:[Attachment],imageList:[UIImage],completion :@escaping (Bool) -> Void) {
        WebService.shared.createAttachments(attachList: attachList, imageList: imageList, completion: { str, resultBool in
            self.attachIdList = WebService.shared.attachmentIdList
            completion(true)
        })
    }
  
    func onClickNext(completion: @escaping (Bool)->Void) {
        
        self.attachNameList
        for (index, i) in attachNameList.enumerated() {
            
            let attach  = Attachment(id: nil , title: i, url: "", image: nil, score: 0, created_at: nil, updated_at: nil)
            
            attachmentList.append(attach)
            
//            addAttachment(title: i, videoUrl: "", image: self.imageArray[index], score: 0) { boolResult in
//                
// 
//                // if  result fail  - show alert!!
//              
//                
//                if index == self.attachNameList.count - 1 {
//                    // NEXT SCENE
//         
//                    completion(true)
//                    
//                }
//            }
        }
        addAttachments(attachList: attachmentList, imageList: imageArray) {
            result in
            completion(true)
        }
    }
    
    func editTitle(index: Int, title: String?) {
        guard let title = title, attachNameList.count > index else { return }
        attachNameList[index] = title
    }

    func removeAttachment(index:Int) {
        //attachIdList.remove(at: index)
        imageArray.remove(at: index)
        attachNameList.remove(at: index)
    }
    var num = 1
    private func checkNewPickItems(results: [PHPickerResult]){ }
     func addAttachmentDidpick(results: [PHPickerResult]) {
         
         total = results.count
         for (index, result) in results.enumerated() {
            result.itemProvider.loadObject(ofClass: UIImage.self) { object, error in
                if let image = object as? UIImage {
                    
                    self.imageArray.append(image)
                    self.attachNameList.append(String(self.num))
                    self.num += 1
                    if index == results.count-1 {
                        // burdaki asenkronu kaldir
                        DispatchQueue.main.asyncAfter(deadline: .now()) {
                            self.callbackReloadTableView?()
                        }
                    }
                }
            }
        }
    }
    func setImage(image: UIImage) {
        
        self.imageArray.append(image)
        self.attachNameList.append(String(self.num))
        self.num += 1
   }
}
