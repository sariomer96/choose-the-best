//
//  GameStartVC.swift
//  quiz
//
//  Created by Omer on 9.11.2023.
//

import UIKit
import Kingfisher

class GameStartVC: BaseViewController {
    @IBOutlet weak var attachTableView: UITableView!
    
    
    @IBOutlet weak var quizTitleLabel: UILabel!

    @IBOutlet weak var quizHeaderImageView: UIImageView!
 

    var viewModel = GameStartViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        attachTableView.delegate = self
        attachTableView.dataSource = self
            
        
    }
    override func viewWillAppear(_ animated: Bool) {
        quizTitleLabel.text = ""
         
        viewModel.getQuizResponse() {
            _ in
        
          let img =  self.viewModel.getQuizImage()
            if img.isEmpty == true {
                return
            }
            let url = img
            self.quizHeaderImageView.kf.setImage(with: URL(string: url))
            DispatchQueue.main.async {
                self.attachTableView.reloadData()
            }
        }
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let quiz = viewModel.getQuiz()
        guard let quiz = quiz else {return}
        quizTitleLabel.text = quiz.title
    
    }
    @IBAction func startClick(_ sender: Any) {
        
        
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "GameStartTourVC") as! GameStartTourVC
          
        let quiz = viewModel.getQuiz()
        guard let quiz = quiz else{return}
        vc.viewModel.quiz = quiz
          
        
        self.navigationController!.pushViewController(vc, animated: true)
      //  performSegue(withIdentifier: "toSelectTourVC", sender: quiz)
    }
}

extension GameStartVC:UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
  
        let attach = viewModel.getAttachments()
        guard let attach = attach else{ return 0}
          
        return attach.count
   
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GameStartTableViewCell") as! GameStartTableViewCell
        
        let attachment = viewModel.getAttachments()
        guard let attachment = attachment else { return cell}
        cell.attachName.text = attachment[indexPath.row].title
         
        DispatchQueue.main.async { [self] in
            let score = attachment[indexPath.row].score
             
            if self.viewModel.totalAttachScore > 0 {
                let resultScore = CGFloat(score!)/CGFloat(viewModel.totalAttachScore)
                 
                viewModel.progress = CGFloat(resultScore)
            }else{
                viewModel.progress = 0
            }
            cell.winRateCircleBar.progress = viewModel.progress
            cell.attachImageView.kf.setImage(with: URL(string: (attachment[indexPath.row].image!)))
        }
        return cell
        
    }
    
    
    
}
