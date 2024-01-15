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

final class ImageChoicesViewModel: BaseChoicesViewModel {
   
    static let shared = ImageChoicesViewModel()
    var attachIdList = [Int]()
    var attachNameList = [String]()
    var imageArray = [UIImage]()
   // var attachmentList = [Attachment]()
    var createdAttachmentList = [Attachment]()
    var callbackReloadTableView: VoidCallBack?

    var attachmentRequestList = [AttachmentRequestObject]()
    var total = 0
    
    func addAttachment(title:String,videoUrl:String,image:UIImage,score:Int,completion :@escaping (Bool) -> Void) {
        WebService.shared.createAttachment(title: title, videoUrl: videoUrl, image: image) {  result in
            
            switch result {
                
            case .success(let attachment):
                
                guard let attachment = attachment.id else {return}
                self.attachIdList.append(attachment)
         
                completion(true)
            case .failure(_):
                completion(false)
            }
            
        }
    }
  
 
  //  let titles = [ "aa", "bb","cc"]
    func onClickNext(completion: @escaping (Bool)->Void) {
        
        WebService.shared.updateAttachment(titles: attachNameList, ids: attachIdList) {
            result in
            print(result)
        }
    
    }
    
    func editTitle(index: Int, title: String?) {
        guard let title = title, attachNameList.count > index else { return }
        attachNameList[index] = title
    }

    func removeAttachment(index:Int, attachmentID:Int) {
        //attachIdList.remove(at: index)
        WebService.shared.deleteAttachment(attachmentID: attachmentID) { result in
            switch result {
            case .success(let result):
                self.imageArray.remove(at: index)
                self.attachNameList.remove(at: index)
            case .failure(let fail):
                print("fail")
            }
        }
      
    }
    var num = 1
    private func checkNewPickItems(results: [PHPickerResult]){ }
     func addAttachmentDidpick(results: [PHPickerResult]) {
         
         total = results.count
         for (index, result) in results.enumerated() {
            result.itemProvider.loadObject(ofClass: UIImage.self) { object, error in
                if let image = object as? UIImage {
                     
                   
                    
             
                    self.addAttachment(title: String(self.num), videoUrl: "", image: image, score: 0) {
                        result in
                  
                        switch result {
                            
                        case true:
                            self.setImage(image: image)
 
                                self.callbackReloadTableView?()
                                print(self.imageArray.count)
                        case false:
                            print("image load failed")
                            break
                        }
                        

                              
                      //  self.num += 1
                       
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
