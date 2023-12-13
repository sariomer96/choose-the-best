//
//  QuizListVC.swift
//  quiz
//
//  Created by Omer on 9.11.2023.
//

import UIKit
import Kingfisher

class QuizListVC: UIViewController {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var categoryName: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    var nameCategory:String?
    let viewModel = QuizListViewModel()
    var quizList = [QuizResponse]()
    var imageList = [UIImage]()
    
    var quizId:Int?
    override func viewDidLoad() {
        super.viewDidLoad()

        print("======\(String(describing: quizId)) ------------")
        
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
       
        viewModel.getQuizList(categoryId: quizId!) { error in
            
           print(error)
            
        }
        
        
        
        _ = viewModel.quizList.do(onNext: {  list in
            self.activityIndicator.startAnimating()
            self.activityIndicator.isHidden = false
            print("start")

        }) .subscribe(onNext: { list in
            self.quizList = list
                 
          
            DispatchQueue.main.async {
               
                self.tableView.reloadData()
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
                print("stop")
            }
            self.loadImages()
            self.tableView.reloadData()
        })
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
       
        categoryName.text = ""
        categoryName.text = nameCategory
   
      
    }
    override func viewDidAppear(_ animated: Bool) {
        
//         self.activityIndicator.isHidden = false
//         self.activityIndicator.startAnimating()
    }
    
    
}

extension QuizListVC : UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.search(searchText: searchText) { result in
             print(result)
        }
    }
}

extension QuizListVC : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return imageList.count
    }

    
    func loadImages() {
        imageList.removeAll()
        for (index,obj) in quizList.enumerated() {
            DispatchQueue.main.async { [self] in
           
          
                let imgUrl = self.quizList[index].image
                let img = UIImageView()
                img.kf.setImage(with: URL(string:imgUrl!)) {
                    result in
                    self.imageList.append(img.image!)
                    self.tableView.reloadData()
                    print("quizlist: \(quizList.count) ------ imagelist: \(imageList.count)")
                }
                
                self.tableView.reloadData()
            }
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuizListTableViewCell", for: indexPath) as! QuizListTableViewCell
        
        cell.nameLabel.text = quizList[indexPath.row].title
        cell.quizImageView.image = imageList[indexPath.row]
//        let url = quizList[indexPath.row].image
//        cell.imageView!.kf.setImage(with: URL(string: url!)) { result in
//            
//            DispatchQueue.main.async {
//                self.tableView.reloadData()
//            }
//        }
//            
        
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let quiz =  quizList[indexPath.row]
        print("quiizz \(quiz.title)")
        performSegue(withIdentifier: "toGameStartVC", sender: quiz)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toGameStartVC" {
            let quiz = sender as! QuizResponse
            
            let vc = segue.destination as! GameStartVC
            
            vc.quiz = quiz

           
        }
    }


}
