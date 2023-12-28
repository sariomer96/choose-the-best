//
//  QuizListVC.swift
//  quiz
//
//  Created by Omer on 9.11.2023.
//

import UIKit
import Kingfisher
import Cosmos
class QuizListVC: UIViewController {


    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var categoryName: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
      let viewModel = QuizListViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        
       
      
   }
    override func viewWillAppear(_ animated: Bool) {
       
        self.activityIndicator.startAnimating()
        self.activityIndicator.isHidden = false
        categoryName.text = ""
        categoryName.text = viewModel.nameCategory
      
      
    }
    override func viewDidAppear(_ animated: Bool) {
  
      
        viewModel.quizListDelegate?.getQuizList(completion: { result in
            DispatchQueue.main.async{
 
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
               
                self.tableView.reloadData()
             
            }

        })
         
    }
 
}

extension QuizListVC : UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.search(searchText: searchText) {
            _ in
            DispatchQueue.main.async{
                self.tableView.reloadData()
            }
        }
        
    }
}
extension QuizListVC : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(viewModel.quizList.count)
        return viewModel.quizList.count
    }
 
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuizListTableViewCell", for: indexPath) as! QuizListTableViewCell
     
        
        cell.nameLabel.text = viewModel.quizList[indexPath.row].title
      
 
        let rate = viewModel.quizList[indexPath.row].average_rate
        if rate != nil {
            cell.starView.rating = Double(rate!)
        }else{
            cell.starView.rating = 0.0
        }
        cell.quizImageView.kf.setImage(with: URL(string:viewModel.imagesList[indexPath.row]),placeholder: UIImage(named: "add"))
     
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let quiz =  viewModel.quizList[indexPath.row]
        
        
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "GameStartVC") as! GameStartVC
         
        vc.viewModel.quiz = quiz
          
        self.navigationController!.pushViewController(vc, animated: true)
       // performSegue(withIdentifier: "GameStartVC", sender: quiz)
    } 
}
