//
//  ViewController.swift
//  quiz
//
//  Created by Omer on 5.11.2023.
//

import UIKit
import Kingfisher
import RxSwift
import Alamofire


class HomeVC: UIViewController {
    @IBOutlet weak var topRateTableView: UITableView!
    
    @IBOutlet weak var lastUpdateTableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var categoryCollectionView: UICollectionView!
   
    let viewModel = HomeViewModel()
    var categoryList = [Category]()
 
    var topQuizList = [QuizResponse]()
    var recentlyList = [QuizResponse]()
    let bag = DisposeBag()
    
    
      
    override func viewDidLoad() {
        super.viewDidLoad()
        
        categoryCollectionView.dataSource = self
        categoryCollectionView.delegate = self
        topRateTableView.delegate = self
        topRateTableView.dataSource = self
        lastUpdateTableView.delegate = self
        lastUpdateTableView.dataSource = self
        
        viewModel.getCategories {result in
            
            if let result = result {
                
               // AlertManager.shared.alert(view: self, title: "RESPONSE", message: String(result.description))
            }
        }
        viewModel.getTopRateQuiz { error in
            
        }
        viewModel.getRecentlyQuiz { error in
            
        }
        
        _ = viewModel.topQuizList.subscribe(onNext: {  list in
            self.topQuizList = list
            
            
            DispatchQueue.main.async {
                self.topRateTableView.reloadData()
                self.lastUpdateTableView.reloadData()
                
            }
            
            
        }).disposed(by: bag)
        
        _ = viewModel.recentlyList.subscribe(onNext: {  list in
            self.recentlyList = list
            
            
            DispatchQueue.main.async {
                
                self.lastUpdateTableView.reloadData()
            }
            
            
        }).disposed(by: bag)
        
        _ = viewModel.categoryList.do(onNext: {  list in
            self.activityIndicator.startAnimating()
            self.activityIndicator.isHidden = false
            
            
        }).subscribe(onNext: {  list in
            self.categoryList = list
            
            DispatchQueue.main.async {
                self.categoryCollectionView.reloadData()
                
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
                
                
            }
            
            
        }).disposed(by: bag)
             
    }
    @IBAction func createQuizClick(_ sender: Any) {
        
        
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "CreateQuizVC") as! CreateQuizVC
        
        self.navigationController!.pushViewController(vc, animated: true)
       // performSegue(withIdentifier: "toCreateVC", sender: nil)
    }
}

extension HomeVC : UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      
        return categoryList.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
    
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryViewCell", for: indexPath) as! CategoryViewCell

        cell.categoryLabel.text = categoryList[indexPath.row].name
      
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
 
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "QuizListVC") as! QuizListVC
        vc.nameCategory = categoryList[indexPath.row].name
        vc.quizId = categoryList[indexPath.row].id
        self.navigationController!.pushViewController(vc, animated: true)
        
       //  performSegue(withIdentifier: "toQuizList", sender: categoryList[indexPath.row])
    }

   
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//
//        let screenWidth = UIScreen.main.bounds.width
//        // 32 constraints + inter space
//        let width: CGFloat = (screenWidth - 16)/2
//
//
//        let height: CGFloat = 64
//
//
//        return .init(width: width, height: height)
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//    }
        
}

extension HomeVC:UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == topRateTableView {
            return topQuizList.count
        }else {
            return recentlyList.count
        }
         
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var quiz:QuizResponse?
        if tableView == topRateTableView {
             
             quiz =  topQuizList[indexPath.row]
          //  performSegue(withIdentifier: "toGameStartVC", sender: quiz)
        }else {
            
             quiz =  recentlyList[indexPath.row]
           // performSegue(withIdentifier: "toGameStartVC", sender: quiz)
        }
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "GameStartVC") as! GameStartVC
        vc.quiz = quiz
        self.navigationController!.pushViewController(vc, animated: true)
         
    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == topRateTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TopRatedViewCell", for: indexPath) as! TopRatedViewCell
           
 
            cell.nameLabel.text = topQuizList[indexPath.row].title
            cell.categoryNameLabel.text = topQuizList[indexPath.row].category.name
                
            let url = topQuizList[indexPath.row].image
            cell.topImageView.kf.setImage(with: URL(string: url!))
             
            return cell
        }
        
        if tableView == lastUpdateTableView {
  
            let cell = tableView.dequeueReusableCell(withIdentifier: "LastUpdateTableViewCell", for: indexPath) as! LastUpdateTableViewCell
           
            
            cell.nameLabel.text = recentlyList[indexPath.row].title
            cell.categoryNameLabel.text = recentlyList[indexPath.row].category.name
                
            let url = recentlyList[indexPath.row].image
            cell.updateImageView.kf.setImage(with: URL(string: url!))
             
            return cell
        }
        
        return UITableViewCell()
    
    }
    
    
}
