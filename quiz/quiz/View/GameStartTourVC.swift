//
//  GameStartTourVC.swift
//  quiz
//
//  Created by Omer on 27.11.2023.
//

import UIKit
import Kingfisher

class GameStartTourVC: UIViewController {

    @IBOutlet weak var dropdownButton: UIButton!
    @IBOutlet weak var quizImage: UIImageView!
    @IBOutlet weak var quizTitleLabel: UILabel!
    var quiz:QuizResponse?
    let viewModel = GameStartTourViewModel()
    var playableCount = 2
   
  
    override func viewDidLoad() {
        super.viewDidLoad()
        showDropDown()
        // Do any additional setup after loading the view.
    }
    
 
    @IBAction func dropDownClick(_ sender: Any) {
     
    }
    override func viewWillAppear(_ animated: Bool) {
        quizImage.kf.setImage(with: URL(string: (quiz?.image)!))
        quizTitleLabel.text = quiz?.title
    }
    
    @IBAction func startClick(_ sender: Any) {
        performSegue(withIdentifier: "toGame", sender: quiz)
    }
    func showDropDown(){
        
        
       // fillDropDownActions()
        let  action = viewModel.getDropDownActions(attachmentCount: (quiz?.attachments.count)!) {
            count in
            self.playableCount = count
        }
        
        if  action != nil {
            
             dropdownButton.menu = UIMenu(children : action
              )
     
             dropdownButton.showsMenuAsPrimaryAction = true
             dropdownButton.changesSelectionAsPrimaryAction = true
        }
    }
    
  
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as? GameVC
        let quiz = sender as? QuizResponse
        if let vc = vc , let quiz = quiz{
            vc.quiz = quiz
            vc.playableCount = playableCount
        }
    }
    
}
