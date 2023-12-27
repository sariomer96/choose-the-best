//
//  GameStartVC.swift
//  quiz
//
//  Created by Omer on 9.11.2023.
//

import UIKit
import Kingfisher

class GameStartVC: UIViewController {
    @IBOutlet weak var attachTableView: UITableView!
    
    
    @IBOutlet weak var quizTitleLabel: UILabel!
    @IBOutlet weak var quizTitle: UILabel!
    @IBOutlet weak var quizHeaderImageView: UIImageView!

//    var quizTitle:String?
//    var quizImage:String?
//    var quiz:QuizResponse?
//    var totalAttachScore = 0
//    var progress:CGFloat = 0
    var viewModel = GameStartViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        attachTableView.delegate = self
        attachTableView.dataSource = self
            
        
    }
    override func viewWillAppear(_ animated: Bool) {
        quizTitleLabel.text = ""
         
        viewModel.getQuiz() {
            _ in
            self.quizTitle.text =  self.viewModel.quiz?.title
            DispatchQueue.main.async {
                self.attachTableView.reloadData()
            }
        }
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
     
     
        quizTitleLabel.text = viewModel.quiz?.title
        
 
    }
    @IBAction func startClick(_ sender: Any) {
        
        
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "GameStartTourVC") as! GameStartTourVC
   
        vc.viewModel.quiz = viewModel.quiz
          
        
        self.navigationController!.pushViewController(vc, animated: true)
      //  performSegue(withIdentifier: "toSelectTourVC", sender: quiz)
    }

  
    
}

extension GameStartVC:UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
  
        
        if let attach = viewModel.quiz?.attachments.count {
            return attach
        }else{
 
            return 0
        }
   
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GameStartTableViewCell") as! GameStartTableViewCell
        
         
        cell.attachName.text = viewModel.quiz?.attachments[indexPath.row].title
        
    
      
        
        DispatchQueue.main.async { [self] in
            let score = self.viewModel.quiz?.attachments[indexPath.row].score
            
            
              
             //let normalizedScore = Double(score!)*100.0
        
            if self.viewModel.totalAttachScore > 0 {
                let resultScore = CGFloat(score!)/CGFloat(viewModel.totalAttachScore)
                 
                viewModel.progress = CGFloat(resultScore)
            }else{
                viewModel.progress = 0
            }
            
 
              
            cell.winRateCircleBar.progress = viewModel.progress
            cell.attachImageView.kf.setImage(with: URL(string: (viewModel.quiz?.attachments[indexPath.row].image!)!))
        }
        return cell
        
    }
    
    
    
}
