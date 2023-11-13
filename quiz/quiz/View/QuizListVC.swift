//
//  QuizListVC.swift
//  quiz
//
//  Created by Omer on 9.11.2023.
//

import UIKit
import Kingfisher

class QuizListVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    let viewModel = QuizListViewModel()
    var quizList = [Result]()
    
    var quizId:Int?
    override func viewDidLoad() {
        super.viewDidLoad()

        print("======\(quizId) ------------")
        
        tableView.delegate = self
        tableView.dataSource = self
        
        _ = viewModel.quizList.subscribe(onNext: {  list in
            self.quizList = list
           
             
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            self.tableView.reloadData()
 
        })
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        viewModel.getQuizList(categoryId: quizId!)
    }
    

}

extension QuizListVC : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return quizList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuizListTableViewCell", for: indexPath) as! QuizListTableViewCell
        
        cell.nameLabel.text = quizList[indexPath.row].title
        let url = quizList[indexPath.row].image
        cell.imageView!.kf.setImage(with: URL(string: url)) { result in
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
            
        
        return cell
        
    }


}
