//
//  CreatePublishingVC.swift
//  quiz
//
//  Created by Omer on 7.11.2023.
//

import UIKit

class CreatePublishingVC: UIViewController {

    
    @IBOutlet weak var categorySelectButton: UIButton!
    
    var viewModel = CreatePublishingViewModel()
 
    override func viewDidLoad() {
        super.viewDidLoad()

        categorySelectButton.isHidden = true
        viewModel.getCategory { result in
            self.showSelectCategoryButton()
        }
      
    }
    override func viewDidAppear(_ animated: Bool) {
        viewModel.didSelectCategory = false
       
    }
    
    func showSelectCategoryButton(){
         
        let  action = viewModel.getDropDownActions()
        categorySelectButton.isHidden = false
        if  action != nil {
            print("action \(action.count)")
            categorySelectButton.menu = UIMenu(children : action)
            categorySelectButton.showsMenuAsPrimaryAction = true
            categorySelectButton.changesSelectionAsPrimaryAction = true
        }
    }
    @IBAction func publishClick(_ sender: Any) {
         
        if viewModel.didSelectCategory == true {
       
            print(" ATTACH IDS    \(viewModel.attachmentIds)")
            viewModel.publishQuiz(uiview:self, title: CreateQuizFields.shared.quizTitle!, image:CreateQuizFields.shared.quizHeaderImage!, categoryID: viewModel.categoryID, isVisible: viewModel.isVisible,is_image: viewModel.is_image, attachment_ids: viewModel.attachmentIds)
        }
    }
    @IBAction func privateClick(_ sender: Any) {
        viewModel.isVisible = false
    }
    
    @IBAction func publicClick(_ sender: Any) {
        viewModel.isVisible = true
    }
    
}
 
