//
//  ImageChoicesVC.swift
//  quiz
//
//  Created by Omer on 15.11.2023.
//
import PhotosUI
import UIKit

class ImageChoicesVC: UIViewController {
     
    @IBOutlet weak var editView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var pickerButton: UIButton!
    var imageArray = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        
    }
    
    @IBAction func nextClick(_ sender: Any) {
        performSegue(withIdentifier: "toPublish", sender: nil)
    }
    
    @IBAction func pickerClick(_ sender: Any) {
        var config = PHPickerConfiguration()
        
        config.selectionLimit = 125
        
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
        
        for result in results {
            result.itemProvider.loadObject(ofClass: UIImage.self) { object, error in
                if let image = object as? UIImage {
                    
                    self.imageArray.append(image)
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
}

extension ImageChoicesVC:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return imageArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ImagePickerTableViewCell") as! ImagePickerTableViewCell
        
       let index =  indexPath.row
      
        cell.attachNameLabel.text = String(index+1)
        cell.attachImageView.image = imageArray[indexPath.row]
        cell.view = editView
        return cell
    }
    
    
}
