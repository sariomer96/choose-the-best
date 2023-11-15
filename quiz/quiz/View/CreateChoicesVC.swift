//
//  CreateChoicesVC.swift
//  quiz
//
//  Created by Omer on 7.11.2023.
//

import UIKit

class CreateChoicesVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func imageChoiceClick(_ sender: Any) {
        performSegue(withIdentifier: "toImage", sender: nil)
    }
    
   

    @IBAction func videoChoiceClick(_ sender: Any) {
        performSegue(withIdentifier: "toVideo", sender: nil)
    }
}
