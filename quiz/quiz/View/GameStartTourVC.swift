//
//  GameStartTourVC.swift
//  quiz
//
//  Created by Omer on 27.11.2023.
//

import UIKit
import Kingfisher
import RxSwift

class GameStartTourVC: UIViewController {

    @IBOutlet weak var dropdownButton: UIButton!
    @IBOutlet weak var quizImage: UIImageView!
    @IBOutlet weak var quizTitleLabel: UILabel!
    var quiz:QuizResponse?
    let viewModel = GameStartTourViewModel()
    var defaulPlayableCount = 2
   var maxPlayableCount = 2
  
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
        
        if quiz?.attachments[0].url?.lowercased().range(of:"youtube") != nil {
  
            let vc = self.storyboard!.instantiateViewController(withIdentifier: "GameVideoVC") as? GameVideoVC
            
            if let vc = vc {
                 
                vc.quiz = quiz
                vc.playableCount = maxPlayableCount
                self.navigationController!.pushViewController(vc, animated: true)
            }
          //  performSegue(withIdentifier: "toGameVideoVC", sender: quiz)
        }else {
            let vc = self.storyboard!.instantiateViewController(withIdentifier: "GameVC") as? GameVC
            
            if let vc = vc {
                
                
                vc.viewModel.quiz = quiz
              
                vc.viewModel.playableDelegate?.playableCount = maxPlayableCount
               // print("quiz zzzz   \(vc.viewModel?.quiz)  ----- \(quiz) ---- nmax play \(vc.viewModel?.playableDelegate?.playableCount)")
             //   vc.playableCount = maxPlayableCount
                self.navigationController!.pushViewController(vc, animated: true)
            }
           // performSegue(withIdentifier: "toGame", sender: quiz)
        }
    }
    func showDropDown(){
         
       // fillDropDownActions()
        let  action = viewModel.getDropDownActions(attachmentCount: (quiz?.attachments.count)!) {
            count in
            self.maxPlayableCount = count
           
        }
        
        if  action != nil {
            
             
             dropdownButton.menu = UIMenu(children : action
              )
     
                  dropdownButton.showsMenuAsPrimaryAction = true
                  dropdownButton.changesSelectionAsPrimaryAction = true
        }
    }
  
}
