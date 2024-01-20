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
 
    var attachNameList = [String]()
    var imageArray = [UIImage]()
  
    var createdAttachmentList = [Attachment]()
    var callbackReloadTableView: VoidCallBack?
    

    var attachmentRequestList = [AttachmentRequestObject]()
    var total = 0
    
    func addAttachment(title:String,videoUrl:String,image:UIImage,score:Int,completion :@escaping (Bool) -> Void) {
        WebService.shared.createAttachment(title: title, videoUrl: videoUrl, image: image) {  result in
            
            switch result {
                
            case .success(let attachment):
                
                guard let attachment = attachment.id else {return}
                self.attachmentIds.append(attachment)
                print("add \(self.attachmentIds)")
          
                completion(true)
            case .failure(_):
                print("false")
                completion(false)
            }
            
        }
    }
   
    func updateAttachment(completion: @escaping (Bool)->Void) {
        
    
        print(attachNameList)
        WebService.shared.updateAttachment(titles: attachNameList, ids: self.attachmentIds) {
            result in
            print("resi;ttt")
              
           
             completion(result)
         
          
        }
    
    }
    
    func editTitle(index: Int, title: String?) {
        guard let title = title, attachNameList.count > index else { return }
        print("edit title \(title) \(index)")
        attachNameList[index] = title
    }

    func removeAttachment(index:Int, attachmentID:Int) {
    
        WebService.shared.deleteAttachment(attachmentID: attachmentID) { result in
            switch result {
            case .success(let result):
                self.imageArray.remove(at: index)
                self.attachNameList.remove(at: index)
                self.attachmentIds.remove(at: index)
                self.callbackReloadTableView?()
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
