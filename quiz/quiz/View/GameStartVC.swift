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
    @IBOutlet weak var quizHeaderImageView: UIImageView!

    var quizTitle:String?
    var quizImage:String?
   // var attachList :[Attachment]?
    var quiz:QuizResponse?
    var totalAttachScore = 0
    var progress:CGFloat = 0
    var viewModel = GameStartViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        attachTableView.delegate = self
        attachTableView.dataSource = self
            
        
    }
    override func viewWillAppear(_ animated: Bool) {
        quizTitleLabel.text = ""
            // quizHeaderImageView.image = nil
        viewModel.getQuiz(quizID:quiz!.id) { [self]
            result in
            self.quiz = result
            
            totalAttachScore = 0
            for i in quiz!.attachments{
                totalAttachScore += i.score!
            }
           
            DispatchQueue.main.async { [self] in
                attachTableView.reloadData()
            }
        }
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
     
        print("acildi")
        quizTitleLabel.text = quiz?.title
        
 
    }
    @IBAction func startClick(_ sender: Any) {
        
        
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "GameStartTourVC") as! GameStartTourVC
   
        vc.quiz = quiz
          
        
        self.navigationController!.pushViewController(vc, animated: true)
      //  performSegue(withIdentifier: "toSelectTourVC", sender: quiz)
    }

  
    
}

extension GameStartVC:UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
  
        
        if let attach = quiz?.attachments.count {
            return attach
        }else{
 
            return 0
        }
   
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GameStartTableViewCell") as! GameStartTableViewCell
        
         
        cell.attachName.text = quiz?.attachments[indexPath.row].title
        
    
      
        
        DispatchQueue.main.async { [self] in
            let score = quiz?.attachments[indexPath.row].score
            
            
              
             //let normalizedScore = Double(score!)*100.0
        
                    if totalAttachScore > 0 {
                let resultScore = CGFloat(score!)/CGFloat(totalAttachScore)
                 
                progress = CGFloat(resultScore)
            }else{
                progress = 0
            }
            
           print("PROGRESS  \(progress) \(totalAttachScore)")
              
            cell.winRateCircleBar.progress = progress
            cell.attachImageView.kf.setImage(with: URL(string: (quiz?.attachments[indexPath.row].image!)!))
        } 
        return cell
        
    }
    
    
    
}
