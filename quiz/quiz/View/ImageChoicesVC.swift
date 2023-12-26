//
//  ImageChoicesVC.swift
//  quiz
//
//  Created by Omer on 15.11.2023.
//
import PhotosUI
import UIKit


class ImageChoicesVC: UIViewController {
     

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var pickerButton: UIButton!
    var viewModel = ImageChoicesViewModel.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        viewModel.tableView = tableView
        tableView.dataSource = self
        tableView.delegate = self
    
        
     
  
    }
    override func viewWillAppear(_ animated: Bool) {
        self.viewModel.num = 1
        clearArrays()
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    func clearArrays() {
        self.viewModel.imageArray.removeAll()
        self.viewModel.attachIdList.removeAll()
        self.viewModel.attachNameList.removeAll()
        WebService.shared.attachmentIdList.removeAll()
    }
    @IBAction func nextClick(_ sender: Any) {
         
        if viewModel.imageArray.count > 1 {
            let vc = self.storyboard!.instantiateViewController(withIdentifier: "CreatePublishingVC") as? CreatePublishingVC
            
            if let vc = vc {
                 
                viewModel.onClickNext() { _ in
                    print("googogo")
                    print("ATTA KLIST  \(self.viewModel.attachIdList)")
                    vc.viewModel.setVariables(is_image: true, attachID: self.viewModel.attachIdList )
                    self.clearArrays()
                    self.navigationController!.pushViewController(vc, animated: true)
                }
               
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
   
    
}
extension ImageChoicesVC:PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        
        dismiss(animated: true)
         
        viewModel.addAttachmentDidpick(results: results)

    }
}

extension ImageChoicesVC:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.imageArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ImagePickerTableViewCell") as! ImagePickerTableViewCell
        
      
        print(indexPath.row)
    //    cell.attachNameLabel.text = String(indexPath.row+1)
      
        let index =  indexPath.row
        cell.attachImageView.image = viewModel.imageArray[indexPath.row]
        cell.nameTextField.text =   viewModel.attachNameList[indexPath.row]
          cell.index = indexPath.row
       

  
        
        return cell
    } 
}
