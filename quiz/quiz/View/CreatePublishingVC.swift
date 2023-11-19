//
//  CreatePublishingVC.swift
//  quiz
//
//  Created by Omer on 7.11.2023.
//

import UIKit

class CreatePublishingVC: UIViewController {

    var viewModel = CreatePublishingViewModel()
    var categoryList = [CategoryClass]()
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()

        categoryCollectionView.delegate = self
        categoryCollectionView.dataSource = self
        viewModel.getCategory()
        _ = viewModel.categoryList.subscribe(onNext: {  list in
            self.categoryList = list
           
            
            DispatchQueue.main.async {
                self.categoryCollectionView.reloadData()
            }
           
 
        })
        // Do any additional setup after loading the view.
    }
    
 

    
}

extension CreatePublishingVC:UICollectionViewDelegate,UICollectionViewDataSource ,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "publishCategoryCell", for: indexPath) as! PublishingCategoryCollectionViewCell
        
        cell.categoryNameButton.setTitle(categoryList[indexPath.row].name, for: .normal)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        print("workkf")
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
