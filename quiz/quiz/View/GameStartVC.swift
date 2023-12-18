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
    override func viewDidLoad() {
        super.viewDidLoad()
        attachTableView.delegate = self
        attachTableView.dataSource = self
            
        
    }
    override func viewWillAppear(_ animated: Bool) {
        quizTitleLabel.text = ""
            // quizHeaderImageView.image = nil
    }
    
    override func viewDidAppear(_ animated: Bool) {
    
        quizTitleLabel.text = quiz?.title
       // guard let url = quiz?.image else { return}
        
        DispatchQueue.main.async {
            
          //  quizHeaderImageView.kf.setImage(with: URL(string: url))
            //print(self.quiz?.attachments)
        }
    }
    @IBAction func startClick(_ sender: Any) {
        
        
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "GameStartTourVC") as! GameStartTourVC
   
        vc.quiz = quiz
          
        self.navigationController!.pushViewController(vc, animated: true)
      //  performSegue(withIdentifier: "toSelectTourVC", sender: quiz)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let vc = segue.destination as? GameStartTourVC
        
        let quiz = sender as? QuizResponse
        
        if let vc = vc {
            vc.quiz = quiz
        }
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
        
       let score = quiz?.attachments[indexPath.row].score
       
        let s = Double(score!)*100.0
        
        let lastScore = s/5
        let progress = lastScore/100
        cell.winRateCircleBar.progress = CGFloat(progress)
        
        DispatchQueue.main.async { [self] in
            cell.attachImageView.kf.setImage(with: URL(string: (quiz?.attachments[indexPath.row].image!)!))
        } 
        return cell
        
    }
    
    
    
}
