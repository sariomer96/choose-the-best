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

    var callbackAttachmentUpdateSuccess: VoidCallBack?
    var callbackAttachmentUpdateFail: CallBack<String>?
    var createdAttachmentList = [Attachment]()
    var callbackReloadTableView: VoidCallBack?
    var callbackStartLoader: VoidCallBack?
    var callbackImageUploadFail: CallBack<String>?
    var callbackAttachRemoveFail: CallBack<String>?

    var total = 0

    func addAttachment(title: String, videoUrl: String, image: UIImage, score: Int,
                    completion: @escaping (Bool) -> Void) {
        self.callbackStartLoader?()
        WebService.shared.createAttachment(title: title, videoUrl: videoUrl, image: image) {  result in

            switch result {

            case .success(let attachment):

                guard let attachment = attachment.id else {return}
                self.attachmentIds.append(attachment)

                completion(true)
            case .failure(_):

                completion(false)
            }

        }
    }

    func updateAttachment() {

        WebService.shared.updateAttachment(titles: attachNameList, ids: self.attachmentIds) { result in
                switch result {

                case .success(_):
                    self.callbackAttachmentUpdateSuccess?()
                case .failure(let error):
                    self.callbackAttachmentUpdateFail?(error.localizedDescription)

                              }

            }

    }

    func editTitle(index: Int, title: String?) {
        guard let title = title, attachNameList.count > index else { return }

        attachNameList[index] = title
    }

    func removeAttachment(index: Int, attachmentID: Int) {

        WebService.shared.deleteAttachment(attachmentID: attachmentID) { result, _ in
            switch result {
            case .success(let result):
                self.imageArray.remove(at: index)
                self.attachNameList.remove(at: index)
                self.attachmentIds.remove(at: index)
                self.callbackReloadTableView?()
            case .failure(let fail):

                self.callbackAttachRemoveFail?(fail.localizedDescription)
            }
        }

    }
    var num = 1

     func addAttachmentDidpick(results: [PHPickerResult]) {

         total = results.count
         for (index, result) in results.enumerated() {
            result.itemProvider.loadObject(ofClass: UIImage.self) { object, error in
                if let image = object as? UIImage {

                    self.addAttachment(title: String(self.num), videoUrl: "", image: image, score: 0) { result in

                        switch result {

                        case true:
                            self.setImage(image: image)

                                self.callbackReloadTableView?()
                                print(self.imageArray.count)
                        case false:
                            self.callbackImageUploadFail?(error?.localizedDescription ?? "image upload failed")

                            break
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
