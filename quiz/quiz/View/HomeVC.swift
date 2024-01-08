//
//  ViewController.swift
//  quiz
//
//  Created by Omer on 5.11.2023.
//

import UIKit
import Kingfisher
import Alamofire


class HomeVC: BaseViewController {
    @IBOutlet weak var topRateTableView: UITableView!
    
    @IBOutlet weak var recentlyQuestTableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var categoryCollectionView: UICollectionView!
   
    let viewModel = HomeViewModel()
 
    override func viewDidAppear(_ animated: Bool) {
        viewModel.getTopRateQuiz { result in
            
            DispatchQueue.main.async {
                self.topRateTableView.reloadData()
            }
        }
        
        viewModel.getRecentlyQuiz { error in
            DispatchQueue.main.async {
                self.recentlyQuestTableView.reloadData()
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
         
 
        topRateTableView.layer.cornerRadius = 7
        recentlyQuestTableView.layer.cornerRadius = 7
        categoryCollectionView.dataSource = self
        categoryCollectionView.delegate = self
        topRateTableView.delegate = self
        topRateTableView.dataSource = self
        recentlyQuestTableView.delegate = self
        recentlyQuestTableView.dataSource = self
        
        self.activityIndicator.startAnimating()
        self.activityIndicator.isHidden = false
        
        viewModel.getCategories { [self]
            result in
            
        if let result = result {
          
            DispatchQueue.main.async {
                
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
                self.categoryCollectionView.reloadData()
            }
           // AlertManager.shared.alert(view: self, title: "RESPONSE", message: String(result.description))
        }
     }
        viewModel.callbackReloadRecentlyTableView = { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.recentlyQuestTableView.reloadData()
            }
        }
        
        viewModel.callbackReloadTopRatedTableView = { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.topRateTableView.reloadData()
            }
        }
    }
 
}

extension HomeVC : UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      
        return viewModel.categoryList?.count ?? 0
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
    
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryViewCell", for: indexPath) as! CategoryViewCell

        cell.clipsToBounds = true
        cell.layer.cornerRadius = 12
        cell.categoryLabel.text = viewModel.categoryList?[indexPath.row].name
        cell.categoryLabel.clipsToBounds = true
        cell.categoryLabel.layer.cornerRadius = 12
         
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
 
         let vc = self.storyboard?.instantiateViewController(withIdentifier: "QuizListVC") as? QuizListVC
        
        guard let vc = vc else{return}
        vc.viewModel.nameCategory = viewModel.categoryList?[indexPath.row].name
        vc.viewModel.categoryID = viewModel.categoryList?[indexPath.row].id
         
        self.navigationController!.pushViewController(vc, animated: true)
    }
}

extension HomeVC:UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == topRateTableView {
            return viewModel.topQuizList.count ?? 0
        }else {
            return viewModel.recentlyList.count ?? 0
        }
        
    }
    
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    
        let quarterwayPoint = scrollView.contentSize.height / 2
 
         if scrollView.contentOffset.y >= quarterwayPoint {
           
   
             if scrollView == topRateTableView {
                 
                 print("top")
                 viewModel.startPaginateToTopRateQuestions()
                
             } else if scrollView == recentlyQuestTableView {
                 print("recent")
                 viewModel.startPaginateToRecentlyQuestions()
             }
         }
     }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        var quiz:QuizResponse?
        if tableView == topRateTableView {
            quiz = viewModel.getQuizList(quizType: .topQuiz, index: indexPath.row)
        } else {
            quiz = viewModel.getQuizList(quizType: .recentlyQuiz, index: indexPath.row)
        }
        
        self.presentGameStartViewController(quiz: quiz)
//        let vc = self.storyboard!.instantiateViewController(withIdentifier: "GameStartVC") as! GameStartVC
//        vc.viewModel.quiz = quiz
//        
//        self.navigationController!.pushViewController(vc, animated: true)
        
    }

  
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == topRateTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TopRatedViewCell", for: indexPath) as! TopRatedViewCell
  
            cell.nameLabel.text = viewModel.topQuizList[indexPath.row].title
            cell.categoryNameLabel.text = viewModel.topQuizList[indexPath.row].category.name
            let rate = viewModel.topQuizList[indexPath.row].average_rate
            if rate != nil {
                cell.startViews.rating = Double(rate!)
            }else{
                cell.startViews.rating = 0.0
            }
            
            let url = viewModel.topQuizList[indexPath.row].image
            cell.topImageView.kf.setImage(with: URL(string: url!))
             
            return cell
        }
        
        if tableView == recentlyQuestTableView {
  
            let cell = tableView.dequeueReusableCell(withIdentifier: "LastUpdateTableViewCell", for: indexPath) as! LastUpdateTableViewCell
           
            
            let rate = viewModel.recentlyList[indexPath.row].average_rate
            if rate != nil {
                cell.starView.rating = Double(rate!)
            }else{
                cell.starView.rating = 0.0
            }
            
            cell.nameLabel.text = viewModel.recentlyList[indexPath.row].title
            cell.categoryNameLabel.text = viewModel.recentlyList[indexPath.row].category.name
                
            let url = viewModel.recentlyList[indexPath.row].image
            cell.updateImageView.kf.setImage(with: URL(string: url!))
             
            return cell
        }
        
        return UITableViewCell()
    
    }
    
  
}
