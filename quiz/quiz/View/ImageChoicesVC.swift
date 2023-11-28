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
    var imageArray = [UIImage]()
    var attachNameLabelList = [String]()
    var attachIdList = [Int]()
    let bag = DisposeBag()
    let viewModel = ImageChoicesViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        
        _ = viewModel.attachIdList.subscribe(onNext: {  list in
            self.attachIdList = list
            
            print(self.attachIdList)
        }).disposed(by: bag)
        
    }
    
    @IBAction func nextClick(_ sender: Any) {
         
        
        performSegue(withIdentifier: "toPublish", sender: attachIdList)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toPublish" {
            let vc = segue.destination as? CreatePublishingVC
            
            let idList = sender as? [Int]
            vc?.attachmentIds = idList!
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
        var num = 1
        for result in results {
            result.itemProvider.loadObject(ofClass: UIImage.self) { object, error in
                if let image = object as? UIImage {
                    
                    self.imageArray.append(image)
                   
                        
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                        
                        DispatchQueue.main.async {
                            print("work \(num)")
                          
                            self.viewModel.addAttachment(title: String(num), videoUrl: "", image: self.imageArray[num-1], score: 5) {error, isSuccess in

                            
                                if isSuccess == false {
                                    print("UPLOAD FAIL")
                                    return
                                }
                            print(isSuccess)
                                num += 1
                        }
                
                            
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
        attachNameLabelList.append(cell.attachNameLabel.text!)
        cell.attachImageView.image = imageArray[indexPath.row]
        
        cell.view = editView
        return cell
    }
    
    
}
