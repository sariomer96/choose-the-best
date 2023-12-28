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
                 
                    vc.viewModel.setVariables(is_image: true, attachID: self.viewModel.attachIdList )
                    self.clearArrays()
                    self.navigationController!.pushViewController(vc, animated: true)
                }
               
            }
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
      
        let index =  indexPath.row
        cell.attachImageView.image = viewModel.imageArray[indexPath.row]
        cell.nameTextField.text =   viewModel.attachNameList[indexPath.row]
        cell.index = indexPath.row
       
        return cell
    } 
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete"){
            contextualAction,view,bool in
         
            self.removeAttachment(index: indexPath.row)
          
    }
    return UISwipeActionsConfiguration(actions: [deleteAction])
  }
    
    func removeAttachment(index:Int) {
        let title = self.viewModel.attachNameList[index]
        let alert = UIAlertController(title: "Delete", message: "\(title) do you want to delete?", preferredStyle: .alert)
    
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        let yes = UIAlertAction(title: "Delete", style: .destructive) {
        action in
        self.viewModel.removeAttachment(index: index)
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
      }
    
        alert.addAction(cancel)
        alert.addAction(yes)
        self.present(alert,animated: true)
    
    }
}
