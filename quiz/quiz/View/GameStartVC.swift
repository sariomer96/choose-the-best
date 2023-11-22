//
//  GameStartVC.swift
//  quiz
//
//  Created by Omer on 9.11.2023.
//

import UIKit
import Kingfisher

class GameStartVC: UIViewController {

    
    @IBOutlet weak var dropdownButton: UIButton!
    @IBOutlet weak var quizTitleLabel: UILabel!
    @IBOutlet weak var quizHeaderImageView: UIImageView!

    var quizTitle:String?
     var quizImage:String?
    override func viewDidLoad() {
        super.viewDidLoad()
           setPopUpButton()
       
        // Do any additional setup after loading the view.
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
        
        let optionClosure = { (action : UIAction) in
            print(action.title)}
        
        dropdownButton.menu = UIMenu(children : [
            UIAction(title:"2", state : .on , handler: optionClosure),
            UIAction(title:"4", state : .on , handler: optionClosure),
            UIAction(title:"8", state : .on , handler: optionClosure),
            UIAction(title:"16", state : .on , handler: optionClosure),
            UIAction(title:"32", state : .on , handler: optionClosure),
            UIAction(title:"64", state : .on , handler: optionClosure),
            UIAction(title:"128", state : .on , handler: optionClosure),
            
        ])
        
        dropdownButton.showsMenuAsPrimaryAction = true
        dropdownButton.changesSelectionAsPrimaryAction = true
    }
    
}
