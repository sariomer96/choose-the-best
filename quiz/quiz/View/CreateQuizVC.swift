//
//  CreateQuizVCViewController.swift
//  quiz
//
//  Created by Omer on 7.11.2023.
//

import UIKit

class CreateQuizVC: UIViewController {
    
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var quizTitleLabel: UITextField!
    var viewModel = CreateQuizViewModel()
    var attachment: [Attachment]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        viewModel.recognizer(imageView: coverImageView, view: self)
    }
    
    override func viewDidAppear(_ animated: Bool) {

//        guard let sourcesURL = Bundle.main.url(forResource: "dummyData", withExtension: "json") else{
//            fatalError("couldnt find")
//            return
//        }
     
//        guard let data = try? Data(contentsOf: sourcesURL) else {
//            fatalError("couldnt convert")
//
//        }
//
//        let decoder = JSONDecoder()
//
//        do{
//            let model = try? decoder.decode(QuizResponse.self, from: data)
// 
//            attachment = model?.attachments
//          
//
//        }catch{
//            print("\(error.localizedDescription) BBBBBBB")
//        }
    }
     
    func setQuizFields(identifier:String) {
        
         let isEmpty = viewModel.checkIsEmptyFields(title: quizTitleLabel.text!, view: self)
          
          
          if isEmpty == false, viewModel.isSelectedImage == true{
              CreateQuizFields.shared.quizHeaderImage = coverImageView.image!
              CreateQuizFields.shared.quizTitle = quizTitleLabel.text!
              
               performSegue(withIdentifier: identifier, sender: nil)
                 
          }else {
              AlertManager().delegateAlert?.alert(view: self, title: "Empty Fields", message: "Please fill title and select image")
             // viewModel.delegateAlert?.alert(view: self, title: "Empty Fields", message: "Please fill title and select image")
          }
    }
    
    @IBAction func imageQuizclicked(_ sender: Any) {
        setQuizFields(identifier: "toImage")
      
    }
    @IBAction func videoQuizClick(_ sender: Any) {
        setQuizFields(identifier: "toVideo")
    }
    
}
