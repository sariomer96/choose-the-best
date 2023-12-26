//
//  ImageChoicesVC.swift
//  quiz
//
//  Created by Omer on 15.11.2023.
//
import PhotosUI
import UIKit
import RxSwift

class ImageChoicesVC: UIViewController {
     
    @IBOutlet weak var editView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var pickerButton: UIButton!
 
    
    var viewModel:ImageChoicesViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        viewModel = ImageChoicesViewModel(tableView: tableView)
        
     
        
    }
    @IBAction func nextClick(_ sender: Any) {
         
        if viewModel!.imageArray.count > 1 {
            let vc = self.storyboard!.instantiateViewController(withIdentifier: "CreatePublishingVC") as? CreatePublishingVC
            
            if let vc = vc {
                
                vc.viewModel.setVariables(is_image: true, attachID: viewModel?.attachIdList ?? [Int]())
                self.navigationController!.pushViewController(vc, animated: true)
            }
          //  performSegue(withIdentifier: "toPublish", sender: attachIdList)
        }else {
            AlertManager.shared.alert(view: self, title: "Fail", message: "need 2 attachments")
        }
       
    }
    @IBAction func pickerClick(_ sender: Any) {
        var config = PHPickerConfiguration()
        
        config.selectionLimit = 128
        
        let phPickerVC = PHPickerViewController(configuration: config)
        phPickerVC.delegate = self
        self.present(phPickerVC,animated: true)
    }
    
    @IBAction func okClickViewButton(_ sender: Any) {
        editView.isHidden = true
        
    }
    
}
extension ImageChoicesVC:PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        
        dismiss(animated: true)
         
        viewModel!.addAttachmentDidpick(results: results)

    }
}

extension ImageChoicesVC:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel!.imageArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ImagePickerTableViewCell") as! ImagePickerTableViewCell
        
       let index =  indexPath.row
       
        cell.attachNameLabel.text = String(index+1)
        viewModel?.attachNameLabelList.append(cell.attachNameLabel.text!)
        cell.attachImageView.image = viewModel!.imageArray[indexPath.row]
        
        cell.view = editView
        return cell
    } 
}
