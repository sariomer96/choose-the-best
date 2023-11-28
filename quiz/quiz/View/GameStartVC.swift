//
//  GameStartVC.swift
//  quiz
//
//  Created by Omer on 9.11.2023.
//

import UIKit
import Kingfisher

class GameStartVC: UIViewController {
    @IBOutlet weak var attachTableView: UITableView!
    
    
    @IBOutlet weak var quizTitleLabel: UILabel!
    @IBOutlet weak var quizHeaderImageView: UIImageView!

    var quizTitle:String?
    var quizImage:String?
    var attachList :[Attachment]?
 
    override func viewDidLoad() {
        super.viewDidLoad()
        attachTableView.delegate = self
        attachTableView.dataSource = self
           setPopUpButton()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        quizTitleLabel.text = ""
        quizHeaderImageView.image = nil
    }
    
    override func viewDidAppear(_ animated: Bool) {
        quizTitleLabel.text = quizTitle
        let url = quizImage!
        quizHeaderImageView.kf.setImage(with: URL(string: url))
    }
    @IBAction func startClick(_ sender: Any) {
        performSegue(withIdentifier: "toGameVC", sender: nil)
    }
    
    func setPopUpButton () {
        
       
//        let optionClosure = { (action : UIAction) in
//            print(action.title)}
//
//        dropdownButton.menu = UIMenu(children : [
//            UIAction(title:"2", state : .on , handler: optionClosure),
//            UIAction(title:"4", state : .on , handler: optionClosure),
//            UIAction(title:"8", state : .on , handler: optionClosure),
//            UIAction(title:"16", state : .on , handler: optionClosure),
//            UIAction(title:"32", state : .on , handler: optionClosure),
//            UIAction(title:"64", state : .on , handler: optionClosure),
//            UIAction(title:"128", state : .on , handler: optionClosure),
//
//        ])
//
//        dropdownButton.showsMenuAsPrimaryAction = true
//        dropdownButton.changesSelectionAsPrimaryAction = true
    }
    
}

extension GameStartVC:UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("COUNT \(attachList?.count)")
        
        if let attach = attachList {
            return attach.count
        }else{
            return 0
        }
      //  return attachList!.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GameStartTableViewCell") as! GameStartTableViewCell
        
        if let attach = attachList {
            
        cell.attachName.text = attachList![indexPath.row].title
    
        
        cell.attachImageView.kf.setImage(with: URL(string: attachList![indexPath.row].image!))
        }
            
        return cell
        
    }
    
    
    
}
