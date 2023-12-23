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
    var is_image:Bool = true
    var didSelectCategory = false
    var categoryList = [Category]()
    var isVisible = true
    var categoryID = 1
    var attachmentIds = [Int]()
 
    override func viewDidLoad() {
        super.viewDidLoad()

        categorySelectButton.isHidden = true
    
        viewModel.getCategory { error in
            
        }
//        _ = viewModel.categoryList.subscribe(onNext: {  list in   IT WILL CHANge
//            self.categoryList = list
//                    
//            if list.count > 0 {
//                self.categorySelectButton.isHidden = false
//               self.showSelectCategoryButton()
//            }
//        })
    } 
    func showSelectCategoryButton(){
         
        let  action = viewModel.getDropDownActions(categoryList: categoryList, completion: { id in
            
            if id != -1 {
                self.categoryID = id
                self.didSelectCategory = true
        
            }
        })
        if  action != nil {
  
            categorySelectButton.menu = UIMenu(children : action)
            categorySelectButton.showsMenuAsPrimaryAction = true
            categorySelectButton.changesSelectionAsPrimaryAction = true
        }
    }
    @IBAction func publishClick(_ sender: Any) {
         
        if didSelectCategory == true {
       
            viewModel.publishQuiz(uiview:self, title: CreateQuizFields.shared.quizTitle!, image:CreateQuizFields.shared.quizHeaderImage!, categoryID: self.categoryID, isVisible: self.isVisible,is_image: is_image, attachment_ids: attachmentIds)
        }
    }
    @IBAction func privateClick(_ sender: Any) {
        isVisible = false
    }
    
    @IBAction func publicClick(_ sender: Any) {
        isVisible = true
    }
    
}
 
