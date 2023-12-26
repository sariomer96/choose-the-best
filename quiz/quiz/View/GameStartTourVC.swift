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

    let viewModel = GameStartTourViewModel()

  
    override func viewDidLoad() {
        super.viewDidLoad()
        showDropDown()
      
    }
    @IBAction func dropDownClick(_ sender: Any) {
     
    }
    override func viewWillAppear(_ animated: Bool) {
        quizImage.kf.setImage(with: URL(string: (viewModel.quiz?.image)!))
        quizTitleLabel.text = viewModel.quiz?.title
    }
    
    @IBAction func startClick(_ sender: Any) {
        
        if viewModel.quiz?.attachments[0].url?.lowercased().range(of:"youtube") != nil {
  
            let vc = self.storyboard!.instantiateViewController(withIdentifier: "GameVideoVC") as? GameVideoVC
            
            if let vc = vc {
                 
                vc.viewModel.quiz = viewModel.quiz
                vc.viewModel.playableCount = viewModel.maxPlayableCount
                self.navigationController!.pushViewController(vc, animated: true)
            }
         
        }else {
            let vc = self.storyboard!.instantiateViewController(withIdentifier: "GameVC") as? GameVC
            
            if let vc = vc {
                
                
                vc.viewModel.quiz = viewModel.quiz
              
                vc.viewModel.playableDelegate?.playableCount =  viewModel.maxPlayableCount
              
                self.navigationController!.pushViewController(vc, animated: true)
            }

        }
    }
    func showDropDown(){
        
        let  action = viewModel.getDropDownActions(attachmentCount: (viewModel.quiz?.attachments.count)!) {
            count in
            self.viewModel.maxPlayableCount = count
           
        }
        
        if  action != nil {
            
             dropdownButton.menu = UIMenu(children : action)
             dropdownButton.showsMenuAsPrimaryAction = true
             dropdownButton.changesSelectionAsPrimaryAction = true
        }
    }
  
}
