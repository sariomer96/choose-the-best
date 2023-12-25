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
    
    var nameCategory:String?
    let viewModel = QuizListViewModel()
    var quizList = [QuizResponse]()
    var imageList = [UIImage]()
    private var imagesList = [String]()
    var imageViewList = [UIImageView]()
    var categoryID:Int?
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
        categoryName.text = nameCategory
       
      
    }
    override func viewDidAppear(_ animated: Bool) {
  
        viewModel.getQuizList(categoryId: categoryID!) { error in
            guard let quizList = self.viewModel.quizList else {return}
         
            for i in quizList {
                guard let image = i.image else { return }
                
                self.imagesList.append(image)
             //   print("imagelist: \(self.quizList.count)  \(self.imagesList.count)")
            }
            print("Images listesi sayısı: \(self.imagesList.count)")
            DispatchQueue.main.async{
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
              
                self.quizList = quizList
                self.tableView.reloadData()
             
            }
        }
    }
 
}

extension QuizListVC : UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.search(searchText: searchText, categoryID: categoryID!) { result in
          
        }
    }
}
extension QuizListVC : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("quizlst :    \(quizList.count)")
        return self.quizList.count
    }
 
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuizListTableViewCell", for: indexPath) as! QuizListTableViewCell
     
        
        cell.nameLabel.text = quizList[indexPath.row].title
      
 
        let rate = quizList[indexPath.row].average_rate
        if rate != nil {
            cell.starView.rating = Double(rate!)
        }else{
            cell.starView.rating = 0.0
        }
        cell.quizImageView.kf.setImage(with: URL(string:imagesList[indexPath.row]),placeholder: UIImage(named: "add"))
     
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let quiz =  quizList[indexPath.row]
        
        
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "GameStartVC") as! GameStartVC
         
        vc.viewModel.quiz = quiz
          
        self.navigationController!.pushViewController(vc, animated: true)
       // performSegue(withIdentifier: "GameStartVC", sender: quiz)
    } 
}
