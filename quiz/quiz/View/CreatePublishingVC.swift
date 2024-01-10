//
//  CreatePublishingVC.swift
//  quiz
//
//  Created by Omer on 7.11.2023.
//

import UIKit

final class CreatePublishingVC: BaseViewController {

    
    @IBOutlet weak var categorySelectButton: UIButton!
    
    var viewModel = CreatePublishingViewModel()
 
    override func viewDidLoad() {
        super.viewDidLoad()

        categorySelectButton.isHidden = true
        viewModel.getCategory { result in
            self.showSelectCategoryButton()
        }
        
        viewModel.callbackFail = {[weak self] error in
            guard let self = self else { return }
            self.alert(title: "Upload Failed!", message: error.localizedDescription)
            
        }
        viewModel.callbackPublishQuiz = { [weak self] quiz in
            guard let self = self else { return }
            self.alert(title: "Success!", message: UploadSuccess.success.rawValue) { _ in
 
                self.presentGameStartViewController(quiz: quiz)
            }
        }
      
    }
    override func viewDidAppear(_ animated: Bool) {
        viewModel.didSelectCategory = false
       
    }
    
    func showSelectCategoryButton(){
         
        let  action = viewModel.getDropDownActions()
        categorySelectButton.isHidden = false
        if  action != nil {
 
            categorySelectButton.menu = UIMenu(children : action)
            categorySelectButton.showsMenuAsPrimaryAction = true
            categorySelectButton.changesSelectionAsPrimaryAction = true
        }
    }
    @IBAction func publishClick(_ sender: Any) {
         
        if viewModel.didSelectCategory == true {
        
            viewModel.publishQuiz(uiview:self, title: CreateQuizFields.shared.quizTitle!, image:CreateQuizFields.shared.quizHeaderImage!, categoryID: viewModel.categoryID, isVisible: viewModel.isVisible,is_image: viewModel.is_image, attachment_ids: viewModel.attachmentIds)
        }
    }
 
    
}
 
