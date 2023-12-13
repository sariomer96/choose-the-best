//
//  CreatePublishingVC.swift
//  quiz
//
//  Created by Omer on 7.11.2023.
//

import UIKit

class CreatePublishingVC: UIViewController {

    
    
    var viewModel = CreatePublishingViewModel()
    var is_image:Bool = true
    var didSelectCategory = false
    var categoryList = [Category]()
    var isVisible = true
    var categoryID = 1
    var attachmentIds = [Int]()
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()

      
        categoryCollectionView.delegate = self
        categoryCollectionView.dataSource = self
        viewModel.getCategory { error in
           
            
        }
        _ = viewModel.categoryList.subscribe(onNext: {  list in
            self.categoryList = list
           
            
            DispatchQueue.main.async {
                self.categoryCollectionView.reloadData()
            }
           
 
        })
 
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "toGameStartVC" {
//            let vc = segue.destination as? GameStartVC
//            let quiz = sender as? QuizResponse
// 
//            vc!.quiz = quiz
//        }
//    }
 
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

extension CreatePublishingVC:UICollectionViewDelegate,UICollectionViewDataSource ,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        categoryID = categoryList[indexPath.row].id!
       
        didSelectCategory = true
         
    }
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) {
            cell.contentView.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.01176470611, blue: 0.5607843399, alpha: 1)
        }
    }


    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) {
            cell.contentView.backgroundColor = nil
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "publishCategoryCell", for: indexPath) as! PublishingCategoryCollectionViewCell
        
        cell.categoryLabel.text = categoryList[indexPath.row].name
      

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
         
        let screenWidth = UIScreen.main.bounds.width
        // 32 constraints + inter space
        let width: CGFloat = (screenWidth - 16)/2
        
        
        let height: CGFloat = 32
        
        
        return .init(width: width, height: height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
    }
    
}
