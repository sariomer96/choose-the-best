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
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
   
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var categoryCollectionView: UICollectionView!
   
    let viewModel = HomeViewModel()
 
    override func viewDidAppear(_ animated: Bool) {
       
      
    }
    @IBAction func segmentedControlAction(_ sender: Any) {
        switch segmentedControl.selectedSegmentIndex{
          case 0:
              
            viewModel.setQuizList(quizList: viewModel.topQuizList)
            viewModel.quizType = .topQuiz
            topRateTableView.setContentOffset(CGPointZero, animated:true)
          case 1:
            viewModel.setQuizList(quizList: viewModel.recentlyList)
            viewModel.quizType = .recentlyQuiz
            topRateTableView.setContentOffset(CGPointZero, animated:true)
          
         default:
            viewModel.setQuizList(quizList: viewModel.topQuizList)
            viewModel.quizType = .topQuiz
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
         
        
 
        topRateTableView.layer.cornerRadius = 7
        
        categoryCollectionView.dataSource = self
        categoryCollectionView.delegate = self
        topRateTableView.delegate = self
        topRateTableView.dataSource = self
 
        
        self.activityIndicator.startAnimating()
        self.activityIndicator.isHidden = false
        
        viewModel.getTopRateQuiz { result in
            
            DispatchQueue.main.async {
                self.viewModel.setQuizList(quizList: self.viewModel.topQuizList)
                self.topRateTableView.reloadData()
            }
        }
        
        viewModel.getRecentlyQuiz()
        viewModel.getCategories { [self]
            result in
            
        if let result = result {
          
            DispatchQueue.main.async {
                
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
                self.categoryCollectionView.reloadData()
            }
           
        }
     }
  
        viewModel.callbackReloadTopRatedTableView = { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.topRateTableView.reloadData()
            }
        }
        
        viewModel.callbackFailRequest = { [weak self] error in
            guard let self = self else { return }
            self.alert(title: "Error" , message: error.localizedDescription)
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
 
        
        return viewModel.currentQuizList.count ?? 0
        
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    
        let quarterwayPoint = scrollView.contentSize.height / 3
 
         if scrollView.contentOffset.y >= quarterwayPoint {
           
             if viewModel.quizType == .topQuiz {
                 
                 viewModel.startPaginateToTopRateQuestions()
                
             } else {
                 viewModel.startPaginateToRecentlyQuestions()
             }
         }
     }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        var quiz:QuizResponse?
        
        
        if viewModel.quizType == .topQuiz {
            quiz = viewModel.getQuizList(quizType: .topQuiz, index: indexPath.row)
        } else {
            quiz = viewModel.getQuizList(quizType: .recentlyQuiz, index: indexPath.row)
        }
        
        guard let quiz = quiz else{return}
        self.presentGameStartViewController(quiz: quiz )
        
    }

  
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == topRateTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TopRatedViewCell", for: indexPath) as! TopRatedViewCell
  
            cell.nameLabel.text = viewModel.currentQuizList[indexPath.row].title
            cell.categoryNameLabel.text = viewModel.currentQuizList[indexPath.row].category.name
            let rate = viewModel.currentQuizList[indexPath.row].average_rate
            if rate != nil {
                cell.startViews.rating = Double(rate ?? 0)
            }else{
                cell.startViews.rating = 0.0
            }
            let url = viewModel.currentQuizList[indexPath.row].image
                cell.topImageView.kf.setImage(with: URL(string: url!)) 
             
            return cell
        }
         
        return UITableViewCell()
    
    }
    
  
}
