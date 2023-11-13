//
//  ViewController.swift
//  quiz
//
//  Created by Omer on 5.11.2023.
//

import UIKit

class HomeVC: UIViewController {

    @IBOutlet weak var categoryCollectionView: UICollectionView!
   
    let viewModel = HomeViewModel()
    var categoryList = [CategoryClass]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        categoryCollectionView.dataSource = self
        categoryCollectionView.delegate = self
        viewModel.getCategories()
        _ = viewModel.categoryList.subscribe(onNext: {  list in
            self.categoryList = list
           
            
            DispatchQueue.main.async {
                self.categoryCollectionView.reloadData()
            }
            self.categoryCollectionView.reloadData()
 
        })
     //   WebService.shared.getQuizElements()
       
    }


}

extension HomeVC : UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
     
        print(categoryList.count)
        return categoryList.count
       
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryViewCell", for: indexPath) as! CategoryViewCell
        
//        cell.layer.cornerRadius = 10
//        cell.layer.masksToBounds = true
//        cell.layer.borderWidth = 2.0
        
        cell.categoryLabel.text = categoryList[indexPath.row].name
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "toQuizList", sender: categoryList[indexPath.row].pk)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toQuizList" {
        
            
            let vc = segue.destination as! QuizListVC
            
            vc.quizId = sender as! Int
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
       
        
        let screenWidth = UIScreen.main.bounds.width
        // 32 constraints + inter space
        let width: CGFloat = (screenWidth - 16)/2
        
        
        let height: CGFloat = 64
        
        
        return .init(width: width, height: height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    
}

