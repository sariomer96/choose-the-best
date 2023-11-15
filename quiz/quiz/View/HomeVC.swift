//
//  ViewController.swift
//  quiz
//
//  Created by Omer on 5.11.2023.
//

import UIKit
import Kingfisher

class HomeVC: UIViewController {
    @IBOutlet weak var topRateTableView: UITableView!
    
    @IBOutlet weak var lastUpdateTableView: UITableView!
    @IBOutlet weak var categoryCollectionView: UICollectionView!
   
    let viewModel = HomeViewModel()
    var categoryList = [CategoryClass]()
    var topQuizList = [Result]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        categoryCollectionView.dataSource = self
        categoryCollectionView.delegate = self
        topRateTableView.delegate = self
        topRateTableView.dataSource = self
        lastUpdateTableView.delegate = self
        lastUpdateTableView.dataSource = self
        
        viewModel.getCategories()
        viewModel.getTopRateQuiz()
        
        _ = viewModel.topQuizList.subscribe(onNext: {  list in
            self.topQuizList = list
           
            
            DispatchQueue.main.async {
                self.topRateTableView.reloadData()
                self.lastUpdateTableView.reloadData()
            }
           
 
        })
        
        _ = viewModel.categoryList.subscribe(onNext: {  list in
            self.categoryList = list
           
            
            DispatchQueue.main.async {
                self.categoryCollectionView.reloadData()
            }
           
 
        })
 
       
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
        
        performSegue(withIdentifier: "toQuizList", sender: categoryList[indexPath.row])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toQuizList" {
          
            let category = sender as! CategoryClass
            
            let vc = segue.destination as! QuizListVC
            
            vc.nameCategory = category.name
            vc.quizId = category.pk
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

extension HomeVC:UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == topRateTableView {
            return topQuizList.count*5
        }else{
            return topQuizList.count*10
        }
   
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == topRateTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TopRatedViewCell", for: indexPath) as! TopRatedViewCell
           
            
                 cell.nameLabel.text = topQuizList[0].title   // IT WILL CHANGE WHEN DATA REFRESH
                 let url = topQuizList[0].image
                 cell.topImageView.kf.setImage(with: URL(string: url))
             
            return cell
        }
        
        if tableView == lastUpdateTableView {
            print("AAAAAA")
            let cell = tableView.dequeueReusableCell(withIdentifier: "LastUpdateTableViewCell", for: indexPath) as! LastUpdateTableViewCell
           
            
                 cell.nameLabel.text = topQuizList[0].title   // IT WILL CHANGE WHEN DATA REFRESH
                 let url = topQuizList[0].image
            cell.updateImageView.kf.setImage(with: URL(string: url))
             
            return cell
        }
        
        return UITableViewCell()
    
    }
    
    
}
