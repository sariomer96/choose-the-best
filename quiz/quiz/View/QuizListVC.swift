//
//  QuizListVC.swift
//  quiz
//
//  Created by Omer on 9.11.2023.
//

import UIKit
import Kingfisher

class QuizListVC: UIViewController {

    @IBOutlet weak var categoryName: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    var nameCategory:String?
    let viewModel = QuizListViewModel()
    var quizList = [Result]()
    
    var quizId:Int?
    override func viewDidLoad() {
        super.viewDidLoad()

        print("======\(quizId) ------------")
        
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        
        _ = viewModel.quizList.subscribe(onNext: {  list in
            self.quizList = list
           
             
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            self.tableView.reloadData()
 
        })
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        categoryName.text = ""
    }
    override func viewDidAppear(_ animated: Bool) {
        viewModel.getQuizList(categoryId: quizId!)
        categoryName.text = nameCategory
    }
    
}

extension QuizListVC : UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
    }
}

extension QuizListVC : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return quizList.count*5
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuizListTableViewCell", for: indexPath) as! QuizListTableViewCell
        
        cell.nameLabel.text = quizList[0].title
        let url = quizList[0].image
        cell.imageView!.kf.setImage(with: URL(string: url)) { result in
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
            
        
        return cell
        
    }


}
